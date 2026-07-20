---

> **Archived 2026-07-11** — config moved to `_archive/sketchybar/` (kept for reference: the pure-shell widget data logic, the power popup, the accent palette). The live bar is now [[07-ubersicht|Übersicht + simple-bar]].
title: SketchyBar
type: reference
status: superseded
superseded_by: "[[07-ubersicht|Übersicht + simple-bar]]"
updated: 2026-07-11
description: Scriptable macOS menu-bar replacement, wired to AeroSpace workspaces — with an apple-menu popup and a full system-widget row (cpu/memory/volume/wifi/battery/weather/brew).
aliases:
  - sketchybar
tags:
  - domain/productivity
  - pattern/gui
  - pattern/cli
  - integration/brew-formula
links:
  website: https://felixkratz.github.io/SketchyBar/
  repo: https://github.com/FelixKratz/SketchyBar
  config: https://felixkratz.github.io/SketchyBar/config/bar
  reloading: https://felixkratz.github.io/SketchyBar/config/reloading
  brew: https://formulae.brew.sh/formula/sketchybar
covers:
  - The config structure (sketchybarrc + colors + items/ + plugins/)
  - The bar items — AeroSpace workspaces, front app, apple-menu power popup, clock, and the system-widget row (cpu/memory/volume/wifi/battery/weather/brew)
  - The AeroSpace integration (custom event + the outer.top gap)
  - Reloading, hotload, and the macOS bash-3.2 gotcha
related:
  - "[[sketchybar/INDEX|SketchyBar — complete guide]]"
  - "[[05-aerospace|AeroSpace]]"
  - "[[04-stats|Stats]]"
---

> **Full walkthrough:** [[sketchybar/INDEX|SketchyBar — complete guide]] (config model · every widget · add your own · styling · roadmap). This page is the quick reference.

