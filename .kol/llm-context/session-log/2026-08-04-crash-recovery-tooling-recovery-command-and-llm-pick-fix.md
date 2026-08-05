# Session: Crash-recovery tooling — ref-recovery card, :Recovery command, and the llm-pick silent close

**Date:** 2026-08-04
**Agent:** Claude Code (Grim) — MBP
**Summary:** A tmux crash took the session and left six orphan nvim swaps holding unsaved text. Built the recovery surface that would have surfaced them: a `ref-recovery` card, an in-editor `:Recovery` picker, and a conditional dashboard button. Fixed a second llm-pick popup bug, audited the popover band for clashes, and appended a third defect to the humpty ticket.

## Changes Made

### Files Modified
- `ref/recovery.md` — **new card**, then rewritten twice on user feedback. Final scope is nvim · tmux · yazi only; every section carries a worked `[e]` example with real output and which line to read
- `bin/ref` — `card_list()` (alphabetical), `card_def()`, `usage()` row. 19 → **20 cards**
- `bin/ref-recovery` — **new wrapper**
- `bin/llm-pick` — `--print-query` on the mode picker; a typed non-match is now answered as an `ask` instead of silently closing the popup
- `nvim/lua/grim/core/recovery.lua` — **new**, the `:Recovery` command over `swapinfo()`
- `nvim/lua/grim/core/init.lua` — requires it
- `nvim/lua/grim/plugins/alpha.lua` — dashboard button, shown only when swaps with unsaved text exist
- `nvim/lua/grim/plugins/auto-session.lua` — `auto_restore_enabled` false → **true**
- `lobby/inbox/humpty-gates-misfire-on-docs-and-command-text.md` — **defect 3** appended
- `lobby/INDEX.md` — ledger row extended, history line

### Features Added/Removed
- Added: `:Recovery` — picker over every swap holding unsaved text, newest first, `[No Name]` entries resolved to their cwd
- Added: `ref-recovery`, the 20th card
- Removed from the card on user ruling: trash · disk-drill · atuin · Time Machine. Recovery here means **the three things that were crashing**, not backup

## Current State

### Working
- `:Recovery` finds **6 recoverable** on this machine; end-to-end run recovered **64 lines** from the 17:09 swap without writing
- Dashboard renders `> Recover unsaved text (6)`; command registered; clean startup
- llm-pick verified against real fzf on all three paths — match `rc=0` + selection on line 2, no-match `rc=1` + query on line 1, Esc `rc=130`
- `ref --lint` clean at 20

### Known Issues
- **`bin/md-preview` ignores piper's `$w`/`$h`** (grep count: 0). mdcat renders at a fixed **76 columns** whatever the pane width is — that is the preview cut-off. The correct pattern is one file over: `yazi/plugins/mdcat.yazi/main.lua` passes `--columns tostring(area.w)`
- `ref/yazi.md` does not list `J`/`K` (`seek 5` / `seek -5`, `yazi/keymap.toml:63-64`) — the preview **does** scroll, piper honours `job.skip`; the keys just aren't carded
- `tmux/layout-picker.sh:3` says `prefix C-d`; the live bind is `prefix C-o`
- **Popups hold real work in an ephemeral client** — `prefix C-b` → nvim, `prefix C-p` → `exec yazi`. Kill the popup, kill the program in it. No fix attempted; it is the shape of `display-popup -E`
- `swapinfo().pid` reads **0** for every swap here, so it cannot test liveness. `recovery.lua` uses an mtime heuristic with a `ponytail:` note

### The crash itself
tmux server PID 51272 started 17:31:25, all 11 sessions created inside 7 seconds — a continuum restore, last save 17:17:50. resurrect brought back two nvim processes but **empty**: it restores the command line, never the buffer. Four of the six swaps are `[No Name]`, which is why nothing ever prompted.

