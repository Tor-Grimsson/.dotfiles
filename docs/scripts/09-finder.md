---
title: Finder selection scripts
type: reference
status: active
updated: 2026-06-05
description: finder-* — Finder selection Quick Actions (every-other / invert), AppleScript-backed, hotkey-bound.
aliases:
  - finder
tags:
  - project/dotfiles
  - domain/scripts/finder
---

# Finder (`finder-`)

| Script | Does | Usage |
|--------|------|-------|
| `finder-select-alternate.sh` | Reshape the front Finder window's selection | `finder-select-alternate.sh [odd\|even\|invert]` — run `--help` |

Finder has no native "select every other" and not even an Invert Selection — this AppleScript-backed
script fills both gaps. Wired as Finder **Quick Actions** (`macos/services/`), two with hotkeys.

## Modes

| Mode | Keeps | Hotkey | Quick Action |
|---|---|---|---|
| `odd` (default) | 1st, 3rd, 5th… of the selection | **⇧⌥⌃A** | Select Every Other |
| `even` | 2nd, 4th, 6th… (the complement) | **⇧⌥⌃S** | Select Every Other (Even) |
| `invert` | everything in the window NOT selected | — (CLI only) | — |

`odd`/`even` act on the **current selection** (or the whole window if fewer than 2 are selected).
Hotkeys registered via `pbs` in `macos/defaults.sh`; the `.workflow` bundles are symlinked into
`~/Library/Services` by `bootstrap.sh`. See [[documentation/09-productivity-desktop/INDEX|productivity]] siblings
and the shortcut table in `macos/defaults.md` §8.

## Use cases
- **Halve a burst.** Exported 200 sequential frames and want a contact sheet at half density — select all, ⇧⌥⌃A, then move/delete the rest.
- **A/B split a batch.** ⇧⌥⌃A → drag the odd set to folder A; reselect all, ⇧⌥⌃S → drag the even set to folder B. Two alternating piles, no manual clicking.
- **Keep-these-trash-the-rest.** Cmd-click the handful you want to keep, run `invert` → everything else is now selected → delete. Beats Cmd-clicking 195 files to deselect 5.
- **Thin a too-heavy batch op.** A conversion that chokes on 400 files at once — run it on the odd half, then the even half.

## Caveat
AppleScript reads items in Finder's internal order, **not** the window's visual sort (name/date/size).
So "every other" is every-other-in-that-list and may not look like a clean on-screen checkerboard — there's
no API for the visual order. For predictable results, sort by **Name** first.
