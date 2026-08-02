---
title: Workspaces — the regulars & their layouts
type: plan
status: draft
updated: 2026-07-11
description: Formalizing the places you work every day into named workspaces with flexible, summon-able layouts — dotfiles, kol-vault (Obsidian notes), kol-studio — plus the layout-system approach (tmux/nvim/Ghostty) that makes dropping into one a single move.
tags:
  - project/dotfiles
  - domain/tooling
  - pattern/tui
related:
  - "[[INDEX|kol-terminality]]"
  - "[[01-vision-and-cockpit|Vision & cockpit]]"
  - "[[05-tmux-and-layout|tmux & layout]]"
  - "[[scripts/20-files|files/to navigation]]"
---

# Workspaces

Create a **workspace per regular** — a named, summon-able layout you drop into, instead of hand-arranging panes each time. Complements the existing `to`/`files` folder-nav (jump *there*) with a layout (arrive *set up*).

## The regulars (day one)

| Workspace | What's in it | Notes |
|---|---|---|
| **dotfiles** | this repo — editor + git-sync + the docs vault + a scratch pane | the repo that "grows"; primary tinkering surface |
| **kol-vault** | the main Obsidian vault — open, parsing new info, markdown + images + git-sync | is it also the task source? see [[06-notes-and-tasks\|Notes & tasks]] |
| **kol-studio** | the studio project — editor + dev server + the dashboard work | the dashboard arc lives here (see [[08-automation-and-ritual\|ritual]]) |

## The layout-system approach

- **Summon, don't arrange.** A workspace = a saved tmux/nvim/Ghostty layout invoked by one command/keybind (the repo already has `bin/pane-layout.sh` / `layout-picker.sh` + tmuxinator ymls — build on those, don't reinvent).
- **Flexible, not rigid.** Layouts are starting points; panes/splits adapt in-session. The layout defines the *skeleton* (which repos, which tools), not a frozen arrangement.
- **Per-workspace working patterns.** Each regular has a natural loop (dotfiles = edit→test→sync; vault = capture→link→sync; studio = build→preview). Document the loop with the layout.

## Ties to elsewhere
- Layout mechanics + tmux popups → [[05-tmux-and-layout|tmux & layout]].
- The nvim inside each workspace → [[03-neovim|Neovim]].
- Jumping to the folder (before the layout exists) → the `to`/`files` system.

## Open questions
- One tmuxinator/layout per workspace, or a single parametrized launcher?
- Does a workspace pin to a specific AeroSpace workspace/monitor, or float?
- kol-vault: same layout locally and over SSH from the iPad, or different?
