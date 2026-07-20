# Session: process widget root-caused — first-load race, self-heals, no fix needed

**Date:** 2026-07-15 (3rd session)
**Agent:** Grim (Fable 5)
**Summary:** The missing focused-app icon (process widget, bar left) was root-caused to a first-load race in simple-bar's `index.jsx`: the widget's init command is baked once at module load from localStorage, before the async `~/.simplebarrc` import lands — a cold/wiped store boots that cycle on wrong-arch defaults. It self-healed mid-session (the 07-15 aerospace hooks re-mounted it); nothing was changed in config.

## Changes Made

### Files Modified
- `docs/documentation/09-productivity-desktop/07-ubersicht.md` — new troubleshooting bullet: process widget missing after relaunch = first-load race; browser bisect trick documented.

### Features Added/Removed
- None — diagnosis-only session. No config, source, or settings edits.

## Diagnosis trail (evidence, in order)

1. **Same-origin POST to `/run/`** (yesterday's parked next-step): every command the widget runs — `list-workspaces --focused`, per-monitor spaces with the format string, `list-windows --workspace T` — returns valid JSON in the WebView-server env. Bare `aerospace` is `command not found` there; the rc's `$(PATH=…which aerospace)` value expands correctly. No bare-`aerospace` call sites exist in simple-bar source.
2. **Render-chain read** (`process.jsx`, `window.jsx`, `aerospace-context.jsx`, `aerospace.js`, `utils.js`, `settings.js`): all gates pass with our settings (`exclusions: ""` is harmless; `isVisibleOnDisplay("")` → true; `filterApps` passes). Settings come from **localStorage** merged over defaults — `~/.simplebarrc` is the import/write-back mirror, re-imported by async `Settings.init()` on every load.
3. **The mechanism:** `index.jsx` runs `Settings.init()` (async, un-awaited) then synchronously bakes `command` from `Settings.get()` and exports it. Cold store at module load → defaults → `aerospacePath = /opt/homebrew/bin/aerospace` (wrong on the Intel iMac) → `init-aerospace.sh` emits `"displays": ,` → `parseJson` fails on every redraw.
4. **Browser bisect at `localhost:41416` (Playwright):** first load (cold profile) reproduced the exact repeating `"displays": ,` error with `.process`/`.spaces` absent; **reload** (store warmed by init()) rendered the process widget fully — icon button, focused window. Code, settings, and server env all green; the failure needs only a cold store at module-load time.
5. Native bar healed mid-session ("it's here already") — consistent: the aerospace `on-focus-changed`/`exec-on-workspace-change` hooks (added 07-15 (24)) refresh `simple-bar-index-jsx`, re-mounting the widget once the native store was warm.

## Current State

### Working
- Process widget renders natively; native localStorage holds the fixed rc settings, so subsequent Übersicht launches bake the correct command from the start.
- No fix applied and none needed — yesterday's `aerospacePath` rc fix + populated store is the stable steady state.

### Known Issues
- After any **future store wipe + relaunch**, the same one-boot race recurs; one workspace switch recovers it. Documented in `07-ubersicht.md`.
- Exact native re-mount timing wasn't traced (it healed while diagnosing); the cold-store race is the proven mechanism, the browser bisect the proof.

## Side notes
- btop's `2.1.210` process rows = `claude` CLI sessions (btop shows the version string); three were live on ttys004–006, each parenting its own playwright-MCP server pair. User `pkill`ed the playwright servers; sessions themselves unaffected.

## Next Steps
1. Unchanged arcs: user lives in `nnow`; simple-bar settings-panel tune; raindrop links layer.
2. User: `prefix r` + `prefix I` still pending for tmux-resurrect (from session 25).
