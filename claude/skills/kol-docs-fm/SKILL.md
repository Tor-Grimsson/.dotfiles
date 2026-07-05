---
name: kol-docs-fm
description: Frontmatter-only slice of the kol-docs spec — the YAML contract (required/recommended/optional fields), the status enum, the closed tag taxonomy, link forms, and the date rule. Use when you only need to add or fix a single file's frontmatter. For a whole doc (archetypes, filenames, folder law) use kol-docs-md; for a whole repo's docs library use scaffold-docs-system.
---

# kol-docs-fm

The **innermost doll**: the frontmatter contract, nothing else. Reach for this when all you need is "give this file correct frontmatter." For the full doc (9 archetypes, filename/folder law, maintenance) → `kol-docs-md`. For a whole repo's docs layout → `scaffold-docs-system`.

**Canon:** the `claude/packages/kol-docs/kol-docs-fm/` package — `01-frontmatter.md`, `02-tags.md`, `_example/samples.md`. The summary below is enough to act; open the package for edge cases.

## Frontmatter block

YAML between `---` fences, top of file, **all keys lowercase.**

**Required — every doc:**

| Field | Type | Purpose |
|---|---|---|
| `title` | string | Human title, distinct from filename. |
| `type` | enum | One of the 9 archetypes (see kol-docs-md). |
| `status` | enum | Lifecycle (below). |
| `updated` | date | ISO `YYYY-MM-DD`, last meaningful edit. |
| `tags` | list | List-form, hierarchical, from the taxonomy. |

**Recommended:** `description` (one sentence) · `related` (list of wikilinks) · `aliases` (un-prefixed name; powers Quick Switcher — add on every `NN-`-prefixed file).

**Optional:** `created` · `verified` · `audience` (`internal`/`agency-internal`/`client`/`public`) · `superseded_by` · `drift`.

```yaml
---
title: Colors
type: reference
status: canonical
updated: 2026-07-05
description: Brand palette + semantic tokens.
aliases:
  - colors
tags:
  - project/zine
  - domain/design-system
related:
  - "[[02-typography|typography]]"
---
```

## Status enum

`draft` → `active` → `canonical` → `superseded` → `archived`

**`active` vs `canonical`:** if an agent could act on it *without verifying*, it's `canonical`; if it might shift under them, `active`. Set `superseded_by:` when `superseded`.

## Tags — closed top-level set

List-form, hierarchical, **2 levels typical / 3 max**, reuse existing leaves. A new **top-level** namespace means editing `03-tag-taxonomy.md` first — never invent ad-hoc top-levels.

`project/` · `domain/` · `audience/` · `provider/` · `integration/` · `pattern/` · `brand/` · `editor/` · `archive/` · `framework/`

**Not tags** (they're their own fields — never duplicate): `type/`, `status/`, dates.

## Link form in frontmatter

`related:` uses **explicit wikilinks** `[[01-colors|colors]]` (resolve by filename, immune to alias/index state). External links use `[text](url)`. Body link form (wikilink vs markdown) depends on render target — see `scaffold-docs-system`.

## Dates

ISO `YYYY-MM-DD`, no timestamps/timezones. `updated:` is the one required date field.
