---
title: TUI shell layout
type: index
status: active
updated: 2026-07-08
description: Terminal-cockpit customization — the fastfetch shell-home greeting, the tmux dashboard layouts (home = music, stats = monitors, torrent), and a tmux bookmark system. Configs documented per doc.
tags:
  - domain/shell
  - pattern/tui
related:
  - "[[documentation/INDEX|documentation]]"
  - "[[07-fastfetch|fastfetch]]"
  - "[[21-chafa|chafa]]"
---

# TUI shell layout

The home for terminal-cockpit customization — how the shell greets you and how the panes are arranged: the fastfetch shell-home greeting, the tmux dashboard layouts (`home` = fastfetch + rmpc, `stats` = monitors, `torrent`), and a bookmark system.

| # | Doc | What it covers |
|---|-----|----------------|
| 01 | [[01-fastfetch-home|Fastfetch shell home]] | A fastfetch greeting with a chafa-rendered portrait logo — the config, the image→chafa→ANSI logo pipeline, regen/tune, and the symlink wiring. |
| 02 | [[02-tmux-dashboards|tmux dashboards]] | tmuxinator layouts — a music `home` (fastfetch + rmpc), a `stats` system cockpit (mactop/htop + fastfetch + yazi), and a Jackett+Transmission `torrent` dashboard; summoned as a window (`C-d`) or session (`C-o`). |
| 03 | [[03-bookmarks|Bookmarks]] | A plain-text bookmark list of paths + URLs, reached from three tmux popups (open · quick-add cwd · typed-add). |

## Related
- [[07-fastfetch|fastfetch]] — the greeting · [[21-chafa|chafa]] — the logo renderer · [[18-tmuxinator|tmuxinator]] — the layout engine
- **Music:** the `home` dashboard is fastfetch + rmpc — see [[08-terminal-music|Terminal music (mpd + rmpc)]].
