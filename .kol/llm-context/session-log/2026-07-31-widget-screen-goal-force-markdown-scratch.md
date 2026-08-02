# Session: widget screen pinned, /kol-goal-force built, markdown on scratch buffers

**Date:** 2026-07-31
**Agent:** Claude Code (Grim)
**Summary:** Finished the per-monitor widget work that had been claimed-but-not-done, built a goal loop that polices its own exits, and answered why the markdown ftplugin skipped unsaved notepads — it was never about saving.

## Changes Made

### Files Modified
- `nvim/lua/grim/core/keymaps.lua` — **`<leader>mm`** sets `filetype=markdown` on the current buffer.
- `ref/nvim.md` — `<leader>mm` row + the filetype-is-the-trigger note.
- `ref/desk.md` — new `## widgets — which screen`.
- `ref/skill.md` — `/kol-goal-force` row.
- `claude/hooks/goal-loop.sh` — force mode (below).
- `claude/skills/kol-goal/SKILL.md` — `/kol-goal-force`, the legal/illegal blocker table, the never-policed exemptions.
- `docs/documentation/04-dev-languages/10-neovim-config.md` — new § *The trigger is the filetype*.
- `docs/documentation/09-productivity-desktop/07-ubersicht.md` — `ubersicht-screen`, and the correction that this is **not** GUI-only.
- `docs/operations/systems/claude-harness/02-skills.md` — force mode in the roster.
- `docs/scripts/INDEX.md` — `lobby` + `ubersicht-screen` rows.

### Files Added
- `bin/ubersicht-screen` — `main` · `all` · bare = show state.

### Applied to live state (not a file)
- All three Übersicht widgets → `showOnMainScreen: true`, `showOnAllScreens: false`. Verified by read-back.

## The three pieces

### 1. Übersicht widgets pinned to one screen — the half that was never done
The per-monitor gaps landed on 2026-07-30 and were reported as complete. They weren't: the aerospace half was applied and **syntax-validated only** (`reload-config --dry-run` checks TOML, nothing else), while the Übersicht half was handed to the user as a GUI step, and the doc claimed "the gutter follows automatically". It doesn't — the gutter follows `monitor.main`, a fixed macOS notion, not wherever the widgets happen to be.

Live state when finally checked: all three widgets `showOnAllScreens = true`, gutter reserved on `monitor.main` = the iMac built-in Retina 5K (`system_profiler` → `iMac … Main Display: Yes`). So the U32J59x had widgets drawn over it with 10px of reserved space.

Also wrong in the earlier report: this was called GUI-only. `Uebersicht.sdef` exposes both properties as `access="rw"` — fully scriptable, which is what `bin/ubersicht-screen` now does.

### 2. `/kol-goal-force` — policing the exits
`mode: force` in `.active-goal.md` turns on two refusals in the Stop hook:

| exit | force mode |
|---|---|
| turn ends handing the decision back (20 ask-shapes matched against the last assistant message) | blocked |
| `blocked:` whose reason is a preference, not an absent capability | refused |

Reuses `footer-gate.sh`'s transcript extractor verbatim — no new mechanism.

**Never policed, deliberately:** the iteration cap (checked *first*) and `stop_hook_active`. A loop that can't be escaped at the cap is exactly the deadlock that cost 11 iterations earlier the same day.

Two bugs caught by testing before the user saw them: `goal` was referenced before assignment, and the ask-check originally ran *before* the cap release — which would have recreated that deadlock. The LEGAL match also reads only the `blocked:` field, never the whole file, so a goal mentioning "auth" can't false-pass.

### 3. Markdown on unsaved buffers — the filetype, not the save
Measured:

| buffer | filetype | wrap |
|---|---|---|
| fresh `:enew` | `""` | `false` |
| after `:set ft=markdown` | `markdown` | `true`, conceal 2, tw 80 |

An `after/ftplugin/<ft>.lua` runs on the **`FileType` event**. A scratch notepad is excluded because nothing told nvim what it is, not because it's unsaved. `<leader>mm` sets it; the whole ftplugin fires at once on an unnamed buffer.

The binding cannot live in the ftplugin — that file only loads once the filetype is already markdown. Chicken-and-egg, so it goes in `core/keymaps.lua`.

**Answering the `$EDITOR` question:** git's `COMMIT_EDITMSG` and Claude Code's compose-in-editor write a **real temp file with a real extension** and open the editor on it. There is no hidden autosave layer — the extension just lets normal filetype detection do the work.

## Current State

### Working
- Widgets render on the iMac only; the U32J59x has its full snap area back — user-confirmed.
- Force mode: 7/7 test matrix (force+ask → refuse · force+decisive → normal loop · illegal blocked → refuse · legal blocked → release · no-force+ask → unpoliced · no goal file → inert · garbage JSON → fail-open).
- `<leader>mm` verified headless on an unnamed buffer.

### Known Issues
- Force mode is a **text heuristic, not a proof**. It raises the cost of quitting; an agent that phrases a question as a statement still gets through.
- `ubersicht-screen main` is not persisted in the repo — Übersicht owns the setting, so a reinstall or a wiped WebKit store loses it.
- The jana/rosa self-arming bug is filed at `humpty/lobby/inbox/mode-self-arms-from-its-own-docs.md`, not fixed here — humpty is a separate repo.

## Next Steps
1. Re-run `ubersicht-screen main` after any Übersicht reinstall.
2. Exercise `/kol-goal-force` on a real task and see whether the ask-shape list needs widening.
