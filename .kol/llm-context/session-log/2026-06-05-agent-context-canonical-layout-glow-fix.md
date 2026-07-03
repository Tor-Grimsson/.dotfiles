# 2026-06-05 — agent-context onto canonical layout + glow-open fix

The repo's hand-rolled `.llm-context/` predated the `/init-agent-context` scaffolder and was never migrated; brought it onto the canonical template layout so `/init-agent`, `/log-work`, and `/init-agent-context-sync` all work here. Also fixed the "Open in glow" Quick Action quitting instantly.

- Moved `.llm-context/{AGENT-CONTEXT,ARCHITECTURE,README}.md` + `session-log/` + `session-bridge/` → `docs/llm-context/`; `history.md`/`plan.md` → `docs/`. Old folder deleted.
- Updated `_template.path` frontmatter and all relative cross-references for the new locations.
- New root `LLM_RULES.md` (template v1, placeholders filled for this repo).
- New repo-local `.claude/skills/{init-agent,log-work}/SKILL.md` from templates, `{{REPO_ABS_PATH}}` → `/Users/biskup/.dotfiles`. Session boot = `/init-agent` or "read LLM_RULES.md".
- `bin/glow-open`: iTerm's AppleScript `command` param exec's directly (no shell, bare PATH), so `; echo; read…` became literal glow args → instant exit. Now creates a default-profile window and `write text`s `glow -p <file>; exit` into the login shell (also fixes brew-prefix PATH on both machines). Terminal branch's bash-only `read -n1` dropped too.

## Next steps

- User: visually confirm the Quick Action from Finder (right-click a .md → Open in glow).
- Working tree left uncommitted for the user, as always.
