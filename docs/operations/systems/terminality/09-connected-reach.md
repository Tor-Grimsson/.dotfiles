---
title: Connected reach — past the desk
type: plan
status: draft
updated: 2026-07-11
description: Wiring the workstation's reach beyond the terminal — Claude app dispatch (mobile↔desktop), the telegram bot (todoist, gcalcli, obsidian) plus Claude's own gcal access, per-task personalities on the wire, and automation that nudges you to actually share the things you make.
tags:
  - project/dotfiles
  - domain/tooling
  - domain/ai/llm
related:
  - "[[INDEX|kol-terminality]]"
  - "[[01-vision-and-cockpit|Vision & cockpit]]"
  - "[[08-automation-and-ritual|Automation & ritual]]"
---

# Connected reach

Use the entire stack for maximum reach — the terminal is the workshop, but the work has to get *out*. The honest gap: "I make shit all the time but rarely share it."

## Dispatch (mobile ↔ desktop)
- **Claude app 'dispatch'** — mobile↔desktop integration so work started on the phone/iPad continues at the desk and vice-versa. Ties to the multi-device cockpit ([[01-vision-and-cockpit|Vision & cockpit]]) and the Blink/SSH remotes.

## The telegram bot
- Existing bot fronting **todoist, gcalcli, obsidian**. Claude **also** has gcal access — so there are two paths to the calendar; decide the division of labor (bot for capture-on-the-go, Claude for reasoning/planning).
- Candidate hub for the "track"/reminder flows from [[08-automation-and-ritual|the ritual]].

## Personalities on the wire
- Per-task **personalities** (from [[08-automation-and-ritual|Automation & ritual]]) exposed across surfaces — the right persona answers on the right channel.

## Publicity / sharing automation (the real want)
- Automate **nudges to share** what gets made — a simple post, an image, a new tool being tested, a script just written. You make things constantly and rarely leave the terminal to surface them.
- Shape: a helper that notices "you made/shipped a thing" and prompts a share (draft a post, grab a screenshot/asset, queue it). Low-friction, terminal-native.

## Open questions
- Dispatch: what actually needs to hand off mobile↔desktop (context? a running session? a task queue)?
- telegram bot vs Claude for calendar — who owns what?
- Publicity nudges: manual "share this" command, or automatic detection of "made a thing"?
- Which channels are in scope (X/Twitter, blog, etc.) and how much drafting is automated?
