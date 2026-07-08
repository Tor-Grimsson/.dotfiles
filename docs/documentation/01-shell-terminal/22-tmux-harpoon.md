---
title: tmux-harpoon
type: reference
status: active
updated: 2026-07-04
description: ThePrimeagen-harpoon-style bookmarking for tmux sessions — tag a handful of sessions and jump straight back to any of them.
aliases:
  - tmux-harpoon
  - harpoon
tags:
  - domain/shell
  - pattern/tui
  - integration/tpm-plugin
links:
  repo: https://github.com/Chaitanyabsprip/tmux-harpoon
covers:
  - Bookmarking a session and jumping back to it
  - Why it gets its own key table (prefix a) instead of a bare modifier
  - The two modifiers that were tried and ruled out first
related:
  - "[[02-tmux|tmux]]"
  - "[[17-sesh|sesh]]"
---

## Summary
`tmux-harpoon` tags up to a handful of tmux sessions and jumps back to any of them with one key — the tmux equivalent of ThePrimeagen's Neovim `harpoon` plugin. Installed as a TPM plugin (its `harpoon` script ships plain, uncompiled, right in the repo — no separate build/install step needed).

## Why it has its own key table
The plugin's own default binds bare **`Ctrl-h`** for "jump" — but this config's `.tmux.conf` section 6 already binds `Ctrl-h`/`j`/`k`/`l` for seamless pane↔Neovim-split navigation (see [[02-tmux|tmux]]). Two bare-modifier overrides were tried and ruled out before landing on a dedicated key table:

1. **`Alt` (`M-1`…`M-4`, `M-a`, `M-e`)** — ruled out: AeroSpace claims every Alt+letter/digit globally for workspace switching and intercepts it before tmux ever sees it.
2. **`Ctrl+Shift` (`C-S-1`…`C-S-4`, `C-S-a`, `C-S-e`)** — ruled out: confirmed live that iTerm2 doesn't report Shift on Ctrl-letter combos, so `Ctrl+Shift+A` arrives at tmux as plain `Ctrl+A` — the prefix key itself. It silently opened prefix-wait instead of bookmarking anything.

Landed on a **key table** instead — the same modal pattern `aerospace.toml`'s `mode.resize`/`mode.service` already use, just inside tmux:
```tmux
bind a switch-client -T harpoon
bind -T harpoon 1 run '~/.tmux/plugins/tmux-harpoon/harpoon -s 1'
```
This lives entirely inside tmux's own already-working prefix system, so neither the AeroSpace collision nor the terminal-reporting problem applies. `@harpoon_key_append` is left unset — its fallback binds bare `Ctrl-h`, which section 6 re-claims anyway, so it's inert.

## Setup
Already wired in `.tmux.conf` (section 5). `prefix I` installs it via TPM (or `bootstrap.sh`'s non-interactive `install_plugins` call on a fresh machine); `prefix r` reloads after any edit.

Every action is hand-bound (no plugin-native override applies to a custom key table) to call the script directly from its TPM plugin directory:
```tmux
bind a switch-client -T harpoon                                  # prefix a → enter harpoon mode
bind -T harpoon a run '~/.tmux/plugins/tmux-harpoon/harpoon -a'   # bookmark current session
bind -T harpoon e run '~/.tmux/plugins/tmux-harpoon/harpoon -e'   # edit bookmark list (popup)
bind -T harpoon 1 run '~/.tmux/plugins/tmux-harpoon/harpoon -s 1' # jump to bookmark 1
```
(2/3/4 follow the same pattern.) Note: since it's TPM-managed rather than `make install`ed to `~/.local/bin`, the `harpoon` script isn't on `PATH` — it only runs via these tmux keybindings, not as a standalone shell command.

## Cheat sheet
| Key | Does |
|---|---|
| `prefix a`, `a` | Bookmark the current session |
| `prefix a`, `e` | Edit the bookmark list in a popup |
| `prefix a`, `1`…`4` | Jump to bookmark 1–4 |

## Future use
Only 4 bookmark slots are bound. `harpoon -r`/`-R` (replace a slot) could get the same `-T harpoon` treatment if a slot ever needs reassigning by key instead of through the edit popup.
