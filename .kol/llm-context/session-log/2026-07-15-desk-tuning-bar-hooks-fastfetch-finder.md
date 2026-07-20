# Session: desk tuning — simple-bar joins kol-theme · bar event hooks · fastfetch restyle · Finder floats

**Date:** 2026-07-15
**Agent:** Grim (Fable 5)
**Summary:** Morning tuning pass across the desk: simple-bar became a kol-theme consumer, the bar's dead event wiring got rebuilt (process-widget lag), a workspace-letter widget landed after two classic traps (interval-0 flood, invisible-ink color), fastfetch was restyled + de-guttered, Ghostty dropped to 14pt, Finder floats, wifi stopped saying `<redacted>`, and bookmark paths now copy to the clipboard.

## Changes Made

### simple-bar → kol-theme consumer (7th surface)
- Each theme's `colors.json` grew a 15-slot `simplebar` block; `bin/kol-theme` jq-merges it into `.themes` of `~/.simplebarrc` — written **through** the symlink (`cat >`, never `mv` — the repo file is the target and stays git-truth). Layout/panel keys untouched; write-back seam beaten by re-patch-per-switch.

### Bar event wiring — the lag
- **Root cause:** the bar never polls (`refreshFrequency = false`); the only hook targeted widget id `simple-bar-spaces-widget-index-jsx` — an id from an older multi-widget simple-bar that **doesn't exist here** (`|| true` ate the failure for weeks). And no `on-focus-changed` existed, so same-workspace focus changes triggered nothing.
- Fixed: both `exec-on-workspace-change` and new `on-focus-changed` refresh `simple-bar-index-jsx` (id verified against the live DOM).

### Workspace-letter widget — two traps
- User widget `(T)` from `aerospace list-workspaces --focused` (both brew prefixes inline on PATH).
- **Trap 1:** `refreshFrequency: false` → simple-bar feeds it straight into `setInterval` → 0 ms interval → `/run` flood, `ERR_INSUFFICIENT_RESOURCES`, whole bar starved. → 2000 ms.
- **Trap 2:** under `widgetsBackgroundColorAsForeground`, a user widget's `backgroundColor` IS its text color — empty string resolved to the bar-background var → **the letter rendered in invisible ink** (computed color = `#1d1f20` on a `#1d1f20` capsule). → `--accent` (palette var, theme-aware). Diagnosed via computed styles in the web client + the desktop's `sb_cmd_*` caches (which held `"(T)\n"` — proof it executed all along).
- One localStorage store wipe + reseed along the way (2nd occurrence of the known seam).

### The rest
- **fastfetch:** left gutter = `--align center` baking 19 spaces into `logo.txt` (the 42×26-cell canvas is landscape, not square — portrait image centered in it); regenerated `-f symbols --align left` (`-f symbols` forced: chafa auto-detect emitted kitty-graphics). Restyle: `─ hardware ─`/`─ software ─` custom sections, `keys` on ANSI yellow (theme-aware via terminal palette), battery/locale dropped, OS format trimmed.
- **Ghostty:** `font-size` 16 → 14.
- **Finder:** floats via combined rule `["layout floating", "move-node-to-workspace W"]` — caught that aerospace runs only the FIRST matching rule; old W-only rule removed.
- **Wifi `<redacted>`:** macOS Sequoia treats SSID as location data; `system_profiler` redacts it for permission-less Übersicht. `hideNetworkName: true` — icon-only.
- **kol-bookmarks:** path click now **copies to clipboard** (listed `~` form, shell-pasteable) instead of Finder reveal — verified end-to-end (`pbpaste` byte-exact); URLs unchanged.

### Files Modified
- `bin/kol-theme` · `themes/*/colors.json` (+simplebar blocks) — the consumer
- `aerospace/aerospace.toml` — hooks + Finder rule
- `ubersicht/simplebarrc` — hideNetworkName, user widget
- `ubersicht/kol-bookmarks.widget/index.jsx` — clipboard action
- `fastfetch/config.jsonc` + `fastfetch/logo.txt` — restyle + regen
- `ghostty/config` — font 14
- docs: `07-ubersicht` (troubleshooting ×4) · `05-aerospace` (hooks + Finder row) · `08-kol-theme` · `11-ricing-backlog` · `21-chafa`

## Current State

### Working
- Bar tracks focus instantly; `(letter)` chip in accent color at the right capsule's left edge; user-confirmed visible.
- kol-theme covers 7 surfaces; still out: yazi (flavors), starship (parked).

### Known Issues
- Ghostty always needs quit+relaunch to show config/theme changes (reload ≠ repaint) — inherent.
- Bookmarks click-copy has no visual feedback (v2 candidate: brief hover-flash on copy).

## Next Steps
1. nvim arc: live in `nnow`; friction → playbook.
2. simple-bar settings-panel tune pass (still open from 12/07).
3. Sticky-widget remainder: raindrop links layer · notes git-sync.
