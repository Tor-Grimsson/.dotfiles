---
title: xplr
type: reference
status: active
updated: 2026-08-01
description: Hackable Rust file explorer whose layout and keymap are Lua code — arbitrary nested Horizontal/Vertical splits, and a selection list that survives changing directory.
aliases:
  - xplr
tags:
  - domain/files
  - pattern/tui
  - integration/brew-formula
links:
  website: https://xplr.dev/
  repo: https://github.com/sayanarijit/xplr
  manual: https://xplr.dev/en/
  brew: https://formulae.brew.sh/formula/xplr
covers:
  - Lua-defined layouts and keymaps
  - Cross-directory persistent selection
  - Message-passing integration with other tools
related:
  - "[[18-vifm|vifm]]"
  - "[[operations/08-research/01-tui-file-managers|TUI file managers survey]]"
---

## Summary

xplr is a file explorer where **the layout is code**. `xplr.config.layouts` composes `Horizontal` and `Vertical` splits to any depth, and every key is a Lua binding rather than a setting — it is the only entry in the survey with no fixed set of view modes to choose from.

## Why installed

Installed 2026-08-01 from the layout-mode survey, as the one tool that answers "can I have a different layout" with "write one" instead of a list.

## Most common use case

Gathering files from several directories into one operation: walk around, `Space` on each wanted path, then act on the whole set at once.

## Biggest win

**The selection list survives changing directory.** Everything else in the survey scopes selection to the current view; xplr keeps a running list you build across the filesystem, then operate on once. `Ctrl+A` selects all, `Ctrl+U` clears, `Ctrl+C` copies the list out.

## How to use

Config is repo-tracked at `xplr/init.lua` (live via `~/.config/xplr` → `~/.dotfiles/xplr`).

```lua
version = "1.1.0"                          -- REQUIRED, must match the binary
xplr.config.general.enable_mouse = true
xplr.config.general.show_hidden  = true
```

| Key | Does |
| --- | --- |
| `j` `k` `h` `l` · `gg` `G` | vi motions — the default set |
| `Space` | add focused path to the selection |
| `Ctrl+A` · `Ctrl+U` | select all · clear selection |
| `Ctrl+C` | copy the selection list out |

Styling is deliberately left alone: xplr's defaults draw in ANSI colour names, so the terminal palette from [[09-productivity-desktop/08-kol-theme|kol-theme]] tints it.

> **The `version` line is not optional.** xplr refuses to start if `version` in `init.lua` does not match the running binary. Bump it whenever the brew formula moves, or the tool simply won't open.

## Future use

`--pipe-msg-in` / `--print-msg-in` let a running xplr session be driven from outside — the hook for wiring it to tmux popups the way the bookmark system already is.
