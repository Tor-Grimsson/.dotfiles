---
title: lazygit
type: reference
status: active
updated: 2026-07-08
description: Keyboard-driven terminal UI for git — stage hunks/lines, commit, branch, interactive-rebase, stash, cherry-pick, and resolve conflicts without memorising git plumbing. Bound to a tmux popup on prefix C-g.
aliases:
  - lazygit
tags:
  - domain/dev
  - pattern/tui
  - integration/brew-formula
links:
  website: https://github.com/jesseduffield/lazygit
  repo: https://github.com/jesseduffield/lazygit
  manual: https://github.com/jesseduffield/lazygit/blob/master/docs/keybindings/Keybindings_en.md
  brew: https://formulae.brew.sh/formula/lazygit
related:
  - "[[02-gh|gh (GitHub CLI)]]"
  - "[[04-git-github|Git & GitHub workflow]]"
  - "[[02-tmux|tmux (the C-g popup)]]"
---

## Summary
A full-screen TUI over git. Everything git does interactively — staging, committing, branching, rebasing, stashing, conflict resolution, viewing diffs and history — driven by single keystrokes in a panel layout, so you skip the plumbing commands. It's the fastest way to do the *interactive* half of git; scripted/CI git still goes through the CLI.

## Why installed
Interactive git from the keyboard. Staging individual hunks or lines, reordering/squashing commits in a rebase, and resolving merge conflicts are all painful as raw `git` invocations and trivial in lazygit. Runs against whatever repo you launch it in.

## How to use
```sh
lazygit                 # open in the current directory's repo
lazygit -p ~/some/repo  # open against a specific repo path
```

Reads its config from `~/.config/lazygit/config.yml` (theme, keybindings, custom commands) — optional; the defaults are sane.

## Key panels & bindings
Cycle panels with `Tab` / arrow keys; `?` shows context-aware keybindings; `q` quits.

| Panel | Key actions |
|---|---|
| **Files** (staging) | `space` stage/unstage file · `Enter` stage individual hunks/lines · `c` commit · `A` amend · `d` discard |
| **Branches** | `space` checkout · `n` new · `M` merge · `r` rebase onto |
| **Commits** | `Enter` view files · `s` squash down · `r` reword · `d` drop · `e` edit (interactive rebase) |
| **Stash** | `s` stash · `space` pop · `g` apply |
| **Global** | `P` push · `p` pull · `+`/`-` next/prev screen mode |

## tmux popup — `prefix C-g`
Bound in `tmux/.tmux.conf` as a floating popup that opens on the **current pane's repo**:
```
bind C-g display-popup -d "#{pane_current_path}" -w 90% -h 90% -E "lazygit"
```
`-d "#{pane_current_path}"` is what makes it act on the repo you're standing in; `-E` closes the popup when you quit lazygit. Float it over any work, commit, `q`, back where you were.

## Biggest win
Staging by hunk and interactive-rebase without the ceremony. `git add -p` and `git rebase -i` are the two most fiddly everyday git operations, and lazygit turns both into a couple of keystrokes with a live diff.

## Future use
Custom commands in `config.yml` can bind repo-specific actions (e.g. one-key `git push --force-with-lease`, or a worktree switcher) — worth wiring if a repeated git chore emerges. Pairs with [[04-git-worktrees|worktrees]] for parallel-agent work.
