# Session: kol-docs split into fm/md/lib skill trio + framework retirement

**Date:** 2026-07-05
**Agent:** Grim (Claude Opus 4.8, `~/.dotfiles`)
**Summary:** Split the single `kol-docs` skill into a russian-doll trio (`kol-docs-fm` ⊂ `kol-docs-md` ⊂ `kol-docs-lib`), each backed by its own package; migrated all `kol-docs-framework` content into them verbatim and retired the framework; added a shared Obsidian vault-config source; updated the scaffold skills and the catalog.

## Changes Made

### Files Modified/Created
- `claude/skills/kol-docs` → renamed **`kol-docs-md`** (one whole doc — archetypes, doc anatomy).
- `claude/skills/kol-docs-fm/SKILL.md` — new (frontmatter + tags only).
- `claude/skills/kol-docs-lib/SKILL.md` — new (whole repo docs library — `documentation/` vs machinery split, `.obsidian` picker, numbering, render-target link rule).
- `claude/packages/kol-docs-fm/` — new package: `01-frontmatter.md`, `02-tags.md`, `_example/samples.md`.
- `claude/packages/kol-docs-md/` — new package: `01-archetypes.md`, `02-doc-anatomy.md`, plus the **full** `_example/` fictional vault (one folder per archetype + `_assets` embed demos) and `_templates/` (Obsidian Templater files) migrated verbatim from the old framework.
- `claude/packages/kol-docs-lib/` — new package: `01-structure.md`, `02-obsidian.md`, `_example-repo/docs/` (a worked `.obsidian` + `documentation/` + `operations/` sibling tree).
- `claude/packages/kol-docs-framework/` — **deleted** (content fully migrated first, nothing condensed/lost).
- `~/.dotfiles/obsidian/` — new: `01-vault-shape/` (seeded from kol-monorepo, rich — plugins/snippets/themes/hotkeys) + `02-kol-ds-shape/` (seeded from kol-design-system, minimal), each an openable mini-vault with a dummy note. `workspace*.json` excluded from both.
- `claude/skills/init-agent-context/SKILL.md` + `init-agent-context-sync/SKILL.md` — updated to copy/sync the three new packages into `.kol/docs-framework/{kol-docs-fm,kol-docs-md,kol-docs-lib}/` instead of the old single framework dir.
- `docs/16-claude-agents/02-skills.md` — 28→30 skills, Docs (1)→(3) row, divergence note for future kol-system re-syncs.
- `docs/16-claude-agents/INDEX.md` — skill count 25→30.
- `docs/09-productivity-desktop/02-obsidian.md` — trimmed to a one-line pointer (avoid duplication).
- **`docs/20-kol-docs-system-setup/INDEX.md`** — new Systems-category doc (row 20 in `docs/INDEX.md`), the single full write-up of this whole arc.
- `.kol/llm-context/{ARCHITECTURE,AGENT-CONTEXT,README}.md` — stale `kol-docs`/`kol-docs-framework` mentions repointed.

### Features Added/Removed
- Added: fm ⊂ md ⊂ lib skill split; shared Obsidian vault-config source with a 4-way symlink/copy picker.
- Removed: the single `kol-docs` skill name and the `kol-docs-framework` package (superseded, not orphaned).

## Current State

### Working
- All three skills registered and live (whole-dir symlink); each reads its own package; INDEX/wikilinks within each package verified to resolve.
- Framework retirement verified — only remaining `kol-docs-framework` mentions are historical (AGENT-CONTEXT chain entries, a divergence note explaining the retirement).
- Catalog reconciled across `02-skills.md`, `16-claude-agents/INDEX.md`, `docs/INDEX.md`, `02-obsidian.md`.

### Known Issues
- **Not reviewed by user yet** — packages were built same-session; user hasn't read through `kol-docs-fm`/`-md`/`-lib` content.
- **Not exercised** — no throwaway repo has been scaffolded end-to-end to confirm `init-agent-context` actually copies the three packages + writes the routing INDEX correctly.
- **No repo yet symlinked** to `~/.dotfiles/obsidian/` — kol-design-system still has its own standalone `.obsidian` copy; the picker has never actually been run.
- **Uncommitted** (user owns git) — nothing here reaches the MBP until committed + pushed.

## Next Steps
1. User reviews the three packages (`claude/packages/kol-docs-{fm,md,lib}/`).
2. Dry-run `/init-agent-context` on a scratch repo to verify the packages copy + the routing INDEX renders correctly.
3. Commit + push so the MBP picks it up.
4. Optionally: when the user reorganizes dotfiles' `docs/` (documenting-function vs repo-documentation split), reconsider whether `20-kol-docs-system-setup` moves categories.
