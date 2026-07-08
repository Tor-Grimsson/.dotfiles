---
title: Bookmarks
type: playbook
status: active
updated: 2026-07-08
description: A lightweight bookmark system — a plain-text list of favourite paths and URLs, reached from three tmux popups (open, quick-add current dir, typed-add). The first cut of the kol-tui-plugin bookmark idea.
aliases:
  - bookmarks
tags:
  - domain/shell
  - pattern/tui
related:
  - "[[02-tmux|tmux]]"
  - "[[02-tmux-dashboards|tmux dashboards]]"
  - "[[explorations/INDEX|bookmark sidebar exploration]]"
---

# Bookmarks

A minimal bookmark system: one plain-text list of favourite **paths and URLs**, reached from three tmux keybinds. No database, no plugin — a file plus three small scripts. This is the on-demand-popup first cut of the [[explorations/INDEX|bookmark sidebar exploration]] (the persistent sidebar, worktree entries, and clickable OSC-8 links are still unbuilt).

## 0. The pieces

| Piece | Path | What |
|---|---|---|
| the list | `~/.dotfiles/tmux/bookmarks.txt` | one entry per line — a path (`~/…` or `/…`) or a URL (`http…`); blank lines ignored |
| open | `tmux/bookmark-open.sh` | fzf-pick → open (routes URL vs path) |
| quick-add | `tmux/bookmark-add.sh` | append a path (deduped, `$HOME`→`~`) |
| typed-add | `tmux/bookmark-input.sh` | prompt for a path/URL, then quick-add it |

All three are wired in `tmux/.tmux.conf` and live on both machines (the repo is the source; the scripts run by `~/.dotfiles/…` path, no symlink needed).

## 1. The keys

| Bind | Does |
|---|---|
| `prefix C-b` | **open** — fzf popup of every bookmark; pick one → a **URL** opens in the default browser (`open`), a **path** opens in `nvim` (dirs land in nvim's explorer) |
| `prefix B` | **quick-add** — bookmark the **current pane's directory** in one press (deduped; `$HOME` shortened to `~` so it's portable across machines) |
| `prefix A` | **typed-add** — a small input popup: type a **path or URL**, hit Enter, it's added |

## 2. Add a bookmark — three ways

1. **This directory:** `prefix B` — done, no typing.
2. **A specific path or URL:** `prefix A` → type it → Enter.
3. **By hand:** open `~/.dotfiles/tmux/bookmarks.txt` (it bookmarks itself — `prefix C-b` → pick `bookmarks.txt`) and add a line.

Both add-paths dedupe, so pressing `prefix B` twice in the same dir won't double it.

## 3. Remove / reorder

Edit the file — `prefix C-b` → `bookmarks.txt` → delete or move lines in nvim → `:w`. Order in the file is the order in the picker.

## 4. How the open routing works

`bookmark-open.sh` reads the pick and branches:
- starts with `http://` / `https://` → `open "$url"` (default browser)
- anything else → `nvim "$path"` (leading `~` expanded to `$HOME`)

To change where paths open (e.g. dirs → [[02-yazi|yazi]] instead of nvim), edit the `case` in `tmux/bookmark-open.sh`.

## 5. Verification

- `bash -n` clean on all three scripts; `prefix B` / `prefix A` add and dedupe; `prefix C-b` lists and opens.
- Reload the config to make the binds live: **`prefix r`**.
