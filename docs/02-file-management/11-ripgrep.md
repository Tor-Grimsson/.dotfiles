---
title: ripgrep
type: reference
status: active
updated: 2026-06-09
description: Fast recursive content search (`rg`) — greps inside files, respects .gitignore, skips binaries. The grep you actually want.
aliases:
  - ripgrep
  - rg
tags:
  - domain/files
  - pattern/cli
  - integration/brew-formula
links:
  website: https://github.com/BurntSushi/ripgrep
  repo: https://github.com/BurntSushi/ripgrep
  manual: https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md
  brew: https://formulae.brew.sh/formula/ripgrep
covers:
  - recursive in-file text search, type filters, context lines
  - gitignore + binary skipping
  - pairing with fzf for live grep
related:
  - "[[10-fd|fd]]"
  - "[[12-fzf|fzf]]"
---

## Summary

Searches *inside* files for text — the modern `grep`. Recursive by default, extremely fast, and it skips `.gitignore`d and binary files automatically. The command is **`rg`**.

## How to use

```sh
rg TODO                  # find "TODO" in every file under here
rg -i error              # case-insensitive
rg -t py "def main"      # only Python files
rg -l keyword            # list matching filenames only
rg -C2 panic             # 2 lines of context around each match
rg --hidden -uu secret   # include hidden + ignored + binary files
```

| Flag | Does |
|---|---|
| `-i` | case-insensitive |
| `-t LANG` | restrict to a file type (`-t py`, `-t md`) |
| `-l` | filenames only |
| `-C N` | N lines of context |
| `-w` | whole-word match |
| `--hidden` / `-u` / `-uu` | include hidden / ignored / binary |
| `-r` | replace (with capture groups) |

## Why installed

Searching code or notes for a string with BSD `grep -r` is slow and noisy. `rg` is faster and ignores junk by default. It also pairs with fzf for "search-as-you-type across files" (the `rg … | fzf` live-grep). See [fzf](12-fzf.md).

## Biggest win

gitignore + binary skipping by default: `rg foo` over a large repo returns only real hits, fast — no `--exclude-dir` incantations.

## Future use

A saved live-grep function (`rg --line-number . | fzf --ansi`); `rg -r` for project-wide find-and-replace.
