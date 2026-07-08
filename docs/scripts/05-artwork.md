---
title: Artwork pipeline
type: reference
status: active
updated: 2026-06-05
description: art-* — config-driven artwork export pipeline (print TIFF/JPG + web 4:5 + web ratio).
aliases:
  - artwork
tags:
  - project/dotfiles
  - domain/scripts/artwork
---

# Artwork pipeline (`art-`)

A YAML-config-driven master→exports pipeline: one flattened master TIFF in, four export families out. The script + its config travel together.

| File | Role |
|------|------|
| `art-process.sh` | Reads `art-export.yml`, copies the source TIFF as master, then renders print **TIFF** + print **JPG** + web **4:5** + web **original-ratio** into a slugified folder tree. |
| `art-export.yml` | Config (NOT a script): `paths.*` (output subdir names), `print.{sizes,dpi,jpg_quality}`, `web_4_5.{sizes,quality}`, `web_ratio.{sizes,quality}`. |

## Usage

```
art-process.sh <source-file> <output-folder>
art-process.sh -h | --help
```

- `<source-file>` — flattened master TIFF, must exist.
- `<output-folder>` — destination root name; slugified (lowercased, non-alphanumerics → dashes), so `"Raven 01"` → `raven-01/`.
- `-h, --help` — print usage and exit.

**Example:** `art-process.sh ~/art/raven-flat.tif "Raven 01"` → builds `./raven-01/` with all five subdirs.

## Stages

The script runs straight through, no flags gating stages — every run produces the full set.

1. **Slugify + validate** — slug the root and the source basename; hard-fail if the config or source file is missing (fail-fast, no half-built tree).
2. **Read config** — a `read_yaml()` PyYAML helper pulls values by dotted key path; lists/dicts come back as Python `repr()` so the export heredocs `ast.literal_eval()` them straight into objects.
3. **Make tree + copy master** — create the five subdirs, then copy the source verbatim to `master/<slug>_flat-master.tif` (no transform — preserves the canonical full-res file).
4. **Print TIFF** — one LZW (lossless) TIFF per `print.sizes` entry at `print.dpi`, fit-inside the WxH box (aspect preserved, no upscale-past-box).
5. **Print JPG** — same paper sizes, flattened/stripped/sRGB/8-bit/baseline JPEGs at `print.jpg_quality`.
6. **Web 4:5** — forced 4:5 portrait crops; each `web_4_5.sizes` `long_edge` is the **width**, height = width×1.25, scaled to cover then center-cropped (`-resize ^` + `-extent`).
7. **Web ratio** — original-aspect JPEGs, no crop; each `web_ratio.sizes` `long_edge` sets the **height** (`-resize x{H}`), width follows the source aspect.

## What `art-export.yml` controls

| Key | Drives |
|-----|--------|
| `paths.{master_dir,print_tif_dir,print_jpg_dir,web_45_dir,web_ratio_dir}` | Output subdir names (default `master`, `print-tif`, `print-jpg`, `web-4-5`, `web-ratio`). |
| `print.dpi` | Print resolution metadata (default `300`). |
| `print.jpg_quality` | Print-JPG quality (default `90`). |
| `print.sizes[]` | `{name, width_px, height_px}` per paper size — ships A4/A3/A2/A1 at 300dpi pixel dims. |
| `web_4_5.{quality,sizes[]}` | 4:5 crops; quality `80`, sizes by `long_edge` (width): 2000/1200/800/400. |
| `web_ratio.{quality,sizes[]}` | Original-ratio web; quality `80`, sizes by `long_edge` (height): 2840/1700/1132/566. |

## Output layout

Under the slugified `<output-folder>` root:

```
master/      <slug>_flat-master.tif          # verbatim copy of source
print-tif/   <slug>-print-<A4|A3|A2|A1>.tif  # LZW, 300dpi
print-jpg/   <slug>-print-<A4|A3|A2|A1>.jpg  # flattened, sRGB, baseline
web-4-5/     <slug>-<edge>-4x5.jpg           # center-cropped to 4:5
web-ratio/   <slug>-<edge>-ratio.jpg         # height-fit, original aspect
```

## Dependencies

- **ImageMagick 7** — the `magick` binary (every export shells out to it).
- **python3 + PyYAML** — config parsing and the per-stage export loops.
- No ffmpeg, no other binaries.

> The older predecessor `process_artwork.sh` (fewer exports, different `artwork_export.yml` schema) is superseded — now in `~/_temp/bin_bak/`.
