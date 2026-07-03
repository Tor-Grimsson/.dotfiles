# Session: AeroSpace one-key grid layouts (2×2 + main-stack)

**Date:** 2026-07-03
**Agent:** Grim (Claude Sonnet 5, `~/.dotfiles`)
**Summary:** Added two `aerospace.toml` bindings that collapse the manual "join a, join b, flip direction" dance into a single keypress — `Cmd+Alt+G` = 2×2 grid, `Cmd+Alt+S` = main+stack — built and verified empirically against a real 4-window workspace, then documented.

## Changes Made

### Files Modified
- `aerospace/aerospace.toml` — two new `[mode.main.binding]` entries (command-list form). Each: `flatten-workspace-tree` → `layout tiles horizontal` → relative focus (`--boundaries workspace --boundaries-action stop`, so focus can't wander to another workspace) → `join-with` + `layout tiles vertical` (2×2: two 2-window columns) / + a `move left` to append the third window (main+stack: 1 big left, 3 stacked right).
- `docs/09-productivity-desktop/05-aerospace.md` — grid rows in the layout-keys table + a "Grid macros" note (no native grid; it's a binary tree). `updated:` → 2026-07-03.
- `docs/00-kol-cli/01-cli-cheatsheet.md` — a row in the AeroSpace keymap; also **converted the Resize-mode line from inline prose to a table** (matches the Service-mode block; it was the last non-table mode in §5). `updated:` → 2026-07-03.

### Verified, no change
- The AeroSpace-vs-yazi mixup: user asked where the "AeroSpace sections from `02-workflows`" went. Checked the user's iCloud copy of the old `02-workflows.md` (updated 2026-06-26) — it held **only** Neovim + yazi sections, **no AeroSpace**. The content in question was the **yazi** sequences, and they're already present in the cheatsheet's `### Sequences` block under `^sec-yazi` (moved there by the prior 2026-07-03 (2) session). Nothing to migrate.

### Key choice
`Cmd+Alt+G` / `Cmd+Alt+S` — every `Alt+<letter>` and `Alt+Shift+<letter>` is already a workspace switch / move-to-workspace, so the main-mode letter space is full; `cmd-alt-*` was the free single-chord lane. If either clashes with an app shortcut, swap.

## Method (how the sequences were found)
- AeroSpace has **no grid primitive** (i3-style binary tree), so 2×2 / main-stack are nested containers built by hand.
- **2×2** verified with `screencapture` → visual read (clean 2×2, both by window-id and by relative-focus).
- **main+stack** verified **structurally** via `aerospace list-windows --format '%{window-parent-container-layout} %{workspace-root-container-layout}'` — the tree query (one window at `h_tiles` root + three at `v_tiles`) confirms the layout **without** a screenshot. Key finding: `join-with` only pairs two windows; the **third window is appended to a column with `move left`**, not another `join-with`.
- Config validated with `aerospace reload-config`; both binds confirmed via `aerospace config --get`.

## Current State
### Working
- Both binds live and reloaded. Tuned for a **flat row of 4**; other counts run (extra focus/join steps are no-ops) but won't tile cleanly.

### Known issues / notes
- **Live-testing friction (disclosed to user):** driving workspace W kept flipping the *visible* workspace to **T**, which is running **another live Claude session in tmux** (Fable 5). **No tmux commands were ever run; T stayed intact (1 window).** Switched to structural tree-queries to cut down on workspace-flipping; restored focus to T when done. User got annoyed at the number of live tests — lesson: for AeroSpace layout work, prefer the `list-windows` tree-query over screenshots, and batch the window ops.
- Grid sequences are 4-window-specific; a genuinely count-adaptive version would need a script (read window count, branch) bound via `exec-and-forget` — not built.

## Next Steps
1. User tries `Cmd+Alt+G` / `Cmd+Alt+S` on a 4-window workspace; swap keys if they clash with an app.
2. If a count-adaptive grid is wanted later, move the logic into a `bin/` script and bind it.
