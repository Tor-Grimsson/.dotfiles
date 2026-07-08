---
title: bat
type: reference
status: active
updated: 2026-06-09
description: `cat` with syntax highlighting, line numbers, and a git-change gutter. Also renders the fzf file preview.
aliases:
  - bat
tags:
  - domain/files
  - pattern/cli
  - integration/brew-formula
links:
  website: https://github.com/sharkdp/bat
  repo: https://github.com/sharkdp/bat
  manual: https://github.com/sharkdp/bat#readme
  brew: https://formulae.brew.sh/formula/bat
covers:
  - syntax-highlighted file viewing, line ranges, plain mode
  - the cat alias + BAT_THEME
  - role as the fzf file-preview renderer
related:
  - "[[08-eza|eza]]"
  - "[[12-fzf|fzf]]"
---

## Summary

`cat` with syntax coloring, line numbers, and a git-change gutter, auto-paged for long files. Aliased to `cat` (paging off) in `shell/.zshrc`, themed via `BAT_THEME`, and used as the **file** side of the fzf preview.

## How to use

```sh
bat file.py              # colored, line numbers, paged (q to quit)
bat -n script.sh         # line numbers only — no header/grid
bat -r 10:20 file.js     # only lines 10–20
bat -p notes.md          # plain: no decorations (good for piping)
bat --diff file.py       # show git changes inline
bat --list-themes        # browse themes; set with BAT_THEME
```

In `shell/.zshrc`: `export BAT_THEME="ansi"` and `alias cat='bat --paging=never'`.

| Flag | Does |
|---|---|
| `-n` | line numbers only |
| `-p` / `--plain` | no decorations (pipe-friendly) |
| `-r A:B` | line range |
| `--style` | pick components (numbers, grid, header…) |
| `--diff` | git-change view |
| `-l <lang>` | force a language for highlighting |
| `$BAT_THEME` | color theme |

## Why installed

Reading config/code in the terminal with no color or line numbers is painful. bat fixes that and doubles as the fzf preview pane — hover a file in any picker and see it highlighted. See [[12-fzf|fzf]].

## Biggest win

The fzf preview came essentially free: one `--preview 'bat …'` and every file picker shows syntax-highlighted contents.

## Future use

`MANPAGER` pointed at bat for colored man pages (currently the oh-my-zsh `colored-man-pages` plugin handles that); a `help()` wrapper to colorize `--help` output.
