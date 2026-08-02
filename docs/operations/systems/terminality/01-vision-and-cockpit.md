---
title: Vision & cockpit — the operating model
type: plan
status: draft
updated: 2026-07-11
description: The north star for kol-terminality — terminal-as-workstation, flexible layout over rigidity, agent-work as a first-class collaborator, the every-day-evolves ethos, and the multi-device cockpit (iPads, Apple TV via Blink, remote machines) that extends the desk.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|kol-terminality]]"
  - "[[02-workspaces|Workspaces]]"
  - "[[08-automation-and-ritual|Automation & ritual]]"
  - "[[09-connected-reach|Connected reach]]"
---

# Vision & cockpit

## The model

- **Terminal as workstation, not a rice.** The point is *working* in it — a better place to build, think, and ship, that improves a little every day. "The only constant is change" — the system has to grow with use, not freeze into a config.
- **Flexible layout over rigidity.** Don't over-fix it. Build *layout systems* and *ways of working within structures* — templates you drop into, not a single locked desktop.
- **Agent work is central.** Daily driver, no complaints on the work itself — the one gripe was output flooding (~80% of the beef with agents), now hard-gated by the footer rules. Agent work is a first-class citizen of the workstation, not a bolt-on.
- **Rarely leave the terminal.** The honest current state: "I make shit all the time but rarely leave the terminal" — and rarely surface it. The vision fixes both: keep the making *in* the terminal, and wire the reach *out* of it (see [[09-connected-reach|Connected reach]]).

## The cockpit (multi-device)

The desk isn't one screen. The imagined steady state:

- **Apple TV** running Blink → SSH into the two remote machines (see [[operations/04-remote-machine/03-tailscale-remote-access|tailscale/mosh remote access]]).
- **One iPad** as the daily-work display (today's work, live).
- **Another iPad** as the SSH/Blink client into the remotes.
- **tmux** holds sticky scripts always running; the **vault** is open, parsing new info; **dotfiles** grow; **git** syncs continuously.
- Every day the process evolves, things grow, the workflow improves — because the surfaces are always-on and always-visible.

## Why it needs building

Right now the process lives **in your head** — done daily, but unceremonial and untracked (you *log* daily, but don't *track*). The whole initiative is to externalize that: a v1 you can run, with a roadmap to grow. See [[08-automation-and-ritual|Automation & ritual]] for the ritual, [[02-workspaces|Workspaces]] for the layouts.

## Open questions
- What is the minimum "cockpit" that's actually useful day one vs. the full multi-device dream?
- Which surface is the *primary* one (the iMac desk, an iPad, the TV) and which are glances?
- How much layout should be fixed vs. summoned on demand?
