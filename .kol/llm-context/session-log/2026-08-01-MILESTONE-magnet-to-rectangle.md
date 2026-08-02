# 🏁 Milestone: Magnet → Rectangle — the floating layer becomes config

**Date:** 2026-08-01
**Agent:** Claude Code (Grim)
**Arc:** The window-snapping half of the desk — chased from "can Magnet have gutters?" through three wrong answers to an app whose entire configuration is `defaults` keys, tracked in the repo.
**Delivered:** Magnet retired. Rectangle installed, its geometry mirroring `aerospace.toml`, its 16 shortcuts written from `defaults.sh`, its plist exported to `macos/prefs/`, and the whole thing documented in three places.

## What closed

- **"Can Magnet have margins and gutters?"** → **done, answered NO by evidence.** Swept its entire preference domain for `gap|margin|padding|inset|spacing|gutter`: zero hits. Every key is `horizontalCommands`/`verticalCommands` — raw frames in a JSON blob — plus UI state. Magnet has no spacing model to configure.
- **"Can AeroSpace tile floating windows with gaps?"** → **done, NO.** `[gaps]` applies to tiled windows only; "floating" in AeroSpace means AeroSpace does not touch that window. `aerospace --help` confirms no positional command exists at all — the vocabulary is tree operations (`move`, `join-with`, `split`, `resize`, `swap`).
- **"What about Raycast?"** → **done, partially.** It has gaps (0–128px) and covers 18 of Magnet's 19 chords, but **one global value serves both the inner gutter and the screen-edge margin**, so it cannot express 304-right-on-one-monitor. Custom commands are Pro *and* ignore gaps. Ruled out on that.
- **The replacement** → **Rectangle.** `gapSize` separate from `screenEdgeGap{Top,Right,Bottom,Left}`, plus `screenEdgeGapsOnMainScreenOnly` — which maps exactly onto AeroSpace's `[{ monitor.main = N }, 10]` split. Every setting, including the keymap, is a `defaults` key.
- **The 11 chord collisions** → **done, structurally.** Previously ruled not-a-problem because AeroSpace wins them; retiring Magnet removed the question. Rectangle's ten letter-chords went to `cmd-ctrl` (verified zero AeroSpace bindings in that band); the six uncontested ones — four arrows, `⏎`, `⌫` — kept Magnet's exact chords, so the fingers lose nothing.
- **Rectangle's own trap** → **closed.** Its Todo feature ships bound to `⌃⌥N`/`⌃⌥B` = AeroSpace workspaces N and B. Both deleted, `todo` off, in `defaults.sh`.
- **`cl` alias** → `claude /ag-init`.

## The arc (brief)

- Opened on a gutter question about Magnet and took three wrong turns before landing: I read "aero windowsnapp" as AeroSpace, then as Windows Aero Snap, then finally as the Magnet→AeroSpace migration that had been asked twice. Two of those produced work nobody wanted, including three uninvited lines in `macos/defaults.sh` that had to be reverted.
- The through-line once it was actually read: **the floating layer had no configuration at all.** Magnet's geometry didn't exist, its keymap was an opaque blob, and it wasn't even in the Brewfile — an untracked app doing untracked things on contested keys.
- Rectangle wins on exactly one property: it is *addressable from a file*. Same snapping vocabulary as Magnet, plus sixths, minus the GUI.
- Also settled along the way: `/vim` is **not** a Claude Code command (asserted from memory, wrong, then wrong again — the false claim is removed from `ref-textmodes` and replaced with what's verified), and `appswitcher-all-displays` is now tracked in `defaults.sh`.
- Spans `session-log/2026-07-31-desk-scoping-ref-help-crash-safety.md` and the QuickLook and card-density logs of the same arc.

**No open threads.**
