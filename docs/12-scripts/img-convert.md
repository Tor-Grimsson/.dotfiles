---
title: Any image or PDF → JPG/PNG (and Quick Action)
type: playbook
status: active
updated: 2026-07-02
audience: internal
description: img-convert.sh — convert any raster image or PDF → JPG/PNG via ImageMagick (Ghostscript for PDF), fit within 2000px by default, then wire it into a Finder right-click Quick Action with a jpg/png prompt.
providers:
  - ImageMagick
  - Ghostscript
  - Automator
tags:
  - project/dotfiles
  - domain/scripts/image
  - domain/macos
  - pattern/quick-action
aliases:
  - image-to-jpg
  - image-to-png
  - img2jpg
related:
  - "[[03-image|Image scripts (img-)]]"
  - "[[img-from-psd|PSD → image (deep-dive)]]"
  - "[[img-from-video|Video frame → image (deep-dive)]]"
  - "[[10-quick-actions|Quick Actions (qa-)]]"
---

# Any image or PDF → JPG/PNG (`img-convert.sh`) + Quick Action

## Overview

The generic sibling of [[img-from-psd|img-from-psd.sh]]: same flag style, but it
takes **any** raster source (jpg/png/tif/webp/heic/psd/…) **or a PDF/EPS** instead
of only PSDs, defaults to fitting the result **within a 2000px box**, and exposes
the **jpg/png choice** both as a flag (`-f`) and as a run-time dialog (`-P`) so a
single Finder Quick Action can ask the format on each run.

PDFs are vector, so they get one extra step — a render resolution (`-d`, default
300 dpi) applied **before** the resize. See §5. By default only the first page
is exported; `-a` writes every page as `<base>-p01.<fmt>, -p02, …`.

The script is the source of truth (`~/.dotfiles/bin/img-convert.sh`, symlinked
onto `PATH`); this doc is the reference.

> Same Automator gotcha as every image action: it runs with a **bare PATH**, so
> `magick` is invisible unless you export `PATH` inside the action (see §6).

## 0. Prerequisites

