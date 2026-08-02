# Handoff — 2026-07-31 01:12

## Goal of the current arc

`aero-add` is built and working; the arc is now **live use, not construction**. Every fix in it came from the user driving it, never from review — so the next move is to leave it alone until he hits something, and fix only what he reports.

## Last actions taken (causal trail, newest first)

- **Parking-lot stale sweep** — deleted 3 entries whose premise no longer held (ricing → dead pointer; AeroSpace-off-Alt → already done, 77 `ctrl-alt` binds; kol-glass scaffold → BUILT and published). Corrected 3 drifts (207→287 docs, ~30→57 memory dirs, iTerm2 Hotkey Window → Ghostty `toggle_quick_terminal`). Archived in `session-log/2026-07-30-parking-lot-stale-sweep.md`.
- **The window-catch bug** — `list-windows --all --app-bundle-id …` exits 2 (`--all` conflicts with filtering flags) and `2>/dev/null || true` hid it. Every run reported `0 open window(s) moved`; a `layout floating` rule left the already-open window tiled and no reload could fix it. Now `--monitor all`. Verified live on Jellyfin.
- **Auto-reload removed, `r` added** — `enter` writes and re-opens the form on the same app (`AERO_ADD_FORM` re-exec) so `r` stays reachable; `esc` back to the list; the `ctrl-r` I'd added to the list removed.
- Form rebuilt from the user's own five-line sketch (two toggles, not a 34-row menu), then keyed by row number after `w` collided with W-for-Window.
- Milestone logged for the desk-keybinds arc; `ref-desk`/`ref-grep` renamed to the `tool — topic` form.

## Current state / open decision points

- **No open tasks.** AGENT-CONTEXT "Open items" reads none; the parking lot holds 11 live questions, none of them this arc's.
- One live generated rule in `aerospace/aerospace.toml`: `tv.jellyfin.player → floating`, written by the user during testing. Intentional, leave it.
- The tmux bind (`bind C-w`, `-EE`, 50%×50%) needs a `prefix r` to arm if he hasn't reloaded since.
- The only thing left unresolved on aero-add itself: `r` reloads config globally but window-moves happen per-app at write time. If he ever edits three apps and expects one `r` to move all three apps' existing windows, that's the gap. **Not written down anywhere on purpose** — it's speculative, and he asked me to stop inventing issues.

## Next intended action

- Nothing. Wait for him to use it and report. Do not review, refactor, or "improve" `bin/aero-add` unprompted.

## Working memory not yet in AGENT-CONTEXT

- **He is out of patience with this agent.** Multiple hard callouts this session: automation he didn't ask for (the auto-reload), settled items reprinted, cryptic concerns handed back instead of resolved, and a status answer that listed closed items as if they were open. Three skills were written mid-session as the correction — `tmpl-yn`, `tmpl-done`, `tmpl-path` — plus `humpty/lobby/no-path.md` porting the diagnosis to the muzzle repo. **Read those three skills before the next reply to him.**
- His standing rules that were broken and matter most: **zero is a valid answer** — don't pad a status reply with closed items; when something is not open, **delete it** and let the session log be the archive; don't automate what he didn't ask for.
- Two of my test runs wrote to his live `aerospace.toml` (a stray jellyfin rule, and `com.apple.ActivityMonitor` moved out of its hand-written group). Both restored byte-identical. **Back up before destructive testing, and prefer apps that have no rule.**
- A phrase-anchored slice duplicated 224 lines of the parking lot earlier. Split these files on `^## ` headings, never on a phrase that might recur in an intro.
- macOS ships bash 3.2 here — a fractional `read -t` is floored to 0. Cost an escape-sequence bug that looked fixed and wasn't.
- `bin/agent-grant` still has no `--help` (89/90 on `help-lint`). Pre-existing, unrelated, not worth raising unprompted.
