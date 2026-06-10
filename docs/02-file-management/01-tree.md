---
title: tree
type: reference
status: active
updated: 2026-06-04
description: Recursive directory lister that prints the filesystem hierarchy as an indented tree.
aliases:
  - tree
tags:
  - domain/files
  - pattern/cli
  - integration/brew-formula
links:
  website: https://oldmanprogrammer.net/source.php?dir=projects/tree
  manual: https://oldmanprogrammer.net/source.php?dir=projects/tree
  brew: https://formulae.brew.sh/formula/tree
covers:
  - Printing a directory hierarchy as an indented tree
  - Depth limiting, pattern filtering, and hidden-file display
  - Machine-readable output (JSON / HTML)
related:
  - "[[02-yazi|yazi]]"
  - "[[03-broot|broot]]"
  - "[[14-dust|dust]]"
---

## Summary

`tree` is a tiny command-line utility that walks a directory and prints its contents as an indented, branch-drawn tree. It is the fastest way to get a visual sense of how a folder is laid out without opening a file manager. Output can be colorized, depth-limited, filtered by glob, or emitted as HTML or JSON.

## Why installed

Every time you need to show or document a project's layout — in a README, a chat message, or just to orient yourself — `tree` does it in one command. It is the lowest-friction "what's in here?" tool in the shell, with no TUI to enter or exit.

## Most common use case

Getting a quick, depth-limited overview of a project directory while ignoring noise like `node_modules` or `.git`.

## Biggest win

One non-interactive command produces a clean, copy-pasteable structure diagram. Unlike a file manager you do not navigate anything — you get the whole shape at once, and the output drops straight into documentation.

## How to use

```sh
# Whole tree from the current directory
tree

# Limit depth to 2 levels
tree -L 2

# Show hidden files, with directory sizes, human-readable
tree -a -h

# Directories only
tree -d

# Skip noisy folders
tree -I 'node_modules|.git|dist'

# Only files matching a pattern
tree -P '*.ts'

# Machine-readable output
tree -J            # JSON
tree -H . -o out.html   # HTML for a static page
```

## Future use

The `-J` JSON output is unexplored here — it makes `tree` a cheap structure scanner for scripts that need to reason about a directory layout, feeding `jq` pipelines or generating documentation snippets automatically rather than just printing for human eyes.
