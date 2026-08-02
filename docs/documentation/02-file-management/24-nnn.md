---
title: nnn
type: reference
status: active
updated: 2026-08-01
description: The smallest terminal file manager — a ~35KB C binary with near-zero memory use, configured entirely through environment variables.
aliases:
  - nnn
tags:
  - domain/files
  - pattern/tui
  - integration/brew-formula
links:
  website: https://github.com/jarun/nnn
  repo: https://github.com/jarun/nnn
  manual: https://github.com/jarun/nnn/wiki
  brew: https://formulae.brew.sh/formula/nnn
covers:
  - Environment-variable configuration
  - Context (workspace) switching
  - Plugin system driven by shell scripts
related:
  - "[[23-lf|lf]]"
  - "[[02-yazi|yazi]]"
---

## Summary

nnn is the minimal end of the field: a tiny C binary with **no config file at all** — every setting is an environment variable. It has four "contexts" (workspaces) rather than tabs, switched with `1`-`4`.

## Why installed

Installed 2026-08-01 from the layout-mode survey. Like [[23-lf|lf]] it offers no layout modes, and was kept for the opposite extreme: the lowest-resource option that still browses comfortably.

## Most common use case

A file browser on a constrained or remote box where even lf feels heavy.

## Biggest win

**Contexts.** Four independent working directories on number keys, each remembering its own position — the same idea as tabs but with no visual cost, because the context indicator is four characters in the status line.

## How to use

Configured entirely by environment, set in `shell/.zshrc`:

```sh
export NNN_COLORS='2136'    # context 1-4 colours: green · blue · yellow · cyan
```

The digits are ANSI colour indices, so [[09-productivity-desktop/08-kol-theme|kol-theme]] retints the contexts with nothing to edit here.

| Key / var | Does |
| --- | --- |
| `1` `2` `3` `4` | switch context |
| `Space` | select · `a` select all |
| `NNN_COLORS` | per-context colour, one ANSI digit each |
| `NNN_FCOLORS` | file-type colours (not set) |
| `NNN_PLUG` | plugin key bindings (not set) |

Mouse works with no flag.

## Future use

`NNN_PLUG` maps single keys to shell scripts — the same integration surface as lf's `cmd`, if nnn earns a permanent slot.
