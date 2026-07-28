# Session: tmuxp load crash root-caused — continuum restore race

**Date:** 2026-07-27
**Agent:** Grim (Fable 5)
**Summary:** `tmuxp load studio` crashed mid-build (libtmux `zip()` ValueError, 3/8 windows) because the load started a fresh tmux server, which fired continuum's auto-restore in parallel — continuum restored the real 8-window session as `1` anyway. Fixed the secondary auto-title issue in `.zshrc` and synced the tmuxp doc.

## Changes Made

### Files Modified
- `shell/.zshrc` — `export DISABLE_AUTO_TITLE='true'` added above the omz source line (tmuxp requirement; omz auto-retitling breaks libtmux's pane parsing)
- `docs/documentation/01-shell-terminal/19-tmuxp.md` — Setup notes the export requirement; new **Gotcha** section (continuum race — check `tmux ls` before `tmuxp load` post-reboot); stale "no frozen configs yet" replaced with the `studio.yaml` entry

### Diagnosis (no config change needed)
- Timeline proved the race: `studio` created 20:40:39 by tmuxp, session `1` (all 8 windows, exact freeze names) created 20:40:41 by continuum's restore hook on the same server start.
- The crash left a dead 3-window `studio` partial; the restored `1` was complete and correct.

## Current State

### Working
- Continuum restore verified end-to-end after a real reboot — the whole point of the 2026-07-27 freeze exercise.
- Post-restart protocol corrected: `tmux ls` first → attach to the restored session; `tmuxp load studio` only if the restore didn't happen. Never both on one server start.

### Known Issues
- User-side cleanup handed off (not yet confirmed run): `kill-session -t studio` partial, `switch-client -t 1`, `rename-session -t 1 studio`, `source ~/.zshrc`.
- Tailscale node-identity confirmation still open from the prior session (keep `biskup`, delete stale `thordurs-imac`, then sync `06-tailscale-jellyfin.md`).

## Next Steps
1. On the next reboot, verify the corrected protocol: continuum restores → attach, no tmuxp.
2. Arcs unchanged: tailscale confirmation → doc sync; simple-bar settings-panel tune; raindrop links layer.
