# Session: ref-lobby cut to commands only — skills · scripts

**Date:** 2026-07-31
**Agent:** Claude Code (Grim)
**Summary:** The lobby card still carried a `states` reference table after the earlier trim. A ref card lists commands; states are protocol and live in docs. Rebuilt as two sections — skills, scripts — with one spacer row each, demonstrating the correct use of a break.

## Changes Made

### Files Modified
- `ref/lobby.md` — **51 → 34 lines, 4 → 2 sections.**
  - `states` table **removed** — emoji ↔ meaning is protocol, not a keybind. It already lives in `docs/operations/systems/lobby/02-lifecycle.md`, and every lobby's own ledger repeats it in place.
  - `where` · `file` · `read` collapsed into **`## lobby — skills`**: all 8 `/lobby*` skills, one spacer row separating the three read/route skills from the five writers.
  - **`## lobby — scripts`**: `bin/lobby` (+ `--counts`, `--paths`), `ref-lobby`, then a spacer, then the `clip-drop.sh` group and `pfx C-p`.
  - Destination flags folded to one line under the tables instead of a column.

## What was wrong

Two passes were needed because the first trim removed the *doctrine* (`law`, `bar`, `entry`) but kept `states` — still a reference table, still not a command. The rule the user restated: **a ref card is a lookup for what to type.** Anything explaining how the system thinks belongs in `docs/`.

The two spacer rows here are the first deliberate use of the 2026-07-31 ruling: a break marks a **category boundary** — route/read vs write in the skills table, `lobby` vs `clip-drop` in the scripts table — not every row.

## Current State

### Working
- `ref-lobby` renders; `ref-lobby skills` and `ref-lobby scripts` both hit.
- No line over 79 columns.
- 17 cards unaffected.

### Known Issues
- Nothing outstanding on this card. `ref-desk` (280 lines) and `ref-nvim` (285) remain the two largest and are still candidates for the same commands-only test.

## Next Steps
1. Apply the same test to `ref-desk` and `ref-nvim` — every section that explains rather than lists is a docs candidate.
