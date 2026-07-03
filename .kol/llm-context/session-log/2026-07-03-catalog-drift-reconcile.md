# Session: Catalog drift reconcile (post-`.kol`-migration)

**Date:** 2026-07-03
**Agent:** Grim (Claude Opus 4.8, `~/.dotfiles`)
**Summary:** Reconciled the `16-claude-agents` catalog + `LLM_RULES.md` with the reality left by the migration/skill changes — skill count, the `init-docs`→`init-agent` rename, the new `claude-bullet`, and the retired Brewfile-mirror.

## Changes Made

### Files Modified
- `docs/16-claude-agents/02-skills.md` — installed set **24→25**; `init-docs`→`init-agent`; Utility **1→2** (added `claude-bullet`); local-authored list += `claude-clear`, `claude-bullet`; description count.
- `docs/16-claude-agents/01-agent-context-protocol.md` — loader row `init-docs`→`init-agent` (+ noted machine-detect/session-bridge).
- `docs/16-claude-agents/INDEX.md` — `skills/` count **22→25**; dropped the inaccurate "01–13 = installed CLI tools" range in the description + intro (17-documents is also CLI tools; 14/15 are guides).
- `claude/skills/kol-migrate-structure/SKILL.md` — trigger text `init-docs`→`init-agent`.
- `LLM_RULES.md` — removed the retired `Brewfile-mirror.txt` from the project overview + directory tree.

## Current State

### Working
- Agent-layer catalog matches reality: **25 skills**, correct names, `claude-bullet` documented.
- Verified: no live `init-docs`, no `22`/`24` skill counts, no live `Brewfile-mirror` outside dated history.

### Known Issues
- `03-agents.md` (4 subagents), `04-hooks-and-tools.md`, root `docs/INDEX.md` (82 tools / 14 categories) checked — **no drift**.
- `TOOLING.md` is stale overall (`updated: 2026-06-04`), incl. a dated "Done this pass" mirror line — left as historical record, not live drift. A full TOOLING refresh is its own task.

## Next Steps
1. Optional: full `TOOLING.md` refresh (it predates ~a month of tooling changes).
2. Optional: bump `_template.version` on the moved `.kol/llm-context/` template files if the sync skill should propagate `.kol/` paths to other scaffolded repos.
