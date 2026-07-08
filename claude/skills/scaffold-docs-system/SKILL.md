---
name: scaffold-docs-system
description: Whole-repo docs-system slice of the kol-docs spec — stand up or normalise a repo's entire docs/ layout (documentation/ vs sibling machinery vs .kol/ agent state, the .obsidian symlink model, render-target link rule, contiguous numbering, INDEX.md coverage) AND the .kol/docs-framework/ machinery (copies of the kol-docs-fm/md/lib packages) a repo needs to actually follow the spec. Use for a repo's whole docs system. For one doc use kol-docs-md; for just frontmatter use kol-docs-fm.
disable-model-invocation: true
allowed-tools: Bash, Read, Edit, Write, Glob, Grep, AskUserQuestion
---

# scaffold-docs-system

The **outermost doll**: the whole docs *system* for a repo — both the `docs/` tree itself and the `.kol/docs-framework/` machinery it conforms to. Contains kol-docs-md (author one doc), which contains kol-docs-fm (frontmatter). Reach for this when standing up a repo's docs system from scratch or normalising a whole tree.

**Canon:** the `claude/packages/kol-docs/kol-docs-lib/` package — `01-structure.md`, `02-obsidian.md`, `_example-repo/` (a worked docs/ tree). The single-doc rules live in the `kol-docs-md` package; don't restate them here — compose. (The package keeps the `kol-docs-*` tier naming — `fm ⊂ md ⊂ lib` — independent of this skill's own name.)

**Structure map + who-owns-what:** [[kol-docs-overview]]. `.kol/llm-context/` + the `LLM_RULES.md` boot symlink are `scaffold-llm-context`'s, not this skill's. A **legacy** repo converts via `/kol-migrate-structure`, which relocates old content and delegates the framework install below back to this skill.

Not this skill's job: `.kol/llm-context/` + `LLM_RULES.md` — that's `/scaffold-llm-context`. Neither depends on the other; run either first, each only ever `mkdir -p`s its own `.kol/` subpath.

---

## The layout

```
docs/
├── .obsidian/            ← real local dir; contents symlinked per-file from obsidian-shapes (see below)
├── INDEX.md              ← docs home; routes to documentation/ + siblings
├── documentation/        ← THE REPO'S SUBJECT (numbered sections: 00-overview … NN)
│   ├── INDEX.md
│   ├── 00-overview/  01-…/  02-…/
└── operations/           ← repo machinery (release, CI, workbench) — a SIBLING, not inside documentation/
    └── INDEX.md
.kol/llm-context/         ← agent state (architecture, context, logs) — owned by /scaffold-llm-context
.kol/docs-framework/      ← this repo's copy of the kol-docs-{fm,md,lib} packages — owned by THIS skill
```

**The split (load-bearing):**
- `documentation/` = what the repo *is about*, in numbered sections.
- **Repo machinery** (release pipeline, CI, tooling) is *not* design/subject content → its own **sibling** folder in `docs/` (`operations/`, etc.), never a numbered section inside `documentation/`.
- `.kol/` = agent context + docs-framework machinery, outside the Obsidian vault entirely.

## Non-negotiables (repo layer)

