---
title: Every write and read path — skills, scripts, and which to reach for
type: reference
status: active
updated: 2026-08-01
description: The lobby-* skill family, bin/lobby, and clip-drop.sh — what each one writes, what each one reads, how to pick between them, and the checklists a writer and a closer each owe every time.
tags:
  - project/dotfiles
  - domain/tooling
  - pattern/cli
related:
  - "[[INDEX|Lobby]]"
  - "[[02-lifecycle|the ticket protocol]]"
  - "[[scripts/16-capture|clip-drop]]"
  - "[[operations/systems/claude-harness/02-skills|skills]]"
---

## Pick by what you have in your hand

| you have | reach for |
|---|---|
| a **conversation** — a finding with context, evidence, reasoning | `/lobby-<repo>` |
| a **screenshot** on the clipboard | `clip-drop.sh --<flag> NAME` |
| a **component** to hand to the design system | `/lobby-ds` |
| an **SVG icon** to promote into the shared set | `/lobby-icon` |
| nothing — you want to *see* the queue | `/lobby-list` · `bin/lobby` · `prefix Ctrl+K` |
| a queue you suspect has drifted | `/lobby-hygiene` |
| no idea | `/lobby` — the router asks |

## The skills

| skill | side | destination | emits |
|---|---|---|---|
| `/lobby` | router | — | asks: file · read · audit, then delegates |
| `/lobby-list` | read | current repo | the queue as a table; **does not start the work** |
| `/lobby-dotfiles` | write | dotfiles | a ticket from the conversation |
| `/lobby-humpty` | write | humpty | a behaviour brief, **user's wording verbatim** |
| `/lobby-web` | write | kol-website | a ticket from the conversation |
| `/lobby-ds` | write | kol-ds-ui | a component **spec to rebuild from**, not source |
| `/lobby-icon` | write | kol-ds-ui icon set | the **cleaned SVG** itself |
| `/lobby-hygiene` | audit | any | ledger-vs-reality diff, both directions |

Old names (`/kol-lobby`, `/kol-lobby-icon`, `/kol-lobby-hygiene`) still resolve for one cycle. The `kol-` prefix was dropped because it meant "design-system-specific" in two of them and "generic" in a third.

### Why `/lobby-ds` emits a spec and `/lobby-icon` emits a file

Consumer JSX carries app-specific wiring — fetch, routing, local state — and sometimes non-DS tokens. The design system recreates clean rather than importing mess, so the ticket is a **brief**. An icon is just an SVG: there is nothing to re-author, so the ticket carries the cleaned file.

### Why `/lobby-humpty` quotes verbatim

humpty's own rule: a brief's value **is** the user's exact wording. Paraphrasing a complaint about the agent's behaviour, *by that agent*, launders the evidence. Quote, then annotate separately.

## The scripts

| script | does |
|---|---|
| **`bin/lobby`** | fzf menu across all four lobbies — list · open · file · move. `prefix Ctrl+K`. Reads the registry, never a hardcoded list. `--outbox` prints the receipts: what each repo filed elsewhere and what came back with a remainder. |
| **`bin/clip-drop.sh`** | clipboard image → `<lobby>/inbox/NAME.md` + `<lobby>/_assets/`, **and appends the ledger row**. Flags derive from the registry: `--dotfiles`, `--humpty`, `--kol-website`, `--kol-ds-ui`; `--lobby` lists them. |
| **`bin/ref-lobby`** | the one-screen card — `ref-lobby states`, `ref-lobby where`, `ref-lobby file` |

## The registry is the only source of the list

`files/folders.md` § `lobby`. `clip-drop.sh` parses it at runtime, `bin/lobby` reads it, the skills read it. Nothing carries a copy — a hardcoded duplicate is how `ref-pick` silently lost three cards, and the same class of bug had `/lobby`'s "known lobbies" table three rows behind reality.

## What a writer must do, every time

1. Write `<lobby>/inbox/<slug>.md` — the entry shape in [[04-conventions|04-conventions]], with a `staged:` date.
2. Append the ledger row to `<lobby>/INDEX.md` at 🔵 `filed`.
3. Add a `History` line.
4. **Write the receipt in the filing repo** — `<this repo>/lobby/outbox/<same-slug>.md`, plus its row under **Filed elsewhere** in this repo's own ledger. Skip only when the current repo has no `lobby/` at all, and say so in the report.
5. Tell the user what landed, where, and that it is **not** started.

Steps 2–4 are not optional bookkeeping. An entry without a row is drift the moment it lands, and a ticket without a receipt is the same drift one repo over ([[02-lifecycle|02-lifecycle]] law 5).

## What a closer must do, every time

The mirror of the above, and the half that was missing until 2026-08-01:

1. Append `## ✅ RESOLUTION — <date>` to the entry, meeting **this** repo's bar.
2. Move it to `done/` (or `archive/`), update the ledger row, fix the count, add the History line.
3. **Return the receipt** — open the filing repo's `lobby/outbox/<slug>.md`, append `## ✅ RETURNED — <date>`, rewrite its `Last known` line, and name the **remainder**: what that repo still owes, or `none`. The field is never omitted.
4. No receipt there to return (a ticket filed before this existed, or by `clip-drop.sh` from a repo with no lobby)? **Write one**, dated from the entry's `staged:` line, going straight to `## ✅ RETURNED`.

Step 3 is [[02-lifecycle|02-lifecycle]] law 2 in its second direction. The entry header's `from a <repo> session` line is what tells you where to send it.
