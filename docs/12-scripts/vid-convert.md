---
title: Reframe video to a target aspect
type: playbook
status: active
updated: 2026-06-19
audience: internal
description: vid-convert.sh — scale + crop one video to a target aspect/resolution (no letterbox), software H.265 CRF 20. The reframe tool of the vid- family. Flags, the longest-side resolution model, how it lines up (and doesn't) with export-specs @Nx, the 4:5/mp4/kebab gaps, and the raw ffmpeg recipe that fills them.
providers:
  - FFmpeg
tags:
  - project/dotfiles
  - domain/scripts/video
aliases:
  - vid-convert
  - reframe-video
  - crop-to-aspect
related:
  - "[[02-video|Video scripts (vid-)]]"
  - "[[vid-archive|Archive to 10-bit H.265 (deep-dive)]]"
  - "[[video-archive-pipeline|Video archive pipeline (workflow)]]"
  - "[[img-canvas|img-canvas.sh — fit an image to a social aspect]]"
  - "[[01-ffmpeg|ffmpeg reference]]"
---

# Reframe to a target aspect (`vid-convert.sh`)

## Overview

`vid-archive.sh` keeps a clip's frame and only shrinks the bytes. `vid-convert.sh`
does the other job: it **changes the frame**. It scales the source so it *fills* a
target box, then crops the overflow to an exact aspect — no letterbox, no padding —
and re-encodes to H.265. This is the tool when a 4:3 capture has to become 16:9, or a
landscape master has to become a 9:16 reel.

It's the `vid-` family's one **arg-taker**: a single input via `-i`, not a cwd glob.

The script is the source of truth (`~/.dotfiles/bin/vid-convert.sh`, symlinked onto
`PATH`); this doc is the reference. For the whole family see [the vid- overview](02-video.md);
the image-side twin (fit a still into a social aspect) is [img-canvas.sh](img-canvas.md).

## 0. Prerequisites

- [FFmpeg](https://ffmpeg.org) on `PATH` with **libx265** — `ffmpeg -hide_banner -encoders | grep libx265`.
  Install via [Homebrew](https://brew.sh): `brew install ffmpeg`.
- **No VideoToolbox needed** — this is a pure software encode (`preset medium`), so it's
  CPU-bound: minutes per long 4K file, not the near-realtime the HW `vid-h265-*` path manages.

## 1. What it does — cover-scale + crop, no letterbox

Two filter steps, in order:

1. `scale=W:H:force_original_aspect_ratio=increase:flags=lanczos` — scale the source
   **up until it covers** the target box (the overflow spills past one pair of edges).
   `increase` = cover, not fit. `lanczos` = high-quality resampler.
2. `crop=W:H:<x>:<y>` — cut the overflow back to the exact target, anchored by `-o`.

The result always *fills* the frame. Nothing is letterboxed; the cost is that whatever
falls outside the target aspect is **discarded**. Pick the anchor (`-o`) to keep the part
that matters.

## 2. The core one-liner

```sh
vid-convert.sh -a 9:16 -r 1k -o center -i clip.mp4 -p ./out
#               aspect  res   anchor   input        outdir
# → out/clip_9x16_1k_center.mov   (1080×1920, H.265 CRF 20, audio copied)
```

The encoder is fixed: `libx265 -preset medium -crf 20 -pix_fmt yuv420p -tag:v hvc1
-movflags +faststart -c:a copy`. Output dims are forced even (yuv420p/HEVC require it).

## 3. Flags

| Flag | Required | Effect |
|---|---|---|
| `-a <aspect>` | yes | Target aspect: `16:9 5:3 4:3 1:1 3:4 3:5 9:16`. Crops to this shape. |
| `-r <res>` | yes | Resolution on the **longest** side: `1k`=1920, `2k`=2560, `4k`=3840. |
| `-i <input>` | yes | Input file (one). |
| `-p <outdir>` | yes | Output folder (created if missing). |
| `-o <origin>` | no (`center`) | Crop anchor: `center left right top bottom`. |
| `-n <name>` | no | Force the output filename. Default: `<stem>_<aspect>_<res>_<origin>.mov`. |
| `-h` | — | usage block |

```sh
vid-convert.sh -a 1:1  -r 4k -o center -i clip.mov -p ~/out          # 4K square
vid-convert.sh -a 9:16 -r 1k -o left   -i wide.mp4 -p ~/out -n reel.mov   # keep left edge
vid-convert.sh -a 5:3  -r 2k -o top    -i drone.mp4 -p ~/out          # keep sky, crop floor
```

## 4. Resolution model — longest side

`-r` sets the **longest** side; the short side is derived from the aspect and rounded
even. So for a landscape aspect `-r` is the width, for a portrait aspect it's the height:

| `-a` / `-r` | `1k` (1920) | `2k` (2560) | `4k` (3840) |
|---|---|---|---|
| `16:9` | 1920×1080 | 2560×1440 | 3840×2160 |
| `9:16` | 1080×1920 | 1440×2560 | 2160×3840 |
| `1:1` | 1920×1920 | 2560×2560 | 3840×3840 |

## 5. Export-specs / @Nx — what lines up, what doesn't

[export-specs](img-canvas.md) sizes by the **short** side: `@1x` = 1080, `@Nx` = 1080×N.
`vid-convert.sh` sizes by the **longest** side. They coincide only when long = 16/9 × short
— i.e. for **16:9 and 9:16** at `-r 1k` / `-r 4k`:

| Export target | px | `vid-convert.sh` |
|---|---|---|
| `16:9 @1x` | 1920×1080 | `-a 16:9 -r 1k` ✅ |
| `16:9 @2x` | 3840×2160 | `-a 16:9 -r 4k` ✅ |
| `9:16 @1x` | 1080×1920 | `-a 9:16 -r 1k` ✅ |
| `9:16 @2x` | 2160×3840 | `-a 9:16 -r 4k` ✅ |
| `4:5 @1x` | 1080×1350 | ❌ no `4:5`, and no `-r` hits 1350-long |
| `4:5 @2x` | 2160×2700 | ❌ same |

`-r 2k` is **off** the @Nx grid (16:9 @ 2k = 2560×1440 = short 1440 = @1.33x). For an
export-spec deliverable, use `1k` (@1x) or `4k` (@2x) only.

## 6. Gaps & the library recipe

`vid-convert.sh` covers most aspects but not the export-specs job end-to-end. Four gaps:

1. **No `4:5`** (nor `5:4 2:3 3:2`) — so the `frame-4-5` bucket has no path.
2. **Longest-side sizing** — can't express a short-side `@Nx` directly (see §5).
3. **`.mov` only, audio stream-copied** — not the web-friendly `.mp4`; a PCM source can't
   later go straight into mp4.
4. **No filename cleanup** — output keeps the source stem + a `_9x16_1k_center` suffix.

Until those are folded in, the **library reframe job** (e.g. `10-sample/library-sample-01/`,
each `frame-*` folder → its export aspect at @1x, kebab-named, into `_export/`) runs as a
raw recipe that mirrors `vid-convert.sh`'s scale+crop but writes `.mp4` + AAC and renames:

```sh
# one file, 9:16 @1x → 1080×1920.  16:9 → 1920:1080 ;  4:5 → 1080:1350.
ffmpeg -nostdin -y -i IN -map 0:v:0 -map 0:a:0\? \
  -vf "scale=1080:1920:force_original_aspect_ratio=increase:flags=lanczos,crop=1080:1920" \
  -c:v libx265 -preset medium -crf 22 -pix_fmt yuv420p -tag:v hvc1 \
  -movflags +faststart -c:a aac -b:a 128k  OUT.mp4
```

- `crf 22` (vs the script's `20`) leans smaller — the library wants size over archival fidelity.
- `-c:a aac` instead of `copy` so any source audio is mp4-safe.
- Kebab the output name: lowercase, strip spec/platform noise (`1080p 2k 3x5 center tt- 1m`),
  transliterate accents (`NÆS → naes`).

**The proper fix** is to extend `vid-convert.sh`: add `4:5` (+ `5:4 2:3 3:2`), a short-side
`-x N` @Nx flag (mirroring `img-canvas`'s `-s N`), and optional `.mp4`/AAC + kebab output.
Then the whole job is one command per folder instead of a hand-rolled loop.

## 7. Where it fits in the `vid-` family

- vs. **`vid-archive.sh`** — archive keeps the frame and only compresses (10-bit CRF, any res).
  `vid-convert.sh` **changes the frame**. Reframe with convert; shrink-in-place with archive.
- vs. **`vid-h264-web.sh`** — web encode keeps the frame too (H.264, universal). Convert is
  HEVC and crops.
- vs. **`img-canvas.sh`** — the still-image equivalent (fit a photo to a social aspect, `-s N`
  @Nx, cover/fit/stretch). Same idea, different medium; convert has no fit/pad mode (cover only).

## 8. Verification

- Dims + codec: `ffprobe -v error -select_streams v:0 -show_entries stream=width,height,codec_name,codec_tag_string -of csv=p=0 <out>`
  → e.g. `1080,1920,hevc,hvc1` for `-a 9:16 -r 1k`.
- No letterbox: the output has no black bars — the source was scaled to cover, then cropped.
- Anchor: `-o top` on a tall source keeps the top of frame; `-o center` keeps the middle.
- CRF mode: the encode log shows `Rate Control … CRF-20.0` (or `22.0` for the recipe).
- Even dims: width and height are both even (forced) — required by yuv420p/HEVC.
