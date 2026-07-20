# Session: bar reference-conformance (linkarzu port) · kol-notes sticky · widget gutter

**Date:** 2026-07-12
**Agent:** Grim (Fable 5)
**Summary:** Second arc of the day (follows `2026-07-12-ubersicht-golive-shakeout-macos-toggles.md`): the bar was conformed to the linkarzu reference by porting his actual `.simplebarrc` instead of deriving from screenshots; the skitty-notes port shipped (`cmd-alt-n`); the desk got a right widget gutter.

## Changes Made

### simple-bar — ported from ground truth
- Fetched linkarzu's real config (`gh api repos/linkarzu/dotfiles-latest` → `ubersicht/.simplebarrc`). The look lives in **three built-in switches** that were being faked or missed: `floatingBar: true` (the island layout), `sideDecoration: true` (the  — a real component; the CSS `::before` hack deleted), `widgetsBackgroundColorAsForeground: true` (colored capsule content). Plus `hideWindowTitle: true`, `displayStackIndex: false`, `noColorInData` back to false (refs are colorful — monochrome was a wrong extrapolation).
- **Upstream bug found:** the *aerospace* spaces component never reads `widgets.spacesWidget` (only yabai's honors it) — pills rendered despite `false`. Hidden via customStyles `.spaces { display: none }`.
- Widget gutter: `outer.right` 10 → **300** (user-tuned through 260/80/316); `05-aerospace.md` synced.
- kol-bookmarks widget: `top: 48px` (bar rhythm), bg → `rgba(18,18,21,0.96)` near-solid — **Übersicht's WebView doesn't run backdrop-filter**, so real translucency double-exposes desktop icons behind the panel.
- Layering law (explained, not fixable): Übersicht widgets draw on the desktop layer between wallpaper and windows — they can never join the AeroSpace layout or sit above windows; the gutter is how they stay visible.

### kol-notes sticky (the skitty-notes port) — NEW
- `bin/notes-toggle` (**cmd-alt-n**): summon/dismiss nvim-in-Kitty on `kol-vault/desk-notes.md` (creates it with an `# desk notes` header if absent; override `KOL_NOTES_FILE`). Launches via `open -na kitty` (PATH-proof under aerospace exec, cross-arch).
- `kitty/kol-notes.conf`: kol-dark palette, JetBrains Mono 11, 410×750, 0.94 opacity.
- `kitty/kol-notes-init.lua`: **dedicated minimal nvim profile** (`nvim -u … --noplugin`) — the daily nvim config must never load in the sticky (its tree/dashboard/colorscheme caused the "border + files" complaint), same trick as linkarzu's separate skitty profile.
- Placement: **tiles into workspace T** via on-window-detected (kitty app-id + `kol-notes` title) — user call; floating + JXA positioning built first, then removed. The small top-right-panel look of the mock is inherently the floating variant.
- `keys/keybinds.md` row + `06-notes-and-tasks.md` synced (ported-v1 entry; open half = git-sync/auto-push).

### Gotchas that cost time
- A **manually opened plain kitty** (login shell, ws 1) masqueraded as "the stuck notes window" — the real sticky verified live on T (spawn + rule + tracking) from the agent side.
- simple-bar settings need `customStyles: { "styles": "…" }` — and its localStorage write-back loop (fixed in the prior log) stayed clean all session.

## Current State

### Working
- Bar: islands + colored capsule +  side icon, kol-dark, no workspace pills, `outer.right = 300` gutter with the bookmarks column at top 48 / width 236 / near-solid.
- `cmd-alt` desk family: `m` menubar · `d` dock · `u` Übersicht · `r` refresh (double-pass) · `n` notes sticky. All live; help-lint 70/70.

### Known Issues
- kol-bookmarks rows still not click-tested (open/reveal actions).
- simple-bar settings-panel tuning pass not done (cmd+click → compare against repo file).

## Next Steps
1. **nvim arc:** user triages the map (`claude.ai/code/artifact/f13381d8`) → agent builds the `now` set as a real `nvim/` config.
2. Notes sticky: git-sync/auto-push of `desk-notes.md`; revisit float-vs-T after living with it.
3. Parked: ritual v1 · workspace layout · `prefix ?` keys-popup · kol-dark emitters.
