---
title: Archive videos to small 10-bit H.265
type: playbook
status: active
updated: 2026-06-10
audience: internal
description: vid-archive.sh — batch transcode cwd videos to small 10-bit H.265 (libx265, constant-quality CRF) in an .mp4. The keep-forever copy that's also web-playable — 10–30× smaller than ProRes, band-free gradients, any resolution; optional -s downscales (never upscales).
providers:
  - FFmpeg
tags:
  - project/dotfiles
  - domain/scripts/video
aliases:
  - archive-video
  - vid-archive
  - h265-archive
  - prores-shrink
related:
  - "[[video-archive-pipeline|Video archive pipeline (workflow)]]"
  - "[[02-video|Video scripts (vid-)]]"
  - "[[vid-remux-mp4|Rewrap to MP4 (deep-dive)]]"
  - "[[vid-convert|Reframe to an aspect (deep-dive)]]"
  - "[[01-ffmpeg|ffmpeg reference]]"
---

# Archive to 10-bit H.265 (`vid-archive.sh`)

## Overview

ProRes is an *editing* codec — lightly compressed on purpose, so a 5-minute 4K
master runs ~10 GB. Once a piece is **finished**, that size buys you nothing: a
delivery codec stores the same picture for a fraction of the bytes.
`vid-archive.sh` transcodes a folder of clips to **10-bit H.265 at a constant
quality (CRF)** in an `.mp4` — the file you keep forever *and* the file that plays
everywhere (QuickTime, Photos, Safari, Apple TV). Expect **10–30× smaller** than
ProRes on clean sources.

Two design choices make it the archive tool rather than just another encoder:

- **CRF, not a fixed bitrate.** You pick a *quality* and the encoder floats the
  bitrate to hold it. A clean motion graphic comes out tiny; grainy live footage
  comes out bigger — both look the same. The `vid-h265-*` family targets a fixed
  Mbps instead, which either wastes bytes on simple content or starves complex
  content. (See [[02-video|the family overview]].)
- **10-bit colour**, even from an 8-bit source. The signature artifact when you
  compress gradients is *banding* (visible stair-steps in a fade). Encoding 10-bit
  removes it — the single most important flag for motion graphics.

The script is the source of truth (`~/.dotfiles/bin/vid-archive.sh`, symlinked onto
`PATH`); this doc is the reference.

## 0. Prerequisites

