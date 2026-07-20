# Session: bookmarks click-test (pass) · kol-notes.widget v1

**Date:** 2026-07-14
**Agent:** Grim (Fable 5)
**Summary:** Resumed the frozen click-test session: kol-bookmarks.widget verified working (both actions), then the sticky-widget's notes half shipped — `kol-notes.widget` v1, a read-only desk display of `desk-notes.md`.

## Changes Made

### kol-bookmarks click-test — PASS
- Driven agent-side: Übersicht serves widgets on `localhost:41416`, so Playwright clicked real rows and `run()` fired on the machine.
- Path row → Finder revealed `~/.dotfiles/tmux/` with `bookmarks.txt` selected (osascript-verified). URL row → Chrome came forward with the tmux wiki (user-confirmed).
- **Gotcha:** clicking from an external browser logs `TypeError … messageHandlers` — Übersicht's native-WebView bridge doesn't exist there. Harmless; `run()` routes via the server regardless.

### kol-notes.widget v1 — NEW
- `ubersicht/kol-notes.widget/index.jsx` — displays the SAME `kol-vault/desk-notes.md` the `cmd-alt-n` sticky edits; read-only, `cat` + 10s refresh, no daemon.
- Minimal markdown render: `#` lines → yellow hairline heads · `- [ ]`/`- [x]` → `□`/`■` (done = muted) · blank lines → spacers · rest verbatim · untouched `# desk notes` seed → empty state ("empty — ⌘⌥n to write").
- Position: same right gutter, below kol-bookmarks — `top: 340px` (tune by eye if the bookmark list grows), width 236, `max-height: 420px` overflow-hidden. Near-solid bg (no backdrop blur in the WebView).
- Wired: live symlink into the widgets folder + a `bootstrap.sh` line (MBP parity). Render paths verified with test content on the live server; seed restored byte-exact.
- Design question from 06-notes-and-tasks answered de facto: **sibling widgets** (bookmarks / notes), Übersicht-native — not one sectioned widget, not the Neovim-container route.

### Files Modified
- `ubersicht/kol-notes.widget/index.jsx` — new widget
- `bootstrap.sh` — symlink line for kol-notes.widget
- `docs/documentation/09-productivity-desktop/07-ubersicht.md` — worked example 3, description → three examples, bootstrap comment, bookmarks bg stale-claim fix (80% + blur → 96% near-solid), click-test note
- `docs/kol-terminality/06-notes-and-tasks.md` — sticky-widget section: shipped line + answered-de-facto line; `updated` bumped

## Current State

### Working
- Both kol widgets live in the right gutter: bookmarks (top 48, click-tested) + notes (top 340, verified). Bar + `cmd-alt-{m,d,u,r,n}` family unchanged.
- Desk loop closed: `cmd-alt-n` to write → widget shows it within 10s.

### Known Issues
- `kol-notes.widget` path is literal in `command` (no `process` in the WebView — `KOL_NOTES_FILE` can't reach it); repoint by hand if the vault moves.
- `top: 340px` is a fixed offset — overlaps if the bookmark list grows past ~13 rows.

## Next Steps
1. simple-bar settings-panel tuning pass (last open item from 12/07).
2. **nvim arc:** user triages the map (`claude.ai/code/artifact/f13381d8`) → agent builds the `now` set as a real `nvim/` config.
3. Notes: git-sync/auto-push of `desk-notes.md` · raindrop links layer (the sticky widget's remaining third).
