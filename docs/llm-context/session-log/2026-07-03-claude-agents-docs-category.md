# Session: docs category 16-claude-agents (the repo's own agent layer)

**Date:** 2026-07-03
**Agent:** Grim (Claude Sonnet 5, `~/.dotfiles`)
**Summary:** Created a dedicated docs category documenting the repo's Claude Code / agent layer (`claude/`) — the agent-context protocol, skills, subagents, hooks, and MCP tools. Filled a real gap: the whole AI layer was undocumented as a subject, with `ponytail` the lone Claude entry tucked in `04-dev-languages`.

## Changes Made

### Files Added (`docs/16-claude-agents/`)
- `INDEX.md` (index) — category overview: `claude/` layout table + routes to the four docs. Frames the category as the **agent layer**, explicitly *not* part of the tool catalog (01–13 = installed CLI tools).
- `01-agent-context-protocol.md` (reference) — the protocol: `LLM_RULES.md` → `docs/llm-context/{ARCHITECTURE,AGENT-CONTEXT,session-log}` + `docs/{history,plan}.md`; the `init-agent-context` / `init-docs` / `log-work` / `init-scaffold` / `init-agent-context-sync` skills; the ARCHITECTURE "do not revisit" convention; the AGENT-CONTEXT "Last updated" **capped prepend chain** (older content demotes to session logs).
- `02-skills.md` (reference) — what skills are; kol-system sourcing (§4) vs local-authored exceptions (`export-specs`, `kol-lobby`, `kol-bucket-b2/r2`); the whole-dir symlink (new skill needs no `bootstrap.sh` edit); the **22** installed skills grouped by job.
- `03-agents.md` (reference) — the **4** `kol-*` design-system subagents (color/div/docs/type); definition shape; skills-vs-subagents distinction.
- `04-hooks-and-tools.md` (reference) — the lone `statusline.sh` hook; `settings.json` config (read-only Bash allowlist + `Bash(git)` deny that enforces the no-git non-goal, effort/voice/tui); plugins (`ponytail`, `rust-analyzer-lsp`); MCP tools (`playwright`, `glif`) registered via `bootstrap.sh` `claude mcp add --scope user`, with account-level claude.ai MCPs noted as untracked.

### Files Modified
- `docs/INDEX.md` — new "## Agent layer" section (category 16 row) between Guides and Related; `updated:` → 2026-07-03. Kept the "78 tools / 13 categories" headline untouched — the agent layer is documented as its own section, not counted among installed tools.

### Conformance
- kol-docs framework: every doc has `title/type/status/updated/tags` (+ `description`/`aliases`/`related`); archetypes `index` + `reference`; `status: active` (the layer evolves — new skills get added).
- Tags from the **closed** set — `project/dotfiles` + `domain/ai/llm` (existing leaf, per the ponytail precedent) + `integration/claude-plugin` on the tools doc. No new top-level namespace invented.
- Wikilinks fixed to framework form: `../`-relative links → vault-root-relative (`[[04-dev-languages/13-ponytail|…]]`); bare `[[INDEX|…]]` (collides across every category) → path-qualified `[[16-claude-agents/INDEX|…]]`.

## Current State

### Working
- Category live at `docs/16-claude-agents/`, routed from the root INDEX. Ground truth verified against the actual repo: 22 skills, 4 agents, 1 hook, `playwright`+`glif` MCP, `ponytail`+`rust-analyzer-lsp` plugins.
- `commands/` and `output-styles/` documented as present-but-empty (accurate — no invented content).

### Known Issues
- `GLIF_API_TOKEN` export is still an open item (noted in `04-hooks-and-tools.md` and the 2026-06-05 (7) context entry) — glif MCP auth waits on the vault→env hookup.
- Docs describe an evolving layer (`status: active`) — the skills/tools counts will drift as skills are added; bump the counts + `updated:` when they change.

## Next Steps
1. Commit so it syncs to the MBP (user owns git).
2. If `commands/` or `output-styles/` ever get populated, extend `04-hooks-and-tools.md` (or split out a doc).
3. Consider moving the `ponytail` write-up's home to this category later — for now it stays in `04-dev-languages` (it's an installed plugin) and is cross-linked from here.
