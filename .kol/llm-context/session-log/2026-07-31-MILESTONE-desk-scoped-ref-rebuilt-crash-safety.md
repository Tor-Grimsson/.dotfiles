# 🏁 Milestone: the desk layer scoped, the ref system rebuilt, crash safety closed

**Date:** 2026-07-31
**Agent:** Claude Code (Grim)
**Arc:** The out-of-terminal layer — every "this keybind half-works" complaint chased to its actual owner, the reference system that describes it made usable, and the data-loss hole underneath both sealed.
**Delivered:** Four desk bugs resolved at root cause (not worked around), `ref` grown 14→16 cards with a rebuilt glow-rendered help, an llm popup joining the popup band, and `swapfile`/`undofile`/`resurrect-capture-pane-contents` turned on after a crash proved they were all off.

## What closed

- **`cmd-alt-d` dock toggle looping** → **done.** macOS owns ⌥⌘D natively (`com.apple.symbolichotkeys` key 52, enabled). Ours made autohide flip twice per press. Bind and `bin/dock-toggle` deleted; the native chord still works. Rule recorded: check for a native shortcut before scripting a macOS toggle.
- **Window won't stay on the other display** → **done.** Not a double-fire — AeroSpace *rejection*. A tiled window belongs to a workspace and a workspace to one monitor, so Magnet's frame-move was re-tiled home inside the tick. `ctrl-alt-cmd-arrows` → `move-node-to-monitor --focus-follows-window --wrap-around`. Confirmed working live by the user after reload.
- **Magnet's 11 contested `ctrl-alt` chords** → **closed as not-a-problem** (user's call). AeroSpace registers the global hotkey first and swallows it, so nothing misfires and Magnet needed no disabling. The collision table stays in `ref-desk magnet clashes` as reference, not as a task.
- **"Übersicht doesn't open"** → **done.** It never does — `LSUIElement = 1`, an agent app whose menu-bar item is its entire UI. The icon was behind Hidden Bar's `›`. `localhost:41416` 400s on a Host-header guard; **`127.0.0.1:41416` serves the widget layer**. Debug Console is icon-only and unscriptable (`Uebersicht.sdef` = `refresh`/`reload`/`quit`).
- **Per-display scoping** → **done.** `gaps.outer.top`/`.right` are per-monitor arrays now, so the 304px widget gutter only exists where Übersicht draws it. Übersicht (`showOnMainScreen`/`showOnAllScreens`) and simple-bar (`showOnDisplay`) carry the widget half; AeroSpace itself has no per-monitor disable and never will.
- **`ref --help` was unhelpful** → **done.** Rewritten as markdown through the existing `show()`/glow: a real usage table with the `ref-bingo ping pong` form, the AND-narrowing rule stated (cards have no subsections — zero `###` across all of them), one dialect in the Cards column, the orphaned filter paragraph folded in. Per-card `--help` is a table too.
- **`ref-pick` drift** → **done.** It carried a hardcoded 11-card array and had silently lost `skill`, `humpty`, `repo`. Now reads `ref --cards`; the drift class is gone.
- **nvim alt-arrows half-working** → **done.** Mapped in normal mode only, so insert-mode Alt-→ became `Esc`+`f` and flash.nvim grabbed the pending find-char (the grey italic dim). Explicit insert maps added.
- **`ref-llm` / markdown findability / "which vim am I in"** → **done.** Cards `llm` and `textmodes` added with wrappers; `Markdown — md prose` section in `ref-nvim`; `cwd` shell function carded in `ref-shell`.
- **Unsaved-text loss** → **closed, with the cost paid.** A tmux crash destroyed unsaved nvim notes and **nothing was recoverable**: `swapfile = false`, no `undofile`, resurrect saving layout without pane contents. Three independent reasons, all three now on. The lost text is not coming back; the hole is shut.

## The arc (brief)

- Opened on a stale `ref-desk widgets` card and three "does this even work?" questions about Übersicht. Every one turned out to be a *different owner* than assumed — macOS, AeroSpace, Hidden Bar, a Host-header guard.
- The through-line: **nothing here was broken, everything was double-owned.** Two apps on one chord, two toggles on one flag, a card describing a GUI path a keybind already covered. The fix each time was deciding who owns it, not adding code.
- Five of my own wrong turns are recorded in the day's session log — the useful one being that Magnet stores every chord in both its axis sets, which is normal, and cross-checking that false lead is what surfaced the 11 real collisions.
- Then the tmux crash, which turned an ordinary cleanup day into a data-loss post-mortem. That the three safeties were *all* off is the finding worth keeping.
- Spans `session-log/2026-07-31-desk-scoping-ref-help-crash-safety.md`.

**No open threads.**
