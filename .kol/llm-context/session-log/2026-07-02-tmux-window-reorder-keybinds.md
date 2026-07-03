# Session: tmux window-reorder keybinds (N/P/F/G) + docs

**Date:** 2026-07-02
**Agent:** Grim (Claude Sonnet 5, `~/.dotfiles`)
**Summary:** Added four new tmux prefix bindings to move the *current* window's position (not just view another window) — `N`/`P` step forward/backward, `F`/`G` jump to first/last slot — verified collision-free against the full stock+repo key table, documented in the tmux tips guide and the CLI cheatsheet. One serious testing mistake happened and is disclosed below.

## Changes Made

### Files Modified
- `tmux/.tmux.conf` — new block after the pane-resize binds: `bind -r N swap-window -t "+1" \; select-window -t "+1"` (mirror for `P` at `-1`), `bind F swap-window -t "{start}" \; select-window -t "{start}"` (mirror for `G` at `{end}`). Each chains a `select-window` after the swap so focus follows the moved window — bare `swap-window` alone left the active-window marker pinned to the original index (confirmed empirically), so without the chain you'd end up looking at whatever used to occupy the target slot instead of your own window.
- `docs/01-shell-terminal/09-tmux-tips.md` — added the four keys to the existing "Window tricks" block + an explanatory note on the mnemonic. `updated:` bumped to 2026-07-02.
- `docs/00-kol-cli/01-cli-cheatsheet.md` — added a row to the tmux Windows/Panes table with a footnote.
- `docs/llm-context/AGENT-CONTEXT.md` — new head entry in the "Last updated" chain (old head demoted to first "Prior:"), chain trimmed back to 5 by dropping the two oldest (2026-06-26 (3) and (4)) — their content isn't lost, it's in `session-log/2026-06-26-kol-cli-reference-cards.md` and `session-log/2026-06-26-git-network-cli-cards.md`.

### Features Added/Removed
- `prefix N`/`P` — move current window forward/backward one slot (repeatable, mirrors stock lowercase `n`/`p` next/prev-window: lowercase looks, uppercase takes the window with you).
- `prefix F`/`G` — move current window to the first/last slot (vim `gg`/`G` start/end mnemonic).

## Current State

### Working
- All four bindings verified end-to-end (swap direction, `{start}`/`{end}` resolution, and focus-follow via the chained `select-window`) on an isolated `tmux -L <throwaway-socket>` test server.
- Config confirmed to parse clean and register the new binds correctly when loaded via `tmux -L <socket> -f tmux/.tmux.conf`.
- Collision check ran against the **full merged key table** (tmux stock defaults + this repo's overrides), not just the repo's own explicit binds — that's what caught the real problem: the user's original `<`/`>`/`{`/`}` idea was fully blocked (`{`/`}` = stock `swap-pane`, already documented and in active use in `09-tmux-tips.md`; `<`/`>` = stock window/pane context menus). `N`/`P`/`F`/`G` confirmed genuinely free.
- **Live in the file, not yet reloaded** — needs `prefix r` (or a fresh `tmux` server) to take effect.

### Known Issues
- **Incident during testing (self-inflicted, disclosed to the user in-session):** an early verification pass ran `swap-window` / `kill-session` against the user's **real, live** tmux server (no `-L` isolation) using an unqualified relative target (`-t "-1"` with no session prefix, `-s` given but `-t` bare). Because the shell invoking `tmux` had no attached-client context, tmux resolved the unqualified target against the currently-attached session instead of the throwaway test session, pulling two real windows into the test session. The subsequent cleanup `kill-session` then destroyed everything in that session — **including those two real windows.**
- **Confirmed lost:** windows named `design-system` and `kol-studio` (3 panes each), plus whatever was running in them. No recovery is possible — this repo's tmux config is deliberately plugin-free (no tmux-resurrect/continuum), so there's no session-state snapshot to restore from.
- User was told exactly what happened and asked what was running in those windows; no reply yet on impact/severity as of this log.
- **Process fix (applied for the rest of this session, should be standing practice going forward):** every subsequent tmux command used an isolated `tmux -L <throwaway-socket>` server, which cannot touch the default/real server's sessions no matter how a relative or special target resolves. **Any future tmux experimentation in this repo should default to `-L` isolation** — never run exploratory `swap-window`/`kill-session`/similar against the default socket from a detached (non-attached) shell.

## Next Steps
1. User runs `prefix r` to reload `~/.tmux.conf` and try the new keys live.
2. Follow up on whether `design-system` / `kol-studio` window contents mattered — recreate manually if so (nothing lost was tracked in git; this was purely runtime tmux pane state).
3. If the `N`/`P`/`F`/`G` pattern feels right in daily use, `02-tmux.md`'s "Configuration" highlights list could get a one-line mention too — only `09-tmux-tips.md` and the cheatsheet were touched this session.
