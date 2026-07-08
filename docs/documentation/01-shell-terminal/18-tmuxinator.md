---
title: tmuxinator
type: reference
status: active
updated: 2026-07-08
description: Define a project's full tmux window/pane layout in a YAML file and launch it with one command — the classic Ruby project-layout tool.
aliases:
  - tmuxinator
tags:
  - domain/shell
  - pattern/tui
  - integration/brew-formula
links:
  repo: https://github.com/tmuxinator/tmuxinator
  brew: https://formulae.brew.sh/formula/tmuxinator
covers:
  - Defining windows/panes/startup commands per project in YAML
  - Starting, stopping, and listing projects
related:
  - "[[02-tmux|tmux]]"
  - "[[19-tmuxp|tmuxp]]"
  - "[[02-tmux-dashboards|tmux dashboards (home / torrent)]]"
---

## Summary
`tmuxinator` reads a per-project YAML file describing windows, panes, layout, and startup commands, then builds that exact tmux session with one command: `tmuxinator start <project>`. It's the standalone-CLI counterpart to hand-building the same layout every time a project is opened.

## Why installed
For a project that always needs the same 3-pane layout (editor / server / logs), typing it out — or even scripting it in `.tmux.conf` — is more to maintain than one YAML file. Kept alongside [[19-tmuxp|tmuxp]] rather than picked as a "winner" — see that doc for why.

## Setup
1. Install (in `brewfile-cli`): `brew install tmuxinator`
2. Set an editor once: `export EDITOR='nvim'` (already the case via `.zshrc`)
3. Create a project: `tmuxinator new myproject` — opens the new YAML in `$EDITOR`

## How to use
```sh
tmuxinator new myproject      # create/edit a project config
tmuxinator start myproject    # build and attach the session
tmuxinator stop myproject     # kill it
tmuxinator list               # show every configured project
```

Config files default to `~/.config/tmuxinator/<name>.yml` (or `.tmuxinator.yml` in a project directory for a local, per-repo config).

## Example config (verified against tmuxinator's own sample)
Three windows, one of them (`editor`) split into two panes — the exact shape "3 windows + pane splits" means in this format:

```yaml
name: myproject
root: ~/dev/projects/myproject   # cwd every window/pane starts in

# Which window is focused when the session opens (name or index; default = first window)
startup_window: editor

windows:
  # Window 1: "editor" — split into 2 panes (main-vertical = one big pane left,
  # a narrower column right). Each pane can be named too, e.g. `- editor: nvim`.
  - editor:
      layout: main-vertical
      panes:
        - editor: nvim
        - # a bare shell, no startup command
  # Window 2: single pane, one startup command — the short form
  - server: npm run dev
  # Window 3: single pane, another short-form command
  - logs: tail -f log/development.log
```

- **`windows`** is a list; each item is `windowName: <command>` (single pane, short form) or `windowName: {layout, panes}` (multiple panes, long form).
- **`layout`** is a tmux layout string — same names as `prefix space` cycles through: `even-horizontal`, `even-vertical`, `main-horizontal`, `main-vertical`, `tiled`.
- **`panes`** is a list, one entry per pane, in the order they're created. A blank entry (like the second `editor` pane above) just opens a plain shell.
- Full field reference (hooks, `pre_window`, `tmux_options`, `focused_pane`, `synchronize`, …): [tmuxinator's own sample config](https://github.com/tmuxinator/tmuxinator/blob/master/lib/tmuxinator/assets/sample.yml) — this doc only covers the fields actually used above.

## Cheat sheet
| Command | Does |
|---|---|
| `tmuxinator new <name>` | Create a new project config |
| `tmuxinator start <name>` | Launch the session from config |
| `tmuxinator stop <name>` | Terminate the project's session |
| `tmuxinator list` | List all configured projects |
| `tmuxinator copy <old> <new>` | Duplicate a project config |
| `tmuxinator delete <name>` | Remove a project config |
| `tmuxinator debug <name>` | Print the shell commands it would run |

## Tracked layouts
Two dashboard configs are tracked at `~/.dotfiles/tmuxinator/` (symlinked to `~/.config/tmuxinator/` by `bootstrap.sh`): **`home`** (system monitor + fastfetch + yazi) and **`torrent`** (Jackett search + Transmission progress). Full write-up: [[02-tmux-dashboards|tmux dashboards]]. Add more by dropping a `<name>.yml` there. For a layout you've already built by hand instead, see [[19-tmuxp|tmuxp]]'s `freeze` command — tmuxinator has no equivalent.
