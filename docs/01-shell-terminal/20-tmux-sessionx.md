---
title: tmux-sessionx
type: reference
status: active
updated: 2026-07-04
description: TPM plugin — an fzf popup session manager with live previews, git branch display, and inline session/window/tree browsing.
aliases:
  - tmux-sessionx
  - sessionx
tags:
  - domain/shell
  - pattern/tui
  - integration/tpm-plugin
links:
  repo: https://github.com/omerxx/tmux-sessionx
covers:
  - The prefix O popup and its keys
  - Configurable options (@sessionx-*)
  - Head-to-head against sesh (both still being evaluated)
related:
  - "[[02-tmux|tmux]]"
  - "[[17-sesh|sesh]]"
---

## Summary
`tmux-sessionx` is a TPM plugin that opens an fzf popup over sessions, with a live preview pane (including git branch) and modes to browse windows, a directory tree, or `fzf-marks`. Installed via TPM, not Homebrew — needs `fzf`, `fzf-tmux`, and `bat` (all already in `brewfile-cli`).

## Why installed
Same job as `sesh` — a fast session switcher — but done as a tmux popup with a richer preview (git branch, tree view) instead of a plain shell command. `tmux-tea` was in this comparison too but lost 2026-07-04 and was dropped; `sesh` vs `sessionx` is still being decided.

## Setup
Already wired in `.tmux.conf` (section 5):
```tmux
set -g @plugin 'omerxx/tmux-sessionx'
```
`prefix I` inside tmux installs it via TPM; `prefix r` reloads the config after any edit.

## How to use
`prefix O` opens the picker. Type to fuzzy-filter; the keys below work inside it.

## Cheat sheet
| Key | Does |
|---|---|
| `prefix O` | Open the sessionx popup |
| `Ctrl-p` / `Ctrl-n` | Move up / down the list |
| `Ctrl-u` / `Ctrl-d` | Scroll the preview up / down |
| `Ctrl-w` | Switch to windows mode |
| `Ctrl-t` | Toggle tree view |
| `Ctrl-x` | Browse the config directory |
| `Ctrl-r` | Rename the selected session |
| `Ctrl-e` | Expand PWD for local directories |
| `Ctrl-b` | Return to the previous query |
| `Ctrl-/` | Tmuxinator project list |
| `Ctrl-g` | fzf-marks list |
| `Alt-Backspace` | Delete the selected session |
| `?` | Toggle the preview pane |

## Configuration
Set any of these with `set -g <option> <value>` above the `@plugin` line: `@sessionx-bind` (change the `O` trigger), `@sessionx-prefix` (require prefix or not), `@sessionx-x-path` / `@sessionx-custom-paths` (browsable directories), `@sessionx-tree-mode`, `@sessionx-window-mode`, `@sessionx-preview-location`, `@sessionx-preview-ratio`.

## Future use
Being run head-to-head against `sesh` before picking one session-switcher to keep bound long-term.
