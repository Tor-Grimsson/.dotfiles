# Session: clip-drop --yazi flag split · Raycast hotkey per-machine gotcha · ref-card capture section

**Date:** 2026-07-27
**Agent:** Grim (Fable 5)
**Summary:** Split clip-drop.sh into save-only default + `--yazi` filing flag (tmux popup keeps yazi via the flag), root-caused the dead ⇧⌥⌘T Toggle-Theme hotkey (Raycast hotkeys are per-machine — was simply unassigned on the iMac), and gave the capture pipeline a home in the ref cards.

## Changes Made

### Files Modified
- `bin/clip-drop.sh` — `--yazi` flag: bare run saves to `~/_inbox` and prints the path (exit 0); `--yazi` saves then execs yazi hovering the file. Flag parse keeps DIR positional. Caught + fixed an exit-1 bug (`(( YAZI ))` as last command) in the same pass.
- `tmux/.tmux.conf` — `prefix Ctrl+P` popup now calls `clip-drop.sh --yazi` (behavior unchanged; needs `prefix r` to go live)
- `docs/scripts/08-system.md` — clip-drop table row + section updated for the flag split
- `ref/system.md` — new `#clipboard #capture #screenshots` section (ss-save vs clip-drop vs --yazi, flat-inbox, ~/Screenshots split, pngpaste dep); plus a per-machine line in `#window-snapping`: Raycast **hotkeys** live in Raycast's DB, not the repo — assign per command on each machine
- `keys/keybinds.md` — clipdrop section: popup line names `--yazi`; new `shell` line (bare = save-only · ss-save pointer)

### Diagnosis (no config change)
- ⇧⌥⌘T dead: script/frontmatter/aerospace all clean — the hotkey was never assigned in Raycast on the iMac (per-machine state). User assigned it; works.

## Current State

### Working
- `clip-drop.sh` save-only verified exit 0; `--help` on both scripts; `ref-system clipboard` filter renders the new section.
- Toggle Theme ⇧⌥⌘T live on the iMac.

### Known Issues
- tmux `prefix r` not yet confirmed run — until then the Ctrl+P popup runs bare clip-drop (saves, no yazi).
- MBP will need the same Raycast per-machine steps (script dir + hotkeys) — now documented in ref-system.

## Next Steps
1. User: `prefix r` to reload the tmux bind.
2. Arcs unchanged: tailscale confirmation → `06-tailscale-jellyfin.md` sync; next-reboot tmux protocol verify.
