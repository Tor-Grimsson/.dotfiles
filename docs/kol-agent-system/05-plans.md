---
title: 05 · Plans — the parking lot
type: explainer
status: active
updated: 2026-07-28
description: The future axis — .kol/llm-plan holds speculative and deferred work as structured entries (premise · shape · open questions · kill criteria) so AGENT-CONTEXT stays live-only. The three verbs: graduate, park, kill. Milestones feed it; it never leaks back as open TODOs.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|kol-agent-system]]"
  - "[[02-context|02 — context]]"
  - "[[03-journaling|03 — journaling]]"
---

# 05 · Plans — the parking lot

Ideas are cheap; open TODOs in a state file are expensive. `llm-plan/` is where futures wait without costing context.

```
                    graduate ──▶  AGENT-CONTEXT "Open items"  (it became real work)
  llm-plan/01-parking-lot.md
                    park     ◀──  milestones close threads here instead of carrying them
                    kill     ──▶  deleted — with the kill criterion that fired
```

## Entry anatomy

Every parked item carries four parts — enough that any future agent can pick it up cold:

| Part | Answers |
|---|---|
| **Premise** | Why this might matter at all |
| **Shape** | What building it would look like (plain filesystem ops — never git verbs) |
| **Open questions** | What's genuinely undecided, and whose call it is |
| **Kill criteria** | The observable condition under which this dies unbuilt — every entry must be killable |

## Rules

- AGENT-CONTEXT lists **live** work only; everything speculative lives here. A milestone drives open items to zero by resolving, parking (here), or closing.
- Entries record decisions when they close ("open questions resolved: X, Y") — the lot doubles as a decision log for futures.
- Nothing here is committed-to. The header says so explicitly; agents must not treat parked shape as approved plan.

## Export notes

- Ships as: the entry template + the three-verb rule + the milestone wiring ([[03-journaling|03]]).
- Near-zero coupling — this module is pure convention, the cheapest extraction after journaling.
- Scrub: template only; the real lot is private state.
