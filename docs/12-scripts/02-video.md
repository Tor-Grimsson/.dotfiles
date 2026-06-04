---
title: Video scripts
type: reference
status: active
updated: 2026-06-04
description: vid-* — video transcode/scale/crop helpers (ffmpeg).
tags:
  - project/dotfiles
  - domain/scripts/video
---

# Video (`vid-`)

| Script | Does | Usage |
|--------|------|-------|
| `vid-convert.sh` | **Flagship.** Scale + crop any video to a target aspect/res/anchor (no letterbox), H.265 | `vid-convert.sh -a <16:9\|5:3\|4:3\|1:1\|3:4\|3:5\|9:16> -r <1k\|2k\|4k> -o <left\|right\|center\|top\|bottom> -i <in> -p <outdir> [-n name]` |
| `vid-h265.sh` | Base H.265 transcode | `vid-h265.sh <in>` |
| `vid-h265-8b.sh` / `vid-h265-10b.sh` | H.265 at 8-bit / 10-bit depth | `vid-h265-8b.sh <in>` |
| `vid-h265-pad.sh` | H.265 with letterbox padding (keeps full frame) | `vid-h265-pad.sh <in>` |
| `vid-h265-dv-pal.sh` | H.265 for DV PAL source | `vid-h265-dv-pal.sh <in>` |
| `vid-h265-small.sh` / `vid-h265-small-web.sh` | Size-reduced / web-optimized small H.265 | `vid-h265-small.sh <in>` |
| `vid-prores.sh` | Transcode → ProRes | `vid-prores.sh <in>` |
| `vid-webm2mp4.sh` | WebM (canvas/screen recordings) → MP4 (H.264/AAC) | `vid-webm2mp4.sh <in.webm> [out.mp4]` |

> Exact CRF/preset flags live in each script. The quarantined `video2k-aspect.sh` / `video4k2k.sh` (byte-identical) and `video4k2ratio5x3.sh` are covered by `vid-convert.sh`.
