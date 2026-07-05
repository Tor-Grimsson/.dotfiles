---
name: kol-docs-md
description: Author or normalise ONE markdown doc to the kol-docs framework — the Obsidian doc spec (frontmatter contract, 9 archetypes, status enum, closed tag taxonomy, filename/prefix + folder law, _assets/_files handling, explicit wikilinks). Use when writing a new doc in a kol-docs vault, or normalising an existing docs folder to the spec. NOT for organising client design-asset folders (use client-normalise) or publication raw media (use publication-mirror) — those emit a doc layer; THIS is the underlying doc spec they conform to.
---

# kol-docs-md

The **middle doll**: one whole doc, to spec — how docs are typed, named, tagged, frontmattered, cross-linked, and foldered. Two jobs — **author a new doc** and **normalise an existing folder** to the spec. Just the frontmatter → `kol-docs-fm`. A whole repo's docs system (the `documentation/` vs machinery split, `.obsidian`, numbering) → `scaffold-docs-system`.

**This skill is self-contained.** The full rules are below (the "syntax"). Canon + copy-from shapes live in the `claude/packages/kol-docs/kol-docs-md/` package (`01-archetypes.md`, `02-doc-anatomy.md`, `_example/`); a one-of-every-type `_example/` vault + Obsidian Templater files in `_templates/` — reference, not required to act.

Sibling skills [[client-normalise]] and [[publication-mirror]] organise *media* then emit a kol-docs doc layer. This skill IS that doc layer's spec.

---

## Workflow A — author a new doc

1. **Pick the archetype** by *why the reader opens it* (decision tree below).
2. **Fill frontmatter** — required set + recommended + any archetype-specific fields.
3. **Tag** from the closed namespaces — list-form, hierarchical, 2–3 levels, reuse existing leaves.
4. **Name + place** — kebab-case, correct `NN-`/date prefix, into a folder that obeys the folder law.
5. **Link** with explicit wikilinks `[[01-colors|colors]]`; add `related:` where it helps.

## Workflow B — normalise an existing folder

Per doc, in order: assign archetype → fix frontmatter (missing required, `status`, `updated`, `description`) → fix tags (map to closed namespaces, drop `type/`+`status/` dupes, collapse over-deep) → fix filename + prefix → fix folder shape (subfolders XOR loose) → fix supporting files (`_assets`/`_files`) → fix wikilinks to explicit form + sync `aliases:`. After bulk moves, run the **Maintenance pass**.

---

# THE SPEC

## Frontmatter

YAML, between `---` fences, top of file. **All keys lowercase.**

**Required — every doc:**

| Field | Type | Purpose |
|---|---|---|
| `title` | string | Human title, distinct from filename. |
| `type` | enum | One of the 9 archetypes. |
| `status` | enum | Lifecycle (see enum). |
| `updated` | date | ISO `YYYY-MM-DD`. Last meaningful edit. |
| `tags` | list | List-form, hierarchical, from the taxonomy. |

**Recommended:** `description` (one-sentence summary) · `related` (list of wikilinks) · `aliases` (un-prefixed name; powers Obsidian Quick Switcher — add on every `NN-`-prefixed file).

**Optional:** `created` (date) · `verified` (date of last reality-check) · `audience` (`internal`/`agency-internal`/`client`/`public`) · `superseded_by` (wikilink, when `status: superseded`) · `drift` (list of known-stale spots; `[]` = clean).

**Archetype-specific:** `covers` `sources` `providers` `placeholders` `prerequisites` `phases` `repo` `repos` `date_range` `supersedes` `themes` `tier` — see each archetype below.

```yaml
---
title: Colors
type: reference
status: canonical
updated: 2026-05-18
verified: 2026-05-18
description: Brand palette + semantic tokens. Two ramps, identity, UI state.
aliases:
  - colors
tags:
  - project/zine
  - domain/design-system
covers:
  - 2 brand ramps × 5 stops
sources:
  - packages/brand-data/colors.css
related:
  - "[[02-typography|typography]]"
---
```

## Status enum

`draft` → `active` → `canonical` → `superseded` → `archived`

