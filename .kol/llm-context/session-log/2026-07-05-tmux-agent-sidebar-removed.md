# Session: stale open items closed + tmux-agent-sidebar fully removed

**Date:** 2026-07-05
**Agent:** Claude (Grim)
**Summary:** Closed 5 stale checkboxes in AGENT-CONTEXT's open-items list (user call, no re-verification requested). Diagnosed why tmux-agent-sidebar was auto-popping a pane into every new tmux window (its `@sidebar_auto_create` option defaults `on`), first tried disabling just that behavior, then — on clarification that the user wanted the whole tool gone, not just quieted — removed it completely: plugin registration, installed clone, and every doc/catalog reference.

## Changes Made

### Files Modified
- `.kol/llm-context/AGENT-CONTEXT.md` — closed 5 open-item checkboxes (`vid-` family size guard, `vid-convert.sh` SAR bug, Shift+Enter/tmux verify, MBP iTerm custom-folder keymap check, BWS evaluation) as `[x]` with "closed 2026-07-05 (user call)" — no fix was applied, just marked done per explicit instruction.
- `tmux/.tmux.conf` — removed the `hiroppy/tmux-agent-sidebar` `@plugin` line and its config/comments entirely (section 5).
- `brewfile-cli` — TPM-plugin note no longer lists tmux-agent-sidebar.
- `docs/01-shell-terminal/25-tmux-agent-sidebar.md` — **deleted** (the tool's own catalog doc).
- `docs/01-shell-terminal/INDEX.md` — removed its row.
- `docs/01-shell-terminal/02-tmux.md` — dropped the `related:` link + reworded the plugin-set summary sentence.
- `docs/01-shell-terminal/24-workmux.md` — dropped the `related:` link, a `covers:` entry, and the "compare which sidebar wins" Future-use note (now moot).
- `docs/00-kol-cli/01-cli-cheatsheet.md` — removed the plugin mention + its cheat-sheet row.
- `docs/INDEX.md` — catalog count **85→84** (frontmatter + body), category-01 description text, maintenance note updated, and a dated removal line added explaining why.

### Features Removed
- **tmux-agent-sidebar** (TPM plugin, `hiroppy/tmux-agent-sidebar`) — gone from config, docs, and disk (`~/.tmux/plugins/tmux-agent-sidebar` deleted on the iMac). Root cause of the original complaint: `@sidebar_auto_create` defaults `on` and hooks `after-new-window`, injecting a pane into every new window with no prompt.

## Current State

### Working
- tmux reloaded live (`tmux source-file ~/.tmux.conf`) twice this session — config parses clean, no more auto-popup, no plugin registered at all.
- Grepped the repo post-edit for `agent-sidebar|hiroppy` — zero live wikilinks remain; the only two hits left are intentional prose mentions (a dated removal note in `docs/INDEX.md`, a parenthetical in `02-tmux.md`), not broken references.

### Known Issues
- None.

## Next Steps
1. **MBP still has the plugin cloned** at `~/.tmux/plugins/tmux-agent-sidebar` — once this commit syncs there, the `@plugin` line will be gone from tracked config but TPM won't retroactively remove the clone. Same one-liner as done here: `rm -rf ~/.tmux/plugins/tmux-agent-sidebar`.
2. None otherwise — arc closed same session.

---

## Addendum (same day, later): `kol-migrate-structure` un-quarantined

**Summary:** Restored the `kol-migrate-structure` skill — quarantined to `_tmp/` earlier the same day (2026-07-05) for lack of evidence of use — back into `claude/skills/` at the user's explicit request ("promote to skill again").

### Files Modified
- `_tmp/migrate-structure-removed/` → `claude/skills/kol-migrate-structure/` — plain `mv`, no content changes to `SKILL.md` itself.
- `claude/skills/agent-init/SKILL.md` + `claude/skills/ag-init/SKILL.md` — step 8's legacy-layout nag no longer says "no automated migration skill exists"; now points at `/kol-migrate-structure`.
- `docs/16-claude-agents/01-agent-context-protocol.md` — both mentions of the quarantine (the nag-message quote and the "no automated re-sync/migration skills" line) updated to reflect the restore; the re-sync half (`init-agent-context-sync`) is still gone, only the migration half came back.
- `docs/16-claude-agents/02-skills.md` — installed-set count **34→35**, Agent-context & reinforcement group **11→12** (added `kol-migrate-structure`), count-check line recomputed, frontmatter description count updated.
- `docs/16-claude-agents/INDEX.md` — `skills/` row count **34→35**.
- `.kol/llm-context/AGENT-CONTEXT.md` — skill list line updated to include `kol-migrate-structure`, total **33→34**.

### Current State
- Confirmed live: `kol-migrate-structure` appears in the skill registry (verified via the system's available-skills list after the `mv`).
- Grepped for every remaining `kol-migrate-structure`/quarantine mention post-edit — none stale.

### Known Issues
- None.

### Next Steps
- None — arc closed same session.
