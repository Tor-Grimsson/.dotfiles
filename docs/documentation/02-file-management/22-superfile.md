---
title: superfile
type: reference
status: active
updated: 2026-08-01
description: Modern Go file manager (binary `spf`) with a live-variable panel count, a process bar showing file operations in flight, and a built-in command line.
aliases:
  - superfile
  - spf
tags:
  - domain/files
  - pattern/tui
  - integration/brew-formula
links:
  website: https://superfile.dev/
  repo: https://github.com/yorukot/superfile
  manual: https://superfile.dev/list-of-commands/
  brew: https://formulae.brew.sh/formula/superfile
covers:
  - Opening and closing panels at runtime
  - Process bar for in-flight file operations
  - Built-in shell command line
related:
  - "[[18-vifm|vifm]]"
  - "[[operations/08-research/01-tui-file-managers|TUI file managers survey]]"
---

## Summary

superfile is the newest of the surveyed managers and the only one where **the number of panels is a runtime decision** — `n` opens another, `w` closes it — rather than a layout chosen in config.

## Why installed

Installed 2026-08-01 from the layout-mode survey, for the variable panel count and the process bar. It is also the only one that ships a gruvbox theme.

## Most common use case

Long-running copies: start them, then watch progress in the process bar while continuing to browse.

## Biggest win

**The process bar (`p`)** — live progress for copy/move/delete, several at once. Every other tool in the survey blocks or hides the operation; superfile makes it a first-class panel alongside metadata (`m`) and the sidebar (`s`).

## How to use

Config lives outside `~/.config` — `~/Library/Application Support/superfile/config.toml`. Find it any time with `spf path-list`.

| Key / setting | Does |
| --- | --- |
| `n` · `w` | open another panel · close it |
| `p` · `m` · `s` | focus process bar · metadata · sidebar |
| `:` | built-in command line |
| `/` | search bar |
| `theme = "gruvbox"` | **set 2026-08-01** (was `catppuccin-mocha`); 21 themes ship |
| `shell_close_on_success = false` | keep command output visible after a success |
| `--print-last-dir` | print exit directory — the hook for a cd-on-quit wrapper |

## Future use

`--chooser-file` writes the picked path to a file on open, which is the integration point for driving superfile from a tmux popup rather than as a full-screen app.
