---
title: Trendy roadmap
type: guide
status: active
updated: 2026-07-10
description: The showpiece SketchyBar features to build next — ranked from a 2025-26 survey of the best configs — with effort and helper requirements, plus the honest answer to disabling the macOS menu-bar reveal.
tags:
  - domain/productivity
related:
  - "[[INDEX|SketchyBar — complete guide]]"
  - "[[02-widgets|Every widget explained]]"
  - "[[06-sketchybar|SketchyBar (catalog reference)]]"
---

# Trendy roadmap

The pure-shell widgets ([[02-widgets|chapter 2]]) are the baseline. These are the showpieces — ranked from reading the best 2025-26 configs (`FelixKratz/dotfiles`, `linkarzu/dotfiles-latest`, `zerochae/sketchybar-gray`, `NoamFav/sketchybar`, `crissNb/Dynamic-Island-Sketchybar`, `nicolas-martin/awesome-sketchybar`).

## Interaction status (2026-07-10)
**Landed:** real icons (`icons.sh` — printf byte-escapes so glyphs survive), **click actions** on every widget (cpu/memory → Activity Monitor, volume/battery → Settings, weather → forecast, clock → Calendar, apple → power popup), and a **wifi details popup** (SSID/IP/router, click-to-copy, auto-closes on `mouse.exited.global`) — all pure shell.

**Copy-ready next** (the research agent returned working bash for each — `items/`+`plugins/` snippets are in the session notes):

| Next | Needs | Pure-shell? |
| --- | --- | --- |
| **Hover-reveal** (label slides open on `mouse.entered`, `--animate tanh` + `label.width`) | — | ✅ |
| **Volume slider in the bar** (`--add slider`, `slider.percentage`, click track to set) | — | ✅ |
| **Audio-device switcher popup** (volume right-click → live output list) | `brew install switchaudio-osx` | ✅ + CLI |
| **CPU/mem graphs** (`--add graph` + `--push` normalized 0–1, `top` fed) | — (or optional C provider for smoothness) | ✅ |
| **Scroll-to-adjust** (`mouse.scrolled` → `$SCROLL_DELTA`; volume via osascript, brightness via `brightness`) | `brew install brightness` (brightness only) | ✅ |
| **Real app-logo icons** (`front_app`/spaces) | `sketchybar-app-font.ttf` + `icon_map.sh` | ✅ + font |


## The menu-bar-reveal question (answered)

macOS gives **no native way** to stop the auto-hidden menu bar reappearing when the cursor hits the top edge — the reveal is baked into the auto-hide feature. Confirmed by SketchyBar issue [#774](https://github.com/FelixKratz/SketchyBar/issues/774), where someone built an external Swift "cursor bouncer" precisely because none exists.

Your realistic options:

| Option | Verdict |
| --- | --- |
| **App-menu mirror** (below) | the clean fix — puts the app menus *in* SketchyBar so you never need the macOS bar, making its reveal irrelevant |
| Cursor Bouncer ([bwl/dots](https://github.com/bwl/dots)) | a Swift app that bounces the cursor 5px from the top; effective but janky (accessibility perms, hardcoded screen res) — skip |
| Un-hide the menu bar | always visible, SketchyBar below it — two bars |
| Live with it | it retracts the instant you move away |

## Ranked showpieces

| Feature | Wow | Effort | What it is |
| --- | --- | --- | --- |
| **App-menu mirror** | ★★★★★ | C helper | FelixKratz's `menus` binary lists the focused app's File/Edit/View… and clicks them — SketchyBar becomes a *real* menu bar. Rebuilt on `front_app_switched`. **The answer to killing the macOS bar.** |
| **Dynamic Island** | ★★★★★ | C helper + cava | a rounded pill in/around the notch that expands for music (with a live audio visualiser), volume, brightness, charging, notifications. Queue-driven. The feature people screenshot. |
| **Wallpaper-derived theming** | ★★★★★ | shell + python | grab the desktop image → PIL colour extraction (WCAG-contrast-aware) → regenerate the palette per display. "pywal for SketchyBar" (NoamFav). |
| **CPU / network graphs** | ★★★★ | C or Rust helper | real scrolling sparklines via the `graph` item + a `push`ing event provider. `joncrangle/sketchybar-system-stats` is a drop-in **Rust** one — no C compile. |
| **Hover-reveal chips** | ★★★★ | **pure shell** | `mouse.entered/exited` + `tanh`-animate `label.width` — compact icons grow into labelled pills. Land this next. |
| **Click popups** (wifi/volume/battery detail, audio-device switch) | ★★★★ | **pure shell** | same `popup.drawing=toggle` pattern as the apple menu; `SwitchAudioSource`, `networksetup -getinfo`, `pmset` time-remaining. |
| **sketchybar-app-font + JankyBorders** | ★★★★ | brew installs | ligature app-icon font (feeds the menu-mirror + workspace icons) + `borders` for gradient window outlines matching the bar. The two installs that most upgrade the look. |
| Weather popup · GitHub notifications · git-repo scanner · keyboard-layout · Focus/DND · AirPods/bluetooth | ★★★ | pure shell | all in `nicolas-martin/awesome-sketchybar` — `wttr.in?format=j1`, `gh api notifications`, `system_profiler SPBluetoothDataType`, OS input-source events. |

## If you build the "impressive modern bar"
The high-leverage core is **app-menu mirror + hover-reveal + click popups + app-font + a floated/blurred bar** — of those, only the menu mirror needs a compiled helper. Then **Dynamic Island** or **wallpaper theming** as the one showpiece. Reference repos, best value-per-read:

- [FelixKratz/dotfiles](https://github.com/FelixKratz/dotfiles) — menus, media, graphs, popups (the source of truth)
- [NoamFav/sketchybar](https://github.com/NoamFav/sketchybar) — AeroSpace + wallpaper-theming + weather/git (closest to this stack)
- [crissNb/Dynamic-Island-Sketchybar](https://github.com/crissNb/Dynamic-Island-Sketchybar) — the notch showpiece
- [nicolas-martin/awesome-sketchybar](https://github.com/nicolas-martin/awesome-sketchybar) — the plugin catalogue
- [kvndrsslr/sketchybar-app-font](https://github.com/kvndrsslr/sketchybar-app-font) — install first; the visual features depend on it
