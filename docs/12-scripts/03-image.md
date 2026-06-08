---
title: Image scripts
type: reference
status: active
updated: 2026-06-05
description: img-* — 2D image crop/resize/web-export helpers (ImageMagick).
tags:
  - project/dotfiles
  - domain/scripts/image
related:
  - "[[img-from-psd|PSD → image (deep-dive + Quick Action)]]"
  - "[[img-canvas|Fixed-aspect canvas (deep-dive + Quick Action)]]"
  - "[[img-convert|Any image → JPG/PNG (deep-dive + Quick Action)]]"
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
| `img-from-psd.sh` | Convert PSD(s) → JPG/PNG, optional resize | `img-from-psd.sh [-f png\|jpg] [-r geom] [-q n] [-o dir] FILE...` |
| `img-canvas.sh` | Fit any image into a fixed social aspect (cover) | `img-canvas.sh -a 4:5 [-s 2] [-m cover\|fit] <img>...` |
| `img-convert.sh` | Convert any image **or PDF** → JPG/PNG, fit within 2000px | `img-convert.sh [-f jpg\|png] [-r geom] [-q n] [-d dpi] [-a] [-o dir] FILE...` |

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

### `img-from-psd.sh`
- **Does:** Converts one or more PSDs to JPG (default) or PNG, reading the merged composite layer (`[0]`) so layered files convert cleanly where `sips` chokes. JPG flattens onto white; PNG keeps transparency. Optional `-r` resize.
- **Usage:** `img-from-psd.sh [-f png|jpg] [-r geom] [-q n] [-d dpi] [-o dir] FILE...`
- **Args/behavior:** `-f` jpg/png (default jpg); `-r` ImageMagick geometry (`2000x`, `50%`, `1920x1080` fit, `^` fill, `!` force-exact, `>` shrink-only); `-q` jpg quality (default 90); `-d` DPI metadata tag only (no re-raster); `-o` output dir (default beside each source). Output is `<name>.<fmt>`; overwrites. Prints `src -> dst` per file, skips missing inputs.
- **Examples:** `img-from-psd.sh art.psd` · `img-from-psd.sh -f png art.psd` · `img-from-psd.sh -r 1920x1080 *.psd` · `img-from-psd.sh -o out -q 92 *.psd`
- **Deps/gotchas:** imagemagick. Without `[0]` ImageMagick exports every layer as a frame. `-d` only tags DPI metadata — use `-r` for real pixel resize. Full resize cheat-sheet + the Finder Quick-Action wiring (incl. a resolution-prompt variant) live in [[img-from-psd|the deep-dive]].

### `img-canvas.sh`
- **Does:** Fits any image into one of 7 fixed-aspect canvases (9:16, 3:5, 4:5, 1:1, 5:4, 5:3, 16:9 — short side 1080, or a raw `WxH`) at exact pixels. Default **cover**: scale to fill, center-crop the overflow (no bars, no distortion). `-auto-orient`, frame `[0]` (PSD/multi-frame ok), sRGB 8-bit.
- **Usage:** `img-canvas.sh -a RATIO [-s 1|2] [-m cover|fit|stretch] [-g gravity] [-f jpg|png] [-q n] [-b bg] [-o dir] FILE...`
- **Args/behavior:** `-a` required (preset, `WxH`, or `orig` = keep source ratio); `-s` 1/2 → short side 1080×N, or `orig` = keep source resolution (crop/pad, no scale); `-m` cover (default) / fit (scale-to-fit + pad to exact with `-b` bg) / stretch (force-exact, distorts); `-g` crop/pad gravity (default center); `-f` jpg/png; `-q` jpg quality (90); `-b` bg (default white jpg / none png); `-P` GUI pick mode for Quick Actions. Output `<base>_<W>x<H>.<fmt>` beside source (overwrites), or into `-o`. Prints `src -> dst`.
- **Examples:** `img-canvas.sh -a 4:5 photo.jpg` (→ `photo_1080x1350.jpg`) · `img-canvas.sh -a 9:16 -s 2 hero.png` · `img-canvas.sh -a 1:1 -m fit -b black art.tif`
- **Deps/gotchas:** imagemagick. cover **will upscale** a source smaller than the canvas to fill it. Full preset table + the multi-prompt Finder Quick Action live in [[img-canvas|the deep-dive]].

### `img-convert.sh`
- **Does:** Converts any raster image **or PDF/EPS** (jpg/png/tif/webp/heic/psd/pdf/eps/…) to JPG (default) or PNG, reading frame `[0]` so multi-frame/layered/multi-page files yield a single still. By default fits the result within a 2000×2000 box (aspect kept, shrink-only). `-auto-orient` first, sRGB 8-bit; JPG composites onto white (per-page, so `-a` keeps every page), PNG keeps alpha.
- **Usage:** `img-convert.sh [-f jpg|png] [-r geom] [-q n] [-d dpi] [-a] [-o dir] FILE...` · `img-convert.sh -P …` (format prompt, for Quick Actions)
- **Args/behavior:** `-f` jpg/png (default jpg); `-r` geometry (default `2000x2000>` = fit within 2000px, shrink-only; `-r none` = full size); `-q` jpg quality (default 90); `-d` rasterize DPI for vector sources pdf/eps/ai/ps (default 300; raster ignores it — without it Ghostscript renders at 72 dpi and the fit-2000 has nothing to shrink); `-a` all pages → `<base>-p01.<fmt>, -p02, …` (default is first page only); `-o` output dir (default beside source); `-P` GUI format picker. If the output would overwrite a same-name same-format source, a `-<cap>px` suffix is added (e.g. `photo.jpg` → `photo-2000px.jpg`) — the source is never clobbered. Prints `src -> dst`, skips missing inputs.
- **Examples:** `img-convert.sh photo.heic` · `img-convert.sh deck.pdf` (first page @300dpi) · `img-convert.sh -a deck.pdf` (every page) · `img-convert.sh -f png shot.tif` · `img-convert.sh -d 600 -r none poster.pdf`
- **Deps/gotchas:** imagemagick; **Ghostscript (`gs`) for PDF/EPS input**. The generic sibling of [[img-from-psd]] (PSD-only) — same flag style, any source, plus a default 2000px fit and a jpg/png `-P` prompt. Full Quick-Action wiring in [[img-convert|the deep-dive]].

> The older `crop2000x2500-01.sh` (a cruder duplicate of `img-crop-2000x2500.sh`) is superseded — now in `~/_temp/bin_bak/`.