## Summary
SketchyBar is a fast, fully scriptable replacement for the macOS menu bar, written in C by Felix Kratz. You hide the native bar and draw your own — workspace indicators, focused app, clock, system stats, anything a shell script can produce. The whole bar is defined by a `sketchybarrc` shell script that issues `sketchybar --add/--set` commands, so it version-controls cleanly. Tracked here as `sketchybar/`, symlinked to `~/.config/sketchybar`. Ported and adapted from [Sin-cy's config](https://github.com/Sin-cy/dotfiles), recolored to Catppuccin Mocha. **Note:** the terminal stack (Ghostty/tmux/nvim/yazi/starship) later moved to **Gruvbox Dark** — SketchyBar is still on Mocha and not yet recolored to match.

## Why installed
Companion to [[05-aerospace|AeroSpace]]. AeroSpace has no bar of its own, so there's no on-screen indicator of which workspace is focused or what's open where — SketchyBar fills that gap. Being config-as-code (not a preferences pane) is exactly why it fits a dotfiles repo.

## Most common use case
Glance at the top strip: **apple menu** + focused **AeroSpace workspace** (mauve chip) + front app on the left; **cpu · memory · volume · wifi · battery · weather · brew · tmux · clock** on the right. Click a workspace chip to jump to it, the apple logo for power actions, the clock for Calendar.

## Biggest win
Everything is a shell script, so the bar is fully reproducible from the repo and trivially extendable — a new item is one `items/*.sh` + one `plugins/*.sh`. No binary config, no GUI clicking.

## Config & setup
- **Config dir:** `~/.config/sketchybar` → whole-dir symlink → `sketchybar/` in the repo (bootstrap links it; SketchyBar auto-runs `sketchybarrc` on launch).
- **Install:** `brew install FelixKratz/formulae/sketchybar` (a formula, in `brewfile-gui`), then `brew services start sketchybar`.
- **Font:** base font is **MesloLGS NF** (already installed for the terminal). System-glyph icons come from **sf-symbols**. Real app-name icons in `front_app` would need `font-sketchybar-app-font` — not installed yet (front_app shows the plain name).
- **The top gap:** AeroSpace tiles over the full screen, so `aerospace.toml` sets `outer.top = 42` (32px bar + 10px gap) to keep tiled windows below the bar. Without it the bar is drawn-over and invisible.

## File structure
```
sketchybar/
├── sketchybarrc          # entry: bar + defaults + sources items, hotload on, update
├── colors.sh             # Catppuccin Mocha palette + accent status colours
├── icons.sh              # Nerd Font glyphs as printf byte-escapes (so they never strip)
├── items/                # item definitions (add + style + subscribe)
│   ├── apple.sh          # apple logo + the power/session popup rows
│   ├── spaces.sh         # invisible controller for the workspace chips
│   ├── front_app.sh      # focused application name
│   ├── clock.sh          # DD/MM HH:MM (click → Calendar)
│   ├── cpu.sh · memory.sh
│   ├── volume.sh · wifi.sh · battery.sh
│   ├── weather.sh · brew.sh
│   └── tmux.sh           # tmux windows
└── plugins/              # updater scripts (set the label on event / interval)
    ├── aerospace.sh      # rebuilds workspace chips (occupied + focused)
    ├── power.sh          # apple-menu actions (lock/sleep/restart/shutdown/logout)
    ├── wifi_click.sh     # wifi popup: SSID/IP/router rows, click-to-copy
    ├── cpu.sh · memory.sh · volume.sh · wifi.sh · battery.sh
    ├── weather.sh · brew.sh
    ├── front_app.sh · clock.sh · tmux.sh
```

## Current items
| Item | Side | Source of data | Refresh |
| --- | --- | --- | --- |
| **apple** | left | static logo; click toggles a power/session **popup** (`plugins/power.sh` → lock/sleep/restart/shutdown/logout) | — |
| workspaces | left | `aerospace list-workspaces` (occupied + focused) | on `aerospace_workspace_change` |
| front_app | left | `front_app_switched` event (`$INFO`) | on app switch |
| **cpu** | right | `ps -o %cpu` sum ÷ core count, colour-graded | every 2s |
| **memory** | right | `memory_pressure` free % → used %, colour-graded | every 5s |
| **volume** | right | `volume_change` event (`$INFO`), osascript fallback | on change |
| **wifi** | right | SSID via `ipconfig getsummary <dev>` (device auto-detected) | every 15s |
| **battery** | right | `pmset -g batt` — icon/colour ramp, bolt on AC; **self-hides on a desktop** | 30s + `power_source_change`/`system_woke` |
| **weather** | right | `wttr.in/?format=%t` (IP-geolocated, no key) | every 30 min |
| **brew** | right | `brew outdated` count — **hidden when up to date**; click → `brew upgrade` in Ghostty | every 30 min |
| tmux | right | `tmux list-windows -a` | every 2s |
| clock | right | `date` — click opens Calendar | every 10s |

Colour-grading uses the accent palette added to `colors.sh` (green/yellow/peach/red + blue/teal/mauve icon tints). Glyphs are Nerd Font (FontAwesome range) in MesloLGS NF — swap any that don't render.

> **Workspaces are dynamic, not static.** There are 31 persistent AeroSpace workspaces — far too many to draw as fixed chips. An invisible `spaces_ctrl` item subscribes to the custom `aerospace_workspace_change` event; its script (`plugins/aerospace.sh`) removes the old `space.*` chips and redraws one per *occupied* workspace plus the focused one (highlighted mauve). If the `aerospace` CLI can't reach the server it exits quietly, so a broken WM never breaks the bar.

## AeroSpace integration
Two pieces wire the workspace chips (details in [[05-aerospace|AeroSpace]]):
1. **`sketchybarrc`** declares the event: `sketchybar --add event aerospace_workspace_change`.
2. **`aerospace.toml`** fires it on every switch via `exec-on-workspace-change`, which runs `sketchybar --trigger aerospace_workspace_change` (both brew bin dirs forced onto `PATH` so it resolves on either machine).

## Reloading
- **Hotload (default):** `sketchybarrc` ends with `sketchybar --hotload on` — edits to the config dir auto-apply, no manual reload.
- **Manual:** `sketchybar --reload ~/.config/sketchybar/sketchybarrc`. The **bare** `sketchybar --reload` only works if the daemon was launched *with* a config present; if it was started configless (e.g. before the symlink existed) it has no path to reload — pass the path, or `brew services restart sketchybar` for a clean relaunch.
- **Gotcha — bash 3.2:** macOS ships bash 3.2 as `/bin/bash`, so plugin scripts must avoid bash-4 builtins (`mapfile`, associative arrays). `plugins/aerospace.sh` uses plain word-splitting for exactly this reason.

## Open / next
- **No now-playing widget** — macOS 15.4 locked down the private MediaRemote framework, so SketchyBar's `media_change` event *and* `nowplaying-cli` are both dead on 15.4+ (this machine is 15.7). Revisit if Apple reopens it or a workaround lands.
- **tmux item shows *windows*, not sessions** — swap `tmux list-windows -a` → `tmux list-sessions` in `plugins/tmux.sh` (deferred).
- Install `font-sketchybar-app-font` for real app icons in `front_app` + the workspace chips.
- **Still Catppuccin Mocha** while the rest of the stack is Gruvbox Dark — recolour `colors.sh` when ready.

## Trendy roadmap (researched 2026-07-10)
Ranked from a survey of the best 2025-26 configs (FelixKratz/dotfiles, NoamFav/sketchybar, crissNb/Dynamic-Island-Sketchybar, nicolas-martin/awesome-sketchybar). The pure-shell wins are done (above); these are the showpieces — most need a compiled helper:

| Feature | Effort | Notes |
| --- | --- | --- |
| **App-menu mirror** | C helper | FelixKratz's `menus` binary shows the focused app's File/Edit/View… in the bar and clicks them — makes SketchyBar a *real* menu-bar replacement (this is the clean answer to "hide the macOS bar for good") |
| **Dynamic Island** | C helper + cava | rounded pill in/around the notch that expands for music/volume/charging/notifications — the screenshot feature (crissNb) |
| **Wallpaper-derived theming** | shell + python | desktop image → PIL k-means (WCAG-contrast-aware) → regenerate palette per display; "pywal for SketchyBar" (NoamFav) |
| **CPU/network graphs** | C or Rust helper | real scrolling sparklines via the `graph` item + a `push`ing event provider (`joncrangle/sketchybar-system-stats` is a drop-in Rust one) |
| **Hover-reveal chips** | pure shell | `mouse.entered`/`exited` + `tanh`-animate `label.width` 0→dynamic so a compact icon grows into a labelled pill under the cursor |
| **Click popups** (wifi/volume/battery detail, audio-device switch) | pure shell | same `popup.drawing=toggle` pattern as the apple menu; `SwitchAudioSource`, `networksetup`, `pmset` time-remaining |
| **app-font + JankyBorders** | brew installs | `sketchybar-app-font` (ligature app icons) + `borders` (gradient window borders matching the bar) — the two installs that most upgrade the *look* |

Hover-reveal + popups are pure-shell and could land next without a helper. Each new item stays a self-contained `items/*.sh` + `plugins/*.sh` pair.
