---
title: Image scripts
type: reference
status: active
updated: 2026-06-05
description: img-* — 2D image crop/resize/web-export helpers (ImageMagick).
tags:
  - project/dotfiles
  - domain/scripts/image
---

# Image / 2D (`img-`)

All use `magick` (ImageMagick). Most output sRGB 8-bit JPEG q80 unless noted.
Every script takes `-h` / `--help` and prints its own usage. Magic dimensions
(2000×2500, 1920×1080) and q80 are the house defaults — see each entry.

| Script | Does | Usage |
|--------|------|-------|
| `img-crop-2000x2500.sh` | Hard crop to 2000×2500 (no scaling) | `img-crop-2000x2500.sh <img> [gravity] [out.jpg]` |
| `img-crop-2000x2500-resize.sh` | Scale by % first, then crop to 2000×2500 | `img-crop-2000x2500-resize.sh <img> [gravity] [50\|75\|100] [out.jpg]` |
| `img-resize-1080.sh` | Resize + center-crop to exactly 1920×1080 | `img-resize-1080.sh <src> [out]` |
| `img-web.sh` | One web JPEG, resized to a target width | `img-web.sh <src> [width]` |
| `img-web-batch.sh` | Batch-optimize every image in the cwd | `img-web-batch.sh [width]` (runs in cwd) |
| `img-web-aspect.sh` | Responsive width set, aspect preserved | `img-web-aspect.sh <src>` |
| `img-web-thumb.sh` | Responsive set cropped to fixed 2:1 | `img-web-thumb.sh <src>` |

## Per script

### `img-crop-2000x2500.sh`
- **Does:** Cuts a fixed 2000×2500 px rectangle (4:5 portrait) out of the source — no scaling, so a smaller source yields fewer pixels rather than an upscale. Auto-orients EXIF, flattens, strips, → sRGB 8-bit JPEG q80.
- **Usage:** `img-crop-2000x2500.sh <image.(tif|tiff|png|jpg)> [gravity] [output.jpg]`
- **Args/behavior:** `gravity` (default `center`) anchors which part is kept; `output` defaults to `<source>_2000x2500_<gravity>.jpg` beside the source and overwrites it.
- **Examples:** `img-crop-2000x2500.sh photo.tif north` · `img-crop-2000x2500.sh photo.tif center cover.jpg`
- **Deps/gotchas:** imagemagick. Prints `Created: <out>`. The `2000x2500+0+0` geometry is a fixed-size box; gravity (not the `+0+0`) decides position.

### `img-crop-2000x2500-resize.sh`
- **Does:** Same fixed 2000×2500 crop, but runs a percentage resize on the whole image *first* — shrink to fit more in frame, or enlarge a small source to fill it. → sRGB 8-bit JPEG q80.
- **Usage:** `img-crop-2000x2500-resize.sh <image> [gravity] [scale:50|75|100] [output.jpg]`
- **Args/behavior:** `scale` (default 100) is the pre-crop resize percent; `output` defaults to `<source>_2000x2500_<gravity>_<scale>pct.jpg`, beside the source, overwriting.
- **Examples:** `img-crop-2000x2500-resize.sh photo.tif center 75` · `… north 50 out.jpg`
- **Deps/gotchas:** imagemagick. Unlike its sibling it prints **nothing** on success. At a small scale the result can be under 2000×2500 (no upscale-to-fill) — verified: 2400×3000 src at 50% → 1200×1500 out.

### `img-resize-1080.sh`
- **Does:** Fills a Full-HD 1920×1080 (16:9) frame — scales so the shorter side covers the box (`^` = cover), then center-crops the overflow to exactly 1920×1080. No distortion, no letterbox.
- **Usage:** `img-resize-1080.sh <source> [output]`
- **Args/behavior:** `output` defaults to `<source>_1920x1080.<ext>` beside the source and **keeps the source extension** (PNG in → PNG out), overwriting.
- **Examples:** `img-resize-1080.sh shot.jpg` · `img-resize-1080.sh shot.png wallpaper.png`
- **Deps/gotchas:** imagemagick. No `-strip`/`-quality`, so format defaults apply (output is not minimized). Prints `Created: <out>`.

### `img-web.sh`
- **Does:** One web-optimized JPEG resized to a target width (height auto, aspect kept). Flatten, strip, → sRGB 8-bit JPEG q80.
- **Usage:** `img-web.sh <source> [width]`
- **Args/behavior:** `width` default 2560. **Output goes to the cwd as `<slug>.jpg`** (lowercased, URL-safe slug of the source name), *not* beside the source — e.g. `My Photo.TIF` → `./my-photo.jpg`. Overwrites.
- **Examples:** `img-web.sh photo.tif` (2560px) · `img-web.sh photo.tif 1200`
- **Deps/gotchas:** imagemagick. `${WIDTH}x` has no `>` guard, so it **will upscale** a source narrower than `width`.

### `img-web-batch.sh`
- **Does:** Batch-optimizes **every** `*.jpg/*.jpeg/*.png/*.tiff/*.heic` in the current directory (case-insensitive, non-recursive): down-scales to a max width and writes size-capped sRGB JPEGs. Originals untouched.
- **Usage:** `img-web-batch.sh [width]` — run it **inside** the folder of images.
- **Args/behavior:** `width` default 2560; `${WIDTH}x>` only shrinks (never upscales). Output → `./web_optimized/<slug>.jpg`, each capped near 500kb via `-define jpeg:extent`. Overwrites same-named files; folder auto-created.
- **Examples:** `img-web-batch.sh` · `img-web-batch.sh 1200`
- **Deps/gotchas:** imagemagick. `MAX_SIZE=500kb` is a target, not a hard cap. No `-depth 8` (differs from the other scripts). No matching files → silent no-op (`nullglob`).

### `img-web-aspect.sh`
- **Does:** From one source emits a responsive width ladder — 1600 / 1200 / 800 / 400 px — each resized by width only, so the **original aspect ratio is preserved** (no crop). sRGB 8-bit JPEG q80.
- **Usage:** `img-web-aspect.sh <source>`
- **Args/behavior:** Output → `./<slug>/web/<slug>-<width>.jpg`; the `<slug>/web/` dir is created in the cwd. Overwrites same-named files. Edit the `SIZES` array to change the ladder.
- **Examples:** `img-web-aspect.sh hero.tif` → `hero/web/hero-1600.jpg … hero-400.jpg`
- **Deps/gotchas:** imagemagick. Aspect-preserving — for fixed-ratio thumbnails use `img-web-thumb.sh`.

### `img-web-thumb.sh`
- **Does:** From one source emits the same 1600/1200/800/400 width ladder but **cropped to a fixed 2:1 landscape** (width × width/2): cover-scale, then center-crop. Outputs are exact 2:1 thumbs (1600×800, 1200×600, 800×400, 400×200). sRGB 8-bit JPEG q80.
- **Usage:** `img-web-thumb.sh <source>`
- **Args/behavior:** Output → `./<slug>/web/<slug>-<width>.jpg` in the cwd; overwrites. Change the ratio via the `height=` line, widths via `SIZES`.
- **Examples:** `img-web-thumb.sh card.tif` → `card/web/card-1600.jpg` (1600×800) …
- **Deps/gotchas:** imagemagick. This is the **cropping** counterpart of `img-web-aspect.sh` (note: the two are easy to confuse — aspect = preserve, thumb = crop to 2:1).

> The older `crop2000x2500-01.sh` (a cruder duplicate of `img-crop-2000x2500.sh`) is superseded — now in `~/_temp/bin_bak/`.
