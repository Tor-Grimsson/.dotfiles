---
name: kol-migrate-structure
description: Converge a repo onto the .kol/ structure convention — move legacy agent-context (docs/llm-context, .claude/llm-context, .llm-context) and the doc framework (docs/_framework) into .kol/{llm-context, docs-framework}, backfill LLM_RULES.md, repoint every live reference, and optionally propose the docs/documentation numbered-section system. Use when init-agent reports a legacy layout, or the user says "migrate structure", "converge to .kol", "/kol-migrate-structure", or asks to modernize a repo's docs/context layout.
allowed-tools: Bash, Read, Edit, Write, Glob, Grep, AskUserQuestion
---

# kol-migrate-structure

Converge one repo onto the **`.kol/` convention** (established 2026-07-03; reference implementation: `kol-design-system`):

```
<repo>/
  LLM_RULES.md          ← boot pointer, read first by any agent
  .kol/
    llm-context/        ← ARCHITECTURE · AGENT-CONTEXT · plan · history · backlog/ · migration/ · session-log/
    docs-framework/     ← the kol-docs spec (was docs/_framework)
  docs/                 ← pure documentation vault, nothing else
```

Rationale: `docs/` stays 100% human-readable content; agent state and doc specs are machinery, hidden at root. `LLM_RULES.md` at root is how the convention communicates itself — any agent landing in a migrated repo reads it first.

## 1. Detect

Identify what exists: `docs/llm-context/` · `.claude/llm-context/` · `.llm-context/` · `docs/_framework/` · root `LLM_RULES.md` · loose planning docs (`docs/plan.md`, `docs/history.md`, `docs/backlog/`, `docs/migration/`). If everything is already under `.kol/` with an up-to-date `LLM_RULES.md`, say so and stop.

Show the user the planned moves as a short table and confirm before touching anything.

## 2. Move

- Legacy context dir → `.kol/llm-context/` (whichever variant exists; merge if several, newest wins on collisions — flag collisions, don't silently overwrite).
- `docs/_framework/` → `.kol/docs-framework/`.
- Planning/working docs (`plan.md`, `history.md`, `backlog/`, `migration/`) → into `.kol/llm-context/`.
- Plain `mv` — the user owns git.

## 3. Backfill LLM_RULES.md

If missing, create it: startup protocol (read `.kol/llm-context/{ARCHITECTURE,AGENT-CONTEXT}.md` + latest session log → stop and wait), a where-things-live table for THIS repo, and the house rules (log only when asked; user owns git; junk → gitignored `_tmp/`). Copy the shape from `kol-design-system/LLM_RULES.md`. If present, repoint its paths.

## 4. Repoint references

Grep the repo for every live mention of the old paths and fix them:

- `docs/llm-context` → `.kol/llm-context` · `docs/_framework` → `.kol/docs-framework` — in docs, code comments, scripts, READMEs, config.
- Wikilinks from `docs/` (the Obsidian vault) into `.kol/` **cannot resolve** (outside the vault) — convert those to standard relative markdown links `[text](../.kol/llm-context/plan.md)`. Wikilinks *within* `.kol/` are agent-read only; keep them path-correct.
- **Leave historical session-log bodies untouched** — they're point-in-time records.
- Verify: final grep for the old paths returns only session-log history; run any repo validators (e.g. taxonomy checks) that reference moved docs.

## 5. Optional — propose the docs system

If the repo's `docs/` is a flat mess (or has no design/system documentation), offer the **numbered-section documentation model** (reference: `kol-design-system/docs/documentation/`, modelled on kol-monorepo's `documentation/`):

```
docs/
  INDEX.md
  documentation/
    INDEX.md
    00-overview/INDEX.md        ← single-doc folders: INDEX is the doc
    01-<section>/01-<doc>.md …  ← numbered section folders, numbered files inside
    NN-research/<topic>/ …      ← research/reference folds in as subfolders
    NN-usage/                   ← generated folders keep their generator's naming
```

Rules: kol-docs framework throughout (frontmatter, closed tags, explicit wikilinks); subfolders XOR loose files per level; generated folders are exempt from the prefix law (record the exception in the repo's `docs-framework/01-conventions.md` if not already there). Propose the section map adapted to what the repo actually has — don't scaffold empty shells.

## 6. Report

List what moved, what was repointed, what was skipped, and any collisions left for the user. **No git, no session log unless asked.**
