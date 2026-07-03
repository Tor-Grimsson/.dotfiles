---
title: File Management
type: index
status: active
updated: 2026-06-14
description: Tools for browsing, navigating, organizing, archiving, and renaming files on macOS and in the shell — plus the modern CLI core (eza, bat, fd, ripgrep, fzf, zoxide).
tags:
  - domain/files
---

Browsing, navigating, organizing, archiving, and renaming files — across the terminal (CLI and TUI) and the macOS GUI. Also home to the **modern CLI core** that replaces the classic Unix tools: `eza` (ls), `bat` (cat), `fd` (find), `ripgrep` (grep), `fzf` (fuzzy finder), and `zoxide` (cd) — wired together in `shell/.zshrc`.

| Tool | Description |
| --- | --- |
| [tree](01-tree.md) | Recursive directory lister that prints the filesystem hierarchy as an indented tree. |
| [Yazi](02-yazi.md) | Blazing-fast terminal file manager written in Rust with async I/O and image previews. |
| [broot](03-broot.md) | Tree-based terminal navigator that fuzzy-filters directory trees and runs commands on matches. |
| [Marta](04-marta.md) | Extensible two-pane (orthodox) file manager for macOS with full keyboard control. |
| [Keka](06-keka.md) | macOS file archiver that creates and extracts a wide range of compression formats. |
| [NameChanger](07-namechanger.md) | macOS app for batch-renaming lists of files with live preview before applying. |
| [eza](08-eza.md) | Modern `ls` — colors, icons, tree view, git-status column (maintained exa fork). |
| [bat](09-bat.md) | `cat` with syntax highlighting + line numbers; also the fzf file preview. |
| [fd](10-fd.md) | Friendly, fast `find` replacement; respects .gitignore; feeds the fzf file list. |
| [ripgrep](11-ripgrep.md) | Fast recursive in-file search (`rg`); the modern grep. |
| [fzf](12-fzf.md) | Interactive fuzzy finder; powers Ctrl-R / Ctrl-T / Alt-C and Tab completion. |
| [zoxide](13-zoxide.md) | Smarter `cd` — `z` jumps to frecency-ranked visited dirs, `zi` picks via fzf. |
| [dust](14-dust.md) | Modern `du` — biggest-first tree of disk usage with inline bar graphs. |
| [7-Zip (sevenzip)](15-sevenzip.md) | High-ratio archiver (`7zz`); yazi's archive preview/extract backend. |
| [resvg](16-resvg.md) | Fast, correct SVG → PNG rasterizer; yazi's SVG preview backend. |

## Guides
- [Yazi cheatsheet (beginner)](17-yazi-cheatsheet.md) — zero-assumptions, workflow-first guide to using [Yazi](02-yazi.md): navigating, previewing, opening/sending files to apps, copy/move, fuzzy-find, and feeding files to Claude (llm), plus one big everything-table.
