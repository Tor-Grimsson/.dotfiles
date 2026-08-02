---
title: kol-terminality — the terminal as workstation
type: index
status: active
updated: 2026-07-11
description: The home for building a terminal-centered workstation and way-of-working — the workstation itself (Neovim, bars, tmux, notes), the workspaces for the regulars, the daily login→work→close ritual and its automation, and the connected multi-device reach. Everything from the 2026-07-11 brain-dump has a space here; nothing was filtered.
tags:
  - project/dotfiles
  - domain/tooling
  - pattern/tui
related:
  - "[[INDEX|docs root]]"
  - "[[11-ricing-backlog|ricing 2025 backlog]]"
  - "[[12-nvim-from-scratch|nvim from scratch]]"
---

# kol-terminality

Building a place to *live and work* inside the terminal — not a static rice, a **workstation + a way of working** that evolves a little every day. This space holds the whole vision, scoped into biggest categories, each its own doc to grow into. Outline first (v1 + roadmap), build second.

## The north star

Rarely leave the terminal. The regulars (dotfiles, the vault, kol-studio) each get a **workspace** with a flexible layout you drop into. A daily **ritual** opens and closes work and tracks it (today it's only in your head). Agent work is central — the one gripe is output, now hard-gated. The rig reaches past the desk: iPads, Apple TV via Blink, remote machines, a dispatch loop, a telegram bot, publicity nudges. Inspired by [linkarzu](https://github.com/linkarzu/dotfiles-latest) and [Sin-cy](https://github.com/Sin-cy/dotfiles) — recreated to fit *our* purpose, not 1:1.

## The map

| # | Category | Holds |
|---|---|---|
| 01 | [[01-vision-and-cockpit\|Vision & cockpit]] | the operating model, the multi-device cockpit, agent-work's role, the daily-evolution ethos |
| 02 | [[02-workspaces\|Workspaces]] | the regulars (dotfiles · kol-vault · kol-studio), flexible layout systems, per-workspace working patterns |
| 03 | [[03-neovim\|Neovim (load-bearing)]] | Sin-cy + linkarzu configs, Neovide, image-paste, the claude-input↔nvim bind, popups, markdown |
| 04 | [[04-desk-visual-layer\|The desk (visual layer)]] | bars (simple-bar/Übersicht vs SketchyBar), hide-menubar, btop/fastfetch, Ghostty/Kitty, colorscheme selector, starship, shaders |
| 05 | [[05-tmux-and-layout\|tmux & layout]] | splits/focus indicators, popups as work layers, sticky scripts, tmux plugins, Ghostty/nvim panes |
| 06 | [[06-notes-and-tasks\|Notes & tasks]] | skitty-notes, kol-vault-as-task-source question, git-sync, markdown tasks |
| 07 | [[07-macos-control\|macOS control]] | osascript GUI-bypass (menubar + dock keybinds), Karabiner, GNU Stow, Raycast |
| 08 | [[08-automation-and-ritual\|Automation & ritual]] | login→work→close→track ritual (v1 + roadmap), the kol-studio dashboard arc + lessons, personalities per task |
| 09 | [[09-connected-reach\|Connected reach]] | Claude dispatch (mobile↔desktop), telegram bot, gcal, publicity/sharing automation, the cockpit's far edges |
| 10 | [[10-references-and-backlog\|References & backlog]] | every link/video/tool, au-transcripts option, cross-links to the ricing backlog + nvim-from-scratch study |
| 11 | [[11-ricing-backlog\|Ricing backlog]] | the to-evaluate tool list + 8 open questions (moved in from research) |
| 12 | [[12-nvim-from-scratch\|Neovim from scratch]] | the Sin-cy nvim build tracker (moved in from research) |
| 13 | [[13-awesome-tuis\|awesome-tuis]] | curated TUI-tools list to browse (moved in from research) |
| — | [[kol-dash/INDEX\|kol-dash]] | the dashboard lineage — wake automation + the three "dashboards" + iPad kiosk (moved in from operations) |

## Roadmap (sequencing only — nothing here is dropped, just ordered)

- **v1 — the skeleton.** The daily ritual v1 (a real `login`/`close` + work-tracking), **one** workspace formalized (dotfiles), Neovim as the load-bearing editor, the **bar decision** (simple-bar vs SketchyBar) settled, and the quick win of hide-menubar.
- **v2 — the surfaces.** Notes/tasks (skitty-notes or vault-native), the tmux layout system, the remaining workspaces (kol-vault, kol-studio), the visual layer polish (btop/fastfetch/colorscheme/shaders).
- **later — the reach.** Connected stack (dispatch, telegram, personalities, publicity automation) and the full multi-device cockpit.

## How to use this space

Each category doc captures its chunks + links + open questions + a v1/roadmap note. Nothing is committed — this is the outline to argue with and grow. Graduate a chunk into real work by moving it to the repo + logging it. The to-evaluate tool references already live in [[11-ricing-backlog|the ricing backlog]]; this space is the *vision and structure* on top of them.
