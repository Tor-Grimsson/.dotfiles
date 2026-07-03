# Session: `.kol/` migration + init-agent/log-work upstream + claude-bullet

**Date:** 2026-07-03
**Agent:** Grim (Claude Opus 4.8, `~/.dotfiles`)
**Summary:** Converged the repo onto the `.kol/` convention (agent machinery out of `docs/`), deleted the redundant repo-local `.claude/`, upstreamed its two niceties into the global skills, and added a `claude-bullet` skill.

## Changes Made

### Structure move
- `docs/llm-context/` → **`.kol/llm-context/`**; `docs/plan.md` + `docs/history.md` → `.kol/llm-context/`. `docs/` is now a pure catalog.
- Deleted repo-root **`.claude/`** (project-scoped `/init-agent` + `/log-work`) — redundant with the global skills (this repo's `claude/` *is* `~/.claude` via symlink), and its `/log-work` was being shadowed anyway.
- No `docs/_framework/` here → the `.kol/docs-framework/` half of the convention doesn't apply (framework stays in `claude/packages/kol-docs-framework/`, ARCHITECTURE §4).

### Skill changes
- Renamed **`claude/skills/init-docs` → `init-agent`** (dir + frontmatter `name`). `init-agent` is the canonical loader name the scaffolder emits; `init-docs` was a misnomer.
- **Upstreamed** the deleted repo-local niceties into the global skills: `init-agent` loader gained `uname -m` machine detection + session-bridge handoff check + machine-named greeting; `log-work` gained the "also write a handoff?" `AskUserQuestion` + handoff template.
- **New `claude/skills/claude-bullet/`** — companion to `claude-clear`; reformats the last reply into bullets/numbers/checkboxes/tables (structure, not length). `/claude-bullet`, user-invoked only.

### Repointing (all `docs/llm-context` → `.kol/llm-context`)
- `LLM_RULES.md` (paths + directory-tree diagram), `TOOLING.md:267`, `docs/16-claude-agents/{01-agent-context-protocol,INDEX}.md`, `docs/14-supabase/09`, `docs/12-scripts/07-torrent.md`, `init-agent-context-sync` (examples), `init-agent-context` report line.
- Moved-file `_template.path` frontmatter + internal `../history.md`/`../plan.md` → sibling refs.

## Current State

### Working
- Full `.kol/llm-context/` layout live; `/init-agent` + `/log-work` resolve it `.kol/`-first (this log written via the upstreamed `/log-work`).
- **Verified:** 0 broken references. Every residual `docs/llm-context` mention is intentional — skills' legacy-fallback lists, the migrate skill's detection text, `kol-bucket-r2` (a *different* repo), or historical narrative. `.kol/` not gitignored → tracks.

### Known Issues
- `docs/16-claude-agents/02-skills.md` — stale: still names `init-docs`, and skill count lags (`init-agent` rename + new `claude-bullet` + `kol-press-research`). Needs a catalog refresh.
- `LLM_RULES.md:48,61` — still reference the retired `Brewfile-mirror.txt` (pre-existing drift).
- The scaffolder still emits a repo-local `.claude/skills/` for *other* repos — fine (portability), but redundant on the user's own machines where global skills are always present.

## Next Steps
1. Refresh `docs/16-claude-agents/02-skills.md` (init-docs→init-agent, +claude-bullet, count).
2. Optional: bump `_template.version` on the moved template files if the sync skill should propagate the `.kol/` paths to other scaffolded repos.
3. Consider whether `init-agent-context` should stop emitting repo-local `.claude/skills/`.
