---
name: kolds
description: One word that means "the kol-ds-ui design system" — the repo, its 15 @kolkrabbi packages, its consumers, its rules and docs. Loads the orientation so the user never has to re-explain which system they mean. Triggered by /kolds (user-invoked only).
---

# kolds — the design system, referenced in one word

Says: **we are talking about kol-ds-ui**, its packages, and everything downstream of them. Stop asking which repo, stop re-deriving the topology.

## The facts this loads

| thing | value |
|---|---|
| repo | `~/dev/projects/kol-ds-ui` |
| what it is | the design system — **the** package publisher of the estate |
| packages (15) | brand · brand-template · chess · component · content · dashboards · foundry · framework · icons · media-client · scrape · store · styleguide · theme · workshop — all `@kolkrabbi/*` |
| in-repo consumers | `showcase/` (11 packages) · `workbench/` (5) — the dogfood; they break first |
| downstream repos | kol-website `apps/web` (10) · kol-chess (6, and publishes `kol-chess` back) · kol-ds-fxr (4) |
| its own docs | `docs/` (kol-docs framework) · agent state in `.kol/llm-context/` |
| boot protocol | `LLM_RULES.md` — ARCHITECTURE → AGENT-CONTEXT → latest session log, then STOP and wait |
| lobby | `lobby/` at repo root — component specs staged for recreation (write side: `/lobby-ds`) |
| naming | it's **KOL**, never "DS" in code, comments or chat |

## On invocation

1. If the cwd is kol-ds-ui, follow `LLM_RULES.md` (context files first, then stop).
2. If it isn't, treat this as "the subject is the design system" and reason from the table above; read the repo's files before making claims about its code.
3. Never invent a package name — the 15 above are the set.

## Family

`/kolds-ref` — decisions must cite the system's existing tokens/components, not invent new ones. Same subject, stricter contract.
