# Session: `keys` keybind reference tool + `keys-add` skill

**Date:** 2026-07-08
**Agent:** Claude (Grim)
**Summary:** Built `keys` — a shell tool that `bat`-prints the user's own keybinds filtered by tag — plus its data file, catalog doc, and a `keys-add` skill for maintaining it.

## Changes Made

### The `keys` tool
- **`bin/keys`** — `keys [tag …]` filters `keys/keybinds.md` by `## #tag` section (all tags must match, case-insensitive) and pipes to `bat --style plain --paging=never`. No args → whole file; no match → stderr + exit 1.
- **`keys/keybinds.md`** (new dir) — the flat hand-kept list: `## #tool #subtopic` headers, key-first `key  action` lines. Seeded from the live tmux / aerospace / nvim / bookmark / git / gh / ssh binds.
- **`docs/scripts/19-keys.md`** + scripts INDEX row (prefix-less standalone, like `15-calendar`).

### Design decision
- Rejected rendering the docs (my first idea) — keybinds are scattered across prose/tables/config-comments and don't parse cleanly into a `key→action` list. A purpose-built flat list is the right artifact; the cost is it's a hand-kept copy (joins the "update when you rebind" discipline). Also: `bat`, not `glow` (user's call).

### `keys-add` skill
- **`claude/skills/keys-add/SKILL.md`** — teaches: only edit `keybinds.md`, the `## #tag` format + column alignment, the existing tag taxonomy (reuse don't invent), and the sync-with-config discipline. Local-authored (won't ride a kol-system re-sync).
- Skill catalog synced: `02-skills.md` Utility group (2→3) + local-authored list + count-check, and `02-claude-agents/INDEX.md` — **35→36 skills**.

## Current State

### Working
- `keys` filters + prints correctly (`keys tmux popover`, `keys bookmark`, `keys aerospace focus` verified); `keys-add` is live in the skill list; all docs synced; dead-link scan clean.

### Known Issues
- `keybinds.md` is a hand-maintained copy — drifts if a config rebind isn't mirrored into it (the `keys-add` skill exists to keep this disciplined).

## Next Steps
1. Use `keys-add` when adding/rebinding keys so the list stays honest.
2. Optional: a `keys -l` live mode wrapping `tmux list-keys`; tag completion.