1. **Every section folder gets an `INDEX.md`.** The md-tier rule is "INDEX is a position, not a default" — at the library level, any folder something *navigates into* is a routing position, so it gets one. Folders left without an INDEX is the most common drift; reinforce it.
2. **Contiguous numbering.** `00-…NN` with no gaps. Remove a section → renumber the rest and repoint refs (a gap is a rule you set but didn't keep).
3. **Render-target decides link form.** Wikilinks `[[path|display]]` for files read *inside the Obsidian vault* (backlinks, graph, move-resilience). **Markdown links** `[text](path.md)` for anything rendered *outside* it — root `README.md`, `LLM_RULES.md`, GitHub-facing files — where wikilinks render as dead `[[…]]`. Links pointing *out of* the vault (to `.kol/…`) are markdown links. **Heading anchors always use the literal heading text** (`[[file#Heading Text|display]]`), never a GitHub kebab-slug — Obsidian doesn't resolve GFM-style `#kebab-case` anchors at all (open upstream feature request, no setting fixes it); a markdown-style anchor link still opens the file but silently fails to jump to the section.
4. **`LLM_RULES.md` is not this skill's job** — it's owned by `/scaffold-llm-context`. Don't write it here.

---

## Workflow — stand up / normalise a repo's docs system

1. **Scaffold `.kol/docs-framework/` if missing** (idempotent — safe to run whether or not `/scaffold-llm-context` has run):
   ```sh
   mkdir -p .kol/docs-framework
   cp -R ~/.dotfiles/claude/packages/kol-docs/kol-docs-fm  .kol/docs-framework/
   cp -R ~/.dotfiles/claude/packages/kol-docs/kol-docs-md  .kol/docs-framework/
   cp -R ~/.dotfiles/claude/packages/kol-docs/kol-docs-lib .kol/docs-framework/
   ```
   Then write `.kol/docs-framework/INDEX.md` routing to the three nested tiers:
   ```markdown
   # kol-docs framework

   The doc spec this repo's docs conform to — three nested tiers (fm ⊂ md ⊂ lib).

   - [[kol-docs-fm/INDEX|kol-docs-fm]] — frontmatter + tags.
   - [[kol-docs-md/INDEX|kol-docs-md]] — one whole doc (archetypes, anatomy, examples).
   - [[kol-docs-lib/INDEX|kol-docs-lib]] — the whole repo docs library.
   ```
   The packages land at `.kol/docs-framework/{kol-docs-fm,kol-docs-md,kol-docs-lib}/`; wikilinks like `[[kol-docs-md/01-archetypes|…]]` resolve against them. No automated sync skill exists — re-run this step by hand if the canonical packages change and the target repo needs the update.

2. **Scaffold the split:** `docs/documentation/` (numbered sections) + sibling machinery folders.
3. **INDEX every section** — docs home `docs/INDEX.md`, `documentation/INDEX.md`, and one per section folder.
4. **Wire `.obsidian/`** — ask which source shape (picker below), then symlink (per-file) or copy.
5. **Apply link form** per Non-negotiables §3; numbering per §2.
6. Per-doc authoring/normalising → hand each file to `kol-docs-md`.

## .obsidian source picker

The vault config source lives at **`~/.dotfiles/claude/packages/scaffold/02-scaffold-docs/obsidian-shapes/`** with reference shapes:
- `01-vault-shape/.obsidian/` — the rich general vault (from kol-monorepo: plugins, snippets, themes, hotkeys, folder-notes, dataview…).
- `02-kol-vault-shape/.obsidian/` — the actual dedicated kol-vault Obsidian vault (30 enabled plugins: `dataview`, `templater-obsidian`, `quickadd`, …) — the richest shape.
- `03-kol-ds-shape/.obsidian/` — the minimal design-system docs shape (bare core plugins).

On setup, **ask which to use** (AskUserQuestion, 6 options):

1. **Symlink 01-vault-shape** — per-file (see below). Repo inherits the rich vault; edits at the source propagate everywhere.
2. **Symlink 02-kol-vault-shape** — same, the full kol-vault set.
3. **Symlink 03-kol-ds-shape** — same, minimal shape.
4. **Copy 01-vault-shape** — `cp -R` the rich `.obsidian`, no symlink. Repo owns its config; drifts independently.
5. **Copy 02-kol-vault-shape** — `cp -R` the kol-vault set, no symlink.
6. **Copy 03-kol-ds-shape** — `cp -R` the minimal `.obsidian`, no symlink.

**Symlink mode is per-file, not whole-directory.** `docs/.obsidian/` is a real local directory; symlink each file/folder inside it individually to the matching path in the chosen shape:
```sh
mkdir docs/.obsidian
SRC=~/.dotfiles/claude/packages/scaffold/02-scaffold-docs/obsidian-shapes/<shape>/.obsidian
for item in "$SRC"/*; do ln -s "$item" "docs/.obsidian/$(basename "$item")"; done
```
Whole-directory symlink (`ln -s .../.obsidian docs/.obsidian`) is wrong — it makes `workspace.json` and other per-vault runtime state one shared file across every repo using that shape, defeating "per-vault local." Per-file symlinking lets shared plugin config coexist with independent per-vault state. Copy mode is unaffected — `cp -R` the whole directory is already an independent copy.

Never seeded in any shape (per-vault local UI state / runtime caches — leave absent, Obsidian creates them fresh): `workspace.json`, `workspaces.json`, `workspace-mobile.json`, `plugin-data/`, `bookmarks.json`, `switcher.json`, `backlink.json`, `webviewer.json`, `note-composer.json`. Gitignore `docs/.obsidian/` wholesale in the target repo either way — none of it is meant to be tracked.
