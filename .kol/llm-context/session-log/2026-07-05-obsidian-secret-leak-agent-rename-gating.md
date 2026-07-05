# Session: Obsidian secret-leak cleanup + agent-init rename + invocation-gating pass

**Date:** 2026-07-05
**Agent:** Claude (Grim)
**Summary:** Fixed a GitHub push-protection block caused by a leaked OAuth secret + vendored plugin bloat in the `02-kol-vault-shape` template, renamed `init-agent`→`agent-init` with reinforcement repositioned to the last step via a new `/agent-reinforce` skill, and reconciled `disable-model-invocation` gating across 9 skills.

## Changes Made

### Files Modified
- `claude/packages/scaffold/02-scaffold-docs/obsidian-shapes/02-kol-vault-shape/.obsidian/plugins/` — deleted `remotely-save` (leaked Google OAuth client id/secret, tripped GitHub push protection) + 60 other installed-but-never-enabled community plugins (91→30, verified against `community-plugins.json`)
- `.../02-kol-vault-shape/.obsidian/plugins/kol-dashboard` → moved to new sibling `claude/packages/scaffold/02-scaffold-docs/obsidian-shapes/04-plugin-kol-dashboard/` (the one genuinely custom plugin, author Tór Grímsson) — no longer bundled inside the vault shape
- `.../02-kol-vault-shape/.obsidian/community-plugins.json` — dropped the dangling `kol-dashboard` enabled-entry after the move
- `.gitignore` — added `**/node_modules/` (kol-dashboard's own `node_modules` being committed was the root bloat)
- `claude/packages/scaffold/02-scaffold-docs/obsidian-shapes/INDEX.md`, `claude/skills/scaffold-docs-system/SKILL.md` — synced plugin counts/examples (90+ → 30, dropped stale `kol-dashboard`/`obsidian-git` mentions)
- `claude/skills/init-agent/` → renamed to `claude/skills/agent-init/` (plain `mv`); reinforcement-skill loading moved from step 1 to the last step (right before reporting "Context loaded")
- `claude/skills/log-work/SKILL.md`, `claude/skills/log-work-handoff/SKILL.md` — same repositioning: reinforcement now loads last, right before the final report message (`log-work-handoff` had no such step before — added for parity)
- New skill `claude/skills/agent-reinforce/SKILL.md` — bundles `agent-output-format` + `agent-reinforce-rules` + `agent-reinforce-memory` into one call
- `LLM_RULES.md` (root) + `claude/packages/scaffold/03-scaffold-llm-context/LLM_RULES.md` — both wired to load `/agent-reinforce` as their last step before reporting status
- `docs/16-claude-agents/{01-agent-context-protocol,02-skills,07-output-formats,INDEX}.md` — repointed every `init-agent` reference to `agent-init`, updated skill count/table entries and the new last-step wiring
- `claude/skills/scaffold-docs-system/SKILL.md` — added `disable-model-invocation: true` (was missing despite doing the same class of unprompted-write action as its sibling `scaffold-*` skills)
- `claude/skills/{agent-init,log-work,log-work-handoff,claude-bullet,claude-clear}/SKILL.md` — removed `disable-model-invocation: true` (user's explicit call: these don't do anything dangerous, just reinforce/log/report)
- `shell/.zshrc` — added `alias cl='claude'` (next to the existing `cc='clear'`)
- `docs/00-kol-cli/01-cli-cheatsheet.md` — added `cl`/`cc` rows to the existing Shell-aliases table
- `aerospace/aerospace.toml` + `docs/09-productivity-desktop/05-aerospace.md` — added `com.apple.Passwords` to the always-floating list

### Features Added/Removed
- New: `agent-reinforce` skill
- Removed: 61 vendored Obsidian plugin bundles from the `02-kol-vault-shape` template (dead weight — installed but never enabled, plus the one that leaked a secret)

## Current State

### Working
- Push-protection block resolved (user's own SSH auth fix, unrelated to the secret cleanup)
- `agent-init`/`log-work`/`log-work-handoff` all load `/agent-reinforce` as their last step, not first
- `disable-model-invocation` now consistent: `true` only on skills with real unprompted side effects (the `scaffold-*` family); reinforcement/logging/reporting skills stay ungated

### Known Issues
- None open from this session

## Next Steps
- None outstanding — this was a closeout session for everything raised in it.
