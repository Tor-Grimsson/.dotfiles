---
title: sesh
type: reference
status: active
updated: 2026-07-04
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
| `sesh connect {name}` | Attach, creating it if missing |
| `sesh last` | Switch back to the previous session |
| `sesh root` | Connect to the git worktree's root session |
| `sesh picker` | Built-in interactive selector (works without fzf) |

## Future use
Not wired into `.tmux.conf` — it's a plain shell command, so no binding is required. Being run side-by-side with `tmux-sessionx` before settling on one session-picker to keep long-term.
