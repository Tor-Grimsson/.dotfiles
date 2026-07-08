---
title: tmux dashboards
type: playbook
status: active
updated: 2026-07-08
description: tmuxinator dashboard layouts — a one-command system-monitor "home" and a Jackett-search + Transmission-progress "torrent" dashboard. The multi-panel cockpits from the reference screenshots.
aliases:
  - tmux-dashboards
  - shell-layouts
tags:
  - domain/shell
  - pattern/tui
related:
  - "[[01-fastfetch-home|Fastfetch shell home]]"
  - "[[18-tmuxinator|tmuxinator]]"
  - "[[07-torrent|torrent scripts (tor-search)]]"
  - "[[11-htop|htop]]"
---

# tmux dashboards

Multi-pane tmux cockpits defined once in YAML and launched with one command via [[18-tmuxinator|tmuxinator]] — or picked from an fzf popup with **`prefix C-d`**. This is the "layout" half of the shell home — the [[01-fastfetch-home|fastfetch greeting]] is the banner; these are the working dashboards from the reference screenshots.

Configs live in `~/.dotfiles/tmuxinator/*.yml` (symlinked to `~/.config/tmuxinator/` via `bootstrap.sh`), so they sync across both machines.

## 0. Prerequisites

| Need | State |
|---|---|
| `tmuxinator` | installed (brew) |
| `htop` · `fastfetch` · `yazi` | installed — used by `home` |
| `tor-search` · `tor-jackett` · `transmission-remote` | installed — used by `torrent` |
| `mactop` | **not** installed, Apple-Silicon only — the MBP upgrade for the monitor pane; the Intel iMac uses `htop` |

## 1. `home` — system dashboard

Monitor on the left, fastfetch banner + yazi file cockpit stacked on the right (`main-vertical`).

```sh
tmuxinator start home     # or: mux home
```

| Pane | Runs | Note |
|---|---|---|
| main (left) | `htop` | swap for `mactop` on the Apple-Silicon MBP — per-core P/E, GPU, power |
| right-top | `fastfetch` | the chafa-logo shell-home banner (prints once, leaves a shell) |
| right-bottom | `yazi` | file cockpit |

## 2. `torrent` — search + progress dashboard

Search shell on top, live download progress + the Jackett server below (`main-horizontal`).

```sh
tmuxinator start torrent  # or: mux torrent
```

| Pane | Runs | Note |
|---|---|---|
| main (top) | shell | type `tor-search <query>` — searches Jackett, pick a result, magnet → Transmission |
| bottom-left | `watch -n 2 -t transmission-remote -l` | live torrent list + progress, refreshed every 2s |
| bottom-right | `tor-jackett` | the Jackett indexer server `tor-search` queries (`Ctrl-C` stops it) |

Full torrent flow: [[07-torrent|tor-search / Transmission]].

## 3. Add a new dashboard

Drop a `<name>.yml` in `~/.dotfiles/tmuxinator/` (the symlink makes it live immediately):

```yaml
name: <name>
root: ~/
windows:
  - win:
      layout: main-vertical      # or main-horizontal, tiled, even-horizontal…
      panes:
        - <command for pane 0>
        - <command for pane 1>
```

Then `tmuxinator start <name>`. `tmuxinator debug <name>` prints the generated tmux script without starting a session — use it to validate.

## 4. Verification

- `tmuxinator debug home` and `tmuxinator debug torrent` render without error (both validated: 4 panes each).
- `tmuxinator start home` opens the three-pane monitor/banner/files layout; `tmuxinator start torrent` opens the search/progress/Jackett layout.
