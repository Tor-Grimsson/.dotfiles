---
title: References & backlog — the source pile
type: reference
status: active
updated: 2026-07-11
description: Every source, video, repo, tool, and open question feeding kol-terminality, in one place — the linkarzu and Sin-cy rigs, the per-topic links, the au-transcript option for going deeper, and cross-links to the existing ricing backlog + nvim-from-scratch study.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|kol-terminality]]"
  - "[[11-ricing-backlog|ricing 2025 backlog]]"
  - "[[12-nvim-from-scratch|nvim from scratch]]"
---

# References & backlog

The source pile — nothing here is filtered. The to-evaluate *tool* backlog + open questions already live in [[11-ricing-backlog|the ricing backlog]]; this collects what's specific to the kol-terminality brain-dump and points back to it.

## Primary rigs
| Rig | Links | Interest |
|---|---|---|
| **linkarzu / dotfiles-latest** | [repo](https://github.com/linkarzu/dotfiles-latest) · [video](https://www.youtube.com/watch?v=8pqFtkQip4I&t=72s) · [blog](https://linkarzu.com/) | the main visual + workflow model — bars, skitty-notes, btop, tasks |
| **Sin-cy / dotfiles** ★621 | [repo](https://github.com/Sin-cy/dotfiles) · [nvim](https://github.com/Sin-cy/dotfiles/tree/main/nvim/.config/nvim) · [video](https://youtu.be/FGVY7gbaoQI) | near-identical stack; the nvim config + GNU Stow + GLSL shaders |

## Per-topic links
- **Neovide** — [neovide.dev](https://neovide.dev/)
- **Übersicht** — [repo](https://github.com/felixhageloh/uebersicht) (parent of simple-bar)
- **simple-bar** — [repo](https://github.com/Jean-Tinland/simple-bar) · build [YT](https://www.youtube.com/watch?v=hybbQI6CRek) · [blog](https://linkarzu.com/posts/macos/ubersitch-simple-bar/)
- **hide menubar** — [linkarzu §hide-macos-menubar](https://linkarzu.com/posts/2024-macos-workflow/sketchybar-macos/#hide-macos-menubar)
- **skitty-notes** — [YT](https://www.youtube.com/watch?v=M0B_24d0MWw) · [blog](https://linkarzu.com/posts/neovim/skitty-notes/)
- **btop** — [repo](https://github.com/aristocratos/btop)
- **Kitty** — [cask](https://formulae.brew.sh/cask/kitty) (+ plugins to explore)
- **images in neovim** — [linkarzu](https://linkarzu.com/posts/neovim/images-neovim/)
- **Raycast / Raindrop** — [linkarzu](https://linkarzu.com/posts/macos/raindrop/)
- **markdown/tasks in nvim** — [markdown 2025](https://linkarzu.com/posts/neovim/markdown-setup-2025/) · [obsidian→nvim](https://linkarzu.com/posts/neovim/obsidian-to-neovim/) · [tasks](https://linkarzu.com/posts/neovim/neovim-tasks/)

## Going deeper — the au-transcript option
The video sources can be turned into searchable markdown transcripts with `bin/au-transcribe.sh` (yt-dlp → whisper). **Ready to run on request** — a way to pull exact steps/config out of a linkarzu/Sin-cy video into a doc when a specific chunk gets built. Not run yet.

## Existing docs this builds on
- [[11-ricing-backlog|ricing 2025 backlog]] — the to-evaluate tool list + the 8 open questions (bar decision, theme selector, btop, menubar-hide, osascript depth, layout borrow, tmux plugins, Sin-cy diff).
- [[12-nvim-from-scratch|nvim from scratch]] — the Sin-cy nvim build tracker.

## Loose flags captured
- **`~/_inbox` image pipeline** — already live: `bin/clip-drop.sh` on tmux `prefix C-p` (pngpaste → yazi). Needs a catalog doc; feeds [[03-neovim|nvim image paste]].
