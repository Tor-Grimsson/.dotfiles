---
title: midnight-commander
type: reference
status: active
updated: 2026-08-01
description: The classic dual-pane commander (binary `mc`) — copy and move between two panels, flip the split between vertical and horizontal with one chord, and reskin it from 39 shipped skins.
aliases:
  - midnight-commander
  - mc
tags:
  - domain/files
  - pattern/tui
  - integration/brew-formula
links:
  website: https://midnight-commander.org/
  repo: https://github.com/MidnightCommander/mc
  manual: https://midnight-commander.org/wiki/doc
  brew: https://formulae.brew.sh/formula/midnight-commander
covers:
  - Two-panel copy/move workflow
  - Split-orientation and listing-mode switching
  - Skins and full key remapping
related:
  - "[[18-vifm|vifm]]"
  - "[[operations/08-research/01-tui-file-managers|TUI file managers survey]]"
---

## Summary

mc is the original two-panel *commander*: both panels show a directory, and every operation acts **from the focused panel to the other one**. It is the only entry in the survey where flipping the split between vertical and horizontal is a single keystroke mid-session.

## Why installed

Installed 2026-08-01 from the layout-mode survey. Kept because the commander shape — two directories on screen, copy between them — is a genuinely different job from browsing, which [[02-yazi|yazi]] already does better.

## Most common use case

Moving a batch of files between two distant directories without typing either path twice: open one per panel, select, `F6`.

## Biggest win

**`Alt+,` flips the panel split** between vertical and horizontal without restarting, and `Alt+T` cycles each panel independently through full / brief / long / custom listing modes. No other tool in the survey changes its own geometry that cheaply.

## How to use

The skin is set by an environment variable in `shell/.zshrc`, **not** a config file — mc rewrites its own `ini` on exit, so a tracked ini would be clobbered:

```sh
export MC_SKIN=modarcon16-defbg    # already in shell/.zshrc
```

`modarcon16-defbg` is a **16-colour** skin and `defbg` keeps the terminal's own background, so [[09-productivity-desktop/08-kol-theme|kol-theme]] tints it for free. 39 skins ship in `$(brew --prefix)/share/mc/skins/`; the four `seasons-*16M` are truecolor, the rest 16- or 256-colour.

| Key | Does |
| --- | --- |
| `Alt+,` | flip split vertical ↔ horizontal |
| `Alt+T` | cycle listing mode on the focused panel |
| `Ctrl+U` | swap the two panels |
| `F5` / `F6` | copy / move to the other panel |
| `Tab` | change focused panel |
| `Ctrl+O` | drop to the shell, same chord returns |

> **No modal editing, ever.** mc has no NORMAL/INSERT — `d` is never an operator. It *is* fully remappable via `~/.config/mc/mc.keymap` (or `MC_KEYMAP=<file>`, or `mc -K <file>`), so vi *motions* are reachable; vi *grammar* is not. If modal editing is the point, use [[18-vifm|vifm]].

## Future use

A `mc.keymap` with `h j k l` on panel navigation, if the muscle memory clash with everything else becomes annoying enough to be worth maintaining a keymap file.
