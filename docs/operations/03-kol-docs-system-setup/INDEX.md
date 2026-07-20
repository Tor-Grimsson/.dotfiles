---
title: kol-docs system setup
type: index
status: active
description: The kol-docs skill trio (fm ⊂ md ⊂ lib), their packages, the shared Obsidian vault-config source, and the kol-appliant tool-doc standard — how a repo's docs system gets authored, structured, and configured.
updated: 2026-07-11
tags:
  - project/dotfiles
  - domain/ai/llm
  - framework/conventions
related:
  - "[[INDEX|tooling catalog]]"
  - "[[01-kol-appliant-tool-standard|kol-appliant standard]]"
  - "[[../claude/skills/kol-docs-fm/SKILL|kol-docs-fm skill]]"
  - "[[../claude/skills/kol-docs-md/SKILL|kol-docs-md skill]]"
  - "[[../claude/skills/scaffold-docs-system/SKILL|scaffold-docs-system skill]]"
  - "[[02-skills|Claude Code skills]]"
  - "[[02-obsidian|Obsidian]]"
---

# kol-docs system setup

Repo infrastructure for **authoring and structuring docs** — a russian-doll trio of skills, each backed by its own package, plus a shared Obsidian vault-config source repos symlink into. Built 2026-07-05 as a split of the former single `kol-docs` skill + `kol-docs-framework` package (now retired).

## The three tiers

| Tier | Skill | Package | Scope |
|---|---|---|---|
| Innermost | `kol-docs-fm` | `claude/packages/kol-docs/kol-docs-fm/` | Frontmatter contract only — required/recommended/optional fields, status enum, tag taxonomy. |
| Middle | `kol-docs-md` | `claude/packages/kol-docs/kol-docs-md/` | One whole doc — the 9 archetypes, filename/folder law, `_assets`/`_files`, wikilink form, the maintenance pass. Contains fm. |
| Outermost | `scaffold-docs-system` (was `kol-docs-lib`, renamed 2026-07-05) | `claude/packages/kol-docs/kol-docs-lib/` (package keeps the tier name) | A whole repo's docs system — the `documentation/` (subject) vs sibling machinery split, `.kol/docs-framework/` + agent state, contiguous numbering, render-target link rule, `.obsidian` picker. Contains md. |

fm ⊂ md ⊂ lib. Reach for the smallest tier that covers the job — "fix this file's frontmatter" needs only `kol-docs-fm`; "stand up this repo's docs/" needs `scaffold-docs-system`.

Each skill is self-contained (reads only its own package) and **local-authored** — won't ride a kol-system re-sync. A future re-sync still ships a single upstream `kol-docs`; reconcile it into `kol-docs-md`, don't let it re-add the old name.

## The tool-doc standard (kol-appliant)

Beyond authoring *a* doc, [[01-kol-appliant-tool-standard|kol-appliant]] is the completeness contract for documenting a **tool or solution** — its in-point install chain, category home, purpose surface (usage/hotkeys/use-cases/sources/links), `keys`/`files` accessibility, and dups map. The definition-of-done every tool ships against.

## The Obsidian vault-config source

`claude/packages/scaffold/02-scaffold-docs/obsidian-shapes/` holds the `.obsidian/` config every repo's docs vault can symlink (or copy) from — edit the source, every symlinked repo inherits it.

| Shape | Seeded from | For |
|---|---|---|
| `01-vault-shape/` | kol-monorepo | Rich general vault — plugins, snippets, themes, hotkeys, folder-notes, dataview. |
| `02-kol-vault-shape/` | kol-vault | The actual dedicated Obsidian vault — 30 enabled plugins. The richest shape. |
| `03-kol-ds-shape/` | kol-design-system | Minimal — core plugins only. |

Each shape is an openable mini-vault (a dummy note + `.obsidian/`) so you can test plugins directly at the source. Symlink mode is per-file, not whole-directory — `docs/.obsidian/` stays a real local dir with each file inside individually symlinked back to the shape, which is what lets `workspace.json` and the rest of the excluded list stay per-vault local and gitignored per repo instead of becoming one shared file (full exclusion list: [obsidian canon](../../claude/packages/kol-docs/kol-docs-lib/02-obsidian.md)). `scaffold-docs-system` offers a 6-way picker on setup: symlink (per-file) or copy (whole-dir), any of the 3 shapes.

## Scaffold wiring

`scaffold-docs-system` copies the three packages into a new repo's `.kol/docs-framework/{kol-docs-fm,kol-docs-md,kol-docs-lib}/` + writes a routing `INDEX.md` (this step was absorbed from the old `init-agent-context` 2026-07-05 — `scaffold-llm-context`, its successor, no longer touches docs-framework at all). **No automated sync exists** — `init-agent-context-sync`, which used to diff an already-scaffolded repo's copy against these sources and pull in updates, was quarantined 2026-07-05 (no evidence it was ever used across 6+ repos). Pulling a framework update into an already-scaffolded repo is a manual/conversational step now: re-run the copy step above, or hand-edit.

## Retired

`claude/packages/kol-docs-framework/` — its `01-conventions`/`02-archetypes`/`03-tag-taxonomy`/`_example`/`_templates` were migrated verbatim into the three packages above before deletion; nothing was lost, nothing condensed.

## See also

- [[02-skills|Skills]] — `kol-docs-fm`/`kol-docs-md` sit in the **Docs (3)** row there; `scaffold-docs-system` (the former `kol-docs-lib`) moved to **Agent-context & reinforcement (10)** since it also owns `.kol/docs-framework/` scaffolding now.
- [[02-obsidian|Obsidian]] — the app itself; this doc covers the shared config source it reads.