| Status | Meaning |
|---|---|
| `draft` | In progress, not yet trustworthy. |
| `active` | Live, evolving, trustworthy now. |
| `canonical` | Locked source of truth. Edits require bumping out of canonical first. |
| `superseded` | Replaced. Set `superseded_by:`. |
| `archived` | No longer relevant; kept for history. |

**`active` vs `canonical`:** if you'd be fine with an agent acting on it *without verifying*, it's `canonical`. If it might shift under their feet, it's `active`.

## The 9 archetypes

Pick by **what the doc does for the reader**, not what the body looks like.

| `type` | Does | Typical file |
|---|---|---|
| `index` | Routes to other docs (TOC/hub) | `INDEX.md` |
| `reference` | Evergreen lookup — specs, tokens, tables, registries | `01-colors.md` |
| `guide` | How to build/use X — concept + code | `01-build-system.md` |
| `playbook` | Sequential copy-paste runbook, numbered steps | `01-prerequisites.md` |
| `plan` | Forward-looking proposal / roadmap / migration | `2026-05-18-restructure.md` |
| `decisions` | Locked architectural calls, ADR-style | `01-architecture/INDEX.md` |
| `audit` | Current-state snapshot / inventory | `02-audit/INDEX.md` |
| `narrative` | Long-form story / retrospective | `01-design-system.md` |
| `log` | One session record | `2026-05-18-initial-build.md` |

**Per-type extra fields + body shape:**

- **index** — *rec* `description`. Body: overview → table of children → optional quick-ref.
- **reference** — *rec* `description`, `verified`, `aliases`; *opt* `covers:`, `sources:`. Body: overview → specs → examples → related.
- **guide** — *rec* `description`, `audience`; *opt* `prerequisites:` (wikilinks). Body: purpose → prerequisites → walkthrough → examples → troubleshooting.
- **playbook** — *req also* `audience`; *rec* `providers:`; *opt* `placeholders:` (`{{TOKENS}}`), `companion_to:`. Body: overview → prerequisites → **numbered sections** (`## 0. Prerequisites`, `## 1. …`, … `## N. Verification`).
- **plan** — *rec* `phases:`; *opt* `superseded_by:`, `drift:`. Body: why → current → target → phases → acceptance. Mark `superseded` once it ships.
- **decisions** — *opt* `supersedes:`. Body: context → decision → consequences. One decision/file (or a small related set). Immutable once `canonical`.
- **audit** — *rec* `sources:`; *opt* `covers:`. Body: scope → findings → recommendations. Decays fast (→ `archived`/`superseded`).
- **narrative** — *rec* `date_range:` (`2025-10-14 → 2026-04-19`); *opt* `repos:`, `themes:`, `tier:`, `log_count:`. Body: free-form prose.
- **log** — *req* `title`, `type: log`, `status` (≈ `archived`), `updated:` (session date), `tags`; *opt* `repo:`. Body: `# Session: …` → `**Date/Agent/Summary**` → `## Changes Made` → `## Current state` → `## Next steps`. **One file per session.**

**Decision tree:** routes→`index` · lookup→`reference` · how-to→`guide` · copy-paste steps→`playbook` · future→`plan` · locked call→`decisions` · inventory→`audit` · story→`narrative` · session→`log`. If two fit, pick the one closest to *why the reader opened it*.

## Tags — closed top-level set

List-form, hierarchical, **2 levels typical / 3 max**. Reuse existing leaves. Adding a new **top-level** namespace requires editing the taxonomy first — don't invent ad-hoc top-levels.

| Namespace | Answers | Example |
|---|---|---|
| `project/` | which project | `project/monorepo` |
| `domain/` | subject area | `domain/typography`, `domain/dns` |
| `audience/` | who reads it | `audience/client` |
| `provider/` | external service | `provider/sanity`, `provider/vercel` |
| `integration/` | connection between two systems | `integration/paypal-printful` |
| `pattern/` | reusable design/arch pattern | `pattern/handoff-kit` |
| `brand/` | brand-tier (voice, assets, identity) | `brand/voice` |
| `editor/` | editor-surface concerns | `editor/persistence` |
| `archive/` | archive-internal (frozen) | `archive/kol` |
| `framework/` | kol-docs itself | `framework/conventions` |

