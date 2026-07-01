# Session: kol-capture → dedicated kol-inbox vault folder

**Date:** 2026-06-26
**Agent:** Grim (Claude Opus, `~/.dotfiles`, iMac)
**Summary:** The capture pipeline's Obsidian leg was dumping to a bare `kol-vault/Inbox.md` at root. Gave it a proper kol-docs home — a `kol-inbox/` folder with a typed folder note — and repointed the route.

## Changes Made

### Files Added (kol-vault)
- `kol-vault/kol-inbox/INDEX.md` — folder note (`type: index`, kol-docs frontmatter): explains the inbox, how the pipeline feeds it, and the triage workflow.
- `kol-vault/kol-inbox/inbox.md` — the capture sink (kebab/lowercase per Obsidian convention; `type: reference`, `status: active`). Bot appends `- YYYY-MM-DD HH:MM <text>` below the intro.

### Files Modified
- `bin/tg-inbox.sh` — `VAULT_INBOX` repointed `kol-vault/Inbox.md` → `kol-vault/kol-inbox/inbox.md`.
- `docs/12-scripts/16-capture.md` — diagram + tag-table path updated to `kol-inbox/inbox.md`.
- Deleted the old root `kol-vault/Inbox.md`.

## Current State
- **Working** — route append verified to the new path; live immediately (timer runs the script fresh each poll, no reload).
- Naming locked: pipeline = **kol-capture**, folder = **kol-inbox**, file = **inbox.md**.

## Next Steps
1. Configure the user's **custom Obsidian plugin** against this inbox (next ask).
2. Clear the two test lines in `inbox.md` (triage gesture).