### Popover audit — no bind can kill tmux
No `kill-server` binding exists (only tmux's own `&` and `x`, both `confirm-before`). No duplicate prefix binds across 123. No nested popups. `prefix C-o` deliberately overrides `rotate-window`. Bare `C-h/j/k/l/C-\` are root-table vim-tmux-navigator binds, so bare `C-l` is pane-nav rather than clear in a non-vim pane.

### Six claims I checked instead of shipping
1. llm-pick failing on a missing API key — `llm` works, key is set.
2. llm-pick failing on `LESS=-F` — `LESS` is `-R`, no `-F`.
3. `prefix C-b` overriding `send-prefix` — artifact of my comparison server running the default prefix; `prefix C-a → send-prefix` is bound.
4. `layout-picker.sh` opening a nested popup — the grep hit a **comment**.
5. First `yazi --debug` reporting `Unknown`/`Chafa` — a pipe artifact; under a pty it is `Left(Ghostty)`/`Kgp`.
6. `:recover <path>` — dies with **E499** because `%` is the Ex line's current-file token. Needs `fnameescape`.

**The pattern AGENT-CONTEXT already records twice: reading or piping is not the live behaviour.** Every one of these was plausible enough to state as fact.

---

## Part two — the preview width, a regression, and the `notes` family

Steps 1 and 2 above were done in the same session; this section closes them.

### Files Modified
- `bin/md-preview` — reads piper's `$w` and passes it on as mdcat `--columns` / glow `-w`; frontmatter values now fold instead of clipping
- `bin/notes` — **new engine**, explainer cards (sibling of `ref`, no shared registry)
- `notes/shell.md` — **new card**, `$ — variables and expansion`
- `bin/notes-shell` — **new wrapper**
- `ref/yazi.md` — `MD_PREVIEW_PAD` replaced (it never existed in the script), `## scroll` group added, width paragraph added
- `docs/scripts/md-preview.md` — **new doc**, the script was undocumented
- `docs/scripts/notes-system.md` — **new doc**
- `docs/scripts/INDEX.md` — rows for both; the ref row stopped enumerating cards and points at `ref --cards`
- `docs/scripts/llm-pick.md` — the `--print-query` behaviour recorded

### The cut-off was horizontal, and I answered vertical first
The user asked twice. **yazi has no horizontal preview scroll at all** — the complete default keymap carries only `seek` — and piper never calls `:wrap()` on its widget, so anything past the pane edge is clipped rather than wrapped. `[preview] wrap = "yes"` does not reach a piper previewer; it governs yazi's built-in text/code one. So the only fix is making the content fit, which is what reading `$w` does.

Measured after: w=40→36, w=60→56, w=100→96 in all three modes. Both renderers take a **total** width and inset within it, so the same number goes to `--columns` and `-w`.

### A regression I shipped and the user caught
The frontmatter fold used `printf '%s'`. **`fold` does not terminate its last line, and a `read` loop silently drops an unterminated one** — so every single-line field vanished and only long, multi-segment values survived. `title`, `type`, `status`, `updated`, `tags` and both list blocks were simply gone from the preview. One character: `printf '%s\n'`. All 11 fields on `docs/INDEX.md` render again.

### Still not fixable here
Wide markdown **tables** overflow in all three modes — `docs/INDEX.md` at w=80 measures 236 · 236 · 224. Neither mdcat nor glow shrinks a table to the requested width, and there is no horizontal scroll to recover it. Short of pre-processing the markdown there is nothing at this layer.

### `ref/yazi.md` documented a lever that does not exist
`MD_PREVIEW_PAD=N` was on the card; the script's count of that string is **0**. Pre-existing drift, corrected in the same edit as the width note.

## Next Steps
1. Fix the stale `prefix C-d` comment in `tmux/layout-picker.sh:3` — the live bind is `prefix C-o`.
2. Untouched and still open: the plugin-namespace question (`/humpty:<name>` vs bare).
3. `notes/` has one card. It is the right shape for anything explained once and then forgotten.
