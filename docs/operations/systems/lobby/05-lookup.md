---
title: Lobby at a glance
type: reference
status: active
updated: 2026-08-01
description: One screen — the states, the four destinations, every command, the flow diagram, and the rules that bite. Everything else in this folder is the long version.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|Lobby]]"
  - "[[02-lifecycle|the ticket protocol]]"
  - "[[03-tooling|skills + scripts]]"
---

# At a glance

```
   YOU FIND SOMETHING            IT BELONGS TO
   THAT ISN'T YOURS TO FIX       ANOTHER REPO
            │                          │
            └────────────┬─────────────┘
                         ▼
              /lobby-<repo>  or  clip-drop.sh --<flag>
                         │
                         ▼
        ┌────────────────────────────────────┐
        │  <repo>/lobby/                     │
        │    INDEX.md  ← THE LEDGER          │
        │    inbox/    🔵 🟡 🟠 🔴           │
        │    done/     🟢                    │
        │    archive/  ⚪ ⚫                 │
        │    outbox/   receipts OUT and BACK │
        │    _assets/                        │
        └────────────────┬───────────────────┘
                         ▼
              that repo's agent, next session
                  /lobby-list  ·  bin/lobby
                         │
                         │  closes it — and in the SAME turn
                         ▼
        <the FILING repo>/lobby/outbox/<slug>.md
           ✅ RETURNED  ·  🟢 closed over there
           📌 Remainder here: what YOU still owe
                         │
                         ▼
              /ag-init, next session, back home
```

## States

| | state | means | lives in |
|---|---|---|---|
| 🔵 | filed | captured, unread | `inbox/` |
| 🟡 | read | understood, restated | `inbox/` |
| 🟠 | addressed | a fix shipped, unproven | `inbox/` |
| 🟢 | closed | met the bar | `done/` |
| ⚪ | parked | not-**now**, reason recorded — revisitable | `archive/` |
| ⚫ | retired | not-**ever**, reason recorded — terminal, never ages | `archive/` |
| 🔴 | needs-ruling | **flag** — blocked on you | anywhere |
| 📌 | remainder | **flag** — closed *there*, still owed *here* | `outbox/` |

## Where it goes

| about | lobby | skill | flag |
|---|---|---|---|
| scripts · configs · ref cards · desk | dotfiles | `/lobby-dotfiles` | `--dotfiles` |
| agent behaviour · muzzle · gates | humpty | `/lobby-humpty` | `--humpty` |
| site content · UI | kol-website | `/lobby-web` | `--kol-website` |
| components · tokens · DS | kol-ds-ui | `/lobby-ds` | `--kol-ds-ui` |

## Commands

| command | does |
|---|---|
| `/lobby` | the router — asks file · read · audit |
| `/lobby-list` | print this repo's queue |
| `/lobby-<repo>` | file the current conversation as a ticket |
| `/lobby-icon` | promote an SVG into the shared icon set |
| `/lobby-hygiene` | ledger-vs-reality audit |
| `bin/lobby` · `prefix Ctrl+K` | fzf menu over all four |
| `bin/lobby --outbox` | receipts: filed elsewhere · returned · 📌 still owed here |
| `clip-drop.sh --<flag> NAME` | screenshot → entry + ledger row |
| `ref-lobby` | this page, in the terminal |

## The bar for 🟢, per repo

| repo | closing costs |
|---|---|
| humpty | a **measurement** naming the brief |
| kol-ds-ui | a shipped version / changeset |
| kol-website · dotfiles | the user confirms |

## Rules that bite

| rule | consequence of breaking it |
|---|---|
| **The ledger is the truth** | an `ls` of `inbox/` mislabels parked entries as open |
| **`read` ≠ `closed`** | six understood briefs read as six fixed ones. None were |
| **Same turn** | work closed, ticket open — the queue lies until someone notices |
| **Same turn, BOTH ends** | ticket closed, filer never told — `agent-init-docs-index` closed in dotfiles with a remainder only kol-ds-ui can do, and kol-ds-ui has no record of it |
| **No entry without a row** | invisible ticket (`ShowSansItalicDisplay`, one day) |
| **No ticket without a receipt** | the same invisibility, one repo over |
| **Stale/closed is the USER's call** | the agent manufactures work out of your own rulings |

## The shape of an entry

```
# One-line title — the ask, not the symptom

**Staged:** YYYY-MM-DD · from a <repo> session
**Change:** how big it is

## The problem, in one case      ← the actual failure + its cost
## The fix                       ← files and lines where possible
## Rejected alternative          ← stops the next reader re-proposing it
## Definition of done            ← [ ] checkboxes, so the bar is provable
```
