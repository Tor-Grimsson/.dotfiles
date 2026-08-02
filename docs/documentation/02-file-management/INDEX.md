---
title: File Management
type: index
status: active
updated: 2026-07-09
description: Tools for browsing, navigating, organizing, archiving, and renaming files on macOS and in the shell — plus the modern CLI core (eza, bat, fd, ripgrep, fzf, zoxide).
tags:
  - domain/files
---

Browsing, navigating, organizing, archiving, and renaming files — across the terminal (CLI and TUI) and the macOS GUI. Also home to the **modern CLI core** that replaces the classic Unix tools: `eza` (ls), `bat` (cat), `fd` (find), `ripgrep` (grep), `fzf` (fuzzy finder), and `zoxide` (cd) — wired together in `shell/.zshrc`.

| Tool | Description |
| --- | --- |
| [[01-tree|tree]] | Recursive directory lister that prints the filesystem hierarchy as an indented tree. |
| [[02-yazi|Yazi]] | Blazing-fast terminal file manager written in Rust with async I/O and image previews. |
| [[03-broot|broot]] | Tree-based terminal navigator that fuzzy-filters directory trees and runs commands on matches. |
| [[04-marta|Marta]] | Extensible two-pane (orthodox) file manager for macOS with full keyboard control. |
| [[06-keka|Keka]] | macOS file archiver that creates and extracts a wide range of compression formats. |
| [[07-namechanger|NameChanger]] | macOS app for batch-renaming lists of files with live preview before applying. |
| [[08-eza|eza]] | Modern `ls` — colors, icons, tree view, git-status column (maintained exa fork). |
| [[09-bat|bat]] | `cat` with syntax highlighting + line numbers; also the fzf file preview. |
| [[10-fd|fd]] | Friendly, fast `find` replacement; respects .gitignore; feeds the fzf file list. |
| [[11-ripgrep|ripgrep]] | Fast recursive in-file search (`rg`); the modern grep. |
| [[12-fzf|fzf]] | Interactive fuzzy finder; powers Ctrl-R history, Ctrl-T / Alt-C and Tab completion (atuin's search on Ctrl-P). |
| [[13-zoxide|zoxide]] | Smarter `cd` — `z` jumps to frecency-ranked visited dirs, `zi` picks via fzf. |
| [[14-dust|dust]] | Modern `du` — biggest-first tree of disk usage with inline bar graphs. |
| [[15-sevenzip|7-Zip (sevenzip)]] | High-ratio archiver (`7zz`); yazi's archive preview/extract backend. |
| [[16-resvg|resvg]] | Fast, correct SVG → PNG rasterizer; yazi's SVG preview backend. |

## On trial — the layout-mode survey (2026-08-01)

Seven managers installed together to answer *"can a file manager have a layout other than three columns"*. The comparison and the verdict live in [[operations/08-research/01-tui-file-managers|the survey]]; these are their reference docs. [[02-yazi|yazi]] remains the daily driver.

| Tool | Description |
|------|-------------|
| [[18-vifm|vifm]] | Dual-pane manager whose config language is a vim dialect; `:rename` edits filenames as text. **The pick of the seven.** |
| [[19-midnight-commander|midnight-commander]] | The classic two-panel commander (`mc`); `Alt+,` flips the split orientation. |
| [[20-xplr|xplr]] | Layouts and keymaps are Lua code; the selection list survives changing directory. |
| [[21-ranger|ranger]] | The original miller-column manager; `multipane` shows tabs side by side. |
| [[22-superfile|superfile]] | `spf` — panel count varies at runtime, with a live process bar for file operations. |
| [[23-lf|lf]] | Single Go binary, no runtime; the fastest cold start. |
| [[24-nnn|nnn]] | ~35KB C binary configured purely by environment variables; four contexts. |

## Guides
- [[17-yazi-cheatsheet|Yazi cheatsheet (beginner)]] — zero-assumptions, workflow-first guide to using [[02-yazi|Yazi]]: navigating, previewing, opening/sending files to apps, copy/move, fuzzy-find, and feeding files to Claude (llm), plus one big everything-table.
