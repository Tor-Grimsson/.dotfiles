---
title: Folder-batch scripts
type: reference
status: active
updated: 2026-06-04
description: batch-* — bulk folder-create + move operations.
tags:
  - project/dotfiles
  - domain/scripts/batch
---

# Folder batch (`batch-`)

| Script | Does | Usage |
|--------|------|-------|
| `batch-create-folder-move-file.sh` | For each file, create a folder (named from the file) and move the file into it | `batch-create-folder-move-file.sh` (folder cwd) |
| `batch-create-folder-move-folder.sh` | Same idea, operating on folders | `batch-create-folder-move-folder.sh` (folder cwd) |

> Tiny one-liners; open the script before running in an unfamiliar directory — they move everything in cwd.
