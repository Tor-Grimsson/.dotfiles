---
title: kol-docs system setup
type: index
status: active
updated: 2026-07-05
description: The kol-docs skill trio (fm ⊂ md ⊂ lib), their packages, and the shared Obsidian vault-config source — how a repo's docs system gets authored, structured, and configured.
tags:
  - project/dotfiles
  - domain/ai/llm
  - framework/conventions
related:
  - "[[INDEX|tooling catalog]]"
  - "[[../claude/skills/kol-docs-fm/SKILL|kol-docs-fm skill]]"
  - "[[../claude/skills/kol-docs-md/SKILL|kol-docs-md skill]]"
  - "[[../claude/skills/kol-docs-lib/SKILL|kol-docs-lib skill]]"
  - "[[../16-claude-agents/02-skills|Claude Code skills]]"
  - "[[../09-productivity-desktop/02-obsidian|Obsidian]]"
---

# kol-docs system setup

Repo infrastructure for **authoring and structuring docs** — a russian-doll trio of skills, each backed by its own package, plus a shared Obsidian vault-config source repos symlink into. Built 2026-07-05 as a split of the former single `kol-docs` skill + `kol-docs-framework` package (now retired).

## The three tiers

| Tier | Skill | Package | Scope |
|---|---|---|---|
| Innermost | `kol-docs-fm` | `claude/packages/kol-docs-fm/` | Frontmatter contract only — required/recommended/optional fields, status enum, tag taxonomy. |
| Middle | `kol-docs-md` | `claude/packages/kol-docs-md/` | One whole doc — the 9 archetypes, filename/folder law, `_assets`/`_files`, wikilink form, the maintenance pass. Contains fm. |
| Outermost | `kol-docs-lib` | `claude/packages/kol-docs-lib/` | A whole repo's docs library — the `documentation/` (subject) vs sibling machinery split, `.kol/` agent state, contiguous numbering, render-target link rule, `.obsidian` picker. Contains md. |

fm ⊂ md ⊂ lib. Reach for the smallest tier that covers the job — "fix this file's frontmatter" needs only `kol-docs-fm`; "stand up this repo's docs/" needs `kol-docs-lib`.

Each skill is self-contained (reads only its own package) and **local-authored** — won't ride a kol-system re-sync. A future re-sync still ships a single upstream `kol-docs`; reconcile it into `kol-docs-md`, don't let it re-add the old name.

## The Obsidian vault-config source

`~/.dotfiles/obsidian/` holds the `.obsidian/` config every repo's docs vault can symlink (or copy) from — edit the source, every symlinked repo inherits it.

| Shape | Seeded from | For |
|---|---|---|
| `01-vault-shape/` | kol-monorepo | Rich general vault — plugins, snippets, themes, hotkeys, folder-notes, dataview. |
| `02-kol-ds-shape/` | kol-design-system | Minimal — core plugins only. |

Each shape is an openable mini-vault (a dummy note + `.obsidian/`) so you can test plugins directly at the source. `workspace.json`/`workspaces.json` (per-vault local UI state) are excluded and gitignored per repo. `kol-docs-lib` offers a 4-way picker on setup: symlink or copy, either shape.

## Scaffold wiring

`init-agent-context` copies the three packages into a new repo's `.kol/docs-framework/{kol-docs-fm,kol-docs-md,kol-docs-lib}/` + writes a routing `INDEX.md`. `init-agent-context-sync` diffs an already-scaffolded repo's copy against these sources per-file (`_template.version`) and pulls in updates — same replace/notify-only/skip policies as the rest of the scaffold.

## Retired

`claude/packages/kol-docs-framework/` — its `01-conventions`/`02-archetypes`/`03-tag-taxonomy`/`_example`/`_templates` were migrated verbatim into the three packages above before deletion; nothing was lost, nothing condensed.

## See also

- [Skills](../16-claude-agents/02-skills.md) — where the trio sits in the full skill catalog (Docs (3) row).
- [Obsidian](../09-productivity-desktop/02-obsidian.md) — the app itself; this doc covers the shared config source it reads.
