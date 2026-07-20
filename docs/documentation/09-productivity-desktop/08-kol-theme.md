---
title: kol-theme — one-switch colorscheme selector
type: reference
status: active
updated: 2026-07-14
audience: internal
description: The cross-tool colorscheme selector — one command reskins ghostty, kitty (main + notes sticky), tmux, nvim-now, btop, simple-bar, and the Übersicht desk widgets from per-theme native files in themes/. Ricing-backlog #4, built 2026-07-14.
aliases:
  - kol-theme
  - colorscheme selector
tags:
  - domain/tooling
  - pattern/tui
related:
  - "[[INDEX|Productivity & desktop]]"
  - "[[07-ubersicht|Übersicht + simple-bar]]"
  - "[[05-aerospace|AeroSpace]]"
---

# kol-theme

## Purpose

One switch → every desk surface reskins. A theme is a directory of small **native-format** files (one per tool); `kol-theme <name>` flips a single symlink and reloads what can reload. Files are the API — no daemon, no templating engine. linkarzu's selector pattern on our stack.

## Dependencies

| piece | does | needs |
|---|---|---|
| `bin/kol-theme` | the switch: symlink flip + per-tool reloads | nothing beyond coreutils |
| `themes/<name>/` | 5 native files per theme (see anatomy) | authored by hand per theme |
| `~/.config/kol-theme/current` | the active-theme symlink (machine-local — two machines can differ) | created on first run; bootstrap seeds `gruvbox` |

## Commands

```sh
kol-theme                    # list themes, * marks active
kol-theme solarized-osaka    # switch everything
kol-theme gruvbox            # the pre-selector look — "change back"
kol-theme kol-dark           # the KOL DS palette (bar/widget native look)
kol-theme linkarzu           # the reference desk: his palette + frosted ghostty (0.88 + blur)
```

## Theme anatomy (`themes/<name>/`)

| file | consumed by | how |
|---|---|---|
| `ghostty.conf` | `ghostty/config` → `config-file = ?current-theme.conf` (last line, optional include; symlink kept in BOTH `~/.config/ghostty/` and repo `ghostty/` — relative-include resolution differs by entry path) | reload: Cmd+Shift+, or new window |
| `kitty.conf` | `kitty/kitty.conf` (main, symlinked to `~/.config/kitty/`) + `kitty/kol-notes.conf` → both end `include current-theme.conf` (include symlink kept in BOTH dirs, same reason as ghostty) | main: `ctrl+shift+f5` or new window; sticky on next `cmd-alt-n` |
| `tmux.conf` | `.tmux.conf` → `source-file -q ~/.config/kol-theme/current/tmux.conf` (last, overrides the gruvbox fallbacks above it) | instant — script runs `tmux source-file` |
| `nvim.lua` | **copied** to `nvim-now/lua/current-theme.lua` (copy, not link — `<leader>ths` writes the same file) | new instances; running ones via `<leader>ths` |
| `colors.json` | both Übersicht widgets prepend it in `command`, parse in render, **kol-dark hardcoded fallback** | instant — script runs `ubersicht-refresh` |
| `btop.theme` | `~/.config/btop/themes/kol-current.theme` symlink + `color_theme` pointer (re-asserted every switch — btop rewrites its conf on exit) | next btop launch — see [[../01-shell-terminal/29-btop|btop]] |
| `colors.json` → `simplebar` block | jq-merged into `.themes` of `~/.simplebarrc` — written **through** the symlink (repo file is the target), layout keys untouched; panel write-backs are beaten by re-patching every switch | instant — the double-pass refresh |

## Structure-per-theme

A theme's `tmux.conf` sources last, so it may carry **layout**, not just palette: `linkarzu` restyles the whole bar (session pill + rounded per-window index chips — the catppuccin/tmux look from his desk, hand-rolled in pure format strings, no plugin; glyphs E0B6/E0B4 from MesloLGS NF). The other three themes explicitly re-assert the quiet flat bar, so switching back always resets the structure.

## Gotchas

- **tmux/ghostty/kitty keep their old colors as in-file fallbacks** — the theme include always lands *last* so it wins; delete nothing.
- The daily `nvim/` is not a consumer yet (graduation item) — only `nvim-now` follows the selector, and kol-dark's `nvim.lua` stands in with gruvbox-material until a kol-dark nvim port exists (the parked emitters item).
- **Not yet themed:** yazi (needs authored flavors), starship (parked prompt).
- simple-bar tuning via its panel still copy-backs to the repo file as before — kol-theme only owns the `.themes` color slots, everything else in `~/.simplebarrc` is yours.
- The `linkarzu` theme's nvim half is a **tokyonight stand-in** (his real colors live in his neobean nvim config, no port on the shelf) — same pattern as kol-dark's gruvbox-material stand-in.

## Why

Ricing-backlog #4 ("the big one"): the desk ran kol-dark chrome over a gruvbox terminal with gruvbox-material nvim — three looks, no switch. This unifies them behind one command, with `gruvbox` preserving the pre-selector state exactly.
