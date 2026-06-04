---
title: Image scripts
type: reference
status: active
updated: 2026-06-04
description: img-* — 2D image crop/resize/web-export helpers (ImageMagick).
tags:
  - project/dotfiles
  - domain/scripts/image
---

# Image / 2D (`img-`)

All use `magick`. Crops output sRGB 8-bit JPEG q80 unless noted.

| Script | Does | Usage |
|--------|------|-------|
| `img-crop-2000x2500.sh` | Crop to 2000×2500 (auto-orient, flatten, strip) | `img-crop-2000x2500.sh <img> [gravity] [out.jpg]` |
| `img-crop-2000x2500-resize.sh` | Same, with a scale-% step first | `img-crop-2000x2500-resize.sh <img> [gravity] [50\|75\|100] [out.jpg]` |
| `img-resize-1080.sh` | Resize to 1080 | `img-resize-1080.sh <src.jpg> [out.jpg]` |
| `img-web.sh` | Single web image | `img-web.sh <src.jpg> [width]` |
| `img-web-batch.sh` | Batch web images over a folder | `img-web-batch.sh` (folder cwd) |
| `img-web-aspect.sh` | Web export at fixed aspect | `img-web-aspect.sh <src.jpg>` |
| `img-web-thumb.sh` | Web thumbnail | `img-web-thumb.sh <src.jpg>` |

> Quarantined `crop2000x2500-01.sh` was a cruder duplicate of `img-crop-2000x2500.sh`.
