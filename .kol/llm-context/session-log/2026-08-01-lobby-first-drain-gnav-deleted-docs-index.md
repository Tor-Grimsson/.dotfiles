# Session: The lobby's first drain — g-nav deleted, /ag-init reads the docs index

**Date:** 2026-08-01
**Agent:** Claude Code (Grim)
**Summary:** Both dotfiles lobby tickets closed in one pass — the `g*` jump family deleted outright (superseded by tmux bookmarks) and the docs-index sentence applied to both init skills. First time the lobby went from filed to closed.

## Changes Made

### Files Modified
- `shell/functions/g-nav.zsh` → **`shell/functions/paths.zsh`** — rewritten; seven `g*` functions + the `_gnav_act`/`_gnav_help` helpers deleted, `zshrc` and `cwd` kept
- `shell/.zshrc:162-163` — source line + section comment repointed at `paths.zsh`
- `ref/shell.md` § `paths` — ⚠ dead-targets block removed, g-rows replaced with a `zshrc` verb table, pointer to `ref-tmux bookmark`
- `claude/skills/ag-init/SKILL.md` — step 3 docs-index sentence + step 8 clause
- `claude/skills/agent-init/SKILL.md` — same two edits (the skills are twins)
- `lobby/INDEX.md` — queue 2→0, both rows moved to a new Closed table, history row added
- `lobby/done/{g-nav-dead-targets,agent-init-docs-index}.md` — moved from `inbox/`, `## ✅ RESOLUTION` appended to each

### Features Added/Removed
- **Removed:** `ghome` · `gdot` · `gdev` · `gobs` · `gapparat` · `gclient` · `gicloud`. User's call — *"yeah just delete I dont use it, it was before I had the bookmarks for that purpose."* The tmux bookmarks system (`prefix C-b` · `B` · `A`) does the job.
- **Added:** `/ag-init` and `/agent-init` now read `docs/documentation/INDEX.md` (and `docs/INDEX.md`) at boot — awareness, not study. `.kol/` carries history and state; `docs/` carries the rules.

## Current State

### Working
- All seven `g*` functions verified gone (`type` → "not found"); `cwd` and `zshrc` resolve from `paths.zsh`.
- `ref shell paths` renders both tables and the new `[e]` line.
- dotfiles has both `docs/documentation/INDEX.md` and `docs/INDEX.md`, so both branches of the new step-3 sentence fire here.
- Lobby queue empty for the first time — 0 filed, 2 closed, 0 parked.

### Known Issues
- **The g-nav ticket's DoD had a phantom line.** It required syncing `docs/documentation/01-shell-terminal/13-shell-functions.md`; that file only ever documented `killport` — g-nav was never in it. A definition-of-done can name a target that doesn't exist; verify each line rather than assuming the filer checked.
- **A ref-card pointer was wrong in the direction nothing catches.** `ref/shell.md` pointed at `ref-tmux bookmarks`; the section is `## bookmark`, singular, so the filter returned *nothing tagged "bookmarks" in tmux*. Cross-card pointers are only as good as the last time someone typed them — the card renders fine either way.

## Next Steps
1. `source ~/.zshrc` in any already-open shell — the deleted functions persist in running shells until re-sourced.

**Ruling made this session:** the per-repo hot-docs block is **not a dotfiles item** and was struck from this log's next steps. The ticket's dotfiles half was the skill edit, which is done; the per-repo table belongs to whichever repo it describes, authored in that repo's own session. Filing another repo's work as a dotfiles follow-up is meddling — *"why are you interferring and meddling in that repo when you have dotfiles?"* The lobby is empty and stays empty.
