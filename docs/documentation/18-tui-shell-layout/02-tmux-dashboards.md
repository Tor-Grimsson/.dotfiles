---
title: tmux dashboards
type: playbook
status: active
updated: 2026-07-08
description: tmuxinator dashboard layouts — a music `home` (fastfetch greeting + rmpc), a `stats` system cockpit (mactop/htop + fastfetch + yazi), and a `torrent` search+progress dashboard. Summoned as a window (C-d) or session (C-o).
aliases:
  - tmux-dashboards
  - shell-layouts
tags:
  - domain/shell
  - pattern/tui
related:
  - "[[01-fastfetch-home|Fastfetch shell home]]"
  - "[[18-tmuxinator|tmuxinator]]"
  - "[[08-terminal-music|Terminal music (mpd + rmpc)]]"
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
| `fastfetch` · `rmpc` | used by `home` — rmpc needs `mpd` running (see [[08-terminal-music|terminal music]]) |
| `htop` · `fastfetch` · `yazi` | used by `stats` |
| `mactop` | **not** installed, Apple-Silicon only — `stats` auto-uses it on the MBP (per-core P/E, GPU, power) and falls back to `htop` on the Intel iMac |
| `tor-search` · `tor-jackett` · `transmission-remote` | used by `torrent` |

## 1. `home` — music greeting

A thin `fastfetch` greeting on top, the `rmpc` music player filling the rest (`main-horizontal`). The daily landing page.

```sh
mux home                 # whole session
# or  prefix C-d home    # window in the current session
# or  prefix C-o home    # own session
```

| Pane | Runs | Note |
|---|---|---|
| top (thin banner) | `fastfetch` | the chafa-logo greeting (prints once, leaves a shell) |
| bottom (fills the rest) | `rmpc` | the music TUI — needs `mpd` running on `:6600` ([[08-terminal-music|setup]]) |

The banner is held to a thin ~8 rows by a `# main-pane-height: 8` directive in the yml so rmpc dominates (lower the number for even more rmpc; see §4). `mux home` uses tmux's default 50/50 split; the tuned banner applies on the `C-d`/`C-o` paths.

## 2. `stats` — system cockpit

Monitor on the left (60% width), `fastfetch` banner + `yazi` file cockpit stacked on the right (`main-vertical`). This is what `home` used to be, before it became the music page.

```sh
mux stats                # or  prefix C-d stats  ·  prefix C-o stats
```

| Pane | Runs | Note |
|---|---|---|
| main (left, 60%) | `command -v mactop && mactop \|\| htop` | **mactop** on Apple-Silicon (per-core P/E, GPU, power), **htop** on Intel — auto-picks per machine |
| right-top | `fastfetch` | the greeting banner |
| right-bottom | `yazi` | file cockpit |

## 3. `torrent` — search + progress dashboard

Search shell on top, live download progress + the Jackett server below (`main-horizontal`).

```sh
mux torrent              # or  prefix C-d torrent  ·  prefix C-o torrent
```

| Pane | Runs | Note |
|---|---|---|
| main (top) | shell | type `tor-search <query>` — searches Jackett, pick a result, magnet → Transmission |
| bottom-left | `watch -n 2 -t transmission-remote -l` | live torrent list + progress, refreshed every 2s |
| bottom-right | `tor-jackett` | the Jackett indexer server `tor-search` queries (`Ctrl-C` stops it) |

Full torrent flow: [[07-torrent|tor-search / Transmission]].

## 4. Add a new dashboard

Drop a `<name>.yml` in `~/.dotfiles/tmuxinator/` (the symlink makes it live immediately):

```yaml
name: <name>
root: ~/
# Optional main-pane sizing (a COMMENT — tmuxinator + yq ignore it; pane-layout.sh
# reads it to size the main pane on the C-d/C-o paths). Rows/cols, or a %:
# main-pane-height: 12
# main-pane-width: 60%
windows:
  - win:
      layout: main-vertical      # or main-horizontal, tiled, even-horizontal…
      panes:
        - <command for pane 0>   # pane 0 = the "main" pane for the main-* layouts
        - <command for pane 1>
```

Then `tmuxinator start <name>` (or `prefix C-d`). `tmuxinator debug <name>` prints the generated tmux script without starting a session — use it to validate.

## 5. Two ways to summon a layout — window vs session

The same yml can land two ways, on two keys. Both fzf-pick from the layout list (`--no-preview` — layout names aren't file paths, so the global fzf bat-preview errors on them).

| Key | Helper | Result |
|---|---|---|
| **`prefix C-d`** | `tmux/pane-layout.sh` | grafts window 0's panes as a **new window in the session you're already in** — the "home in every session" case. No new session, no `switch-client`. |
| **`prefix C-o`** | `tmux/layout-picker.sh` | spawns the layout as its **own dedicated session** and switches you to it (the old `C-d`). |

**`C-d` (window graft, the common one):** `pane-layout.sh` reads window 0's panes + `layout:` from the yml via `yq`, opens a new window in the current session, `send-keys` each command into a shell pane (so `fastfetch` prints-then-shells, like `mux` does), then `select-layout <preset>`. Because you're already attached, it never touches `switch-client` — which is what made the session path able to hijack the wrong client.

**`C-o` (session spawn):** `layout-picker.sh` runs `tmuxinator start --no-attach <pick>` then `tmux switch-client -c #{client_name} -t <pick>`. The explicit `-c` targets the client that pressed the key — `tmuxinator start`'s own attach shells out a **target-less** `switch-client` that resolves to the *most-recently-used* client, which from a popup can be a different terminal (it would hijack that one's view instead).

**Add more window layouts:** any single-window yml in `~/.dotfiles/tmuxinator/` works for both keys and for `mux <name>` — one definition, three entry points.

## 6. Verification

- `yq` reads window 0's panes + `layout:` from `home`/`stats`/`torrent` (validated — including the quoted `command -v mactop && … || htop` fallback in `stats`).
- **`home`** → `main-horizontal` + `# main-pane-height: 12` builds a thin fastfetch banner over a big rmpc pane (verified: 12-row top, rest below).
- **`stats`** → `main-vertical` + `# main-pane-width: 60%` builds the monitor on the left, fastfetch + yazi stacked right.
- `prefix C-d <name>` → a **new window in your current session**; `prefix C-o <name>` → its **own session** on the client you pressed from.
- `home` needs `mpd` running for rmpc to connect — see [[08-terminal-music|terminal music]].
