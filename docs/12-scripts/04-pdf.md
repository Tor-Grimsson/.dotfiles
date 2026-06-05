---
title: PDF scripts
type: reference
status: active
updated: 2026-06-05
description: pdf-* — PDF make/convert helpers (ImageMagick, img2pdf, Ghostscript, poppler, pandoc).
tags:
  - project/dotfiles
  - domain/scripts/pdf
---

# PDF (`pdf-`)

All scripts take `-h`/`--help`. The three `pdf-make*` builders and
`pdf-from-images.sh` operate on the **current directory** (no input arg, top
level only); the rest take an input PDF.

| Script | Does | Usage |
|--------|------|-------|
| `pdf-make.sh` | Images + vectors → one PDF; vectors rasterised at 300 dpi | `pdf-make.sh [out.pdf]` (cwd) |
| `pdf-make-16bit.sh` | Same, but downconverts >8-bit inputs to 8-bit | `pdf-make-16bit.sh [out.pdf]` (cwd) |
| `pdf-make-16bit-force.sh` | Same, but re-encodes **every** image through magick | `pdf-make-16bit-force.sh [out.pdf]` (cwd) |
| `pdf-from-images.sh` | Bare `*.png`/`*.jpg` → `output.pdf`, no processing | `pdf-from-images.sh` (cwd) |
| `pdf-notes.sh` | Concatenate `notes/**/*.md` (sorted) → `notes.pdf` | `pdf-notes.sh` |
| `pdf-expand.sh` | Split a PDF into one **PDF** per page | `pdf-expand.sh <in.pdf>` |
| `pdf-to-png.sh` | Rasterise a PDF to one **PNG** per page (300 dpi) | `pdf-to-png.sh <in.pdf>` |

## The three `pdf-make*` builders

They share the same job — collect `*.png *.jpg *.jpeg *.pdf *.ai *.eps` from the
cwd (top level, `sort -V` order), rasterise vectors at 300 dpi, embed via
img2pdf — and differ only in how hard they fight img2pdf's strict input rules.
Climb this ladder only when the previous rung fails.

- **`pdf-make.sh`** — the plain build. Raster images pass through untouched
  (lossless, fastest); vectors rasterise at 300 dpi with alpha flattened onto
  white. No bit-depth handling, so a 16-bit PNG will make img2pdf bail.
- **`pdf-make-16bit.sh`** — adds a depth probe (`magick identify -format %z`).
  Only inputs deeper than 8 bits/channel get re-encoded to `-depth 8`; 8-bit
  files still pass through as-is. Use when plain make dies on "unsupported bit
  depth".
- **`pdf-make-16bit-force.sh`** — the hammer. Routes **every** raster image
  through `magick "$f[0]"` (first frame only) into a fresh PNG, re-encoding even
  already-8-bit files. This normalises colorspace, strips problem ICC profiles,
  and drops extra frames — so img2pdf accepts files it otherwise rejects.
  Slower, lossless. Uses `-ping` for a faster header-only depth probe.

`pdf-from-images.sh` sits below all three: no vectors, no depth handling, just
`ls -1v *.png *.jpg | img2pdf`. Reach for it when the inputs are already clean.

### Per-script detail

- **`pdf-make.sh`** — `pdf-make.sh [out.pdf]` (default `output.pdf`). Vectors get
  `-alpha remove -background white`; raster images embedded raw. Dep: ImageMagick
  + img2pdf. Example: `pdf-make.sh portfolio.pdf`.
- **`pdf-make-16bit.sh`** — `pdf-make-16bit.sh [out.pdf]`. 16-bit → 8-bit only
  when needed; rasterised PDF pages depth-checked too. Dep: ImageMagick + img2pdf.
- **`pdf-make-16bit-force.sh`** — `pdf-make-16bit-force.sh [out.pdf]`. Every
  image re-encoded; gotcha — multi-frame inputs are reduced to frame `[0]`. Dep:
  ImageMagick + img2pdf.
- **`pdf-from-images.sh`** — `pdf-from-images.sh`, always writes `output.pdf`.
  No args beyond `--help`; PNG/JPG only. Dep: img2pdf.

## PDF in / out helpers

- **`pdf-notes.sh`** — `pdf-notes.sh`. Recursively collects `notes/**/*.md`
  (sorted, NUL-safe), prepends a `<!-- path -->` banner per file, renders to
  `notes.pdf` via pandoc. Input dir and output name are hard-coded. Dep: pandoc
  (+ a PDF engine such as LaTeX).
- **`pdf-expand.sh`** — `pdf-expand.sh <in.pdf>`. Splits into single-page PDFs
  with poppler's `pdfseparate` (content stays vector). Writes `page-NNN.pdf` into
  the first unused `frames-NN/` dir, so reruns never clobber. Dep: poppler.
- **`pdf-to-png.sh`** — `pdf-to-png.sh <in.pdf>`. Rasterises with Ghostscript
  (`-sDEVICE=png16m -r300`, 24-bit RGB) to `page-NNN.png` in the first unused
  `frames-NN/`. Dep: Ghostscript. Use `pdf-expand.sh` instead if you want vector
  pages, not raster.

> `make-pdf-simple.sh` was byte-identical to `pdf-from-images.sh` → superseded (now in `~/_temp/bin_bak/`).
> Filenames had a `covert`→`convert` typo, fixed in the rename.
