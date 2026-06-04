---
title: tmux
type: reference
status: active
updated: 2026-06-04
description: Terminal multiplexer that keeps shell sessions alive and splits one terminal into many panes and windows.
aliases:
  - tmux
tags:
  - domain/shell
  - pattern/tui
  - integration/brew-formula
links:
  website: https://tmux.github.io/
  repo: https://github.com/tmux/tmux
  manual: https://github.com/tmux/tmux/wiki
  brew: https://formulae.brew.sh/formula/tmux
covers:
  - Sessions, windows, and panes
  - Detaching and reattaching to persistent sessions
related:
  - "[[01-iterm2|iTerm2]]"
---

## Summary
tmux is a terminal multiplexer: it lets a single terminal window host multiple sessions, windows, and panes. Sessions run inside a server process, so they survive a closed terminal, a dropped SSH connection, or a logout, and can be reattached later.

## Why installed
It provides session persistence and layout control that the terminal emulator alone cannot. Long-running tasks and remote work stay alive across disconnects, and a single window can be carved into the panes a workflow needs without depending on iTerm2's own splits.

## Most common use case
Starting a named session, splitting it into panes, detaching, and reattaching later with the work exactly where it was left — especially over SSH where a dropped link would otherwise kill the running process.

## Biggest win
Detach/reattach. A session keeps running on the server after you disconnect; `tmux attach` brings it back intact. That persistence is what separates it from native terminal splits.

## How to use
```sh
tmux                      # start a new session
tmux new -s work          # start a named session "work"
tmux ls                   # list running sessions
tmux attach -t work       # reattach to "work"

# Inside tmux, the prefix is Ctrl-b by default:
#   Ctrl-b "   split pane horizontally
#   Ctrl-b %   split pane vertically
#   Ctrl-b o   cycle panes
#   Ctrl-b c   new window
#   Ctrl-b n / p   next / previous window
#   Ctrl-b d   detach (session keeps running)
#   Ctrl-b [   enter copy/scroll mode (q to exit)
```

## Future use
A `~/.tmux.conf` to remap the prefix, enable mouse mode, and persist layouts; plus the tpm plugin manager with `tmux-resurrect`/`tmux-continuum` to save and auto-restore full session state across reboots.
