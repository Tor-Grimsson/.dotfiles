---
title: sesh
type: reference
status: active
updated: 2026-07-08
description: Smart tmux session picker — fuzzy-finds across running sessions, tmuxinator/tmuxp configs, and zoxide's frecency-ranked directories from one command.
aliases:
  - sesh
tags:
  - domain/shell
  - pattern/tui
  - integration/brew-formula
links:
  repo: https://github.com/joshmedeski/sesh
  brew: https://formulae.brew.sh/formula/sesh
covers:
  - Connecting to or creating a session from one fuzzy picker
  - Where its config lives and what it's for
  - Head-to-head against tmux-sessionx (both still being evaluated)
related:
  - "[[02-tmux|tmux]]"
  - "[[20-tmux-sessionx|tmux-sessionx]]"
---

## Summary
`sesh` is a session picker for tmux: it fuzzy-finds across **running tmux sessions**, **zoxide's frecency-ranked directories**, and anything defined in its own config, tmuxinator, or tmuxp — then attaches to a match or creates the session on the spot. It's a standalone Go binary, not a tmux plugin.

## Why installed
zoxide already knows the directories actually worked in; `sesh connect` reuses that ranking instead of hand-maintaining a project list, so casual "jump into a project" switching needs zero config. Being run head-to-head against `tmux-sessionx` (same job, done as a tmux popup with a richer preview) — `tmux-tea` lost this comparison 2026-07-04 and was dropped.

## Setup
1. Install (in `brewfile-cli`): `brew install sesh`
2. Optional config, only needed for named sessions with startup commands: `mkdir -p ~/.config/sesh && touch ~/.config/sesh/sesh.toml`

## How to use
```sh
sesh list              # sessions + zoxide dirs + configured sessions, one list
sesh connect <name>     # attach, creating it first if it doesn't exist
sesh last               # jump to the second-to-last attached session
sesh root               # connect to the root session of the current git worktree
```

## Cheat sheet
| Command | Does |
|---|---|
| `sesh list` | List sessions, zoxide dirs, and configured sessions |
| `sesh list -t` | List only running tmux sessions |
| `sesh connect {name}` | Attach, creating it if missing |
| `sesh last` | Switch back to the previous session |
| `sesh root` | Connect to the git worktree's root session |
| `sesh picker` | Built-in interactive selector (works without fzf) |
| `sesh preview {name}` | Preview a session's pane or a directory listing — used as the popup's fzf `--preview` |

## Future use
Wired into `.tmux.conf` as `prefix C-s` — a `display-popup` running `sesh connect -s "$(sesh list -t | fzf --reverse --preview 'sesh preview {}')"`, so it floats a picker of **running tmux sessions only** (`-t`, not the full session+zoxide+config blend) and switches to the match. **`-s`/`--switch` is required here** — plain `sesh connect` does a raw `attach-session`, and calling that from inside a popup's ephemeral client (a non-interactive nested context) crashed all tmux sessions on 2026-07-08 with no crash report left behind (server wedge, not a segfault). `-s` makes it `switch-client` instead, which is safe from a popup/keybinding trigger. **The explicit `--preview 'sesh preview {}'` is also required** — without it, fzf falls back to the shell's global `FZF_DEFAULT_OPTS` bat/eza preview, which errors on session-name entries like `0` (not real paths); `sesh preview` handles both sessions and directories correctly. Still being run side-by-side with `tmux-sessionx` (`prefix O`) before settling on one session-picker to keep long-term. Also usable as a plain shell command (`sesh connect …`, no `-s` needed) with no binding.
