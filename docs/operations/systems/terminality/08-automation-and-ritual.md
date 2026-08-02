---
title: Automation & ritual — login → work → close → track
type: plan
status: draft
updated: 2026-07-11
description: The process layer — turning the unceremonial, in-head daily workflow into a real ritual you can run (log in, open work, close work, track it), with a v1 and a roadmap; plus the lessons from the kol-studio dashboard arc and the idea of per-task personalities.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|kol-terminality]]"
  - "[[01-vision-and-cockpit|Vision & cockpit]]"
  - "[[09-connected-reach|Connected reach]]"
---

# Automation & ritual

The heart of the initiative: the process is done **daily but lives only in your head** — unceremonial, untracked (you log daily, you don't *track*). Build it. Even a v1 with a roadmap.

## The ritual (to design)
A repeatable **login → work → close → track** loop:
- **Log in / start** — one command spins up the day: the workspaces, sticky scripts, the vault, sync. (The "cockpit boot" — see [[01-vision-and-cockpit|Vision & cockpit]].)
- **Open work** — enter a workspace ([[02-workspaces|Workspaces]]) with its layout.
- **Close work** — a ceremonial end: stop timers, commit/sync, snapshot state.
- **Track** — capture what got done (feeds the notes/tasks surface, [[06-notes-and-tasks|Notes & tasks]]). Currently the missing piece — logging ≠ tracking.

**v1:** a `login`/`close` script pair + a simple work-tracker (append to a day log, or a markdown task tick). Roadmap: richer state, timers, the dashboard.

## The kol-studio dashboard arc (lessons)
The cautionary tale to learn from — a chain that ate itself:
1. dashboard expansion → 2. scripts to control **dark mode** → 3. a scripted **alarm clock with timers** → 4. **exposing script inputs + timer settings to a web app** (meant for the iPad) → 5. the **kol-studio dashboard idea ate all of it**.
- **The problem:** the dashboard is *uninspired* — and that's the **layout's** fault (self-diagnosed). The pieces (dark-mode control, timers, input-exposure, an iPad web surface) are good; the container was wrong.
- **The lesson for kol-terminality:** don't let one uninspired container swallow good primitives. Keep the primitives (dark-mode toggle, timers, exposed inputs, an iPad surface) as composable parts of the ritual, not locked inside a dashboard.

## Per-task personalities & process outlines
- Different **personalities for different tasks** — distinct agent personas/configs per kind of work (build vs research vs writing vs ops), each with its own process outline. Ties to the agent-work-is-central model ([[01-vision-and-cockpit|Vision]]) and the dispatch loop ([[09-connected-reach|Connected reach]]).

## Open questions
- What's the smallest useful v1 of the ritual — a script pair, or a TUI?
- Where does "track" write — the vault, a `kol-tasks` repo, a day-log file?
- Revive the dashboard primitives (dark-mode/timers/iPad web) as ritual parts — which first?
- How many personalities, and what triggers a switch?
