---
title: Yazi
type: reference
status: active
updated: 2026-06-04
description: Blazing-fast terminal file manager written in Rust with async I/O and image previews.
aliases:
  - yazi
tags:
  - domain/files
  - pattern/tui
  - integration/brew-formula
links:
  website: https://github.com/sxyazi/yazi
  repo: https://github.com/sxyazi/yazi
  manual: https://yazi-rs.github.io/
  brew: https://formulae.brew.sh/formula/yazi
covers:
  - Full-screen terminal file navigation with previews
  - Bulk rename, selection, and shell integration
  - Changing the shell's directory on quit (cd-on-exit)
related:
  - "[[03-broot|broot]]"
  - "[[01-tree|tree]]"
---

## Summary

Yazi is a full-screen terminal file manager built in Rust on top of async I/O, so directory listings and previews load without blocking. It shows a Miller-column layout (parent, current, preview) and previews text, images, video frames, archives, and more inline. Navigation is Vim-style and bulk operations like rename and selection are first-class.

## Why installed

It is the interactive file manager for day-to-day work in the terminal — browsing, previewing, moving, and bulk-renaming files without leaving the shell or reaching for the GUI. The async core keeps it instant even on large or network directories where other TUI managers stall.

## Most common use case

Browsing into an unfamiliar directory tree, previewing files (including images and archives) inline, then dropping the shell into the chosen directory on quit.

## Biggest win

Async previews with no blocking, plus the cd-on-quit integration: you navigate visually and the shell follows you, so Yazi doubles as a fast interactive `cd`. The inline image and archive previews remove most reasons to leave the terminal.

## How to use

```sh
# Launch in the current directory
yazi

# Launch pointed at a path
yazi ~/Projects
```

Wrap it so quitting changes the shell's directory (add to your shell rc):

```sh
function yy() {
	local tmp="$(mktemp -t yazi-cwd.XXXXXX)" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
```

Inside Yazi: `hjkl` to navigate, `Space` to select, `y`/`x`/`p` to copy/cut/paste, `d` to trash, `a` to create, `r` to rename, `:` for commands, `q` to quit.

## Future use

Yazi's plugin system (Lua) and custom keymaps are untapped here — adding previewers for project-specific file types, custom openers, and a flavor/theme to match the terminal would turn it into a tailored cockpit rather than a stock browser.
