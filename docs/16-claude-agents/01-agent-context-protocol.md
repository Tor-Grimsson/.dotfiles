---
title: Agent-context protocol
type: reference
status: active
updated: 2026-07-05
description: How an agent session loads a project's state and logs its work — the LLM_RULES.md boot file, the .kol/ layout (llm-context + docs-framework at repo root), and the scaffold-llm-context / scaffold-docs-system / init-agent / log-work skills that drive it.
aliases:
  - agent-context-protocol
tags:
  - project/dotfiles
  - domain/ai/llm
related:
  - "[[02-skills|skills]]"
  - "[[05-working-rules|working rules]]"
  - "[[16-claude-agents/INDEX|Claude & Agents]]"
---

# Agent-context protocol

A portable convention every kol-system repo can carry, so any agent boots with the project's load-bearing decisions and current state — instead of re-deriving them each session. This repo (`~/.dotfiles`) carries it; so do `kol-media-admin`, `kol-design-system`, the vault, etc.

## The layout (`.kol/` — current convention, 2026-07-03)

A repo on the protocol has all machinery **hidden at repo root**, keeping `docs/` a pure documentation vault:

| Path | Archetype | Holds |
|---|---|---|
| `LLM_RULES.md` (repo root) | boot pointer | "read this first" — points the agent at `.kol/` + the house rules |
| `.kol/llm-context/ARCHITECTURE.md` | decisions | load-bearing calls, each `§N` with a "do not revisit unless…" |
| `.kol/llm-context/AGENT-CONTEXT.md` | state | current project state + the "Last updated" chain |
| `.kol/llm-context/session-log/` | logs | one `YYYY-MM-DD-slug.md` per session |
| `.kol/llm-context/{history,plan}.md` + `backlog/`, `migration/` | narrative/plans | the *why*, speculative work, working queues |
| `.kol/docs-framework/` | spec | the kol-docs framework the repo's docs conform to |

**Legacy layouts** (`docs/llm-context/` + `docs/_framework/`, or `.claude/llm-context/`, or `.llm-context/`) still boot — the skills check `.kol/` first, then fall back, and nag once: *"legacy layout — no automated migration skill exists; converge by hand or re-run `/scaffold-llm-context` + `/scaffold-docs-system` over it."* (`kol-migrate-structure`, the former automated converger, was quarantined to `_tmp/` 2026-07-05 — no supporting evidence it was ever used.) Reference implementation of the new shape: `kol-design-system`. Note: wikilinks from `docs/` into `.kol/` can't resolve (outside the Obsidian vault) — use standard relative links across that boundary.

## The driving skills

| Skill | Job |
|---|---|
| [scaffold-llm-context](02-skills.md) | scaffold the protocol into a repo — `LLM_RULES.md` + `.kol/llm-context/` only. Docs system is a separate skill (below) — neither depends on the other |
| [scaffold-docs-system](02-skills.md) | stand up/normalise a repo's whole `docs/` tree *and* `.kol/docs-framework/` (absorbed from the old `init-agent-context` 2026-07-05) |
| `init-agent` | load the context (ARCHITECTURE → AGENT-CONTEXT → latest session log) and **stop** — wait for a task; loads the three `agent-reinforce-*`/`agent-output-format` reinforcement skills first, detects the machine, checks session-bridge, nags on legacy layouts, and (guard: repo consumes `@kolkrabbi/*`) reports stale KOL packages via `pnpm/npm outdated`, asking before any bump — report-only, apply on explicit OK |
| `log-work` | **only when asked** — loads the same three reinforcement skills first, then writes a session log + prepends the AGENT-CONTEXT "Last updated" chain |
| `scaffold-dev-stack` | scaffold a new **headless** app (Vite + React + Tailwind 4, no design system) |
| `scaffold-dev-stack-kol` | scaffold a new app on the **published** `@kolkrabbi/kol-*` npm packages (4-point consumer contract wired) |

No automated re-sync/migration skills exist anymore (`init-agent-context-sync`, `kol-migrate-structure` — both quarantined 2026-07-05, no evidence of real use). Pulling framework updates into an already-scaffolded repo, or converging a legacy layout, is a manual/conversational step now.

Boot a session with `/init-agent` (or just "read `LLM_RULES.md`").

## Conventions that matter

- **ARCHITECTURE = immutable-ish.** Each `§N` is a deliberate call with a "do not revisit" clause. An agent proposing something that contradicts it must flag the contradiction first.
- **AGENT-CONTEXT "Last updated" chain.** Each session *prepends* a dated head entry; the previous head demotes to the first `Prior:`. The chain is **capped** (~5 entries) — older entries are dropped, but their content isn't lost: it lives in the session logs. (See `session-log/2026-06-26-agent-context-cap-convention.md`.)
- **One session = one log.** `session-log/YYYY-MM-DD-slug.md`, shape: `# Session: …` → Date/Agent/Summary → Changes Made → Current State → Next Steps. `log-work` writes it.
- **Dates are absolute.** Convert "today"/"yesterday" to ISO before writing.

## Related
- The docs *inside* `.kol/llm-context/` and the catalog docs both follow the [ponytail](../04-dev-languages/13-ponytail.md)-adjacent [kol-docs](02-skills.md) framework, but the agent-context protocol (this doc) is a **separate** convention — it governs the `llm-context/` state files, not the published-doc spec.
