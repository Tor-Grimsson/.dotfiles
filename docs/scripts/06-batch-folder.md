---
title: Folder-batch scripts
type: reference
status: active
updated: 2026-06-05
description: batch-* — bulk folder-create + move operations.
aliases:
  - batch-folder
tags:
  - project/dotfiles
  - domain/scripts/batch
---

# Folder batch (`batch-`)

| Script | Does | Usage |
|--------|------|-------|
| `batch-create-folder-move-file.sh` | For each `*.*` entry in cwd, create a folder (named from the basename) and move the entry in — **no type guard** | `batch-create-folder-move-file.sh` (folder cwd) |
| `batch-create-folder-move-folder.sh` | Same, but a `[ -f ]` guard limits it to **regular files** and skips dot-named folders | `batch-create-folder-move-folder.sh` (folder cwd) |

> Tiny one-liners; open the script before running in an unfamiliar directory — they move everything matching `*.*` in cwd.

## The one real difference

Both loop `for f in *.*` in the current directory only (not recursive), and `*.*` matches every name containing a dot — files, symlinks, **and dot-named directories**. The single difference is a guard:

- `batch-create-folder-move-file.sh` — **no guard**. Folderizes everything `*.*` matched, so a dot-named directory like `data.bak/` gets nested into a new `data/` folder.
- `batch-create-folder-move-folder.sh` — **`[ -f "$f" ]` guard**. Processes only regular files (the test follows symlinks), so dot-named directories are left untouched.

The `-folder` name is a misnomer: it does not operate *on* folders — its guard *excludes* them. Use it as the safe variant when the directory may hold dot-named subfolders you do not want moved.

## How the folderizing works

- `${f%.*}` strips the shortest trailing `.ext` to get the basename: `song.mp3` → `song`, `my.archive.tar` → `my.archive` (only the last dot splits).
- `mkdir -p "${f%.*}" && mv "$f" "${f%.*}/"` creates that folder (idempotent) and moves the entry in; `&&` aborts the move if `mkdir` fails.
- Leading-dot dotfiles (e.g. `.gitignore`) are not matched by `*.*` under default globbing, so they are never touched.

## Help & safety

- Both gained a `#!/bin/bash` shebang, a `usage()` block, and `-h`/`--help` handling; help fires only on those flags and never disturbs the bare cwd-glob run.
- Both are **destructive** (they move files); `cd` into the target directory before running.

## Sandbox example

Given `a.txt b.jpg data.bak/` in the cwd:

| | `-file` (no guard) | `-folder` (`[ -f ]` guard) |
|--|--|--|
| `a.txt` | → `a/a.txt` | → `a/a.txt` |
| `b.jpg` | → `b/b.jpg` | → `b/b.jpg` |
| `data.bak/` | → nested into new `data/data.bak/` | **left in place, untouched** |
