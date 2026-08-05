---
title: notes system
type: reference
status: active
updated: 2026-08-04
description: Explainer cards — what a thing MEANS, filtered by words in section titles. Sibling engine to ref, deliberately separate because ref documents tools under a terse-cell lint and notes carries prose.
tags:
  - project/dotfiles
  - domain/scripts
  - pattern/cli
related:
  - "[[INDEX|Scripts index]]"
  - "[[scripts/ref-system/INDEX|ref-system]]"
---

## Summary
`notes` prints hand-kept explainer cards, glow-rendered, narrowed by words in their `## ` section titles. Where [[scripts/ref-system/INDEX|ref]] answers *what does this tool do*, notes answers *what does this mean*.

| command | does | needs |
|---|---|---|
| `notes` | list the cards | glow |
| `notes-shell` | the whole shell card | glow |
| `notes-shell <word>` | only sections whose title has that word | — |
| `notes-shell <word> <word>` | only titles containing BOTH | — |
| `notes-shell --help` | that card's section list | — |
| `notes --cards` | machine-readable card list | — |

## Setup
1. Data lives at `~/.dotfiles/notes/<card>.md`, one flat file per card.
2. Each card gets a three-line `bin/notes-<card>` alias — copy any existing one, `chmod +x`.
3. Nothing else. **There is no registry to update** — see below.

## Why it is not part of `ref`

| | |
|---|---|
| **It is a separate engine, not a separate format** | the dialect is identical — [[../../claude/skills/ref-admin/SKILL\|ref-admin]] is the arbiter for both, and `ref --lint` checks `notes/*.md` alongside `ref/*.md` |
| **What it answers** | ref: *which key, which flag*. notes: *what does `$` mean* — the thing you look up once and stop needing |
| **Why a separate engine at all** | its own namespace (`notes-<card>`), and a registry-free card list. Nothing about the file format differs |
| **What is shared** | the dialect, the lint, the glow theme (`ref/glow-style.json`), and both hard-won render fixes: `\| cat` to stop the pager erasing the card on quit, and `CLICOLOR_FORCE=1` because glow strips colour on a non-TTY |

## The directory is the registry
`bin/ref` carries a hand-written `card_list()` that drifted seven cards behind before `ref --cards` was added to read it. `bin/notes` lists `notes/*.md` instead, so there is no second place to keep in sync and no way for it to drift. Adding a card is: write the file, add the alias.

## Cards

| card | covers |
|---|---|
| `shell` | `$` — variables and expansion: names vs positional arguments, `${w:-80}` fallbacks, why quoting matters |

## Gotchas

| gotcha | fact |
|---|---|
| the lint covers this too | `ref --lint` reads `notes/*.md`. A notes card is not done until it passes — same 46-char cells, same no-per-row-spacers, same `doc:` targets. Prose goes in the paragraphs around the table |
| section titles are the filter | a word only narrows if it appears in a `## ` heading, so headings carry the searchable words |
| `$` in a shell | typing `notes-shell $` is asking the shell to expand something — narrow by a word in the title (`notes-shell variables`) instead |
