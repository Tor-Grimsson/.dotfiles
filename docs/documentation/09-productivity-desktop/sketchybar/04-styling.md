---
title: The styling toolkit
type: guide
status: active
updated: 2026-07-10
description: The visual layer of SketchyBar — the colour palette, bar geometry (float/blur/rounded), item chips, brackets, popups, hover-reveal animations, and the Nerd Font glyph system.
tags:
  - domain/productivity
related:
  - "[[INDEX|SketchyBar — complete guide]]"
  - "[[03-build-your-own|Add your own widget]]"
  - "[[05-roadmap|Trendy roadmap]]"
---

# The styling toolkit

## The palette — `colors.sh`

One file, sourced everywhere, in `0xAARRGGBB` (AA = alpha). Catppuccin Mocha base + an accent set:

| Var | Use |
| --- | --- |
| `BAR_BG` (transparent) · `ITEM_BG` (mantle) · `TEXT` · `DIM` | bar + chip + text |
| `CHIP_BG` · `FOCUS_BG` (mauve) · `FOCUS_FG` | workspace chips |
| `GREEN` `YELLOW` `PEACH` `RED` | status grading |
| `BLUE` `TEAL` `MAUVE` | icon tints (wifi/volume · cpu · memory/apple) |

Change the whole look by editing this one file. (Open item: the terminal stack moved to Gruvbox; recolour here to match.)

## Bar geometry

Set on `--bar` in `sketchybarrc`:

| Property | Effect |
| --- | --- |
| `position=top` `height=32` | placement + thickness |
| `blur_radius=20` | frosted-glass background |
| `color=$BAR_BG` | bar fill (transparent here — chips carry their own bg) |
| `corner_radius` + `y_offset` + `margin` | **float** the bar off the top edge (detached-pill look) |
| `shadow` | drop shadow |

> **If you float the bar** (`y_offset`/`margin`), re-check `outer.top` in `aerospace.toml` — tiled windows must clear the new bar position, or the bar gets drawn over. It's currently `42` for a 32px top-anchored bar.

## Item chips & defaults

The `--default` block styles every item: `background.color`/`corner_radius`/`height`, `icon.font`/`color`, `label.font`/`color`, paddings. Per-item files override only the difference. Turn a chip's background off with `background.drawing=off` (the apple logo does this to float bare).

## Brackets

`--add bracket name item1 item2 …` draws one shared background *behind* a group of items — e.g. wrap the system widgets in a subtle pill, or give the focused workspace a two-tone outline via a *transparent* bracket with its own `border_color`/`border_width`. Members keep their own styling; the bracket sits behind.

## Popups

Any item can own a dropdown:
```bash
--set foo popup.background.color=$ITEM_BG popup.background.corner_radius=8 \
          popup.background.border_width=2 popup.background.border_color=$CHIP_BG
```
Toggle with `click_script="sketchybar --set foo popup.drawing=toggle"`; add rows as items on the `popup.foo` side. `popup.horizontal=off` (default) = vertical menu. The apple menu is the reference.

## Hover-reveal (the trendy micro-interaction)

Subscribe an item to `mouse.entered` / `mouse.exited` and animate a property:
```bash
sketchybar --animate tanh 20 --set "$NAME" label.width=dynamic   # entered
sketchybar --animate tanh 20 --set "$NAME" label.width=0         # exited
```
A compact icon **grows into a labelled pill** under the cursor and collapses when you leave. `--animate <curve> <duration>` (curves: `linear`, `quadratic`, `sin`, `tanh`, `exp`) works on almost any numeric property — width, alpha, colour, corner_radius.

## Glyphs & fonts — the `icons.sh` lesson

Two traps bit this bar (both fixed):

- **The font name must be exact.** The installed family is **`MesloLGS Nerd Font Mono`** (`fc-list | grep -i meslo`), *not* `MesloLGS NF` — the wrong name silently falls back to a glyph-less font → every icon is tofu. Set once as `$FONT` in `sketchybarrc`.
- **Never put literal glyphs in the config files.** Private-use glyph bytes get **stripped in transit** (they came out empty here — `icon=""` with nothing inside). Author them as **`printf` byte-escapes** in `icons.sh`:
  ```bash
  export CPU=$(printf '\xef\x92\xbc')   # U+F4BC — plain-ASCII source, real bytes at runtime
  ```
  `source "$CONFIG_DIR/icons.sh"` in `sketchybarrc` and in every plugin that draws an icon, then reference `$CPU`, `$WIFI_ON`, `$BATT_50`…
- **Stay in the legacy FontAwesome range** (U+F000–F2FF) — present in *every* Nerd Font build. Newer Material/MDI 4-byte glyphs (`\U000F05A9`) need NF v2.1+/v3, so they're less safe.
- **Real per-app icons** (VS Code / Chrome logos in `front_app`, workspace chips) need a **different** font — `sketchybar-app-font` (a ligature TTF + an `icon_map.sh` `case`). MesloLGS has no app logos. Not installed yet.

Next: [[05-roadmap|Trendy roadmap]].