**Not tags** (they're frontmatter fields — never duplicate): `type/`, `status/`, dates. Kebab-case multi-word leaves.

## Filenames + prefix law

- Kebab-case, lowercase, `.md`, no spaces.
- **Every file gets a prefix** — `INDEX.md` exempt:
  - **Sequential** folder (playbook/ordered guide): `NN-` = reading order.
  - **Catalog** folder (reference/guides): `NN-` = display priority (most-referenced / alphabetical / added-order — pick one per folder, stick to it).
  - **Dated** folder (plan/log): `YYYY-MM-DD-` replaces `NN-`.
- **H1** = `# Title` (matches `title:`, optional ` — qualifier`). No numbering in the H1; the filename carries it.

## Folder structure

At any level you have: `INDEX.md` (only when it adds signal) + `_assets/`/`_files/` (when needed) + **either subfolders OR loose content files — never both.** (Finder/Obsidian sort folders before files; mixing breaks numeric order visually.)

- **Single-doc folders are fine** — `01-architecture/INDEX.md` *is* the architecture doc (`type: decisions`); the folder reserves the namespace.
- **INDEX is a position, not a default.** Have one when: a folder routes to multiple subfolders, has a real "why this section exists" story, or is a single-doc folder (INDEX *is* the doc). Skip it when a leaf's files are self-evident or the parent INDEX already lists them. **Default = no INDEX.**

## Supporting files — `_assets/` vs `_files/`

| Folder | Holds | Embed |
|---|---|---|
| `_assets/` | renderable media (png/jpg/svg/mp4/pdf/mp3) | `![[name.png]]` renders inline; width via `![[name.png\|400]]`; caption = italic line directly below |
| `_files/` | non-renderable (txt/json/yaml/css/jsx, raw data) | `[[name.txt]]` links only; paste contents into a fenced block to show them |

- **Placement** = closest common ancestor of the docs that reference it; promote upward if it ends up shared across sections (don't link across sibling section folders).
- Both coexist as siblings when a section has both kinds.
- **No `NN-` prefix** (they're embedded/linked by name, not navigated). Kebab-case, descriptive, namespace to stay unique vault-wide (`acyr-logo-mark.svg`, not `logo.svg`). `_` prefix sorts them above content + exempts the numbering rule.
- Flat until ~10 files, then **topic-based** subfolders (`_assets/screenshots/`) over type-based (`_assets/images/`).

## Wikilinks

| Form | Source | Resolves via |
|---|---|---|
| Pure alias | `[[colors]]` | Obsidian cache + target `aliases:` |
| **Explicit + display** | `[[01-colors\|colors]]` | the **filename** directly |

**Default: explicit-with-display.** Always resolves, immune to index state, survives alias changes. The framework's own cross-refs all use it. `aliases:` stays in frontmatter (powers Quick Switcher) but wikilinks don't depend on it. `related:` is a flat list of wikilinks — no graph structure. External links use standard `[text](url)`.

## Dates
ISO `YYYY-MM-DD`. No timestamps, no timezones. One date field required (`updated:`).

## Maintenance pass (after any rename/move/prefix change)

1. **Reload Obsidian** (Cmd-P → "Reload app without saving") to reindex — pure-alias links won't resolve until then; explicit-form links are immune.
2. **Grep old filenames** across `.md` — prose mentions + code blocks don't auto-update, only Obsidian-managed wikilinks do.
3. **Spot-check wikilinks** in moved files (broken ones render unstyled).
4. **Keep `aliases:` in sync** — slug rename = update the alias.

---

## Non-negotiables

1. **Closed tag set** — fit an existing namespace before inventing; a genuinely new top-level means editing the taxonomy first.
2. **Subfolders XOR loose files** at every level.
3. **INDEX is a position, not a default** — add only where a child listing isn't enough.
4. **Explicit wikilinks always.** Run the maintenance pass after any bulk move.
5. For exact starting shapes, copy the nearest type from `claude/packages/kol-docs/kol-docs-md/_example/` — but the rules above are sufficient to author/normalise without it.
