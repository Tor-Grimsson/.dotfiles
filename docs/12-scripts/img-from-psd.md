---
title: PSD → image (and Quick Action)
type: playbook
status: active
updated: 2026-06-08
audience: internal
description: img-from-psd.sh — convert PSD → JPG/PNG via ImageMagick with -resize resolution control, then wire it into a Finder right-click Quick Action (optionally with a resolution prompt).
providers:
  - ImageMagick
  - Automator
tags:
  - project/dotfiles
  - domain/scripts/image
  - domain/macos
  - pattern/quick-action
aliases:
  - psd-to-image
  - psd2img
related:
  - "[[03-image|Image scripts (img-)]]"
  - "[[10-quick-actions|Quick Actions (qa-)]]"
---

# PSD → image (`img-from-psd.sh`) + Quick Action

## Overview

macOS's built-in `sips` reads flat PSDs but chokes on layered ones. **ImageMagick** (`magick`) reads the PSD's merged composite cleanly and gives full control over output format and resolution, so the whole job is a single shell script — `bin/img-from-psd.sh`. That script then drops straight into an **Automator Quick Action**, so converting becomes a Finder right-click — optionally with a dialog to pick the resolution.

The script is the source of truth (`~/.dotfiles/bin/img-from-psd.sh`, symlinked onto `PATH`); this doc is the reference.

> The one gotcha that trips everyone: Automator runs with a **bare PATH**, so `magick` is invisible unless you give the full path or export `PATH` inside the action (see §4).

## 0. Prerequisites

- [ImageMagick](https://imagemagick.org) on `PATH` — verify with `magick -version`. Install via [Homebrew](https://brew.sh): `brew install imagemagick`. (Confirmed working: ImageMagick 7.1.2.)
- macOS with **Automator** (built in) for the Quick Action.

## 1. The core one-liner

Everything rests on one command. The `[0]` reads the PSD's **merged composite layer** — without it, ImageMagick exports every layer as a separate frame.

```sh
# PSD → JPG, flattened onto white, quality 90
magick "input.psd[0]" -background white -flatten -quality 90 output.jpg

# PSD → PNG, transparency preserved
magick "input.psd[0]" -background none output.png
```

`-resize` is the resolution knob — drop it in before the output path:

```sh
magick "input.psd[0]" -resize 1920x1080 -background white -flatten output.jpg
```

## 2. The script

The reusable form lives at `bin/img-from-psd.sh` — batch input, format/resize/quality/dpi/outdir flags, and `--help`. Run `img-from-psd.sh --help` for the full contract; catalog entry in [[03-image|Image scripts]].

```sh
img-from-psd.sh art.psd                   # → art.jpg, full size
img-from-psd.sh -f png art.psd            # → art.png, keeps transparency
img-from-psd.sh -r 1920x1080 *.psd        # fit each inside 1920×1080
img-from-psd.sh -r 50% -f png poster.psd  # half-size PNG
img-from-psd.sh -o out -q 92 *.psd        # batch into ./out at quality 92
```

## 3. Resolution options — the `-resize` cheat sheet

`-resize` takes an ImageMagick **geometry**. The default preserves aspect ratio; `!` forces exact dimensions.

| Geometry | Effect |
|---|---|
| `2000x` | width 2000, height auto |
| `x1080` | height 1080, width auto |
| `1920x1080` | **fit** inside the box (largest that fits, aspect kept) |
| `1920x1080^` | **fill** the box (smallest that covers; crop after if needed) |
| `1920x1080!` | force exact size — **ignores aspect ratio**, distorts |
| `50%` | scale to 50% |
| `1920x1080>` | shrink only if larger (never upscale) |

`-d` / `-density` sets the DPI tag in metadata; it does **not** change pixel dimensions of already-rasterized PSD layers. The real resolution control is `-resize`.

## 4. Wire it into a Finder Quick Action

The generic recipe (and `qa-make.sh` to stamp one from a single line) is in [[10-quick-actions|Quick Actions]]. By hand:

1. **Automator → New Document → "Quick Action."**
2. At the top of the canvas: **"Workflow receives current"** → **files or folders** in **Finder**.
3. Drag in a **Run Shell Script** action. Set **Shell** to `/bin/zsh`, **Pass input** → **as arguments** (selected files arrive as `"$@"`).
4. Body — export PATH first so `magick` resolves under Automator's bare PATH (both brew prefixes listed, so the action works on the Intel iMac `/usr/local` *and* the Apple-Silicon MBP `/opt/homebrew` — the absent one is just an ignored PATH entry):

```bash
export PATH="$HOME/.dotfiles/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"
img-from-psd.sh -r 2000x "$@"
```

5. **Save** as e.g. *"Convert PSD → JPG (2000px)."* It now appears under Finder right-click → **Quick Actions**, and in the **Services** menu. Assign a keyboard shortcut under System Settings → Keyboard → Keyboard Shortcuts → Services if wanted.

Or stamp the same thing in one line — tracked in `macos/services/`, synced to the other machine:

```sh
qa-make.sh -t public.image "Convert PSD → JPG (2000px)" \
  'export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"; "$HOME/.dotfiles/bin/img-from-psd.sh" -r 2000x "$@"'

# or — original resolution (drop -r; full size is the default)
qa-make.sh -t public.image "Convert PSD → JPG (original size)" \
  'export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"; "$HOME/.dotfiles/bin/img-from-psd.sh" "$@"'
```

Each preset (format + size combo) is its own Quick Action — clean and reliable. For a single action with a chooser, use §5.

## 5. One action, with a resolution prompt

Quick Actions don't prompt by default. An inline `osascript … choose from list` adds a dialog while `"$@"` still carries the files. Use this as the **Run Shell Script** body instead of §4's:

```bash
export PATH="$HOME/.dotfiles/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"

choice=$(osascript -e 'choose from list {"Full size","2000px wide","1920x1080","50%"} with prompt "Output resolution:" default items {"Full size"}')
[ "$choice" = "false" ] && exit 0   # user cancelled

case "$choice" in
  "Full size")   r=() ;;
  "2000px wide") r=(-r 2000x) ;;
  "1920x1080")   r=(-r 1920x1080) ;;
  "50%")         r=(-r 50%) ;;
esac

img-from-psd.sh "${r[@]}" "$@"
```

Add a second `choose from list` for JPG/PNG the same way if you want format choice too.

## 6. Verification

- CLI: `img-from-psd.sh -r 50% test.psd` prints `test.psd -> test.jpg`, and `magick identify test.jpg` reports the halved dimensions.
- Quick Action: right-click a `.psd` in Finder → **Quick Actions** → your action. The output appears beside the source (or in the `-o` dir). With the §5 body, the resolution dialog shows first.
- PATH sanity: if the Quick Action silently does nothing, run the same body in Terminal — a `magick: command not found` confirms the PATH export (§4) is missing or wrong.

## Alternative — built-in `sips` (flat PSDs only)

No ImageMagick install needed, but unreliable on layered PSDs:

```sh
sips -s format jpeg --resampleWidth 2000 input.psd --out output.jpg
```

Use this only for single-layer / already-flattened PSDs. For anything with layers, ImageMagick's `[0]` composite is the correct path.
