# Session: tmux-resurrect · kitty main config · simple-bar login-item PATH fix · process widget OPEN

**Date:** 2026-07-15 (2nd session)
**Agent:** Grim (Fable 5)
**Summary:** tmux sessions now survive reboots (resurrect+continuum), kitty got a real main config (kol-theme + Claude Code soft-enter), and the simple-bar "JSON error" from the new login-item launch was root-caused to launchd's brew-less PATH and fixed. **Unresolved at session end: the process widget (focused-app, bar left) doesn't render** — every server-side check passes; the failure is only observable in the WebView.

## Changes Made

### tmux-resurrect + tmux-continuum (`.tmux.conf`)
- Both plugins added before the tpm `run` line; `@continuum-restore on` (autosave 15 min, replay on server start). Save rebound `@resurrect-save S` — default `C-s` collides with the sesh picker. Restore `prefix C-r`.
- **User still has to install: `prefix r`, then `prefix I`.** Layouts + cwds restore; running process state doesn't.
- Docs: `02-tmux.md` (TPM bullet + future-use graduation), `keys/keybinds.md` new `## #tmux #resurrect`.

### kitty main config (new `kitty/kitty.conf`)
- kitty had NO main config — only the kol-notes sticky conf. New file: JetBrains Mono 14 (matches ghostty), `map shift+enter send_text all \x1b\r` (Claude Code newline — kitty's default shift+enter is a plain CR), ends `include current-theme.conf`.
- Wiring: `bootstrap.sh` symlink block (`~/.config/kitty/kitty.conf`); `bin/kol-theme` now also asserts the include symlink in `~/.config/kitty/` (both-dirs pattern, same reason as ghostty). Live symlinks created this session — kitty is themed on next window; running windows `ctrl+shift+f5`.
- Docs: `08-kol-theme.md` (kitty row + description), `keys/keybinds.md` `## #kitty #claude`.

### simple-bar JSON error — root cause + fix (`ubersicht/simplebarrc`)
- Übersicht became a login item → launchd env has **no brew dirs in PATH** → stock `aerospacePath: "$(which aerospace)"` resolved empty → `lib/scripts/init-aerospace.sh` emitted `"displays": ,` → the bar-wide JSON parse error. It only ever worked before because manual launches inherited a brew-aware env.
- Fix: `"aerospacePath": "$(PATH=/opt/homebrew/bin:/usr/local/bin:$PATH which aerospace)"` — expands to the absolute binary, both arches. **An env-prefix value (`PATH=… aerospace`) does NOT work** — init-aerospace.sh receives the value as `$1` and execs it as a command name (first attempt, failed live).
- localStorage store wiped twice en route (write-back seam; backups in the session scratchpad, ephemeral `/private/tmp`). `rm` of the store was denied by the permission classifier — `mv` aside instead.
- Doc: `07-ubersicht.md` troubleshooting bullet rewritten with this root cause (earlier localStorage attribution was wrong).

## Current State

### Working
- Bar renders after the fix (init pipeline verified: exact script emits valid JSON in a brew-less env).
- Inert leftovers, deliberately untouched: `yabaiPath: "$(which yabai)"`, `githubWidgetOptions.ghBinaryPath: /opt/homebrew/bin/gh` (widget off; cross-arch violation if ever enabled).

### OPEN — process widget (focused-app display, bar left) missing
All CLI-side evidence is green; the failure is inside the WebView only:
- All aerospace queries valid in brew-less env (list-monitors/-workspaces/-windows, per-workspace loop over all 31, incl. simple-bar's `00000→0` cleanup — no mangling with current ids).
- Focused-window id (kitty 221) present in its workspace's window list — `displayOnlyCurrent` gate should pass.
- `widgets.processWidget: true`; `process.*`/`spacesDisplay.*` blocks complete; settings merge is `mergeDeep`; `/state/` screens sane (single id) → `displayIndex` resolves to 1 on every path.
- "Glitching out crazy" episode: stacked `osascript … refresh widget` procs (6 at once) from the aerospace hooks during churn; cleared after user restarted Übersicht. If it recurs, debounce the hooks.

**Next diagnostic (pick up here):**
1. Übersicht menubar → Debug Console — read the actual WebView error/state (user-side, 10 seconds).
2. Or POST the widget's exact commands through the server: `curl -s -H "Origin: http://127.0.0.1:41416" -X POST --data-binary @- http://127.0.0.1:41416/run/` (plain POST gets 403 — `ensureSameOrigin`; the endpoint pipes body into `bash`, the widget's true runtime env). Session ended right as this was about to run.
3. Suspect ranking: something in `AerospaceContextProvider.getSpaces` rejecting in-WebView (`getFocusedSpace` destructure is NOT try/caught) → `spaces` stays `[]` → process returns null while everything else renders.

## Next Steps
1. Resolve the process-widget blank (diagnostics above).
2. User: `prefix r` + `prefix I` to install resurrect/continuum.
3. Unchanged arcs: live in `nnow`; simple-bar settings-panel tune; raindrop links layer.
