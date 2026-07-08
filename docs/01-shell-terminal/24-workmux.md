---
title: workmux
type: reference
status: active
updated: 2026-07-04
description: Pairs a git worktree with a tmux window in one command — parallel feature branches (or parallel AI agents) with zero stashing, zero manual setup.
aliases:
  - workmux
tags:
  - domain/shell
  - pattern/cli
  - integration/brew-formula
links:
  website: https://workmux.raine.dev/
  repo: https://github.com/raine/workmux
  brew: https://formulae.brew.sh/formula/workmux
covers:
  - Creating and cleaning up a worktree + tmux window pair
  - Listing/dashboarding all active worktrees
related:
  - "[[02-tmux|tmux]]"
---

## Summary
`workmux` ties a git worktree to its own tmux window: `workmux add <branch>` creates the worktree *and* the window together (copying `.env`, symlinking `node_modules`, running install commands), and `workmux merge` tears down the branch, worktree, and window in one shot. Built on top of tmux (also supports kitty/WezTerm/Zellij as alternative backends) — not a replacement.

## Why installed
Working on several feature branches in parallel normally means stashing, switching, and re-running setup each time. `workmux add` skips all of that — each branch gets its own directory and tmux window, so nothing needs stashing to check something else. Particularly aimed at running multiple AI coding agents in parallel, one per worktree, without them stepping on each other's working tree.

## Setup
Install (in `brewfile-cli`, own tap): `brew install raine/workmux/workmux`

## How to use
```sh
workmux add user-auth       # create worktree + tmux window, switch to it
# ...work in the new window...
workmux merge                # merge the branch, remove worktree + window + branch

workmux list                 # every worktree, with status
workmux dashboard             # TUI: monitor all active agents at once
workmux sidebar                # toggle a compact agent-status sidebar in tmux
```

## Cheat sheet
| Command | Does |
|---|---|
| `workmux add <branch>` | Create worktree + tmux window, switch to it |
| `workmux merge` | Merge branch, remove worktree/window/branch — full cleanup |
| `workmux rebase <name>` | Rebase a worktree's branch onto its base |
| `workmux remove <name>` | Remove a worktree without merging |
| `workmux list` | List all worktrees with status |
| `workmux open <name>` / `close <name>` | Reopen / close a worktree's tmux window (keeps the worktree) |
| `workmux resurrect` | Restore worktree windows after a crash |
| `workmux dashboard` | TUI dashboard of every active agent |
| `workmux sidebar` | Toggle its own compact agent-status sidebar |

## Configuration
`workmux config edit` opens the global config (base branch, default agent, file-copy/symlink rules, named pane layouts via `--layout`). `workmux init` generates a starter one.

## Future use
Not configured yet — worth setting up `post_create` hooks (`.env` copy, `node_modules` symlink) for whichever project sees the most parallel-branch churn first.
