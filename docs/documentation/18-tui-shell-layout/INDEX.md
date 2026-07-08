---
title: TUI shell layout
type: index
status: active
updated: 2026-07-08
description: Terminal-cockpit customization — the fastfetch shell-home greeting now, and the fuller tmux dashboard layouts (system monitor + music panels) as they get built. Configs documented per doc.
tags:
  - domain/shell
  - pattern/tui
related:
  - "[[documentation/INDEX|documentation]]"
  - "[[07-fastfetch|fastfetch]]"
  - "[[21-chafa|chafa]]"
---

# TUI shell layout

The home for terminal-cockpit customization — how the shell greets you and how the panes are arranged. Starts with the fastfetch shell-home; grows as tmux dashboard layouts (system monitor, music player) get added.

| # | Doc | What it covers |
|---|-----|----------------|
| 01 | [[01-fastfetch-home|Fastfetch shell home]] | A fastfetch greeting with a chafa-rendered portrait logo — the config, the image→chafa→ANSI logo pipeline, regen/tune, and the symlink wiring. |
| 02 | [[02-tmux-dashboards|tmux dashboards]] | tmuxinator layouts — a system-monitor `home` and a Jackett+Transmission `torrent` dashboard, launched with one command. |
| 03 | [[03-bookmarks|Bookmarks]] | A plain-text bookmark list of paths + URLs, reached from three tmux popups (open · quick-add cwd · typed-add). |

## Related
- [[07-fastfetch|fastfetch]] — the greeting · [[21-chafa|chafa]] — the logo renderer · [[18-tmuxinator|tmuxinator]] — the layout engine
- **Planned:** a music panel (mpd+rmpc) for the dashboards — parked in `.kol/llm-context/plan.md`.
