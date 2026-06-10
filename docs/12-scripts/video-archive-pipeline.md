---
title: Video archive pipeline — ProRes master to tiered deliverables
type: playbook
status: active
updated: 2026-06-10
audience: internal
description: The end-to-end video archive workflow — keep (or drop) the ProRes master, render one 10-bit HEVC archive with vid-archive.sh, then derive smaller sizes and universal-delivery copies on demand. Tier model, full file-naming scheme, decision tables, and a worked 4K example.
providers:
  - FFmpeg
tags:
  - project/dotfiles
  - domain/scripts/video
aliases:
  - video-archive-pipeline
  - archive-pipeline
  - prores-archive-workflow
  - video-archive
related:
  - "[[vid-archive|Archive to 10-bit H.265 (script deep-dive)]]"
  - "[[02-video|Video scripts (vid-)]]"
  - "[[vid-remux-mp4|Rewrap to MP4]]"
  - "[[vid-h264-web|H.264 web encode]]"
---

# Video archive pipeline

## Overview

The problem: a finished 5-minute 4K motion graphic exported as **ProRes is ~10 GB**.
ProRes is an *editing* codec — lightly compressed on purpose — so that size stores
no extra picture quality you can see once the piece is done. This pipeline turns one
fat master into a small **archive** copy plus any **derivative** sizes you need,
without baking in decisions you can reverse later.

The one rule that drives everything: **archive the top rung, derive the rest.** A
high-res archive downscales to any smaller size in seconds, but you can never blow a
small file back up. So you store *one* near-master-quality file and cut smaller
copies on demand — you don't pre-store a "ladder".

```
  master.mov ─ ProRes 422 ────────────────────────── ~10 GB   (keep only if re-editing)
      │
      │  vid-archive.sh                                        ← the one encode you always do
      ▼
  master_h265.mp4 ─ HEVC 10-bit, CRF 20 ───────────── ~0.4–0.7 GB   ★ THE ARCHIVE (keep forever)
      │
      ├─ vid-archive.sh -s 1080 ─▶ master_h265_1080p.mp4 ─ ~150 MB   derive on demand
      ├─ vid-archive.sh -s 720  ─▶ master_h265_720p.mp4  ─ ~70 MB    derive on demand
      ├─ vid-h264-web.sh        ─▶ master_web.mp4        ─ ~200 MB   universal-playback delivery
      └─ vid-convert.sh -a 9:16 ─▶ master_9x16_1k_center.mov         reframe to another aspect
```

The scripts are the source of truth (`~/.dotfiles/bin/vid-*.sh`, symlinked onto
`PATH`); this doc is the workflow that ties them together. For the encoder's own flag
reference see [[vid-archive|the vid-archive.sh deep-dive]]; for the whole family see
[[02-video|the vid- overview]].

## 0. Prerequisites

