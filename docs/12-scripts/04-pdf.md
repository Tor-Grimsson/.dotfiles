---
title: PDF scripts
type: reference
status: active
updated: 2026-06-04
description: pdf-* — PDF make/convert helpers (ImageMagick + img2pdf).
tags:
  - project/dotfiles
  - domain/scripts/pdf
---

# PDF (`pdf-`)

| Script | Does | Usage |
|--------|------|-------|
| `pdf-make.sh` | Images → PDF at 300 dpi (`magick`) | `pdf-make.sh` (folder cwd) |
| `pdf-make-16bit.sh` | 16-bit-aware PDF build | `pdf-make-16bit.sh` |
| `pdf-make-16bit-force.sh` | 16-bit build, forced | `pdf-make-16bit-force.sh` |
| `pdf-notes.sh` | Collect `notes/*.md` in sorted order → PDF | `pdf-notes.sh` |
| `pdf-expand.sh` | PDF → PDF (upscale/expand) | `pdf-expand.sh <in.pdf>` |
| `pdf-to-png.sh` | PDF → PNG pages | `pdf-to-png.sh <in.pdf>` |
| `pdf-from-images.sh` | `ls -1v *.png *.jpg \| img2pdf -o output.pdf` | `pdf-from-images.sh` (folder cwd) |

> `make-pdf-simple.sh` was byte-identical to `pdf-from-images.sh` → quarantined. Filenames had a `covert`→`convert` typo, fixed in the rename.
