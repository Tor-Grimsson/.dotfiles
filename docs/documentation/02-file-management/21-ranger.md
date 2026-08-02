---
title: ranger
type: reference
status: active
updated: 2026-08-01
description: The Python miller-column file manager that popularised the layout — and the only one with a second, genuinely different view mode (multipane tabs).
aliases:
  - ranger
tags:
  - domain/files
  - pattern/tui
  - integration/brew-formula
links:
  website: https://ranger.fm/
  repo: https://github.com/ranger/ranger
  manual: https://github.com/ranger/ranger/wiki
  brew: https://formulae.brew.sh/formula/ranger
covers:
  - Miller and multipane view modes
  - vim-syntax rc.conf mappings
  - Mouse support on by default
related:
  - "[[02-yazi|yazi]]"
  - "[[operations/08-research/01-tui-file-managers|TUI file managers survey]]"
---

## Summary

ranger is the file manager that made the three-column miller layout standard — [[02-yazi|yazi]] and lf both inherit it. Its distinguishing feature today is the second view mode: `multipane`, which shows open tabs side by side instead of parent/current/preview.

## Why installed

Installed 2026-08-01 from the layout-mode survey. Its `miller` mode duplicates what yazi already does; `multipane` is the reason it stayed.

## Most common use case

Working two or three directories at once as tabs, all visible, rather than switching between them.

## Biggest win

**`set viewmode multipane`** — every open tab rendered side by side. It is off by default, so a vim user should set it in `rc.conf`; without it ranger is a slower yazi.

## How to use

ranger writes its own config on first `--copy-config`; the default `rc.conf` ships at `$(brew --prefix)/Cellar/ranger/*/libexec/share/doc/ranger/config/rc.conf`.

| Setting / key | Does |
| --- | --- |
| `set viewmode multipane` | tabs side by side (default is `miller`) |
| `set mouse_enabled true` | **already the shipped default** |
| `zm` | toggle mouse live |
| `gn` · `gt` | new tab · next tab |
| `S` | drop to a shell in the current directory |

Colours use curses ANSI pairs, so [[09-productivity-desktop/08-kol-theme|kol-theme]] tints it with no per-app file.

## Future use

ranger's `rc.conf` uses vim-syntax `map` lines, so a keymap matching the nvim setup is cheap if ranger earns a permanent slot over yazi.
