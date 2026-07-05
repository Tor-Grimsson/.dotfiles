---
name: kol-docs-lib
description: Whole-repo docs-library slice of the kol-docs spec — stand up or normalise a repo's entire docs/ layout: the documentation/ (repo subject) vs sibling machinery (operations/…) split, .kol/ agent state, the .obsidian symlink model with a source picker, the render-target link rule (wikilinks in-vault, markdown links for GitHub), contiguous numbering, and INDEX.md coverage. Use for a repo's whole docs system. For one doc use kol-docs-md; for just frontmatter use kol-docs-fm.
---

# kol-docs-lib

The **outermost doll**: the whole docs *library* for a repo. Contains kol-docs-md (author one doc), which contains kol-docs-fm (frontmatter). Reach for this when standing up a repo's `docs/` from scratch or normalising a whole tree.

**Canon:** the `claude/packages/kol-docs-lib/` package — `01-structure.md`, `02-obsidian.md`, `_example-repo/` (a worked docs/ tree). The single-doc rules live in the `kol-docs-md` package; don't restate them here — compose.

---

## The layout

```
docs/
├── .obsidian/            ← vault config, symlinked from ~/.dotfiles/obsidian (see below)
├── INDEX.md              ← docs home; routes to documentation/ + siblings
├── documentation/        ← THE REPO'S SUBJECT (numbered sections: 00-overview … NN)
│   ├── INDEX.md
│   ├── 00-overview/  01-…/  02-…/
└── operations/           ← repo machinery (release, CI, workbench) — a SIBLING, not inside documentation/
    └── INDEX.md
.kol/llm-context/         ← agent state (architecture, context, logs) — OUTSIDE the vault, at repo root
```

**The split (load-bearing):**
- `documentation/` = what the repo *is about*, in numbered sections.
- **Repo machinery** (release pipeline, CI, tooling) is *not* design/subject content → its own **sibling** folder in `docs/` (`operations/`, etc.), never a numbered section inside `documentation/`.
- `.kol/` = agent context, outside the Obsidian vault entirely.

## Non-negotiables (repo layer)

1. **Every section folder gets an `INDEX.md`.** The md-tier rule is "INDEX is a position, not a default" — at the library level, any folder something *navigates into* is a routing position, so it gets one. Folders left without an INDEX is the most common drift; reinforce it.
2. **Contiguous numbering.** `00-…NN` with no gaps. Remove a section → renumber the rest and repoint refs (a gap is a rule you set but didn't keep).
3. **Render-target decides link form.** Wikilinks `[[path|display]]` for files read *inside the Obsidian vault* (backlinks, graph, move-resilience). **Markdown links** `[text](path.md)` for anything rendered *outside* it — root `README.md`, `LLM_RULES.md`, GitHub-facing files — where wikilinks render as dead `[[…]]`. Links pointing *out of* the vault (to `.kol/…`) are markdown links.
4. **LLM_RULES.md is not this skill's job** — it's owned by init-agent-context. Don't write it here.

---

## Workflow — stand up / normalise a repo's docs library

1. **Scaffold the split:** `docs/documentation/` (numbered sections) + sibling machinery folders + `.kol/llm-context/` if agent state is wanted.
2. **INDEX every section** — docs home `docs/INDEX.md`, `documentation/INDEX.md`, and one per section folder.
3. **Wire `.obsidian/`** — ask which source shape (picker below), then symlink or copy.
4. **Apply link form** per §3; numbering per §2.
5. Per-doc authoring/normalising → hand each file to `kol-docs-md`.

## .obsidian source picker

The vault config source lives at **`~/.dotfiles/obsidian/`** with reference shapes:
- `01-vault-shape/.obsidian/` — the rich general vault (from kol-monorepo: plugins, snippets, themes, hotkeys, folder-notes, dataview…).
- `02-kol-ds-shape/.obsidian/` — the minimal design-system docs shape (bare core plugins).

On setup, **ask which to use** (AskUserQuestion, 4 options):

1. **Symlink 01-vault-shape** — `ln -s ~/.dotfiles/obsidian/01-vault-shape/.obsidian docs/.obsidian`. Repo inherits the rich vault; edits at the source propagate everywhere.
2. **Symlink 02-kol-ds-shape** — same, minimal shape.
3. **Copy 01-vault-shape** — `cp -R` the rich `.obsidian`, no symlink. Repo owns its config; drifts independently.
4. **Copy 02-kol-ds-shape** — `cp -R` the minimal `.obsidian`, no symlink.

Symlink = one source of truth, no drift, but the repo shares `workspace.json` churn. Copy = independent, editable per-repo, but drifts from the source. `workspace.json`/`workspaces.json` are per-vault local UI state — gitignore them in the target repo either way.
