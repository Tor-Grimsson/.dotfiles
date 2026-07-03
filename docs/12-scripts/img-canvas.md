---
title: Fixed-aspect canvas (and Quick Action)
type: playbook
status: active
updated: 2026-07-02
audience: internal
description: img-canvas.sh — fit any image into a fixed social-media aspect ratio (cover/fit/stretch, 1x/2x, sRGB) via ImageMagick, then wire it into a Finder Quick Action that prompts for ratio + scale.
providers:
  - ImageMagick
  - Automator
tags:
  - project/dotfiles
  - domain/scripts/image
  - domain/macos
  - pattern/quick-action
aliases:
  - img-canvas
  - social-canvas
related:
  - "[[03-image|Image scripts (img-)]]"
  - "[[10-quick-actions|Quick Actions (qa-)]]"
  - "[[img-from-psd|PSD → image]]"
  - "[[img-convert|Any image or PDF → JPG/PNG]]"
---

# Fixed-aspect canvas (`img-canvas.sh`) + Quick Action

## Overview

One script to drop any image into a fixed social-media aspect ratio at exact pixels. Default mode is **cover** — scale the image up/down so it fills the whole frame, then center-crop the overflow: no letterbox bars, no distortion, the way Instagram/CMS crops behave. `fit` (pad) and `stretch` are there when you need them.

The script is the source of truth (`~/.dotfiles/bin/img-canvas.sh`, on `PATH`); this doc is the reference.

> Same Automator gotcha as every Quick Action: it runs with a **bare PATH**, so `magick` is invisible unless you export PATH inside the action (see §5).

## 0. Prerequisites

