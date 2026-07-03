---
title: fs-reveal.sh
type: reference
status: active
updated: 2026-07-03
description: fs-reveal.sh — open Finder at a path; -f opens a new floating window on the current AeroSpace workspace, bypassing the blanket Finder→W assignment per-window.
tags:
  - project/dotfiles
  - domain/scripts/system
related:
  - "[[08-system|System & clipboard scripts]]"
  - "[[../09-productivity-desktop/05-aerospace|AeroSpace]]"
---

# `fs-reveal.sh`

Open a Finder window at a path. Aliased to `reveal` in `shell/.zshrc`.

| Invocation | Result |
|---|---|
| `reveal` | Finder at the current dir (`$PWD`) |
| `reveal PATH` | Finder at PATH — a directory opens as a window; a file is revealed (selected) in its folder |
| `reveal -f [PATH]` | a **new floating** Finder window on the **current** AeroSpace workspace |

Plain mode is just macOS `open` (`open DIR` / `open -R FILE`). The value is `-f`.

## The problem `-f` solves

`aerospace.toml` sends every Finder window to workspace **W**:

```toml
[[on-window-detected]]
if.app-id = 'com.apple.finder'
run = "move-node-to-workspace W"
```

That rule is blunt — `on-window-detected` matches on window properties (app-id, title, role), **not** how the window was opened. It can't tell a "reveal here" window from any other Finder window, so there's no native per-invocation opt-out.

## How `-f` bypasses it

The rule can't be prevented, so `-f` lets it fire and then **overrides that one window by its `window-id`**:

1. `aerospace list-workspaces --focused` — remember the current workspace.
2. Snapshot the existing Finder `window-id`s.
3. Open a **new** window via AppleScript (`make new Finder window to …`) — `open` alone reuses an existing window; AppleScript guarantees a fresh one.
4. Poll the Finder id set until the new id appears (AeroSpace needs a beat to detect the window and run its rule).
5. `move-node-to-workspace <current> --window-id <new>`, then `layout floating --window-id <new>`.

Targeting by `--window-id` is what makes it safe — it acts on the exact new window regardless of where AeroSpace parked it or what's focused, so nothing else moves.

## Notes
- `-f` needs `aerospace` on PATH; without it, it just opens a plain new window (no move/float).
- `list-windows --all` **cannot** be combined with `--app-bundle-id` (AeroSpace rejects it) — enumerate with `--all --format` and filter the bundle id in-script.
- A file argument in `-f` mode floats its **parent folder** (Finder windows show folders, not files).
