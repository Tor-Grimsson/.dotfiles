---
title: Repo docs-library structure
type: reference
status: canonical
updated: 2026-08-01
description: The repo layer — how a whole docs/ tree is split (documentation vs machinery vs .kol), foldered, INDEXed, numbered, linked by render target, and how docs/INDEX.md answers the agent that reads it at boot.
tags:
  - framework/conventions
aliases:
  - structure
related:
  - "[[02-obsidian|obsidian]]"
---

# Repo docs-library structure

Where the `kol-docs-md` package governs one file, this governs the **whole `docs/` tree**.

## The three layers

| Layer | Home | Holds |
|---|---|---|
| **Subject** | `docs/documentation/` | What the repo *is about* — numbered sections `00-overview … NN`. |
| **Machinery** | `docs/<sibling>/` (e.g. `docs/operations/`) | Repo/CI/tooling process. A **sibling** of `documentation/`, never a numbered section inside it. |
| **Agent state** | `.kol/llm-context/` (repo root) | Architecture, context, session logs. **Outside** the Obsidian vault. |

The dividing question for any doc: *"is this the repo's subject, or the machinery around the repo?"* Subject → `documentation/`. Machinery → its own sibling folder. Agent-only → `.kol/`.

## Folder + INDEX law (library level)

- **Every section folder gets an `INDEX.md`.** At the single-doc tier "INDEX is a position, not a default"; at the library tier, any folder something *navigates into* is a routing position — so it earns one. **Missing INDEXes are the most common drift — reinforce it.**
- **Subfolders XOR loose files** at every level still holds.
- **Docs home** `docs/INDEX.md` routes to `documentation/` + each sibling. `documentation/INDEX.md` routes the numbered sections.

## The agent section — required in `docs/INDEX.md`

`docs/INDEX.md` is a **boot surface**, not only a router: `/ag-init` and `/agent-init` read it at
session start to learn what the repo has written down before improvising anything. So it has to
answer an agent, not just route a human. Every repo's docs home carries a section — conventionally
**`## For the agent — the read contract for this vault`** — and it is **authored per repo, never
pasted.** Its whole value is which handles work *here*.

Reference implementation: `kol-dumpty/humpty/docs/INDEX.md`.

| The section must state | Because |
|---|---|
| **`docs/` is the rules layer; `.kol/` is state** | `.kol/` carries history and current position. Neither is the law. An agent that boots on state alone knows what happened and not what is true |
| **Search by grep, not end to end** | the vault is written to be *found by name*. Say so, or it gets read like a book or not at all |
| **A summary is never the source** — with a table | this is the rule that earns the section. Several docs *enumerate* things living elsewhere: a register of filings, a tracker of targets, a verdict of an arc. A row is one line describing a document that may carry four concepts, and **a row that reads as terminal can be a compression, not a decision** |
| **The grep entry points**, literally | filing numbers, slugs, target ids, dated result files — the stable handles. Name the actual shapes (`\| 14 \|`, `D8`, `2026-08-01-`), not "use grep" |
| **What is deliberately NOT under `docs/`** | live state — `lobby/`, its ledger, a completion register. An agent that assumes `docs/` is everything will miss the queue addressed to it |

The summary-is-never-the-source table is the load-bearing half. Shape it as
**enumeration → …but answer from the source**, one row per index that could be mistaken for an
authority:

```markdown
| If the question is about | Open the enumeration | …but answer from the source |
|---|---|---|
| a filed critique | [[…/13-critique-register\|13 — critique register]] | `lobby/inbox/` + `lobby/archive/` |
| what a gate actually does | the tracker row or verdict | the predicate in `hooks/*.py` — the code is the contract |
| a law's exact wording | [[…/01-doctrine/INDEX\|01 — doctrine]] | the single injection source it points at |
```

**Placement:** directly under the router table, above the repo's live-thread block. An agent reads
top-down and stops early; the contract has to arrive before the content it governs.

## Numbering

Contiguous `00-…NN`, no gaps. Remove or move a section → **renumber the rest and repoint refs.** A gap is a rule set but not kept.

## Link form by render target

| File renders… | Use | Why |
|---|---|---|
| Inside the Obsidian vault (`docs/**`) | wikilinks `[[path\|display]]` | backlinks, graph, survives moves |
| Outside the vault (root `README.md`, `LLM_RULES.md`, GitHub-facing) | markdown `[text](path.md)` | wikilinks render as dead `[[…]]` there |
| Pointing *out of* the vault (to `.kol/…`) | markdown `[text](path)` | target isn't in the vault index |

`related:` frontmatter stays wikilinks regardless (metadata, never rendered outside Obsidian).

**Heading anchors are where this matters most.** GitHub/VS Code auto-slug headings to kebab-case (`#some-heading`) — Obsidian doesn't understand that form at all and fails silently (`"Unable to find selection"`). Obsidian only resolves anchors against the **literal heading text** (`#Some Heading`, case and spacing preserved). No core Obsidian setting fixes this — it's a long-standing open feature request, not a toggle. So any in-vault link that jumps to a section **must** be a wikilink with the literal heading text (`[[file#Some Heading|display]]`) — a markdown link with a GFM-slug anchor (`[display](file.md#some-heading)`) will silently fail to jump inside Obsidian even though the file-level link itself resolves fine.

## Out of scope

`LLM_RULES.md` is owned by the `scaffold-llm-context` skill, not this one — don't author it here.
