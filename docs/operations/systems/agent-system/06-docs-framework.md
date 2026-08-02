---
title: 06 · Docs framework — the kol-docs spec
type: explainer
status: active
updated: 2026-07-28
description: The specification layer every doc conforms to — frontmatter contract, 9 archetypes, closed tag taxonomy, filename law, wikilink form — shipped as packages (kol-docs-fm/md/lib) with skills that read them, plus the scaffolds that stamp the system into new repos.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|kol-agent-system]]"
  - "[[07-human-tier|07 — human tier]]"
---

# 06 · Docs framework — the kol-docs spec

Docs are only searchable, graphable, and agent-usable because every file obeys one spec. The spec is a **package**; skills read it — never bundle it.

```
  claude/packages/kol-docs/          the canon (fm · md · lib)
        ▲               ▲
  kol-docs-fm       kol-docs-md      skills that read the canon
  (one file's       (one whole doc:
   frontmatter)      archetype+body)
        ▲
  scaffold-docs-system               stamps docs/ + framework into a new repo
  scaffold-llm-context               stamps .kol/llm-context + boot symlink
  scaffold-dev-stack(-kol)           stamps a working project around both
```

## The contract, compressed

| Layer | Rule |
|---|---|
| **Frontmatter** | `title · type · status · updated · description · tags · related` — status from a closed enum, dates real |
| **Archetypes** | 9 body shapes; playbooks require numbered sections (`## 0. Prerequisites` … `## N. Verification`) |
| **Tags** | List form, hierarchical, top-level namespace from a closed taxonomy |
| **Links** | Explicit-with-display wikilinks `[[path\|display]]`; sibling cross-refs go in **both** files' `related:` |
| **Filenames** | `NN-` prefix for docs; UPPERCASE for meta files (README, INDEX, HANDOFF) |
| **Doc shape** | Lookup first (summary ≤2 lines → deps table → steps → commands → flags), narrative after |

## The package rule

Skill **dependencies** (frameworks, templates, the canon) live in `claude/packages/` — never inside a skill. Skills reference the package path; the package is versioned once, consumed by many. This is the system's answer to skill drift.

## Export notes

- Ships as: the three package dirs + the two reading skills + the scaffolds — already engineered to be self-contained (the repo is portable to machines without kol-system).
- Public naming: from the bag when assigned; "kol-docs" is a working title outside KOL.
- One open export question: wikilinks vs standard markdown for stranger-facing repos (parked in dotfiles; the memory-glass answer was standard links).
