---
title: Artwork pipeline
type: reference
status: active
updated: 2026-06-04
description: art-* — config-driven artwork export pipeline (print TIFF/JPG + web 4:5 + web ratio).
tags:
  - project/dotfiles
  - domain/scripts/artwork
---

# Artwork pipeline (`art-`)

A YAML-config-driven master→exports pipeline. The script + its config travel together.

| File | Role |
|------|------|
| `art-process.sh` | Reads `art-export.yml`, copies the source TIFF as master, then exports: print **TIFF** + print **JPG** (per `print.sizes`/`dpi`) + web **4:5** + web **original-ratio** JPEGs (sRGB, stripped) into a slugified folder tree |
| `art-export.yml` | Config: `paths.*` (output subdirs), `print.{sizes,dpi,jpg_quality}`, `web_4_5.{sizes,quality}`, `web_ratio.{sizes,quality}` |

**Usage:** `art-process.sh <source-master.tif> <output-folder-name>`

> Quarantined `process_artwork.sh` was the older predecessor (fewer exports, different `artwork_export.yml` schema).
