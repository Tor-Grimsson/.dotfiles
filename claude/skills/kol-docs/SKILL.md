---
name: kol-docs
description: Author or normalise markdown docs to the kol-docs framework — the Obsidian doc spec (frontmatter contract, 9 archetypes, status enum, closed tag taxonomy, filename/prefix + folder law, _assets/_files handling, explicit wikilinks). Use when writing a new doc in a kol-docs vault, or normalising an existing docs folder to the spec. NOT for organising client design-asset folders (use client-normalise) or publication raw media (use publication-mirror) — those emit a doc layer; THIS is the underlying doc spec they conform to.
---

# kol-docs

The spec every doc in a `kol-docs/` vault conforms to: how docs are typed, named, tagged, frontmattered, cross-linked, and foldered. Two jobs — **author a new doc** and **normalise an existing folder** to the spec.

Sibling skills [[client-normalise]] and [[publication-mirror]] organise *media* then emit a kol-docs doc layer. This skill IS that doc layer's spec — reach for it when the work is the docs themselves.

## Canon — read before acting

Canon lives in the shared package `~/.dotfiles/claude/packages/kol-docs-framework/` (copied from the canonical kol-system source — re-sync with [[init-agent-context-sync]]):

- `~/.dotfiles/claude/packages/kol-docs-framework/01-conventions.md` — frontmatter schema, status enum, filename + folder rules, `_assets`/`_files`, wikilink form, maintenance.
- `~/.dotfiles/claude/packages/kol-docs-framework/02-archetypes.md` — the 9 types, per-type schema + body shape, decision tree.
- `~/.dotfiles/claude/packages/kol-docs-framework/03-tag-taxonomy.md` — the 10 top-level tag namespaces (closed set).
- `~/.dotfiles/claude/packages/kol-docs-framework/_example/` — fully-applied reference vault (fictional "kol-zine"). **Copy-from shapes for all 9 types.**
- `~/.dotfiles/claude/packages/kol-docs-framework/_templates/` — Obsidian Templater files (`<% %>`), the in-vault new-file mechanism.

The tables below are enough to act. Open the canon for full detail, edge cases, and copy-shapes.

## Workflow A — author a new doc

1. **Pick the archetype** by *why the reader opens it* (decision tree in `02-archetypes.md`).
2. **Copy the nearest `_example/` doc** of that type as the starting shape — don't write frontmatter from memory.
3. **Fill frontmatter** — required set + recommended + any archetype-specific fields.
4. **Tag** from the closed namespaces. List-form, hierarchical, 2–3 levels, reuse existing leaves.
5. **Name + place** — kebab-case, correct `NN-`/date prefix, into a folder that obeys the folder law.
6. **Link** with explicit wikilinks `[[01-colors|colors]]`. Add `related:` where it helps.

## Workflow B — normalise an existing folder

Per doc, in order:

1. **Assign archetype** → set `type:`.
2. **Fix frontmatter** — add missing required fields, fix `status`, `updated`, `description`.
3. **Fix tags** — map to closed namespaces, drop `type/`/`status/` duplicates, collapse over-deep tags.
4. **Fix filename + prefix** — kebab-case, correct `NN-`/`YYYY-MM-DD-`, INDEX exempt.
5. **Fix folder shape** — subfolders XOR loose files (never both); INDEX only where it adds signal.
6. **Fix supporting files** — renderable → `_assets/`, non-renderable → `_files/`, placed at closest common ancestor.
7. **Fix wikilinks** to explicit form; sync `aliases:`.
8. **After bulk moves:** reload Obsidian, grep old filenames across `.md`, spot-check links.

## Frontmatter contract

| Tier | Fields |
|---|---|
| Required (every doc) | `title` · `type` · `status` · `updated` (ISO) · `tags` |
| Recommended | `description` · `related` · `aliases` |
| Optional | `created` · `verified` · `audience` · `superseded_by` · `drift` |

Archetype-specific: `covers` `sources` `providers` `placeholders` `prerequisites` `phases` `repo` `date_range` `supersedes` etc. — see `02-archetypes.md`.

## The 9 archetypes

| `type` | Does | Typical file |
|---|---|---|
| `index` | Routes to other docs | `INDEX.md` |
| `reference` | Evergreen lookup / specs / tables | `01-colors.md` |
| `guide` | How to build/use X (concept + code) | `01-build-system.md` |
| `playbook` | Sequential copy-paste runbook | `01-prerequisites.md` |
| `plan` | Forward-looking proposal | `2026-05-18-restructure.md` |
| `decisions` | Locked ADR-style calls | `01-architecture/INDEX.md` |
| `audit` | Current-state snapshot | `02-audit/INDEX.md` |
| `narrative` | Long-form story / retro | `01-design-system.md` |
| `log` | Session record (one per session) | `2026-05-18-initial-build.md` |

## Status enum

`draft` → `active` → `canonical` (locked; trust without verifying) → `superseded` (set `superseded_by:`) → `archived`.

## Tag taxonomy — closed top-level set

`project/` · `domain/` · `audience/` · `provider/` · `integration/` · `pattern/` · `brand/` · `editor/` · `archive/` · `framework/`

List-form, hierarchical, 2–3 levels max, reuse leaves. Never tag `type/` or `status/` (those are fields). New top-level namespace requires editing `03-tag-taxonomy.md` first.

## Filename + folder law

- Kebab-case, lowercase, `.md`, no spaces. **Every file gets a prefix** (`INDEX.md` exempt): `NN-` (sequential = read order, catalog = display priority) or `YYYY-MM-DD-` (dated folders).
- At any level: `INDEX.md` (only when it adds signal) + `_assets/`/`_files/` (when needed) + **either subfolders OR loose files, never both**.
- `_assets/` = renderable media, embed `![[name.png]]`. `_files/` = non-renderable, link `[[name.txt]]`. Place at closest common ancestor of referencing docs; promote upward if shared.
- Wikilinks: **explicit form** `[[01-colors|colors]]` (immune to index state). `aliases:` powers Quick Switcher only — keep in sync on rename.

## Non-negotiables

1. **Copy from `_example/`, don't hand-write frontmatter** — drift starts there.
2. **Closed tag set** — fit an existing namespace before inventing one; if genuinely new, edit `03-tag-taxonomy.md` first.
3. **Subfolders XOR loose files** at every level. Mixing breaks numeric sort in Finder + Obsidian.
4. **INDEX is a position, not a default** — add only where a child listing isn't enough.
5. **Explicit wikilinks always.** After any bulk rename/move, run the maintenance pass.
