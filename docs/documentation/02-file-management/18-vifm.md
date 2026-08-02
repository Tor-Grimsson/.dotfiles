---
title: vifm
type: reference
status: active
updated: 2026-08-01
description: Dual-pane terminal file manager whose entire config language is a vim dialect — ex-commands, :map, registers, marks, and bulk rename by editing the filenames as text.
aliases:
  - vifm
tags:
  - domain/files
  - pattern/tui
  - integration/brew-formula
links:
  website: https://vifm.info/
  repo: https://github.com/vifm/vifm
  manual: https://vifm.info/manual.shtml
  brew: https://formulae.brew.sh/formula/vifm
covers:
  - Dual-pane navigation with vim window chords
  - Tree view with bounded depth
  - Bulk rename by editing filenames in $EDITOR
related:
  - "[[02-yazi|yazi]]"
  - "[[19-midnight-commander|mc]]"
  - "[[operations/08-research/01-tui-file-managers|TUI file managers survey]]"
---

## Summary

vifm is a two-pane file manager where **the config language is vim's**. `vifmrc` takes `:map`, `:command`, `:highlight` and `:filetype` lines; the running program takes `:` ex-commands with completion, registers, marks and macros. If you know nvim, you already know how to configure and drive it.

## Why installed

Installed 2026-08-01 out of the layout-mode survey ([[operations/08-research/01-tui-file-managers|survey]]). It was the only candidate offering every layout the question asked for — single pane, vertical and horizontal splits, ls-style grid, and tree — without leaving vi keys.

## Most common use case

Bulk-renaming a directory: select the files, `:rename`, edit the names as plain text in nvim, `:w`. The same trick oil.nvim does inside the editor.

## Biggest win

**`:rename` on a selection** and **`:filter` with a regex**. The first turns renaming into text editing; the second hides everything not matching and stays hidden until cleared — a persistent view filter, not a search jump.

## How to use

Config is repo-tracked at `vifm/vifmrc` (live via `~/.config/vifm` → `~/.dotfiles/vifm`). Colours come from `vifm/colors/kol.vifm`, which uses **ANSI 0-15 only** so [[09-productivity-desktop/08-kol-theme|kol-theme]] retints it with nothing to edit.

```sh
vifm                  # opens with ONE pane — `only` is set in vifmrc; stock vifm opens two
```

| Command | Does |
| --- | --- |
| `:vsplit` / `:split` | second pane, side by side / stacked |
| `Ctrl+W x` · `Tab` | exchange panes · flip focus |
| `:only` | back to one pane |
| `:t2` / `:t1` | tree view, depth 2 / depth 1 — repo-defined commands |
| `:tree` | **unbounded** tree — walks the whole subtree eagerly |
| `gh` | leave tree view from any level |
| `:rename` | edit selected filenames in `$EDITOR` |
| `:filter <re>` | persistent view filter |
| `set lsview` | ls-style grid |

> **`:tree` has no lazy expansion.** The depth argument is the only brake — the man page states it *"specifies nesting level on which loading of subdirectories won't happen"*. Run it in `$HOME` without a depth and it stats the entire tree, `.git` included (`set dotfiles` is on). Use `:t2`.

## Future use

`:filetype` handlers per extension, and a `--choose-dir` wrapper function so vifm can `cd` the shell on quit the way `y` (yazi) and `b` (broot) already do.
