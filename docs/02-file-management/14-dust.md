---
title: dust
type: reference
status: active
updated: 2026-06-10
description: Modern `du` — a depth-limited tree of what's eating disk, biggest-first, with inline bar graphs. `dust` on its own profiles the current dir.
aliases:
  - dust
  - du-dust
tags:
  - domain/files
  - pattern/cli
  - integration/brew-formula
links:
  website: https://github.com/bootandy/dust
  repo: https://github.com/bootandy/dust
  manual: https://github.com/bootandy/dust#usage
  brew: https://formulae.brew.sh/formula/dust
covers:
  - dust tree output and reading the bars
  - depth / count / reverse / exclude flags
  - how it differs from du and from the dedup tools
related:
  - "[[01-tree|tree]]"
---

## Summary
`dust` answers "what's eating my disk?" in one command: it walks a directory, ranks subdirs and files by size, and prints a **biggest-first tree with inline bar graphs**. No flags needed — `dust` on its own profiles the current dir.

The win over `du`: the output is already sorted, depth-limited, and human-readable — no `du -h | sort -rh | head` pipe to assemble in your head.

## Use

```sh
dust                 # profile the current dir, biggest-first
dust ~/Downloads     # profile a specific dir
dust -d 2            # limit the tree to 2 levels deep
dust -n 30           # show 30 entries
dust -r              # reverse — smallest first
dust -X .git         # exclude a path/glob
dust -s              # apparent size (what files claim) vs on-disk blocks
dust -p              # full paths instead of the indented tree
```

## Flags

| Flag | Does |
|---|---|
| `-d <n>` | max depth |
| `-n <n>` | number of entries to show |
| `-r` | reverse order (smallest first) |
| `-X <glob>` | exclude matching paths |
| `-s` | apparent size instead of disk usage |
| `-p` | full paths instead of tree indent |
| `-c` | no color |

## Why installed
The modern-CLI core had replacements for `ls`/`cat`/`find`/`grep`/`cd` ([eza](08-eza.md)/[bat](09-bat.md)/[fd](10-fd.md)/[ripgrep](11-ripgrep.md)/[zoxide](13-zoxide.md)) but nothing for `du`. `dust` fills the last common gap — finding the heavy directory before a cleanup.

## Biggest win
`dust ~/Library` or `dust ~/Downloads` names the offender instantly, ranked and graphed, with zero pipeline ceremony.

## Future use
Front-end for the dedup pass: `dust` finds *where* the weight is, then the [Dedup & Cleanup](../03-dedup-cleanup/INDEX.md) tools (rmlint/czkawka) remove the *duplicates* within it.
