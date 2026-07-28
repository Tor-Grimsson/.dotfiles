# Session: ref-pick — fzf drill-down popup for the ref cards

**Date:** 2026-07-27
**Agent:** Grim (Fable 5)
**Summary:** New `bin/ref-pick` — an fzf two-level drill-down (card → section → paged read) over the ref family, in a tmux popup on **Prefix + Ctrl+F**. Solves "I don't remember what it's called": live preview at both levels + fuzzy typing. User-confirmed working.

## Changes Made

### Files Modified
- `bin/ref-pick` — new (~20 real lines): level 1 cards with full-card preview, level 2 section headers with section preview, Enter pages via `less -R` (q → back to sections), Esc walks up. Key trick: `ref` awk-joins all args into one tag string, so a whole header ("clipboard capture screenshots") passes as a single fzf `{}` — zero parsing.
- `tmux/.tmux.conf` — `bind C-f display-popup -w 50% -h 50%` (sized down from 85×80 after a live look), commented with the popup siblings
- `keys/keybinds.md` — `#tmux #popover` gained the Prefix + Ctrl+F line
- `docs/scripts/22-ref.md` — summary + deps (fzf row) + how-to-use updated for ref-pick; `updated: 2026-07-27`
- `docs/documentation/01-shell-terminal/02-tmux.md` — popup enumeration gained `prefix C-f` → [[22-ref|ref-pick]]

### Key-choice note
- Ctrl+R was rejected twice: taken by resurrect restore, and the user wants distance from all restore/recovery binds. Ctrl+F (find) chosen from the free pool (E/F/J/K/L/U/V/W/X were open).

## Current State

### Working
- Verified: `bash -n`, `--help`, section derivation on all 7 cards (40/11/6/7/5/17/16 sections), multi-tag single-arg lookup, fzf 0.74 preview syntax, help-lint clean (80 scripts). Live-tested by the user, resized to taste.

### Known Issues
- None on this arc. Carried: tailscale confirmation → `06-tailscale-jellyfin.md` sync; next-reboot tmux protocol verify.

## Next Steps
1. Arcs unchanged (tailscale · reboot-protocol verify).