- [ImageMagick](https://imagemagick.org) on `PATH` — verify with `magick -version`. Install via [Homebrew](https://brew.sh): `brew install imagemagick`. (Confirmed working: ImageMagick 7.1.2.)
- [Ghostscript](https://www.ghostscript.com) (`gs`) — **only needed for PDF/EPS input**; ImageMagick shells out to it to rasterize vector pages. `brew install ghostscript`, verify with `gs --version`. Raster-only use doesn't need it.
- macOS with **Automator** (built in) for the Quick Action.

## 1. The core one-liner

`[0]` reads frame 0 — for a normal JPEG it's a no-op, but for a multi-page TIFF,
animated GIF, HEIC, or layered PSD it picks the single still / composite instead
of exporting every frame. `-auto-orient` honors phone EXIF rotation first.

```sh
# any image → JPG, fit within 2000px, flattened onto white, quality 90, sRGB
magick "input.heic[0]" -auto-orient -resize "2000x2000>" \
  -background white -flatten -quality 90 -colorspace sRGB -depth 8 output.jpg

# any image → PNG, transparency preserved
magick "input.tif[0]" -auto-orient -resize "2000x2000>" \
  -background none -colorspace sRGB -depth 8 output.png
```

`2000x2000>` is the default fit: scale so neither side exceeds 2000px, aspect
kept, and the `>` means **shrink-only** (a smaller source is left alone).

## 2. The script

The reusable form lives at `bin/img-convert.sh` — batch input, format/resize/
quality/outdir flags, a `-P` format prompt, and `--help`. Run
`img-convert.sh --help` for the full contract; catalog entry in [[03-image|Image scripts]].

```sh
img-convert.sh photo.heic                  # → photo.jpg, fit within 2000px
img-convert.sh deck.pdf                    # → deck.jpg, first page @300dpi, fit 2000px
img-convert.sh -a deck.pdf                 # → deck-p01.jpg, deck-p02.jpg, … (all pages)
img-convert.sh -f png shot.tif             # → shot.png, keeps transparency
img-convert.sh -r none big.tif             # → big.jpg, full size (no resize)
img-convert.sh -d 600 -r none poster.pdf   # → poster.jpg, 600dpi full-res render
img-convert.sh -o out -q 92 *.heic         # batch into ./out at quality 92
img-convert.sh -f png -c 256 art.png       # flat PNG: quantize palette (see §4)
```

**Collision guard:** writing `<base>.<fmt>` beside a source of the *same* format
(e.g. `photo.jpg` → `photo.jpg`) would clobber the original — and APFS is
case-insensitive, so `photo.JPG` collides too. When that happens the output gets
a size suffix instead: `photo.jpg` → `photo-2000px.jpg`. The source is never
overwritten. (Cross-format — `photo.png` → `photo.jpg` — never collides.)

## 3. Resolution options — the `-r` cheat sheet

`-r` takes an ImageMagick **geometry**. Default is `2000x2000>` (fit within
2000px, shrink-only); pass `-r none` to keep full size.

| Geometry | Effect |
|---|---|
| `2000x2000>` | **default** — fit within 2000px, shrink-only (never upscale) |
| `2000x` | width 2000, height auto |
| `x1080` | height 1080, width auto |
| `1920x1080` | **fit** inside the box (largest that fits, aspect kept) |
| `1920x1080^` | **fill** the box (smallest that covers; crop after if needed) |
| `1920x1080!` | force exact size — **ignores aspect ratio**, distorts |
| `50%` | scale to 50% |
| `none` | no resize — keep the source's pixels |

### Why "fit" can land 1px off target — and `-e` to force it exact

Plain `WxH` (no modifier) is a **fit-inside** box: ImageMagick picks the scale
factor from whichever axis is the binding constraint, then rounds width and
height *independently*. When the source's aspect ratio is close to but not
exactly the target's, the non-binding axis can round to target **minus** a
pixel — a 1854×2316 source fit into `1600x2000` lands at **1600×1999**, not
1600×2000. This isn't a bug in the script or in ImageMagick; it's inherent to
independent per-axis rounding of a shared scale factor, and it's a well-known
ImageMagick quirk. (It can't round the *other* way and land at 1601 — a plain
fit box never exceeds the target on either axis, by definition of "fit.")

If you need the literal target dimensions — export specs, a print/social
deliverable with a hard requirement — pass **`-e`** alongside a `WxH` `-r`:

```sh
img-convert.sh -r 1600x2000 -e photo.jpg   # exactly 1600x2000, guaranteed
```

`-e` runs a `-gravity center -extent WxH` pass after the normal resize —
crops any overflow, pads any shortfall with the same background already in
use (white for jpg, transparent for png). No distortion (that's `!`, a
different thing) — this is cover+crop, the same mechanism
[[img-canvas|img-canvas.sh]] uses for its aspect presets, just exposed as a
flag here instead of a separate tool. Requires `-r` to be a literal `WxH`;
errors clearly on `-r none`, `-r 50%`, or single-axis forms like `-r 2000x`
(no second dimension to extend against).

## 4. PNG compression (`-c`) — and why `-q` barely moves PNG at all

`-q` is jpg's real lever (1-100 lossy quality). For png it only tunes zlib
compression effort + filter — lossless, a few percent at best. It does **not**
reduce color depth, which is what actually bloats a PNG.

The real lever for a **flat graphic/illustration** (not a photo) is palette
quantization: `-c N` reduces to N colors. A busy vector-style PNG — flat fills
plus anti-aliased edges — routinely carries tens of thousands of distinct
colors it doesn't need, almost all of it anti-aliasing noise along curves.
Quantizing to 256 or fewer is usually visually identical and cuts file size
70-90%:

```sh
img-convert.sh -f png -r 1600x2000 -c 256 art.png   # resize + quantize, one pass
```

Real numbers from a 1854×2316, 3.0 MB source (dense flat illustration, dark bg):

| Pass | Colors | Size |
|---|---|---|
| resize only (`-r 1600x2000`, no `-c`) | 41,165 | 2.4 MB |
| `-c 256` | 254 | 0.68 MB |
| `-c 64` | 64 | 0.50 MB |

**No dithering, deliberately.** `-c` uses `-dither None`, not the more common
`FloydSteinberg`. Dithering error-diffuses the quantization error into
neighboring pixels to fake smoother gradients — which inflates the *actual*
output color count well past the requested `-c N` (`-c 256` measured **777**
actual colors with dithering on this source). PNG's indexed color-type caps at
256 palette entries; blow past that and ImageMagick silently falls back to
full truecolor, and the whole size win evaporates. No dithering keeps the
requested count exact and guarantees it stays palette-eligible — the right
trade for flat art with hard edges. **Skip `-c` for photos** — no dithering
means visible banding on real gradients; photos should stay off `-c` (or use
jpg, where `-q` is the correct lossy lever).

`-c` is ignored for jpg (jpg has no palette).

## 5. PDFs and other vector sources (`-d`, `-a`)

A PDF/EPS/AI has no pixels — ImageMagick rasterizes it through Ghostscript at a
**density** you choose. The default is **72 dpi**, which makes a Letter page only
~612px wide; the fit-to-2000 resize is shrink-only, so it can't enlarge that, and
you'd get a tiny image. So the script renders vector sources at **`-d` dpi (default
300)** *before* the resize: 300 dpi turns a Letter/A4 page into ~2500–3500px, which
the `2000x2000>` fit then cleanly shrinks to 2000px on the long edge.

```sh
img-convert.sh deck.pdf            # first page, 300dpi render → fit 2000px → deck.jpg
img-convert.sh -d 150 flyer.pdf    # lighter render (≈1275px wide page), still fit 2000
img-convert.sh -d 600 -r none art.pdf   # full 600dpi raster, no downscale
```

The `-d` value is the render resolution, not the output size — pair it with `-r`
to control final pixels. For a guaranteed-crisp result just leave `-d 300` and let
the default fit do the sizing. Raster sources (jpg/heic/…) ignore `-d` entirely.

**Multi-page PDFs.** By default only the **first page** is converted (frame `[0]`)
— the right call for a "make this a shareable image" action. Pass **`-a`** to
export every page:

```sh
img-convert.sh -a slides.pdf       # → slides-p01.jpg, slides-p02.jpg, slides-p03.jpg, …
img-convert.sh -a -f png slides.pdf
```

Page numbering is 1-based (`-p01`, `-p02`, …). The JPG path composites each page
onto white with `-alpha remove` **per image** — not `-flatten`, which would merge
every page into a single composite. For an all-pages full-resolution dump (300 dpi,
no fit) reach for [[04-pdf|pdf-to-png.sh]] instead; this tool is the sized/export form.

## 6. Wire it into a Finder Quick Action

The generic recipe (and `qa-make.sh` to stamp one from a single line) is in
[[10-quick-actions|Quick Actions]]. The PATH export lists **both** brew prefixes
so the action works on the Intel iMac (`/usr/local`) *and* the Apple-Silicon MBP
(`/opt/homebrew`) — the absent one is just an ignored PATH entry.

```sh
# fixed format: any image → 2000px JPG
qa-make.sh -t public.image "Convert image → JPG (2000px)" \
  'export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"; "$HOME/.dotfiles/bin/img-convert.sh" "$@"'

# fixed format: any image → 2000px PNG (keeps transparency)
qa-make.sh -t public.image "Convert image → PNG (2000px)" \
  'export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"; "$HOME/.dotfiles/bin/img-convert.sh" -f png "$@"'
```

## 7. One action, with a JPG/PNG prompt

The whole point of the `-P` flag: a single Quick Action that asks the format on
each run. The script's built-in `osascript` dialog fires before any work, while
`"$@"` still carries the selected files. Cancel = no-op.

Type it `public.image,com.adobe.pdf` so the **same** action fires on both images
and PDFs (a PDF → first page @300dpi, fit 2000px, in the format you pick). This is
the live action stamped into `~/Library/Services` — re-running `qa-make.sh --force`
with the same name updates it in place.

```sh
qa-make.sh -t public.image,com.adobe.pdf "Convert image (pick format)" \
  'export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"; "$HOME/.dotfiles/bin/img-convert.sh" -P "$@"'
```

To prompt for resolution too, drop an inline `choose from list` into the action
body the way [[img-from-psd]] §5 does and pass the chosen `-r` through.

## 8. Verification

- CLI: `img-convert.sh -r 50% test.heic` prints `test.heic -> test.jpg`, and `magick identify test.jpg` reports the halved dimensions, sRGB, no alpha.
- Default fit: a 3000×4000 source → `magick identify` shows `1500x2000` (long edge capped at 2000).
- Collision guard: `img-convert.sh photo.jpg` writes `photo-2000px.jpg`, leaving `photo.jpg` untouched.
- Quick Action: right-click an image **or PDF** in Finder → **Quick Actions** → your action. With the §7 `-P` body, the JPG/PNG dialog shows first.
- PDF: `img-convert.sh deck.pdf` → `deck.jpg`; `magick identify deck.jpg` shows the long edge at 2000px. `-a deck.pdf` writes `deck-p01.jpg`, `deck-p02.jpg`, … one per page.
- PATH sanity: if the Quick Action silently does nothing, run the same body in Terminal — a `magick: command not found` confirms the PATH export (§6) is missing.
- PNG quantization: `img-convert.sh -f png -c 256 art.png`; `magick identify -format "%[colors]" art.png` reports ≤256, and file size drops sharply vs. no `-c`.
- Exact dimensions: `img-convert.sh -r 1600x2000 -e photo.jpg`; `magick identify -format "%wx%h" photo.jpg` reports exactly `1600x2000` — compare against the same command without `-e`, which may land 1px short on one axis. `img-convert.sh -r 50% -e photo.jpg` errors clearly (no `WxH` to extend against).
