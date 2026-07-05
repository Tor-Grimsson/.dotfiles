---
name: kol-docs-overview
description: Orientation explainer for the kol-docs system — why a docs/ tree is shaped the way it is (documentation/ vs machinery vs .kol/ agent state), the numbering law, and the doc contract, in one read. Not action-based — to actually author/normalise one doc use kol-docs-md, a whole repo's docs/ use scaffold-docs-system, just frontmatter use kol-docs-fm. Use when asked "explain the docs system", "why is docs/ structured this way", "what's kol-docs", or orienting to an unfamiliar kol-docs repo for the first time.
---

# kol-docs-overview

The **front door**. One read to understand *why* a `docs/` tree looks the way it does, before reaching for scaffold-docs-system/kol-docs-md/kol-docs-fm to actually do the work. If you're about to author, normalise, or move files — stop, go use one of those three instead; this skill only explains.

## The three layers (the split that governs everything)

| Layer | Home | Holds |
|---|---|---|
| **Subject** | `docs/documentation/` | What the repo *is about* — numbered sections `00-… NN`. |
| **Machinery** | `docs/<sibling>/` (e.g. `operations/`) | Repo/CI/tooling process — a sibling, never a numbered section inside `documentation/`. |
| **Agent state** | `.kol/llm-context/` | Architecture, context, session logs — outside the Obsidian vault entirely. |

**The Obsidian layer:** `docs/.obsidian/` is vault *config*, not doc content — symlinked (or copied) from `~/.dotfiles/claude/packages/scaffold/02-scaffold-docs/obsidian-shapes/` so the render/graph/backlinks experience is consistent across repos without hand-configuring each one. It's part of the system a newcomer needs to know exists, even though `scaffold-docs-system` owns the actual wiring (source picker, symlink-vs-copy trade-off).

The dividing question for any doc: *"is this the repo's subject, or the machinery around the repo?"* Subject → `documentation/`. Machinery → its own sibling folder. Agent-only → `.kol/`.

**Known gap:** the canon only names these three. Content that's neither — dead/superseded subject matter (an `archive/` sibling), or a content registry carrying PII that shouldn't sit in the numbered vault sections (e.g. a founder/business-data registry) — has no officially blessed slot. Treat these as pragmatic per-repo exceptions, not license to invent siblings freely; if a repo needs one, name the real reason (history vs access-boundary vs something else), don't default to "it felt right."

## The numbering law

`NN-slug.md` — two-digit, kebab-case, catalog (display-priority) or sequential (reading-order) depending on the folder. **Not** `X.Y.Z-slug.md` — a dotted three-part scheme is not, and has never been, the spec. Dated folders (`plan`/`log`) use `YYYY-MM-DD-` instead. `INDEX.md` is the only prefix-exempt filename — section index files are literally named `INDEX.md`, not `NN-section-index.md`. Numbering is contiguous, no gaps; removing/moving a section means renumbering the rest and repointing refs.

## The doc contract (one line)

Every doc's frontmatter: `title` / `type` (1 of 9 archetypes: index, reference, guide, playbook, plan, decisions, audit, narrative, log) / `status` (`draft`→`active`→`canonical`→`superseded`→`archived`) / `updated` / `tags` (closed taxonomy, list-form). Body shape follows from the archetype.

## Where to go to actually do something

| Need | Skill |
|---|---|
| Stand up or normalise a whole `docs/` tree | [[scaffold-docs-system]] |
| Author or normalise one doc | [[kol-docs-md]] |
| Just fix one file's frontmatter | [[kol-docs-fm]] |

Canon for all three lives in `claude/packages/kol-docs-{lib,md,fm}/` (package names keep the original tier naming, independent of the `scaffold-docs-system` skill name).
