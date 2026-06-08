---
title: Any image → JPG/PNG (and Quick Action)
type: playbook
status: active
updated: 2026-06-08
audience: internal
description: img-convert.sh — convert any raster image → JPG/PNG via ImageMagick, fit within 2000px by default, then wire it into a Finder right-click Quick Action with a jpg/png prompt.
providers:
  - ImageMagick
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
  - "[[10-quick-actions|Quick Actions (qa-)]]"
---

# Any image → JPG/PNG (`img-convert.sh`) + Quick Action

## Overview

The generic sibling of [[img-from-psd|img-from-psd.sh]]: same flag style, but it
takes **any** raster source (jpg/png/tif/webp/heic/psd/…) instead of only PSDs,
defaults to fitting the result **within a 2000px box**, and exposes the **jpg/png
choice** both as a flag (`-f`) and as a run-time dialog (`-P`) so a single Finder
Quick Action can ask the format on each run.

The script is the source of truth (`~/.dotfiles/bin/img-convert.sh`, symlinked
onto `PATH`); this doc is the reference.

> Same Automator gotcha as every image action: it runs with a **bare PATH**, so
> `magick` is invisible unless you export `PATH` inside the action (see §4).

## 0. Prerequisites

- [ImageMagick](https://imagemagick.org) on `PATH` — verify with `magick -version`. Install via [Homebrew](https://brew.sh): `brew install imagemagick`. (Confirmed working: ImageMagick 7.1.2.)
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
img-convert.sh -f png shot.tif             # → shot.png, keeps transparency
img-convert.sh -r none big.tif             # → big.jpg, full size (no resize)
img-convert.sh -r 1920x1080 *.png          # fit each inside 1920x1080
img-convert.sh -o out -q 92 *.heic         # batch into ./out at quality 92
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

## 4. Wire it into a Finder Quick Action

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

## 5. One action, with a JPG/PNG prompt

The whole point of the `-P` flag: a single Quick Action that asks the format on
each run. The script's built-in `osascript` dialog fires before any work, while
`"$@"` still carries the selected files. Cancel = no-op.

```sh
qa-make.sh -t public.image "Convert image (pick format)" \
  'export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"; "$HOME/.dotfiles/bin/img-convert.sh" -P "$@"'
```

To prompt for resolution too, drop an inline `choose from list` into the action
body the way [[img-from-psd]] §5 does and pass the chosen `-r` through.

## 6. Verification

- CLI: `img-convert.sh -r 50% test.heic` prints `test.heic -> test.jpg`, and `magick identify test.jpg` reports the halved dimensions, sRGB, no alpha.
- Default fit: a 3000×4000 source → `magick identify` shows `1500x2000` (long edge capped at 2000).
- Collision guard: `img-convert.sh photo.jpg` writes `photo-2000px.jpg`, leaving `photo.jpg` untouched.
- Quick Action: right-click an image in Finder → **Quick Actions** → your action. With the §5 `-P` body, the JPG/PNG dialog shows first.
- PATH sanity: if the Quick Action silently does nothing, run the same body in Terminal — a `magick: command not found` confirms the PATH export (§4) is missing.
