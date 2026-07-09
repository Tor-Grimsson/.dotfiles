---
title: SketchyBar
type: reference
status: active
updated: 2026-07-09
description: Scriptable macOS menu-bar replacement, wired to AeroSpace workspaces.
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
  - The current bar items — AeroSpace workspaces, front app, tmux, clock
  - The AeroSpace integration (custom event + the outer.top gap)
  - Reloading, hotload, and the macOS bash-3.2 gotcha
related:
  - "[[05-aerospace|AeroSpace]]"
  - "[[04-stats|Stats]]"
---

## Summary
SketchyBar is a fast, fully scriptable replacement for the macOS menu bar, written in C by Felix Kratz. You hide the native bar and draw your own — workspace indicators, focused app, clock, system stats, anything a shell script can produce. The whole bar is defined by a `sketchybarrc` shell script that issues `sketchybar --add/--set` commands, so it version-controls cleanly. Tracked here as `sketchybar/`, symlinked to `~/.config/sketchybar`. Ported and adapted from [Sin-cy's config](https://github.com/Sin-cy/dotfiles), recolored to Catppuccin Mocha. **Note:** the terminal stack (Ghostty/tmux/nvim/yazi/starship) later moved to **Gruvbox Dark** — SketchyBar is still on Mocha and not yet recolored to match.

## Why installed
Companion to [[05-aerospace|AeroSpace]]. AeroSpace has no bar of its own, so there's no on-screen indicator of which workspace is focused or what's open where — SketchyBar fills that gap. Being config-as-code (not a preferences pane) is exactly why it fits a dotfiles repo.

## Most common use case
Glance at the top strip: focused **AeroSpace workspace** (mauve chip) on the left next to the front app, tmux windows and the clock on the right. Click a workspace chip to jump to it.

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
├── colors.sh             # Catppuccin Mocha palette (sourced everywhere)
├── items/                # item definitions (add + style + subscribe)
│   ├── spaces.sh         # invisible controller for the workspace chips
│   ├── front_app.sh      # focused application name
│   ├── clock.sh          # DD/MM HH:MM
│   └── tmux.sh           # tmux windows
└── plugins/              # updater scripts (set the label on event / interval)
    ├── aerospace.sh      # rebuilds workspace chips (occupied + focused)
    ├── front_app.sh      # label = $INFO on front_app_switched
    ├── clock.sh          # label = date
    └── tmux.sh           # label = tmux window list
```

## Current items
| Item | Side | Source of data | Refresh |
| --- | --- | --- | --- |
| workspaces | left | `aerospace list-workspaces` (occupied + focused) | on `aerospace_workspace_change` |
| front_app | left | `front_app_switched` event (`$INFO`) | on app switch |
| tmux | right | `tmux list-windows -a` | every 2s |
| clock | right | `date` | every 10s |

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
- **tmux item shows *windows*, not sessions** — the ask was sessions; swap `tmux list-windows -a` → `tmux list-sessions` in `plugins/tmux.sh` (deferred).
- Flesh out the bar — volume, wifi, and a now-playing item (this machine runs mpd/rmpc) are the natural next additions. Battery is moot on the iMac.
- Install `font-sketchybar-app-font` for real app icons in `front_app`.

## Future use
The bar is a thin starting set; SketchyBar's item/plugin model scales to system stats, media, popups, sliders, and graphs. Add items incrementally — each is a self-contained `items/*.sh` + `plugins/*.sh` pair sourced from `sketchybarrc`.