- [ImageMagick](https://imagemagick.org) on `PATH` — `magick -version`. Install: `brew install imagemagick`.
- macOS with **Automator** (built in) for the Quick Action.

## 1. The core one-liner — cover

`^` resizes to **cover** the box (smallest size that fully covers), then `-extent` crops to the exact canvas around the chosen gravity. `-flatten` composites any alpha onto the background (JPEG has none).

```sh
# any image → 4:5 (1080×1350), filled + center-cropped, sRGB JPEG
magick "input.jpg[0]" -auto-orient -background white \
  -resize 1080x1350^ -gravity center -extent 1080x1350 \
  -flatten -colorspace sRGB -depth 8 -quality 90 output.jpg
```

`[0]` takes the first frame / merged composite, so layered PSDs and multi-frame files work too. `-auto-orient` honors EXIF rotation before the crop.

## 2. The script

`bin/img-canvas.sh` wraps that with the preset table, 1x/2x scaling, mode/gravity/format flags, and batch input. Run `img-canvas.sh --help` for the full contract; catalog entry in [[03-image|Image scripts]].

```sh
img-canvas.sh -a 4:5 photo.jpg              # → photo_1080x1350.jpg, cover
img-canvas.sh -a 9:16 -s 2 hero.png         # → hero_2160x3840.jpg
img-canvas.sh -a 1:1 -m fit -b black art.tif
img-canvas.sh -a 16:9 -f png -o out *.jpg   # batch into ./out, keep alpha
img-canvas.sh -a 1080x1350 -g north pose.psd
img-canvas.sh -a 4:5 -s orig big.tif        # crop to 4:5 at native resolution
img-canvas.sh -a orig -s orig raw.psd       # re-encode only (keep ratio + res)
```

## 3. Presets and modes

Short side is 1080 at 1x; `-s 2` doubles every dimension.

| `-a` | Ratio | 1x | 2x |
|---|---|---|---|
| `9:16` | portrait | 1080×1920 | 2160×3840 |
| `3:5`  | portrait | 1080×1800 | 2160×3600 |
| `4:5`  | portrait | 1080×1350 | 2160×2700 |
| `1:1`  | square   | 1080×1080 | 2160×2160 |
| `5:4`  | landscape| 1350×1080 | 2700×2160 |
| `5:3`  | landscape| 1800×1080 | 3600×2160 |
| `16:9` | landscape| 1920×1080 | 3840×2160 |

Or pass raw pixels: `-a 1080x1350`.

**Keep the source's own ratio or resolution** — `orig` works on either axis:

| Combo | Result |
|---|---|
| `-a 4:5` (default `-s 1`) | crop/fit to 4:5 at 1080×1350 |
| `-a 4:5 -s 2` | …same, at 2160×2700 |
| `-a 4:5 -s orig` | crop/pad to 4:5 at the **source's** pixels (no downscale) |
| `-a orig` | keep the source ratio, resize short side → 1080 (`-s 2` → 2160) |
| `-a orig -s orig` | plain re-encode — keep ratio **and** resolution (just format + sRGB) |

`-s orig` keeps native pixels: cover crops the long axis to the ratio, fit pads the short axis — neither scales. `-m stretch` needs a fixed `-s`.

| `-m` mode | Effect |
|---|---|
| `cover` (default) | Scale to **fill** the frame, center-crop the overflow. Output is the exact canvas. Upscales a too-small source. |
| `fit` | Scale to **fit inside**, then pad to the exact canvas with `-b` background (default white, or transparent for `-f png`). |
| `stretch` | Force the exact size — **ignores aspect ratio, distorts**. |

`-g` sets the gravity for the cover-crop or the fit-pad: `center` (default), `north`, `south`, `east`, `west`, `northwest`, … — use `north` to keep heads/tops when cropping portraits.

## 4. PNG palette quantization (`-c`)

Same mechanism as [[img-convert|img-convert.sh]]'s `-c` — no dithering, exact
requested color count, ignored for jpg. See that doc's §4 for the full why
(dithering silently defeats palette conversion above ~85 colors). Here it
quantizes the **finished canvas**, after the crop/pad, so the count applies to
what actually ships:

```sh
img-canvas.sh -a 4:5 -f png -c 256 logo.png
```

**How low can you reasonably go?** Depends entirely on how many *real*
colors the source has — a flat design with a handful of hues and sharp edges
tolerates far more quantization than one with real gradients. Measured on a
1600×2000 flat illustration (dark bg, ~4 real hues, anti-aliased edges,
41,165 raw colors from AA noise alone):

| `-c` | Actual colors | Size | Visible loss? |
|---|---|---|---|
| 256 | 254 | 0.69 MB | none |
| 128 | 126 | 0.61 MB | none |
| 64  | 64  | 0.50 MB | none |
| 32  | 30  | 0.39 MB | none |
| 16  | 16  | 0.33 MB | none, at normal viewing size |
| 8   | 8   | 0.25 MB | none, at normal viewing size — this is close to the floor for this source |

For a design this simple, 16-32 is a comfortable, confident floor with zero
visible loss; even 8 held up at normal viewing size in this test. That's
specific to *this* source's low real-color-count — don't treat 8 as a
universal safe number. A source with actual gradients (not just flat
regions + AA) will band much earlier; eyeball the result before shipping low.
256 is the safe default that's essentially always lossless-looking regardless
of source.

## 5. Wire it into a Finder Quick Action — ratio + scale prompt

The prompt logic lives in the script's **`-P` (pick) mode**, so the Quick Action stays a clean **one-liner** — no inline `osascript`, no multi-line nested quoting. (You *can* inline the `osascript` dialogs, but pasting that multi-line form into a shell with bracketed-paste off makes the shell evaluate the dialog mid-paste and drop you in a subshell — avoid it.) Generic recipe + the `qa-make.sh` stamper are in [[10-quick-actions|Quick Actions]]. Stamp it:

```sh
qa-make.sh -t public.image "Canvas (pick aspect)" \
  'export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"; "$HOME/.dotfiles/bin/img-canvas.sh" -P "$@"'
```

`-P` pops a dialog for aspect (the 7 presets **+ "original ratio"**), then scale (1x / 2x **+ "original resolution"**), then runs the cover conversion (cancel = no-op). Because the bundle just calls `img-canvas.sh -P`, the dialogs live in the script — adding choices there needs **no re-stamp**. The PATH export lists **both** brew prefixes so it works on the Intel iMac (`/usr/local`) and the Apple-Silicon MBP (`/opt/homebrew`) — the absent one is just an ignored PATH entry. (`$(brew --prefix)` is no help here: `brew` itself isn't on Automator's bare PATH.)

Prefer fixed presets over a prompt? Stamp one action per ratio instead:

```sh
qa-make.sh -t public.image "Canvas 4:5" \
  'export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"; "$HOME/.dotfiles/bin/img-canvas.sh" -a 4:5 "$@"'
```

## 6. Verification

- CLI: `img-canvas.sh -a 4:5 test.jpg` prints `test.jpg -> test_1080x1350.jpg`, and `magick identify -format '%wx%h %[colorspace]' test_1080x1350.jpg` reports `1080x1350 sRGB`. `-s 2` → `2160x2700`.
- PNG quantization: `img-canvas.sh -a 4:5 -f png -c 256 art.png`; `magick identify -format "%[colors]" art_1080x1350.png` reports ≤256, and file size drops vs. no `-c`.
- Quick Action: right-click an image in Finder → **Quick Actions** → *Canvas (pick aspect)* → choose ratio + scale; output lands beside the source.
- PATH sanity: if the action silently does nothing, run its body in Terminal — a `magick: command not found` means the PATH export (§5) is missing.
