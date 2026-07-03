---
title: eza
type: reference
status: active
updated: 2026-06-09
description: Modern `ls` replacement — colors, icons, a tree view, and a git-status column. Maintained fork of the abandoned exa.
aliases:
  - eza
tags:
  - domain/files
  - pattern/cli
  - integration/brew-formula
links:
  website: https://eza.rocks/
  repo: https://github.com/eza-community/eza
  manual: https://github.com/eza-community/eza/blob/main/README.md
  brew: https://formulae.brew.sh/formula/eza
covers:
  - long view with sizes/dates and a git-status column
  - tree mode, sort keys, column trimming
  - the ls/ll/la/lt aliases + icons (Nerd Font)
related:
  - "[[01-tree|tree]]"
  - "[[09-bat|bat]]"
  - "[[12-fzf|fzf]]"
---

## Summary

A drop-in `ls` upgrade: colors, file-type icons, a `--tree` mode, and a per-file **git-status column**. The maintained fork of the now-dead `exa`. Aliased to everyday `ls`/`ll`/`la`/`lt` in `shell/.zshrc`, and used as the directory-preview renderer in the fzf setup.

## How to use

```sh
eza                      # current dir — colored + icons
eza -l                   # long: perms, size, owner, date
eza -lah --git           # long, all (hidden), human sizes, git-status column
eza --tree --level=2     # 2-level tree
eza -l -s modified -r    # long, sorted by mtime, newest last
eza -l --no-permissions --no-user   # trim columns you don't care about
```

The aliases (in `shell/.zshrc`): `ls`/`ll`/`la`/`lt` → eza. Icons need a Nerd Font — already installed.

| Flag | Does |
|---|---|
| `-l` | long view |
| `-a` | include dotfiles |
| `-h` | human-readable sizes |
| `-T` / `--tree` (`-L N`) | tree, depth N |
| `--git` | git-status column |
| `--icons` | file-type icons (Nerd Font) |
| `-s name\|size\|modified` | sort key (`-r` reverses) |
| `--group-directories-first` | folders on top |

## Why installed

macOS ships BSD `ls` — no git column, weak color, no tree. eza covers all three and is the daily file-lister. It also renders the **directory** side of the fzf preview (a file → bat, a folder → eza tree). See [fzf](12-fzf.md).

## Biggest win

`ll` (`eza -lah --git --icons`) shows size, date, hidden files, **and** git status in one glance — exactly what `ls -la` can't do.

## Future use

`eza --total-size` for real recursive directory sizes; `--hyperlink` for clickable paths in terminals that support it.
