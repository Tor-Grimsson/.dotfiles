---
title: potrace
type: reference
status: active
updated: 2026-08-05
description: Bitmap-to-vector tracer — turns a black-and-white raster (logo, lineart, scan) into clean SVG/PDF/EPS paths. Reads PNM/BMP only, so ImageMagick is a hard front-end dependency.
aliases:
  - potrace
tags:
  - domain/images
  - pattern/cli
  - integration/brew-formula
links:
  docs: https://potrace.sourceforge.net/
covers:
  - The PNM/BMP-only input wall and the ImageMagick pipe that clears it
  - The one-line PNG → SVG recipe
  - The three flags that decide output quality
related:
  - "[[01-imagemagick|ImageMagick]]"
  - "[[03-pdf2svg|pdf2svg]]"
---

## Summary
`potrace` traces a **black-and-white bitmap** into vector paths — the tool for turning a logo PNG, a scanned signature or lineart into editable SVG. Version 1.16.

Opposite direction from [[03-pdf2svg|pdf2svg]], which extracts vectors that already exist. potrace **invents** the curves.

## Dependencies

| Command | Does | Needs |
| --- | --- | --- |
| `potrace` | Bitmap → SVG / PDF / EPS / DXF / GeoJSON | Input in **PNM (PBM/PGM/PPM) or BMP only** |
| `magick` | PNG/JPG → PNM, plus the threshold to two colours | [[01-imagemagick|ImageMagick]] — already installed |

**This is the wall people hit:** potrace cannot open a PNG or a JPG. Everyday use is always an ImageMagick pipe, never potrace alone.

## Setup

Installed via `brewfile-cli`. Nothing to configure.

```sh
brew install potrace
```

## Commands

```sh
# PNG → SVG, the everyday one-liner
magick logo.png -alpha remove -threshold 50% pnm:- | potrace -s -o logo.svg -

# Straight from a bitmap potrace can already read
potrace scan.pbm -s -o scan.svg

# Cleaner trace: kill speckles, soften corners
magick logo.png -threshold 50% pnm:- | potrace -s -t 5 -a 1.2 -o logo.svg -

# Vector PDF instead of SVG
magick art.png -threshold 50% pnm:- | potrace -b pdf -o art.pdf -
```

## Flags

| Flag | Does |
| --- | --- |
| `-s`, `--svg` | SVG backend. **Not the default** — EPS is, which surprises everyone |
| `-b <name>` | Pick a backend: `svg` · `pdf` · `pdfpage` · `eps` · `ps` · `dxf` · `geojson` · `gimppath` · `xfig` |
| `-o <file>` | Output file. `-` as the input filename reads stdin |
| `-t <n>` | Turdsize — suppress speckles up to `n` pixels (default 2). **The main quality knob** |
| `-a <n>` | Alphamax — corner threshold (default 1). Lower = sharper corners, higher = rounder |
| `-O <n>` | Curve optimisation tolerance (default 0.2). `-n` turns optimisation off entirely |
| `--tight` | Strip whitespace around the input image |
| `-x <n>` | Scale factor for pixel-based backends |

## Why installed
Vectorising a raster logo otherwise means Illustrator's Image Trace or an online converter. This is the same job in a pipe, offline, scriptable.

## Biggest win
`-t` alone rescues most bad traces. A scan traced with default turdsize carries every dust speck as a path; `-t 5` deletes them before they ever become geometry.

## Gotchas

- **EPS is the default backend, not SVG.** Forget `-s` and you get an `.svg` filename containing PostScript.
- **Two colours only.** Anything else gets threshold-flattened by potrace's own crude method — set the threshold in ImageMagick where you can actually see it, not by accident here.
- **Transparency reads as black.** `-alpha remove` in the ImageMagick step, or a transparent PNG traces as a solid block.
