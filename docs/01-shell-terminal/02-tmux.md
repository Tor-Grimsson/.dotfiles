---
title: tmux
type: reference
status: active
updated: 2026-07-04
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
  - "[[10-tmux-help|tmux help & cheat sheet]]"
  - "[[09-tmux-tips|tmux tips & tricks]]"
  - "[[17-sesh|sesh]]"
  - "[[18-tmuxinator|tmuxinator]]"
  - "[[19-tmuxp|tmuxp]]"
  - "[[20-tmux-sessionx|tmux-sessionx]]"
  - "[[22-tmux-harpoon|tmux-harpoon]]"
  - "[[24-workmux|workmux]]"
  - "[[25-tmux-agent-sidebar|tmux-agent-sidebar]]"
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

# Inside tmux, the prefix is Ctrl-a. With this repo's ~/.tmux.conf:
#   Ctrl-a |   split left/right         Ctrl-a -   split top/bottom
#   Ctrl-a h/j/k/l   move between panes (arrows work too)
#   Ctrl-a z   zoom a pane fullscreen (toggle)
#   Ctrl-a c   new window               Ctrl-a 1..9   jump to window N
#   Ctrl-a n / p   next / previous window
#   Ctrl-a d   detach (session keeps running)
#   Ctrl-a [   copy/scroll mode (q to exit)   Ctrl-a r   reload config
# (tmux's stock " and % splits still work — see Configuration below.)
```

## Configuration
`~/.tmux.conf` is repo-managed at `~/.dotfiles/tmux/.tmux.conf` (symlinked by `bootstrap.sh`), self-commented. Highlights:
- **Mouse on** — click panes, drag borders to resize, scroll to scroll back.
- **Intuitive splits** — `prefix |` / `prefix -`, opening in the current folder; `h/j/k/l` to move, `H/J/K/L` to resize. tmux's stock `"`/`%` still work.
- **vi copy mode → macOS clipboard** — `v` select, `y` copy via `pbcopy`; mouse-drag copies too.
- **Quiet top status bar** — faint window list flush top-left (`#I:#W#F`), with a blank second row for breathing space above the p10k prompt.
- **base-index 1**, 50k scrollback, true-colour passthrough, `prefix r` to reload.
- **TPM** (`tmux-plugins/tpm`, cloned + installed by `bootstrap.sh`) runs [tmux-sessionx](20-tmux-sessionx.md) (`prefix O`) — an fzf-based session picker being run head-to-head against the standalone [sesh](17-sesh.md) — and [tmux-harpoon](22-tmux-harpoon.md) (session bookmarking) — given its own key table, `prefix a` then `1`–`4`/`a`/`e`, after both `Alt` (collides with AeroSpace's global workspace keys) and `Ctrl+Shift` (this terminal doesn't report Shift on Ctrl-letter combos) were tried and ruled out. [tmuxinator](18-tmuxinator.md) and [tmuxp](19-tmuxp.md) (YAML project layouts) round out the set — no tmux binding needed, both are plain shell commands, kept side by side rather than picked as a winner (tmuxinator for upfront-designed layouts, tmuxp for freezing one already built by hand). (`tmux-tea` was evaluated alongside these and dropped 2026-07-04.) [tmux-agent-sidebar](25-tmux-agent-sidebar.md) (`prefix e`/`prefix E`) rounds out the plugin set — live AI-agent status across sessions/windows, paired with [workmux](24-workmux.md) (git worktree + tmux window pairing, not a TPM plugin, plain CLI) for parallel-branch/agent workflows. Note: workmux ships its own `workmux sidebar` command that overlaps somewhat with tmux-agent-sidebar's job — worth comparing before keeping both permanently.

Day-to-day keys, copy mode in full, and pane/window/session tricks: see [tmux tips & tricks](09-tmux-tips.md).

## Future use
`tmux-resurrect` / `tmux-continuum` to save and auto-restore full session layouts **across reboots** (native detach/reattach only survives while the machine stays on) — TPM is in place now, so these are just a `@plugin` line away whenever that's worth adding. Once `sesh` or `tmux-sessionx` "wins" the side-by-side evaluation, drop the other.
