---
title: Wishlist & backlog — the command center
type: guide
status: active
updated: 2026-07-10
description: The full capture of every SketchyBar/menu-bar/command-center idea from the build sessions — the vision, the idea categories mapped to the right tool, and a check-off backlog to review later. Nothing here is lost even if it isn't built yet.
tags:
  - domain/productivity
related:
  - "[[INDEX|SketchyBar — complete guide]]"
  - "[[05-roadmap|Trendy roadmap]]"
  - "[[01-raycast|Raycast]]"
---

# Wishlist & backlog — the command center

The whole idea, captured so we can review the bunch later. `[x]` done · `[ ]` queued · `[?]` open question.

## The vision
A **personal command center**: SketchyBar as the always-visible glance + one-tap surface, and a **hotkey to summon** everything else. A click *or* a keystroke away. The pieces already exist — they're just not wired together:

| Piece | Role | You already have |
| --- | --- | --- |
| **SketchyBar** | ambient status + micro-action popups | the bar (this folder) |
| **Raycast** | the hotkey-summoned palette (search & run) | 6 script commands (`theme-*`, `aerospace-enable`, `alarm-*`) — scales to scripts/links/tasks/snippets |
| **tmux popups** | in-terminal summons | 4 already: scratch shell · yazi · lazygit · bookmark (+ sesh) |
| **`keys <tag>`** | shortcuts on demand | the `keys` cheatsheet tool |

## The constraint (what belongs where)
SketchyBar popups **cannot be dragged or resized** — they're bar-anchored overlays, not windows. So:
- **glance + one tap** → SketchyBar chip + tight popup
- **rich / searchable / resizable** → Raycast (hotkey) or a floating window — *not* a bar popup

## Your idea categories → where each lives
| Category | On the bar | Hotkey / palette | Source |
| --- | --- | --- | --- |
| **Claude** (status, usage) | chip (hook-fed) + usage meter | — | `Stop`/`Notification` hooks · `npx ccusage` |
| **Notifications** | a mute circle that "wakes up" (*report done* / *audit complete*) | — | Claude hook → `sketchybar --set` |
| **Tasks / todo** | count chip + check-off popup | add/check via Raycast | note-to-self list |
| **Scripts** | quick-run popup | search & run (Raycast Script Commands) | `bin/` |
| **Progress** (logged projects, time-on-project) | stat chip / popup | — | `session-log/` across repos |
| **Saved links / bookmarks** | — | Raycast Quicklinks | + the tmux bookmark popup |
| **tmux sessions** | chip ✓ (done) | sesh / tmux-sessionx picker | — |
| **Shortcuts** | — | — | `keys <tag>` |
| **Calendar** (gcalcli display) | agenda chip + popup | — | `cag`/`cday`/`cw`/`cm` |

## Backlog

### Done
- [x] Real icons (`icons.sh`) · correct font
- [x] Click → CLI preview popup · **left-click preview · ⌘-click full app · ⌥-click dismiss · one at a time**
- [x] Utility windows float (Settings/Calendar/Activity Monitor)
- [x] Apple power popup · htop over Activity Monitor
- [x] tmux **sessions** (not windows)
- [x] Theme → **Gruvbox** (warm, less purple) · popup border removed · popups tightened

### Queued
- [ ] **Claude notification bridge** ⭐ — hook → chip wakes with the job result
- [ ] **Usage meter** — session/week/period, red near the cap (`npx ccusage`)
- [ ] **gcalcli agenda widget** — next event on the chip, today's agenda in the popup
- [ ] **Launcher popup** — music player (rmpc) · saved layouts · edit configs (`$EDITOR`)
- [ ] **Script runner** — popup / Raycast list of `bin/` scripts
- [ ] **Tasks / todo** — count chip + quick-add & check-off
- [ ] **Progress: recently logged/documented projects** — from `session-log/` dates
- [ ] **Progress: most logged time per project** — aggregate session-log activity
- [ ] **Saved links / bookmarks** — Raycast Quicklinks + the tmux bookmark popup
- [ ] **Interactive terminal links** — Shift-click in tmux opens URLs; add custom Ghostty `link` regexes (clickable `file:line`, issues…)
- [ ] **App-menu mirror** — focused app's File/Edit/View in the bar (needs C helper)
- [ ] hover-reveal · volume slider · cpu graph · audio-device switcher (patterns in [[05-roadmap]])

### Open questions
- [?] **"windows switch if in view"** — workspace chips already run `aerospace workspace <n>`; what's the wanted behaviour (focus a visible window on another monitor? across displays?)
- [?] **Float terminal utilities** (htop / config editor) — needs a reliable window-title match; Ghostty `--title` didn't lock in testing

## Notes
- Now-playing widget stays off the list — macOS 15.4+ killed MediaRemote.
- Theme is Gruvbox to match the terminal stack (closes the old "still Mocha" item).