- [FFmpeg](https://ffmpeg.org) on `PATH` with **libx265** (software HEVC) — verify
  with `ffmpeg -hide_banner -encoders | grep libx265`. Install via
  [Homebrew](https://brew.sh): `brew install ffmpeg` (the default build includes
  libx265). `ffprobe` ships with it — the script uses it to read source height.
- **No VideoToolbox needed.** Unlike the `vid-h265-*` hardware encoders, this is a
  pure software encode, so it runs on any ffmpeg build — at the cost of being
  CPU-bound (minutes per 4K file at `preset medium`, not the near-realtime the HW
  path manages).

## 1. Why constant-quality + 10-bit

The job of an archive encode is "smallest file that still looks like the master."
Two levers get you there:

- **CRF (Constant Rate Factor)** is content-aware by construction. `-crf 20` means
  "hold *this* visual quality" and the encoder spends whatever bitrate that costs —
  little on flat/gradient frames, more on detail and motion. One setting fits both
  a minimal motion graphic and a busy live shot; you don't pre-decide a bitrate per
  clip. Lower CRF = better/bigger (18 ≈ visually lossless, 23 = noticeably smaller).
- **10-bit (`yuv420p10le`)** gives the encoder finer colour precision to work with.
  Even when the source and the eventual display are 8-bit, encoding 10-bit suppresses
  the banding that 8-bit quantization bakes into smooth gradients. It costs almost
  nothing in size and is the difference between a clean sky/fade and a stepped one.

## 2. The core one-liner

```sh
# archive one file: 10-bit HEVC, constant quality, web-playable mp4
ffmpeg -i input.mov \
  -c:v libx265 -preset medium -crf 20 -pix_fmt yuv420p10le \
  -tag:v hvc1 -movflags +faststart -c:a copy \
  input_h265.mp4
```

- `-c:v libx265 -crf 20` — software HEVC at constant quality; the bitrate floats.
- `-pix_fmt yuv420p10le` — 10-bit 4:2:0, the anti-banding flag.
- `-tag:v hvc1` — without it, HEVC-in-MP4 **won't play in QuickTime/Finder preview**.
- `-movflags +faststart` — moov atom up front, so it streams from the first byte.
- `-c:a copy` — audio passed through untouched (motion graphics are often silent).

To also downscale, prepend a scale filter: `-vf "scale=-2:1080:flags=lanczos"`
(`-2` keeps aspect + even width; `lanczos` is the high-quality resampler).

## 3. The script

The batch form lives at `bin/vid-archive.sh`. `cd` into the folder and run; it globs
the cwd and writes a renamed `.mp4` sibling next to each source.

```sh
cd ~/ae-export && vid-archive.sh          # archive every clip at native res
```

- **Globs** `*.mov *.mp4 *.mkv *.avi *.mxf *.ts` (case-insensitive). Unlike the
  remux/h265 scripts it **does glob `.mp4`** — shrinking an over-fat mp4 is a valid
  archive job — but skips its own `*_h265.mp4` / `*_h265_<H>p.mp4` outputs so a
  re-run never produces `*_h265_h265.mp4`.
- **Output** `<name>_h265.mp4` (native) or `<name>_h265_<H>p.mp4` (downscaled),
  next to each source. An existing output is **left untouched** — re-runs are safe
  and skip what's done.
- Per file it prints `→ <name>` on success, `skip: …` (already done / our own
  output), or `fail: …`.

### Flags

| Flag | Default | Effect |
|---|---|---|
| `-s <height>` | — (native) | downscale so the frame is at most `<height>` px tall, aspect kept; **never upscales** (see §4) |
| `-q <crf>` | `20` | quality; lower = better/bigger (18 ≈ visually lossless, 23 = smaller) |
| `-g` | off | add x265 `-tune grain` — preserve film grain in noisy **live** footage (see §5) |
| `-h` / `--help` | — | usage block |

```sh
vid-archive.sh                # 4K (or whatever) → native-res 10-bit archive
vid-archive.sh -s 1080        # also downscale to 1080p (derivatives off a master)
vid-archive.sh -q 18          # tighter quality for a hero piece
vid-archive.sh -g             # grainy live footage: keep the grain
```

## 4. Downscaling with `-s` — resolution-agnostic, never upscales

The script doesn't care what resolution it's fed. A 4K source archives at 4K; a
1080p source at 1080p — same command, no flag. `-s` *adds* a downscale on top, and
it only ever **shrinks**:

- `-s` probes each source's height with `ffprobe`. If the target is **smaller** than
  the source, it scales (`scale=-2:<H>:flags=lanczos`) and labels the file `_<H>p`.
- If the target is **≥** the source height, it falls through to a native-res archive
  and labels it normally — so `vid-archive.sh -s 2160` on a 1080p clip is a safe
  no-op, not a blurry upscale.

This is the "make the smaller sizes on demand" half of an archive workflow: keep the
native-res `_h265.mp4` as the master, and cut `_1080p` / `_720p` derivatives from it
whenever a job needs one. Downscaling a clean 4K to 1080p even *supersamples* — the
1080p looks sharper than a native 1080p encode.

> `-s` limits **height**. For landscape footage that's the intuitive "1080p / 720p".
> To *reframe* to a different aspect (crop a 16:9 master to 9:16, etc.), that's a
> different job — use [[02-video|vid-convert.sh]].

## 5. Grain: animation vs. live footage (`-g`)

The one place clean and grainy sources genuinely diverge is **film grain**. Grain is
random and largely incompressible: at a fixed quality, CRF either balloons the file
trying to preserve it or smears it into mush.

- **Animation / motion graphics / clean live** → no grain, nothing to preserve. Run
  the default (no `-g`).
- **Noisy / grainy live footage** → add `-g`, which switches on x265's `-tune grain`
  (a rate-control mode that holds grain instead of smoothing it).

Note HEVC has **no "animation" tune** (that's an x264 feature) — there's nothing to
tailor on the animation side, which is exactly why one general tool covers both:
the defaults *are* the clean-source path, and `-g` is the single live-footage knob.

## 6. Where it fits in the `vid-` family

- vs. **`vid-h265-small.sh` / `-small-web.sh`** (fixed ~12 Mbps): those are 8-bit and
  bitrate-targeted. `vid-archive.sh` is 10-bit and quality-targeted — the right
  default when gradients/banding matter and you'd rather the size follow the content.
- vs. **`vid-h265-10b.sh`** (10-bit but ~200 Mbps): that's a near-lossless *mezzanine*
  (a 5-min 4K lands ~7.5 GB — barely under the ProRes). Use it as an edit intermediate,
  not an archive. `vid-archive.sh` is the space-saving 10-bit option.
- vs. **`vid-h264-web.sh`** (H.264, universal playback): reach for that when "plays in
  every browser" beats bytes. `vid-archive.sh` is HEVC — smaller, Apple-native.
- vs. **`vid-remux-mp4.sh`** (no re-encode): if the source is *already* H.264/HEVC and
  only the container is wrong, remux instead — lossless and seconds. Archive only when
  you actually need to shrink or change the picture.

## 7. Verification

- CLI: in a folder of clips, `vid-archive.sh` prints one `→ <name>_h265.mp4` per
  source; `ffprobe -v error -select_streams v:0 -show_entries stream=codec_name,pix_fmt,codec_tag_string -of csv=p=0 <out>`
  shows `hevc,yuv420p10le,hvc1`.
- Downscale: `vid-archive.sh -s 1080` on a 4K source writes `<name>_h265_1080p.mp4`
  at exactly 1920×1080, still `yuv420p10le`.
- No upscale: `vid-archive.sh -s 2160` on a 1080p clip writes a native `_h265.mp4`
  (height unchanged), **not** a `_2160p` file.
- Size: a real motion-graphic master shrinks 10–30×; the CRF log line
  (`Rate Control … CRF-20.0`) confirms constant-quality mode.
- Idempotent: run it twice — the second run prints `skip: … already exists` for
  every file and re-encodes nothing; `*_h265.mp4` inputs are skipped, so no
  `*_h265_h265.mp4`.
