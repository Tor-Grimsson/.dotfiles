---
title: Notes & tasks — the capture surface
type: plan
status: draft
updated: 2026-07-14
description: The note + task surface of the workstation — skitty-notes (Neovim-in-Kitty markdown sticky notes), the question of whether kol-vault can double as the task source or needs a separate repo, git-sync, and markdown-native task tracking.
tags:
  - project/dotfiles
  - domain/tooling
  - pattern/tui
related:
  - "[[INDEX|kol-terminality]]"
  - "[[03-neovim|Neovim]]"
  - "[[09-connected-reach|Connected reach]]"
  - "[[11-ricing-backlog#3. skitty-notes|ricing backlog: skitty-notes]]"
---

# Notes & tasks

The always-visible capture surface — todos, notes, the day's work — markdown-native and git-synced.

## skitty-notes
- **What** — linkarzu's markdown sticky-notes: really his Neovim config launched inside a dedicated **Kitty** window, git-synced with an auto-push script. Vim motions + markdown + pasted images. Simple and nice. [YT](https://www.youtube.com/watch?v=M0B_24d0MWw) · [blog](https://linkarzu.com/posts/neovim/skitty-notes/).
- **Reference** — the closeup + the top-view (menubar + tmux bar + skitty-notes owning the top-right) captured 2026-07-11.
- **Ported v1 (2026-07-12):** `cmd-alt-n` summons/dismisses nvim-in-Kitty on `kol-vault/desk-notes.md` (override `KOL_NOTES_FILE`) — `bin/notes-toggle` + `kitty/kol-notes.conf` (kol-dark, 410×750 @ 0.94 opacity) + an aerospace rule tiling it into **workspace T** (kitty + `kol-notes` title; user call — not floating). Kitty stays notes-only; Ghostty remains the terminal. **Open half:** git-sync/auto-push of the note.
- **Dependency note** — it's **Kitty**-based; we run Ghostty. Kitty was added for this surface (tracked in `brewfile-gui`). See [[04-desk-visual-layer|the desk]].
- He demos an iCloud file but **suggests a GitHub repo** for the notes store.

## The sticky widget (notes + bookmarks + links)

The superset of skitty-notes: a persistent, always-visible widget holding **notes + bookmarks + links**, not notes alone. Built on **Übersicht** (the widget engine under simple-bar — see [[04-desk-visual-layer|the desk]]), so the top bar and this widget share one engine. This is where the [Raycast/Raindrop](https://linkarzu.com/posts/macos/raindrop/) bookmark thread plugs in — bookmarks + links become first-class widget content alongside todos.
- **vs skitty-notes:** skitty-notes is notes-only (Neovim-in-Kitty); this adds the bookmarks + links layer and rides Übersicht instead of a terminal window.
- **Shipped:** `kol-bookmarks.widget` (v1, 2026-07-12 — click-tested 2026-07-14) + **`kol-notes.widget` (v1, 2026-07-14)** — read-only desk display of `desk-notes.md` below the bookmarks panel, 10s refresh; edit via the `cmd-alt-n` sticky. See [[../documentation/09-productivity-desktop/07-ubersicht|Übersicht]] worked examples 2–3.
- **Answered de facto:** a small set of sibling widgets (bookmarks / notes), Übersicht-native — not one sectioned widget, not the Neovim-container route. **Still open:** the raindrop links layer.

## The pipeline answer (design-sync view 05, 2026-07-11)

**Files are the API.** The vault pipes into the desk with no API and no daemon: capture writes markdown (telegram bot → `inbox.md`, clip-drop → `~/_inbox`), Git-Sync carries it, and every surface just *reads the same files* — the skitty widget, `kol-kb`/`kol-dash`, obsidian.nvim in the editor, the dashboard webapp on the iPad, obsidian mobile. Edit in one, it appears in the rest. Drawn live in the desk artifact, view 05 (`claude.ai/code/artifact/67803a9b`).

## The kol-vault question
- **Can the main vault double as the task source, or does it need a separate repo?** kol-vault is markdown + images + Git-Sync already — so mechanically it fits. Open question: mix task-automation state into the main knowledge vault, or keep a dedicated `kol-tasks` repo the skitty-notes/automation write to.
- Ties to [[02-workspaces|the kol-vault workspace]] and to the telegram/obsidian bot in [[09-connected-reach|Connected reach]].

## Markdown-native tasks
- linkarzu's [tasks in neovim](https://linkarzu.com/posts/neovim/neovim-tasks/) — Telescope list of completed/pending markdown tasks. Feeds the "track my work" need ([[08-automation-and-ritual|the ritual]]).

## Open questions
- Vault-as-task-source vs a dedicated `kol-tasks` repo?
- Kitty for skitty-notes, or port to Ghostty/Neovide (no second terminal)?
- One task store, or per-context (studio tasks vs vault tasks vs dotfiles todos)?
