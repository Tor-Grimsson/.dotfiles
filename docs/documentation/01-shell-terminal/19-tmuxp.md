---
title: tmuxp
type: reference
status: active
updated: 2026-07-27
description: Python session-layout tool with one feature tmuxinator lacks — tmuxp freeze snapshots an already-running session's layout into a config, instead of hand-typing one upfront.
aliases:
  - tmuxp
tags:
  - domain/shell
  - pattern/tui
  - integration/brew-formula
links:
  repo: https://github.com/tmux-python/tmuxp
  brew: https://formulae.brew.sh/formula/tmuxp
covers:
  - Freezing a running session's layout into a config
  - Why it's kept alongside tmuxinator instead of choosing one
related:
  - "[[02-tmux|tmux]]"
  - "[[18-tmuxinator|tmuxinator]]"
---

## Summary
`tmuxp` builds a tmux session from a YAML/JSON config — same pitch as `tmuxinator` — but adds the one thing tmuxinator can't do: `tmuxp freeze` snapshots an **already-running** session (windows, panes, layout) straight into a config file. No hand-typing required for a layout you've already built by clicking/splitting your way to.

## Why kept alongside tmuxinator
Originally dropped 2026-07-04 in tmuxinator's favor, then reinstated the same day — hand-typing a layout from scratch (tmuxinator's only mode) doesn't cover "I already built this by hand and want to keep it," which was a stated requirement. The two aren't a duplicate pair: **tmuxinator** for layouts designed upfront as YAML, **tmuxp** for freezing one you already built interactively. Use whichever fits how the layout came to exist, not one "winner."

## Setup
Install (in `brewfile-cli`): `brew install tmuxp`

Requires `export DISABLE_AUTO_TITLE='true'` before oh-my-zsh loads (set in `shell/.zshrc`) — omz auto-retitling panes breaks tmuxp's pane parsing (libtmux `zip()` crash mid-build).

## How to use
```sh
# Build a layout by hand in tmux (split panes, cd into dirs, start your server, etc.),
# then capture it without typing any YAML:
tmuxp freeze                  # prompts for a save location, writes a YAML/JSON snapshot

# Later, rebuild that exact layout:
tmuxp load ./mysession.yaml

# Convert between formats if needed:
tmuxp convert mysession.yaml
```

Configs default to `~/.config/tmuxp/` (or a `.tmuxp.yaml`/`.tmuxp.json` in a project directory, loaded automatically from there).

## Cheat sheet
| Command | Does |
|---|---|
| `tmuxp freeze` | Snapshot the current session's layout — the reason this tool exists |
| `tmuxp load <file>` | Build and attach a session from a config |
| `tmuxp convert <file>` | Transform between YAML and JSON |
| `tmuxp shell` | Interactive Python console with the session objects |
| `tmuxp debug-info` | System info dump for troubleshooting |

## Gotcha — continuum race on fresh server start
`tmuxp load` on a machine with tmux-continuum: if the tmux server isn't running yet, the load *starts* it, which fires continuum's auto-restore in parallel — the pane churn crashes tmuxp mid-build (partial session) while continuum restores the real one anyway. **After a reboot, check `tmux ls` first**: if continuum restored the session, just attach; `tmuxp load` is the fallback for when the restore didn't happen.

## Saved configs
`~/.config/tmuxp/studio.yaml` (machine-local, iMac) — frozen 2026-07-27 from the live 8-window studio session.
