---
title: tmux & layout — work layers
type: plan
status: draft
updated: 2026-07-11
description: The tmux side of the workstation — windows as work layers, popups for transient tools, focus-aware split indicators, sticky always-on scripts, the tmux-plugin decision (reversing plugin-free), and how Ghostty/nvim panes fit alongside.
tags:
  - project/dotfiles
  - domain/shell
  - pattern/tui
related:
  - "[[INDEX|kol-terminality]]"
  - "[[02-workspaces|Workspaces]]"
  - "[[kol-cli/01-cli-cheatsheet|CLI cheatsheet]]"
  - "[[11-ricing-backlog#9. tmux plugins (TPM) — video overview|ricing backlog: tmux plugins]]"
---

# tmux & layout

tmux is the frame the workstation hangs on — windows as **work layers**, popups for transient tools, layouts summoned per workspace.

## Chunks
- **Windows as work layers** — linkarzu's main view = tmux windows holding config files / work / popups. Map our workspaces ([[02-workspaces|Workspaces]]) onto a window-per-layer scheme.
- **Popups everywhere** — heavy use of tmux `display-popup` for transient tools (we already have `prefix C-t/C-y/C-s/C-g/C-p/C-d/C-o/C-b`). Extend the pattern; popups are the "summon a tool, dismiss it" surface.
- **Focus-aware split indicators** — linkarzu's tmux shows **arrows changing with focus** marking pane direction/active pane. Find the option in his `tmux.conf` (`pane-border-format` / border-status). Cosmetic + orientation. (He also demos splits via Ghostty panes and nvim panes — three ways to split; not important which, just noting.)
- **Sticky scripts** — the cockpit wants scripts *always running* in tmux (see [[01-vision-and-cockpit|cockpit]]) — a persistent window/pane of long-lived processes (timers, watchers, sync). Design what's sticky.
- **tmux plugins — the reversal decision** — we're deliberately **plugin-free**. linkarzu's TPM set (sent yesterday): `tpm`, `tmux-sensible`, `tmux-resurrect`, `tmux-continuum`, `tmux-yank`, `vim-tmux-navigator`, `tmux-prefix-highlight`, `sainnhe/tmux-fzf`. Highest-value for us: resurrect/continuum (session persistence) + `vim-tmux-navigator` (already have the standalone version) + the plugin-free `C-f` fzf window-jump. Full analysis in [[11-ricing-backlog#9. tmux plugins (TPM) — video overview|the backlog]].
- **Ghostty / nvim panes** — panes also come from Ghostty and from nvim splits; decide which layer owns splitting for which task.

## Open questions
- Reverse plugin-free for resurrect/continuum, or keep native detach/reattach?
- Window-per-work-layer, or session-per-workspace, or both?
- Which scripts are genuinely "sticky" (always-on) vs summoned?
