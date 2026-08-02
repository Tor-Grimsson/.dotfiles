# Session: parking-lot stale sweep — three entries deleted, three drifts fixed

**Date:** 2026-07-30
**Agent:** Claude Code (Grim)
**Summary:** Audited `llm-plan/01-parking-lot.md` against reality; deleted the three entries whose premise no longer holds and corrected three that had drifted. This log is their archive — they are not to be raised again.

## Deleted (archived here, gone from the lot)

### § macOS ricing 2025 (linkarzu) → see dedicated doc
Pointed at `docs/research/ricing-2025-backlog.md`, which **does not exist**. The entry was a pointer to nothing. Its content — a wishlist of btop, simple-bar, skitty-notes, a cross-tool colorscheme selector, tmux pane arrows, osascript menubar-hide, and linkarzu's dotfiles layout — is recoverable from this paragraph alone if it ever matters again.

### § AeroSpace keybind conflict — move off the Alt modifier
**Already done.** The premise was "AeroSpace's default modifier is Alt, which collides with Figma/Affinity". `aerospace/aerospace.toml` now carries **77 `ctrl-alt` binds**; the only bare-`alt` binds left are `alt-shift-hjkl` inside `[mode.service.binding]`, which are mode-local and cannot collide. Its fallback proposal — Caps Lock → Hyper via Karabiner-Elements — was raised again this session and **dropped by the user** ("you can't handle 6 or 7").

### § kol-glass shareable scaffold (public template) — BUILT 2026-07-28
Said BUILT in its own heading. `~/dev/projects/kol-dumpty/memory-glass` exists with a `.git`, README, INDEX, LICENSE, `docs/`, `sync.sh`; milestone log (46) records it published. A finished item sitting in a lot reserved for undecided ones.

## Drift corrected (entries kept)

| entry | was | now |
|---|---|---|
| § active → canonical status pass | "all 207 docs carry `status: active`" | **287** |
| § Dead-key Claude memory triage | "~30 orphaned dirs" (heading + body) | **57** |
| § Zero-friction torrent search | step 2 proposed the **iTerm2** Hotkey Window | Ghostty's built-in quick terminal (`toggle_quick_terminal` + a `global:` keybind) — the live terminal has been Ghostty since the 2026-07-29 audit |

## Current State

### Working
- Parking lot: **11 entries**, 173 lines, every premise checked against the machine this session.
- Confirmed still live, premises verified, not touched: gcalcli OAuth (`gcalcli agenda` still crashes), torrent consolidated guide (never built), mbp↔iMac reconcile (iCloud Workbox present on the iMac), doc-link syntax (explicitly ONGOING), skills-cut review, estate leftovers, AGENT-CONTEXT trim (recurring; 16 KB against a 30 KB trigger).

### Known Issues
- The first delete attempt this session anchored on a phrase that also appears in the file's intro, which duplicated 224 lines instead of removing 30. Repaired the same turn. The sweep above uses a `^## ` heading split, not phrase indexing — the correct way to slice these files.

## Next Steps
None. The lot holds only live questions; deleted entries live here and are not to be re-surfaced.
