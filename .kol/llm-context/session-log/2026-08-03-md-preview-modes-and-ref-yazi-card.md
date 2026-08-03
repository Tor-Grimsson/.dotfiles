# Session: md-preview gains modes and colour · yazi promoted to its own ref card

**Date:** 2026-08-03
**Agent:** Claude Code (Grim) — MBP
**Summary:** Finished the markdown previewer started earlier today — three switchable modes on a tmux bind, and colour forced in all of them after discovering neither renderer emits any when yazi captures the pane. Then split yazi out of `ref-explorer` into its own card. Continues `session-log/2026-08-03-md-preview-frontmatter-in-yazi.md`.

## Changes Made

### Files Modified
- `bin/md-preview` — rewritten. Three modes (`full` · `mdcat` · `glow`) read per render from `~/.cache/md-preview.mode`; `--cycle` and `--mode` flags; `mdcat --ansi --margin` and `CLICOLOR_FORCE=1 glow -s ref/glow-style.json` for colour; `MD_PREVIEW_PAD` for the inset
- `tmux/.tmux.conf:293` — **new bind** `prefix v`, cycles the mode and reports it in the status line
- `ref/yazi.md` — **new card.** `## yazi — keys` (moved, renamed from `## yazi`) + `## md-preview — yazi markdown-preview modes`
- `ref/explorer.md` — yazi sections removed; header points at the new card. Keeps broot · trial · in nvim
- `bin/ref` — `yazi` added to `card_list` and `card_def`; usage table split into a yazi row and a trimmed explorer row
- `bin/ref-yazi` — **new wrapper**, the 18th card
- `docs/scripts/ref-system/{INDEX,01-system,02-cards}.md` — card inventory, alias list, and the dialect-model citation updated

### Features Added/Removed
- Added: switchable markdown preview modes, live in a running yazi
- Added: `ref-yazi` as a first-class card

## Current State

### Working
- All three modes verified emitting colour: full 47 coloured lines · mdcat 32 · glow 53. All were 0 or near-0 before.
- `ref --lint` clean on 18 cards. Filters verified: `ref-yazi keys` → keymap only, `ref-yazi md-preview` → preview only, `ref-explorer yazi` → nothing.

### Known Issues
- **Neither renderer colours a non-TTY, and yazi always captures the pane.** mdcat needs `--ansi`, glow needs `CLICOLOR_FORCE=1`. This was pre-existing: yazi's original `run = "mdcat"` previewer had no forcing, so that pane had been rendering colourless since it was wired.
- The `prefix v` bind needs `prefix r` before it exists. Mode changes need the cursor moved off the file and back to redraw.

### Three wrong claims this session, all corrected by measuring
1. Said mdcat colours when piped. It does not — I had piped it through `sed` to strip codes, which proves nothing about whether any existed. Counting them showed zero.
2. Measured mdcat's left margin as 0 and removed my gutter to match. mdcat drops its margin on a non-TTY, so the number was never the live behaviour. `--margin` is the real lever.
3. Reported the new ref tags as resolving to zero sections. The filter was fine — glow splits headings across escape sequences, so a grep for a contiguous string could never match.

**The pattern is the same one AGENT-CONTEXT already records from 2026-08-03 (69):** reading or piping is not the live behaviour. Every one of these looked plausible enough to state as fact until it was actually run and counted.

## Next Steps
1. Eyeball the three modes in a live yazi — everything above is verified by counting escape codes, not by looking at the pane.
2. Untouched and still open: the plugin-namespace question, and the humpty gate defects filed at `lobby/inbox/humpty-gates-misfire-on-docs-and-command-text.md`.
