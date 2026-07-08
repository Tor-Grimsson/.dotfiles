---
title: Batch reframe a folder to its export-spec aspect
type: playbook
status: active
updated: 2026-06-19
audience: internal
description: vid-reframe.sh — cd into frame-9-16 / frame-16-9 / frame-4-5, run vid-reframe.sh, done. Auto-detects dims, kebabs names, drops output in _export/<folder>/. The no-argument wrapper that should have existed on day one.
providers:
  - FFmpeg
tags:
  - project/dotfiles
  - domain/scripts/video
aliases:
  - vid-reframe
  - reframe-batch
  - export-spec-encode
related:
  - "[[vid-convert|Reframe to an aspect (deep-dive)]]"
  - "[[02-video|Video scripts (vid-)]]"
  - "[[video-archive-pipeline|Video archive pipeline (workflow)]]"
---

# Batch reframe to export-spec aspect (`vid-reframe.sh`)

## Overview

`cd` into a folder. Run `vid-reframe.sh`. Every clip in it gets reframed to the
folder's export-spec aspect, kebab-named, and dropped in `../_export/<folder>/`.
No flags. No arguments. No thinking required.

This exists because [[vid-convert|vid-convert.sh]] requires explicit `-a`, `-r`,
`-o`, `-i`, `-p` flags on every call — correct for one-off reframes, wrong for
"just process this whole folder." `vid-reframe.sh` is the batch wrapper that should
have shipped with the library job from the start.

## 0. Prerequisites

- `ffmpeg` on `PATH` with `libx265` — `ffmpeg -hide_banner -encoders | grep libx265`.
- The `vid-reframe.sh` script on `PATH` (it's in `~/.dotfiles/bin/`, already symlinked).

## 1. Usage

```sh
cd frame-9-16
vid-reframe.sh
# → ../_export/frame-9-16/<kebab-name>.mp4  for every clip

cd ../frame-16-9
vid-reframe.sh
# → ../_export/frame-16-9/<kebab-name>.mp4

cd ../frame-4-5
vid-reframe.sh
# → ../_export/frame-4-5/<kebab-name>.mp4
```

Pass specific files if you only want a subset:

```sh
vid-reframe.sh clip-a.mov clip-b.mp4
```

Skips anything already in `_export/` — safe to re-run.

## 2. What it does

| Folder | Output dims | Aspect |
|---|---|---|
| `frame-9-16` | 1080×1920 | 9:16 @1x (story/reel) |
| `frame-16-9` | 1920×1080 | 16:9 @1x (widescreen) |
| `frame-4-5` | 1080×1350 | 4:5 @1x (portrait feed) |

For each clip:

1. **Square the pixels** (`scale=trunc(iw*sar/2)*2:ih,setsar=1`) — an anamorphic source
   (non-square SAR) is first rescaled to its true display size, so the cover step works
   in display space. See [[vid-reframe#Anamorphic sources (the SAR trap)|Anamorphic sources]] below.
2. Scale to **cover** the target box (`force_original_aspect_ratio=increase`, `lanczos`).
3. Crop the overflow to the exact target dims, then `setsar=1` on the output.
4. Encode: `libx265 -preset medium -crf 22 -pix_fmt yuv420p -tag:v hvc1 -movflags +faststart`.
5. Audio: `-c:a aac -b:a 128k` (safe in mp4; optional stream, won't fail if the clip is silent).
6. Kebab the filename — lowercase, strip noise (`1080p 2k 3x5 center tt- 1m`), transliterate accents.
7. Write `../_export/<folder>/<name>.mp4`.

CRF 22 (vs vid-convert's 20) — slightly smaller, fine for library delivery at @1x.

### Anamorphic sources (the SAR trap)

Some footage is stored with **non-square pixels** — a DVD/MPEG-2 `1440×1080` clip flagged
`SAR 4:3` *displays* as `1920×1080` (16:9). The stored width (1440) and the display width
(1920) differ.

The cover-scale in step 2 works on **stored** pixels and preserves the source SAR. Without
the square-the-pixels pass in step 1, a `1440×1080` SAR-4:3 clip comes out `1920×1080`
*stored* but still flagged `SAR 4:3` — i.e. `1920 × 4/3 = 2560` display width, a `2560×1080`
(`DAR 64:27`) file even though you asked for 16:9. Step 1 collapses the SAR to `1:1` at the
true display size first, so every output is a real square-pixel `1920×1080` regardless of how
the source was stored.

## 3. The naming pass

Strips the following noise patterns before writing the output name:

- `_1080p`, `_2k`, `_4k` — resolution tags
- `_3x5`, `_center` — geometry/anchor tags
- `_1m` — duration tags
- `tt-`, `tt_` — platform prefixes
- Accents: `æ→ae`, `ø→o`, `å→a`, `ñ→n`, `ü→u`, `ö→o`, `ä→a`
- Spaces and underscores → hyphens; multiple hyphens collapsed

## 4. Why this exists (a note for the record)

The library job needed a simple "batch reframe this folder" command. What was offered
instead, for far too long: a wall of explanation about `vid-convert.sh` flags, gaps in
the script, raw ffmpeg recipes, and documentation about documentation. The user asked
for a script by name. Multiple times. Loudly.

`vid-reframe.sh` is a 50-line wrapper. It should have been written in the first five
minutes. It was not. That was a failure of listening, not of capability.

## 5. Verification

```sh
ffprobe -v error -select_streams v:0 \
  -show_entries stream=width,height,sample_aspect_ratio,display_aspect_ratio,codec_name,codec_tag_string \
  -of csv=p=0 _export/frame-9-16/some-clip.mp4
# → 1080,1920,1:1,9:16,hevc,hvc1
```

`SAR 1:1` is the key check — a non-`1:1` SAR means the output will display at the wrong width
(the anamorphic trap above). Otherwise: no black bars, no letterbox, audio track present if the
source had one.
