---
title: 07.03 · Fork plan
type: explainer
status: active
updated: 2026-07-28
description: What a fork keeps, cuts, and renames; the divergence points that motivate forking at all; naming (Humpty-Dumpty floated by the user); how it wires into jabberwocky.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[07-ponytail-fork/INDEX|ponytail fork]]"
  - "[[07-ponytail-fork/04-dependencies-and-license|dependencies & license]]"
---

# Fork plan

> **SUPERSEDED 2026-07-28, same day:** the user scrapped the fork. The product became **humpty-dumpty** — a clean-room plugin (reuse doctrine + 4-level muzzle stepper) written from our own spec and idioms at `~/dev/projects/kol-humpty-dumpty/humpty-dumpty/`, carrying no upstream license obligations. This doc stays as the evaluation record; [[07-ponytail-fork/02-mechanics|02-mechanics]] served as the clean-room spec.

## Keep · cut · rename

| Action | What |
|---|---|
| **Keep** | the runtime core: manifest, 2-hook wiring, the 5 node scripts, the 6 skills, the mode-state mechanism, LICENSE (with upstream copyright — see [[07-ponytail-fork/04-dependencies-and-license\|04]]) |
| **Cut** | dev bulk (benchmarks, tests, assets, examples) and — decision pending — the 10 other platform adapters; a Claude-Code-first fork keeps the repo small, the adapters can return if ever wanted |
| **Rename** | plugin name, command prefix (`/ponytail` → the fork's name), state-file name, skill names, all namespace strings in the 5 node scripts + manifest + hook wiring |

## Why fork at all — the divergence points

1. **Merge with our behavior stack:** one plugin carrying the laziness ladder AND the report-shape discipline (the jabberwocky 08 stack) instead of two systems injected separately.
2. **Steal the rebuild trick:** our reinforce payloads become mode-filtered builds from the skill source — one source of truth like ponytail has.
3. **Own the cadence:** tune modes, wording, and the ladder to this ecosystem instead of tracking upstream releases.

## Naming

User floated **Humpty-Dumpty** — chambered in the Alice bag since day one, and apt: the fork takes the plugin apart and puts it together *differently* (all the king's horses famously couldn't). One note for the decision, not against it: the local parent folder `kol-humpty-dumpty` already uses the name privately; a public plugin named `humpty-dumpty` coexists fine (different namespace) but the word would then live in both. **Name stays open until the user calls it.**

## Wiring into the export

The fork becomes the shipped form of jabberwocky's behavior-cadence layer — either as a payload under `modules/08-behavior/` or as a third sibling repo in the family. Decision belongs to the fork execution phase, not this doc.

## Execution steps (when the user says go)

1. Copy the runtime core from the 4.8.1 cache into a new repo skeleton.
2. Rename sweep (names table above), keep upstream LICENSE + add fork attribution line.
3. `node -c`-check the scripts, fixture-test both hooks, verify mode persistence with a scratch state file.
4. Publish protocol (token screen etc.) before the user's git.
