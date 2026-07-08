# Session: docs/ markdown links converted to wikilinks + Obsidian anchor caveat documented

**Date:** 2026-07-05
**Agent:** Grim (Claude Sonnet 5, `~/.dotfiles`)
**Summary:** Diagnosed why `#anchor` jumps fail in Obsidian (GitHub-style kebab-slugs vs Obsidian's literal-heading-text anchors — no setting fixes it, confirmed via Obsidian forum threads), documented the gap in the kol-docs framework, then converted every internal markdown link across `docs/` (197 files) to wikilinks.

## Changes Made

### Files Modified
- `claude/packages/kol-docs/kol-docs-lib/01-structure.md` — extended "Link form by render target" with the anchor-incompatibility paragraph (GFM slug vs literal heading text; no core Obsidian setting fixes it)
- `claude/packages/kol-docs/kol-docs-md/02-doc-anatomy.md` — new "Heading anchors" section + comparison table
- `claude/packages/kol-docs/kol-docs-fm/01-frontmatter.md` — pointer sentence extended
- `claude/skills/kol-docs-overview/SKILL.md` — one-line mention added
- `claude/skills/scaffold-docs-system/SKILL.md` — non-negotiable #3 extended with the anchor rule
- `docs/**/*.md` (126 of 197 files) — 608 internal markdown links (`[text](path.md[#anchor])`) converted to wikilinks (`[[path|text]]` / `[[path#Heading Text|text]]`), vault-root-relative, bare filename unless it collides (e.g. `INDEX`)
- `LLM_RULES.md`, `TOOLING.md` (repo root) — one-line note each: these stay on standard markdown links (GitHub-facing), `docs/**` is the vault where wikilinks apply

### Features Added/Removed
- None (documentation + link-format conversion only, no code/behavior change)

## Current State

### Working
- Render-target link rule (wikilinks in-vault, markdown outside) was already documented pre-session; the missing anchor-format caveat is now filled in across all 5 kol-docs skill/package docs
- 608 links converted, 24 correctly left as markdown (genuine out-of-vault targets: root `TOOLING.md`, `.kol/llm-context/...`, `claude/skills/.../SKILL.md`)
- Caught and repaired a self-inflicted bug mid-session: headings containing nested markdown links (`01-cli-cheatsheet.md`'s numbered tool headings) had their raw link syntax leak into the wikilink `#anchor` slot on first pass — repaired using each heading's plain text (21 instances, one file)
- Verified clean: bracket-balance check across all 197 files, zero-byte-file check, no leftover in-vault markdown links besides one known pre-existing issue (below)

### Known Issues
- `docs/01-shell-terminal/09-tmux-tips.md` → `02-remote-dev-workflow.md#3-nvim-clipboard-over-ssh--tmux` is a **pre-existing stale anchor** (target heading was renamed to "3. Clipboard over SSH + tmux" at some point; this one backlink was never updated) — left as a markdown link since the fix wasn't guessable. Needs a manual one-line correction.
- `TOOLING.md:35` already contained a wikilink (`[[docs/INDEX|docs/]]`) despite the file being classified GitHub-facing/markdown-only by the render-target rule — pre-existing inconsistency, not touched.

## Next Steps
1. Fix the stale anchor in `09-tmux-tips.md` (point it at the renamed heading).
2. Decide whether `TOOLING.md`'s existing wikilink should be converted to markdown for consistency, or whether the render-target rule should carve out an exception for it.
3. Open Obsidian and spot-check a handful of the converted heading-anchor jumps live (especially the repaired `01-cli-cheatsheet.md` jump table) — this session's confidence is from static verification (slug-matching, bracket balance), not a live Obsidian render.
