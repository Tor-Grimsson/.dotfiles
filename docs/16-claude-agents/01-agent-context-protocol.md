---
title: Agent-context protocol
type: reference
status: active
updated: 2026-07-03
description: How an agent session loads a project's state and logs its work — the LLM_RULES.md boot file, the docs/llm-context/ layout, and the init-agent-context / init-docs / log-work skills that drive it.
aliases:
  - agent-context-protocol
tags:
  - project/dotfiles
  - domain/ai/llm
related:
  - "[[02-skills|skills]]"
  - "[[16-claude-agents/INDEX|Claude & Agents]]"
---

# Agent-context protocol

A portable convention every kol-system repo can carry, so any agent boots with the project's load-bearing decisions and current state — instead of re-deriving them each session. This repo (`~/.dotfiles`) carries it; so do `kol-media-admin`, `kol-design-system`, the vault, etc.

## The layout

A repo on the protocol has:

| Path | Archetype | Holds |
|---|---|---|
| `LLM_RULES.md` (repo root) | boot pointer | "read this first" — points the agent at the context dir + rules |
| `docs/llm-context/ARCHITECTURE.md` | decisions | load-bearing calls, each `§N` with a "do not revisit unless…" |
| `docs/llm-context/AGENT-CONTEXT.md` | state | current project state + the "Last updated" chain |
| `docs/llm-context/session-log/` | logs | one `YYYY-MM-DD-slug.md` per session |
| `docs/history.md` | narrative | the *why* — alternatives considered, evolution |
| `docs/plan.md` | plan | speculative / not-yet-committed work |

Some repos use `.claude/llm-context/` or `.llm-context/` (vault-style) instead of `docs/llm-context/` (scaffolded-repo style) — the skills check all three, first match wins.

## The driving skills

| Skill | Job |
|---|---|
| [[02-skills\|init-agent-context]] | session boot — detect the machine (`uname -m`), read `LLM_RULES.md`, load the context dir |
| `init-docs` | load the context (ARCHITECTURE → AGENT-CONTEXT → latest session log) and **stop** — wait for a task |
| `log-work` | at session end — write a session log + prepend the AGENT-CONTEXT "Last updated" chain |
| `init-scaffold` | stamp the protocol onto a fresh repo |
| `init-agent-context-sync` | re-pull skills + `_framework` from kol-system (see §4) |

Boot a session with `/init-agent` (or just "read `LLM_RULES.md`").

## Conventions that matter

- **ARCHITECTURE = immutable-ish.** Each `§N` is a deliberate call with a "do not revisit" clause. An agent proposing something that contradicts it must flag the contradiction first.
- **AGENT-CONTEXT "Last updated" chain.** Each session *prepends* a dated head entry; the previous head demotes to the first `Prior:`. The chain is **capped** (~5 entries) — older entries are dropped, but their content isn't lost: it lives in the session logs. (See `session-log/2026-06-26-agent-context-cap-convention.md`.)
- **One session = one log.** `session-log/YYYY-MM-DD-slug.md`, shape: `# Session: …` → Date/Agent/Summary → Changes Made → Current State → Next Steps. `log-work` writes it.
- **Dates are absolute.** Convert "today"/"yesterday" to ISO before writing.

## Related
- The docs *inside* `docs/llm-context/` and the catalog docs both follow the [[04-dev-languages/13-ponytail|ponytail]]-adjacent [[02-skills|kol-docs]] framework, but the agent-context protocol (this doc) is a **separate** convention — it governs the `llm-context/` state files, not the published-doc spec.
