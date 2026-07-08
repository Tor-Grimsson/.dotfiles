---
title: Agent-context protocol
type: reference
status: active
updated: 2026-07-08
description: How an agent session loads a project's state and logs its work — the symlinked LLM_RULES.md boot file, the .kol/ layout (llm-context + docs-framework at repo root), and the scaffold-llm-context / scaffold-docs-system / kol-migrate-structure / agent-init / log-work skills that drive it.
aliases:
  - agent-context-protocol
tags:
  - project/dotfiles
  - domain/ai/llm
related:
  - "[[02-skills|skills]]"
  - "[[05-working-rules|working rules]]"
  - "[[operations/02-claude-agents/INDEX|Claude & Agents]]"
---

# Agent-context protocol

A portable convention every kol-system repo can carry, so any agent boots with the project's load-bearing decisions and current state — instead of re-deriving them each session. This repo (`~/.dotfiles`) carries it; so do `kol-media-admin`, `kol-design-system`, the vault, etc.

## The layout (`.kol/` — current convention, 2026-07-03)

A repo on the protocol has all machinery **hidden at repo root**, keeping `docs/` a pure documentation vault:

| Path | Archetype | Holds |
|---|---|---|
| `LLM_RULES.md` (repo root) | boot pointer | **A symlink** to the one generic boot file in dotfiles (`…/scaffold/03-scaffold-llm-context/LLM_RULES.md`), **gitignored**. Identical across every repo — startup protocol + where-things-live + house rules. **Never hand-authored per repo**; project-specific facts live in `.kol/llm-context/`, never in the boot file. Owned by `scaffold-llm-context`. |
| `.kol/llm-context/ARCHITECTURE.md` | decisions | load-bearing calls, each `§N` with a "do not revisit unless…" |
| `.kol/llm-context/AGENT-CONTEXT.md` | state | current project state + the "Last updated" chain |
| `.kol/llm-context/session-log/` | logs | one `YYYY-MM-DD-slug.md` per session |
| `.kol/llm-context/{history,plan}.md` + `backlog/`, `migration/` | narrative/plans | the *why*, speculative work, working queues |
| `.kol/docs-framework/` | spec | the kol-docs framework the repo's docs conform to |

**Legacy layouts** (`docs/llm-context/` + `docs/_framework/`, or `.claude/llm-context/`, or `.llm-context/`) still boot — the skills check `.kol/` first, then fall back, and nag once: *"legacy layout — run `/kol-migrate-structure` to converge it onto `.kol/`."* (`kol-migrate-structure` was quarantined to `_tmp/` 2026-07-05 for lack of evidence it was ever used, then restored the same day.) As of 2026-07-08 `kol-migrate-structure` relocates the legacy content, then **delegates** the boot symlink to `scaffold-llm-context` and the framework + `docs/` vault to `scaffold-docs-system` — it no longer reimplements them (that reimplementation was the source of the boot-file symlink-vs-author contradiction). Reference implementation of the new shape: `kol-design-system`, `kol-design-editor`. Note: wikilinks from `docs/` into `.kol/` can't resolve (outside the Obsidian vault) — use standard relative links across that boundary.

## The driving skills

| Skill | Job |
|---|---|
| [[02-skills|scaffold-llm-context]] | scaffold the protocol into a repo — `LLM_RULES.md` + `.kol/llm-context/` only. Docs system is a separate skill (below) — neither depends on the other |
| [[02-skills|scaffold-docs-system]] | stand up/normalise a repo's whole `docs/` tree *and* `.kol/docs-framework/` (absorbed from the old `init-agent-context` 2026-07-05) |
| [[02-skills|kol-migrate-structure]] | convert a **legacy** repo → `.kol/` — relocate old content, then **delegate** the boot symlink + framework/docs to the two scaffolders above (orchestrator, not a reimplementation) |
| [[02-skills|kol-docs-overview]] | orientation front door — one read of the whole `.kol/` + `docs/` structure and who-owns-what, before reaching for a doer |
| `agent-init` (renamed from `init-agent` 2026-07-05) | load the context (ARCHITECTURE → AGENT-CONTEXT → latest session log) and **stop** — wait for a task; detects the machine, checks session-bridge, nags on legacy layouts, (guard: repo consumes `@kolkrabbi/*`) reports stale KOL packages via `pnpm/npm outdated` asking before any bump, then loads `/agent-reinforce` **last** — right before reporting "Context loaded" |
| `log-work` | **only when asked** — writes a session log + prepends the AGENT-CONTEXT "Last updated" chain, then loads `/agent-reinforce` last, right before the "Session log created" report |
| `log-work-handoff` | **only when asked** — writes a forward-looking session-bridge handoff, then loads `/agent-reinforce` last, right before the "Handoff created" report |
| `agent-reinforce` | bundles the three reinforcement skills (`agent-output-format`, `agent-reinforce-rules`, `agent-reinforce-memory`) into one call — used as the **last** step, right before reporting status, by `agent-init`, `log-work`, `log-work-handoff`, and the plain `LLM_RULES.md` boot path |
| `scaffold-dev-stack` | scaffold a new **headless** app (Vite + React + Tailwind 4, no design system) |
| `scaffold-dev-stack-kol` | scaffold a new app on the **published** `@kolkrabbi/kol-*` npm packages (4-point consumer contract wired) |

No automated re-sync skill exists anymore (`init-agent-context-sync` — quarantined 2026-07-05, no evidence of real use). Pulling framework updates into an already-scaffolded repo is a manual/conversational step now. Converging a legacy layout is still automated — `kol-migrate-structure` (briefly quarantined, then restored same day 2026-07-05).

Boot a session with `/agent-init` (or just "read `LLM_RULES.md`") — both now load `/agent-reinforce` as their last step, right before reporting status.

## Conventions that matter

- **ARCHITECTURE = immutable-ish.** Each `§N` is a deliberate call with a "do not revisit" clause. An agent proposing something that contradicts it must flag the contradiction first.
- **AGENT-CONTEXT "Last updated" chain.** Each session *prepends* a dated head entry; the previous head demotes to the first `Prior:`. The chain is **capped** (~5 entries) — older entries are dropped, but their content isn't lost: it lives in the session logs. (See `session-log/2026-06-26-agent-context-cap-convention.md`.)
- **One session = one log.** `session-log/YYYY-MM-DD-slug.md`, shape: `# Session: …` → Date/Agent/Summary → Changes Made → Current State → Next Steps. `log-work` writes it.
- **Dates are absolute.** Convert "today"/"yesterday" to ISO before writing.

## Related
- The docs *inside* `.kol/llm-context/` and the catalog docs both follow the [[13-ponytail|ponytail]]-adjacent [[02-skills|kol-docs]] framework, but the agent-context protocol (this doc) is a **separate** convention — it governs the `llm-context/` state files, not the published-doc spec.
