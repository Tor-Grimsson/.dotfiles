---
title: Neovim — the load-bearing editor
type: plan
status: draft
updated: 2026-07-11
description: Making Neovim a load-bearing tool of the workstation — building on Sin-cy's and linkarzu's configs, Neovide as a GUI option, image paste in nvim, the claude-input↔nvim bind, popups, and markdown workflows.
tags:
  - project/dotfiles
  - domain/neovim
related:
  - "[[INDEX|kol-terminality]]"
  - "[[12-nvim-from-scratch|nvim from scratch]]"
  - "[[06-notes-and-tasks|Notes & tasks]]"
  - "[[kol-cli/02-nvim-workflows|Neovim workflows]]"
---

# Neovim (load-bearing)

Pull Neovim to the center of the workstation — the editor, the note surface, the task surface, the markdown engine. The config study is already tracked; this is where the *workstation role* is designed.

## Configs to build from
- **Sin-cy nvim** — [github](https://github.com/Sin-cy/dotfiles/tree/main/nvim/.config/nvim) · [YT walkthrough](https://youtu.be/FGVY7gbaoQI) (also at [t=2029s](https://www.youtube.com/watch?v=FGVY7gbaoQI&t=2029s)). Near-identical stack to ours; being built from scratch — tracked in [[12-nvim-from-scratch|nvim from scratch]].
- **linkarzu nvim (`neobean`)** — inside [dotfiles-latest](https://github.com/linkarzu/dotfiles-latest); the markdown/notes/tasks-heavy variant.

## Chunks
- **Neovide** — [neovide.dev](https://neovide.dev/) — a GUI Neovim ("wow"). Evaluate as a workspace surface vs terminal nvim.
- **Image paste in nvim** — [linkarzu: images in neovim](https://linkarzu.com/posts/neovim/images-neovim/). Ties to the existing `bin/clip-drop.sh` + `~/_inbox` capture flow (live, on tmux `prefix C-p`) and Karabiner shortcuts.
- **claude-input ↔ nvim bind** — the missing keybind: send the Claude Code input line to nvim for real editing, then back. Known to be possible; find/build it. (This is the "I want a proper editor for this" fix.)
- **Popups & custom nvim** — linkarzu leans heavily on popups + customized nvim; the "work layers" are nvim + tmux popups. See [[05-tmux-and-layout|tmux & layout]].
- **Markdown workflows** — linkarzu's [markdown setup 2025](https://linkarzu.com/posts/neovim/markdown-setup-2025/), [obsidian→neovim](https://linkarzu.com/posts/neovim/obsidian-to-neovim/), [tasks in neovim](https://linkarzu.com/posts/neovim/neovim-tasks/). Feeds [[06-notes-and-tasks|Notes & tasks]].

## In flight (2026-07-11)

- **Video → interactive overview:** transcribing the [Sin-cy walkthrough](https://youtu.be/FGVY7gbaoQI) via `au-transcribe.sh`, then an artifact matching his sections — chapters + TOC, what each section *adds*, and nvim's **dependency logic** (A+B must green-light before C: plugin manager → deps → LSP → completion, etc.). Purpose: view it whole to isolate what's good for us *now* vs later. Tracker: [[12-nvim-from-scratch|nvim from scratch]].
- The desk artifact's **view 03** mocks the target: buffer tabs, oil, markdown, lazygit float.

## Open questions
- How far to go with nvim-as-everything vs keeping Obsidian for the vault?
- Neovide as a separate GUI surface, or stay all-terminal?
- Adopt a config wholesale (fork Sin-cy) or keep building ours from scratch?
