# Session: MBP handoff verification + caveman purge handoff

**Date:** 2026-06-05
**Agent:** Grim (Claude Opus 4.8)
**Summary:** Verified last session's MBP handoff items landed; prepared the full caveman purge (live settings → repo symlink) — command block handed off, not yet run.

## Changes Made

### Files Modified
- `claude/settings.json` — voice block ported from live MBP settings (`voice: {enabled, mode: hold}` + `voiceEnabled`) so the settings symlink loses nothing.

### Features Added/Removed
- Caveman purge prepared (user runs via `!`): rm live `~/.claude/hooks/` + settings cruft (`settings-1.json`, `settings.json.bak`), park live settings at `~/_temp/settings-caveman-bak.json`, symlink `settings.json` + `hooks/` to repo, rm plugin cache/marketplace dirs, jq-strip caveman from `installed_plugins.json` + `known_marketplaces.json`.

## Current State

### Working
- Verified done from last session: bbrew uninstalled + untapped; Obsidian reinstalled; `settings.json.reconciled` applied (glif in, node un-pinned); `~/.claude-server-commander` deleted; defaults.sh apparently ran (screenshot dir set).
- Verified NOT done: hiddenbar not reinstalled (next `brew bundle` brings it back — confirm wanted); `~/_temp/claude-skills-pre-reconcile/` still parked.

### Known Issues
- **Caveman purge NOT yet executed** — live `~/.claude/settings.json` still a real file with caveman plugin/hooks/statusline; hooks dir + plugin cache + registry entries intact. Handoff block in chat.
- Repo settings deny **all** git; live had granular git allows — those die when the symlink lands (consistent with the never-run-git contract).
- glow ⌃⇧G dispatch + ⇧⌥⌃A/S re-binds still unverified (need user keypress).

## Next Steps
1. User: run the caveman purge block, then restart the session (this session's hooks already loaded).
2. Decide iTerm password manager doc note (interactive type-only; can't replace Keychain `bw-master` → `bwu`/`bwl` chain) — pending user answer.
3. Decide hiddenbar: keep in Brewfile (reinstalls next bundle) or drop.
