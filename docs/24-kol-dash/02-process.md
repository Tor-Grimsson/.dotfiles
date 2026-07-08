---
title: Process
type: plan
status: active
updated: 2026-07-05
description: The wake-up bundle's phased design — what's built, what's a real next step, and what's still brainstorm (escalation ladder, multi-device reach, the iPad dashboard tie-in).
tags:
  - project/dotfiles
  - domain/automation
related:
  - "[[INDEX|kol-dash]]"
  - "[[01-automation|Automation]]"
  - "[[04-ipad-kiosk|iPad kiosk]]"
---

# Process

The origin ask was "a custom theme timer" — it grew into "extreme measures for when I genuinely won't wake up." This doc tracks that arc so a future session (or the user) can tell what's real vs. still an idea.

## Phasing

| Phase | What | Status |
|---|---|---|
| 1 | `os-mode.sh` — toggle/set/relative-timer theme control, Raycast-hotkeyed | **Built** — [[../12-scripts/18-appearance\|18-appearance]] |
| 2 | `theme-alarm.sh` — real clock-time bundle: theme + Focus + Spotify + Telegram, `launchd`-scheduled | **Built** — [[../12-scripts/18-appearance\|18-appearance]] |
| 3 | iPhone-side mirror — a Shortcut using the native **Alarm / Waking-Up** automation trigger (confirmed real, iOS/iPadOS only, syncs via iCloud) | Not started |
| 4+ | Escalation ladder, Jellyfin cast, iPad dashboard tie-in | Brainstorm only (below) |

## Why "wake every device" doesn't need a relay

The instinct is "the Mac tells the phone to do things." The realistic version is the opposite: **each device gets its own trigger at the same wall-clock time**, and neither commands the other.

- Mac: `launchd` calendar job (built).
- Phone: the Clock app's own alarm + a Shortcuts personal automation on the **Alarm** or **Waking Up** trigger (real, verified via Apple's own docs — not assumed).

No OAuth relay, no cross-device API needed for the core "multiple things happen at 7:15" requirement.

## Phase 3 brainstorm — iPhone-side mirror (not built)

- Confirm-you're-up gate: the shortcut requires a tap/reply within N minutes or the automation escalates.
- Force max volume + un-mute + exit silent mode before playing anything (a quiet phone defeats the point).
- Flash screen white / max brightness as a visual jolt.
- Speak today's weather + first calendar events aloud (Shortcuts has native TTS + calendar actions).
- HomeKit lights/plugs on, if any exist.
- Open Jellyfin/YouTube to a specific "get up" video automatically.

## Phase 4+ brainstorm — escalation + wider ecosystem (not built, real complexity)

- Real escalation ladder: no ack in 5 min → louder/different alarm; no ack in 10 min → the Telegram bot calls or texts a trusted contact.
- Jellyfin cast to the living-room TV as the "nuclear option," via Jellyfin's Sessions API — only works against a client that already has an active, open session; not a cold-start remote wake.
- Two-way Telegram: the nudge message carries an inline "I'm up" button; no tap, escalation continues.
- Location-aware: skip TV/Jellyfin cast entirely when not home.
- **[[04-ipad-kiosk|iPad dashboard]] tie-in:** the always-on screen shows "alarm fired at 7:15, not yet acknowledged" plus the morning brief (calendar/tasks) — fed by the *same* Telegram bot event so the alarm and the dashboard never need direct coupling to each other.

## Open questions (genuinely undecided, not just unbuilt)

- Should the escalation ladder live as more `theme-alarm.sh` flags, or move to a small stateful daemon once there's an "acknowledged?" concept to track? Flags stop scaling once state (did you ack, how many times has it escalated) enters the picture.
- Waking to Dark instead of Light is a one-line code change today, not a flag — add a flag only if it's actually wanted both ways.
