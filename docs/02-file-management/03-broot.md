---
title: broot
type: reference
status: active
updated: 2026-06-10
description: Tree-based terminal navigator that fuzzy-filters directory trees and runs commands on matches.
aliases:
  - broot
  - br
tags:
  - domain/files
  - pattern/tui
  - integration/brew-formula
links:
  website: https://dystroy.org/broot/
  repo: https://github.com/Canop/broot
  manual: https://dystroy.org/broot/
  brew: https://formulae.brew.sh/formula/broot
covers:
  - Fuzzy-filtered, collapsible directory-tree navigation
  - Disk-usage sizing and sorting inside the tree
  - Running commands on matched paths and cd-on-quit
related:
  - "[[02-yazi|yazi]]"
  - "[[01-tree|tree]]"
  - "[[13-zoxide|zoxide]]"
---

## Summary

broot shows a directory tree that stays readable no matter how deep it is by collapsing branches and surfacing only what matches your live fuzzy search. As you type, the tree filters down to matching paths; you then act on a match — open it, `cd` into it, or pipe it to any shell command. It can also annotate the tree with file sizes for at-a-glance disk usage.

## Why installed

It fills the gap between `tree` (static dump) and `yazi` (full file manager): a navigator for finding a path in a large hierarchy by typing a few characters, then jumping the shell there. The `br` wrapper makes it a powerful interactive `cd` for deep project trees.

## Most common use case

Fuzzy-searching a deep directory tree for a file or folder and `cd`-ing the shell into the result on quit.

## Biggest win

It keeps the whole tree comprehensible while you search — branches collapse so the matches always fit on screen — and then lets you run a command (`cd`, edit, rm) on the selected path. The built-in size mode turns it into a quick disk-usage explorer too.

## How to use

Install the `br` shell function once so broot can change the parent shell's directory:

```sh
broot --install
```

Then:

```sh
# Launch broot in the current directory
br

# Start in a specific path
br ~/Projects

# Show sizes (disk usage), sorted
br -s

# Show hidden and gitignored files
br -h -g
```

Inside broot: type to fuzzy-filter, arrows to move, `Enter` to focus a directory or open a file, `Alt+Enter` to `cd` there and quit, `:` to invoke a verb (e.g. `:rm`, `:mv`, `:cp`), `?` for help.

## Future use

broot's custom verbs (defined in its config) are unexplored — binding project-specific actions (open in editor, run a build, send to a script) to keystrokes would make it a command launcher keyed off whatever path you've filtered to, not just a navigator.