- [FFmpeg](https://ffmpeg.org) with **libx265** on `PATH` (`ffmpeg -hide_banner -encoders | grep libx265`).
  Install via [Homebrew](https://brew.sh): `brew install ffmpeg`. Already in the Brewfile.
- The `vid-` scripts on `PATH` — they are (`~/bin` is a directory symlink to
  `~/.dotfiles/bin`, so every `bin/` script resolves with no extra step).
- That's it. The archive path is pure software (no VideoToolbox), so it runs on any
  ffmpeg build.

## 1. The tier model

Think in three tiers. Each has a clear owner script and a clear keep/discard answer.

| Tier | File | Made by | Codec / depth | Size¹ (5-min 4K) | Keep? |
|---|---|---|---|---:|---|
| **Master** | `project.mov` | camera / AE export | ProRes 422 (HQ), 10-bit | ~10 GB | **only if you'll re-edit** |
| **Archive** ★ | `project_h265.mp4` | `vid-archive.sh` | HEVC 10-bit, CRF 20 | ~400–700 MB | **yes — keep forever** |
| **Derivative** | `project_h265_1080p.mp4` | `vid-archive.sh -s 1080` | HEVC 10-bit, CRF 20 | ~150 MB | no — regenerate when needed |
| **Delivery (universal)** | `project_web.mp4` | `vid-h264-web.sh` | H.264 8-bit | ~200 MB | no — regenerate when needed |

¹ Sizes are estimates for a *clean* motion graphic. CRF floats the bitrate to the
content, so a busy/grainy live shot lands larger and a minimal graphic smaller — the
quality stays the same either way.

**The archive is the only thing you must store.** Everything below it is an output you
can re-cut from the archive (or the master, if you kept it) in seconds.

## 2. Decide: keep the ProRes master?

The 10 GB master — not the small mp4s — is the real storage question. Decide once:

| Situation | Keep the ProRes? |
|---|---|
| You will re-edit / re-grade / re-export this piece | **Yes** — the archive is for playback, not editing |
| Finished, delivered, unlikely to touch again | **No** — the 10-bit archive looks identical; reclaim the 10 GB |
| Unsure, and storage is cheap | Keep it for now; the archive doesn't replace it, it sits beside it |

At CRF 20 the archive is *visually* indistinguishable from the master, but it is still
a lossy, single-generation copy — fine for playback and further downscales, not ideal
as an editing source for heavy re-grading. That's the whole "keep the master if you'll
re-edit" line.

## 3. Make the archive

Drop the master in a folder and run `vid-archive.sh` with no flags. It archives at the
source's **native resolution** — a 4K master stays 4K, a 1080p source stays 1080p.

```sh
cd ~/projects/intro-mograph        # folder holding intro-mograph.mov
vid-archive.sh                     # → intro-mograph_h265.mp4  (4K, 10-bit, CRF 20)
```

- 10-bit (`yuv420p10le`) kills the gradient **banding** that ruins motion graphics in
  8-bit.
- CRF 20 = "hold this quality, float the bitrate." Tighten with `-q 18` for a hero
  piece; loosen with `-q 23` for a smaller file.
- The output is `hvc1`-tagged + `+faststart`, so it plays in QuickTime/Finder/Safari
  and streams from the first byte.

```sh
vid-archive.sh -q 18               # tighter quality (bigger)
vid-archive.sh -g                  # grainy LIVE footage: preserve grain (skip for animation)
```

## 4. Derive smaller sizes on demand

Don't pre-store a 1080p/720p ladder. When a job needs a smaller copy, cut it with `-s`
(target **height**, aspect kept). `-s` only ever **downscales** — asking for a size
≥ the source is a safe no-op, never an upscale.

```sh
vid-archive.sh -s 1080             # → intro-mograph_h265_1080p.mp4
vid-archive.sh -s 720              # → intro-mograph_h265_720p.mp4
```

Run in the same folder, `-s` derives from the **master** (`.mov`) and skips the
existing `_h265.mp4` archive (it ignores its own outputs) — so derivatives come off the
highest-quality source available. A 1080p cut downscaled from clean 4K even
*supersamples*: it looks sharper than a natively-rendered 1080p.

| `-s` value | Output height | Typical use |
|---|---|---|
| *(omit)* | native (e.g. 2160) | the archive itself |
| `1440` | ≤1440 | QHD displays |
| `1080` | ≤1080 | decks, most web, "send me the video" |
| `720` | ≤720 | email, quick preview, chat |
| `480` | ≤480 | thumbnail / proxy |

## 5. Delivery & reframing forks

The archive plays natively on Apple everything. Reach past it only for two specific jobs:

| You need | Use | Output | Why not the archive? |
|---|---|---|---|
| Plays in **every** browser/device | `vid-h264-web.sh` | `<name>_web.mp4` | archive is HEVC — smaller, but only Safari plays HEVC on the web |
| **Reframe** to another aspect (16:9 → 9:16, square…) | `vid-convert.sh -a … -r … -o …` | `<name>_<aspect>_<res>_<origin>.mov` | archive keeps the original frame; convert crops to a new aspect |
| Source is **already H.264/HEVC**, only the container is wrong | `vid-remux-mp4.sh` | `<name>.mp4` | no re-encode needed — lossless, seconds, don't transcode |
| Near-lossless **edit intermediate** (mezzanine) | `vid-h265-10b.sh` | `<name>_h265_200m.mov` | ~200 Mbps ≈ ProRes size — that's a mezzanine, not an archive |

Rule of thumb: **archive = HEVC 10-bit (small, Apple-native, keep). Delivery = H.264
(universal, regenerate).** Don't confuse the mezzanine (`vid-h265-10b`, ~200M) with the
archive (`vid-archive`, CRF) — the mezzanine barely beats ProRes on size.

## 6. File-naming reference

Every script names its output by suffix, so the tier is legible from the filename and
re-runs never collide. For a master named `intro-mograph.mov`:

| Command | Output filename | Resolution | Codec |
|---|---|---|---|
| `vid-archive.sh` | `intro-mograph_h265.mp4` | native (4K) | HEVC 10-bit |
| `vid-archive.sh -s 1080` | `intro-mograph_h265_1080p.mp4` | 1920×1080 | HEVC 10-bit |
| `vid-archive.sh -s 720` | `intro-mograph_h265_720p.mp4` | 1280×720 | HEVC 10-bit |
| `vid-h264-web.sh` | `intro-mograph_web.mp4` | native | H.264 8-bit |
| `vid-convert.sh -a 9:16 -r 1k -o center …` | `intro-mograph_9x16_1k_center.mov` | 1080×1920 | HEVC (sw) |
| `vid-remux-mp4.sh` | `intro-mograph.mp4` | native | copied (no re-encode) |
| `vid-h265-10b.sh` | `intro-mograph_h265_200m.mov` | native | HEVC 10-bit (mezzanine) |

Naming grammar for the archive family: **`<stem>_h265[_<height>p].mp4`** — the
`_h265` marks "this is an archive output" (so `vid-archive.sh` skips it on re-runs), and
the optional `_<height>p` marks a downscaled derivative. No suffix height = native.

## 7. Worked example — 10.37 GB 4K ProRes → the whole pipeline

Start: `intro-mograph.mov`, ProRes 422 HQ, 3840×2160, 5:00, **10.37 GB**.

```sh
cd ~/projects/intro-mograph
ls
# intro-mograph.mov                         10.37 GB   ← the master

# 1) make the archive (native 4K, 10-bit)
vid-archive.sh
# → intro-mograph_h265.mp4                  ~0.5 GB    ★ keep this

# 2) need a 1080p for a deck — derive it (from the master; the _h265.mp4 is skipped)
vid-archive.sh -s 1080
# skip: intro-mograph_h265.mp4 (already an archive output)
# → intro-mograph_h265_1080p.mp4            ~150 MB

# 3) need something that plays on a non-Apple browser.
#    NOTE: vid-h264-web globs the WHOLE folder and only skips its own *_web.mp4 — with
#    the _h265 files now present it would web-encode those too. Run it on the master
#    alone, in a scratch subfolder, then move the result back:
mkdir _web && cp intro-mograph.mov _web/ && ( cd _web && vid-h264-web.sh )
mv _web/intro-mograph_web.mp4 . && rm -rf _web
# → intro-mograph_web.mp4                   ~200 MB    (H.264, universal)

# 4) decide on the master: this piece is delivered and done → drop the ProRes
rm intro-mograph.mov                        # reclaim 10 GB (only because you won't re-edit)

ls
# intro-mograph_h265.mp4                     ~0.5 GB   ★ archive
# intro-mograph_h265_1080p.mp4               ~150 MB   derivative
# intro-mograph_web.mp4                      ~200 MB   universal delivery
```

Result: **~0.85 GB of files replace 10.37 GB**, the archive looks like the master, and
any other size is one command away. If you'd kept the master, it simply sits alongside
the archive — the pipeline doesn't require deleting it.

> **Batch-globbers act on the whole folder.** `vid-archive.sh` is self-skipping (it
> ignores its own `_h265*` outputs, so archive + `-s` derivatives re-run safely in
> place). But `vid-h264-web.sh` / `vid-convert.sh` will process every clip in the cwd —
> so for a delivery or reframe step, run it on the master in a scratch subfolder (as in
> step 3) or before the folder fills up. `vid-archive.sh` itself is idempotent — repeating
> a step always skips what's done.

## 8. Verification

- Archive is correct: `ffprobe -v error -select_streams v:0 -show_entries stream=codec_name,width,height,pix_fmt,codec_tag_string -of csv=p=0 intro-mograph_h265.mp4`
  → `hevc,3840,2160,yuv420p10le,hvc1`.
- Derivative downscaled, not upscaled: the `_1080p` file reports `1920,1080`; running
  `-s 2160` on a 1080p source produces a native `_h265.mp4`, **not** a `_2160p` file.
- Constant-quality confirmed: the encode log shows `Rate Control … CRF-20.0`.
- Plays natively: the `_h265.mp4` opens in QuickTime / Finder preview (that's the `hvc1`
  tag doing its job); `_web.mp4` opens in any browser.
- Storage win: `du -h` the outputs vs. the master — a clean motion graphic archive lands
  10–30× smaller than the ProRes.
