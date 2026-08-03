# Session: ubu-roi published — payload generator, skill cut, shared/local marketplace split

**Date:** 2026-08-03
**Agent:** Claude Code (Grim)
**Summary:** The humpty plugin now has a public publishing surface (`ubu-roi`, 67 files, generated not hand-copied), the skill set was cut 35 → 18, and the marketplace/statusline wiring was reworked so one shared `settings.json` works on both machines.

## Changes Made

### Files Modified — humpty
- `bin/humpty-payload` — **new.** Stages the runtime payload into `../ubu-roi`. Allowlist not denylist; copy never move. Five pre-flight checks: tests green · no personal paths · every registered hook exists · both manifests present · every skill's frontmatter valid. Refuses to stage on any failure
- `README.public.md` — **new.** Staged as ubu-roi's README so the public front page is generated too. Rewritten to the kolkrabbi writing guidelines (active voice, no rhetorical framing, tables for structured data)
- `skills/layouts/` — **new.** Collapsed 8 `output-l*` skills into one, bundling `LAYOUT-REGISTER.md`, `FOOTER-REGISTER.md`, 8 format modules, `box-table.py` and `format-check.py`
- `skills/humpty-goal/` — renamed from `kol-goal`; `humpty_goal.py`'s `CMD` constant and `humpty_lib.py`'s comment follow
- `hooks/humpty_stop.py` — imported `format-check.py` from `docs/`; repointed at the bundled copy
- `hooks/tests.sh` — repointed at bundled scripts; added a `skip()` counter so a dev-only dependency being absent is reported as not-applicable rather than as a failure
- `hooks/humpty_rm.py` — added `__pycache__`, `.pyc`, `.pytest_cache`, `.mypy_cache`, `.ruff_cache` to the scratch list
- `.claude-plugin/{plugin,marketplace}.json` — descriptions synced to the current feature set
- `_tmp/2026-08-03-skills-cut/` — 20 skills quarantined; `_tmp/2026-08-03-skills-before-cut/` holds all 37 pre-cut

### Files Modified — dotfiles
- `claude/settings.json` — marketplace repointed to `github: Tor-Grimsson/ubu-roi`; `statusLine` → `bin/kol-statusline`
- `bin/kol-statusline` — **new.** Locator: prefers the dev repo, falls back to the newest plugin cache, prints nothing if neither exists
- `~/.claude/settings.local.json` — **new, untracked.** Overrides the marketplace back to `directory` on this machine only
- `_tmp/2026-08-03-skills-cut-dotfiles/` — the same 20 skills quarantined here

### Features Added/Removed
- Added: a generated publishing surface, a pre-publish gate, a machine-local marketplace override
- Removed: 20 skills from both repos (quarantined, never deleted)

## Current State

### Working
- `ubu-roi` — 67 files, tests pass standalone (191 pass · 0 fail · 1 skip)
- `humpty-payload --check` — the pre-publish command
- Statusline renders through the locator on this machine
- Skills: humpty 18 · dotfiles 62 (was 82)

### Known Issues
- **The 18 kept skills are live in both repos.** Plugin skills are namespaced (`humpty:layouts` confirmed in the live skill list), so the duplicate is the user's call
- `docs/operations/systems/agent-system/12-setup-a-to-z.md` still describes the old hook wiring
- 8 concepts remain specs, not packages; `concepts/09-memory` was never written

## Next Steps
1. On the MBP: pull dotfiles, restart, `/plugin install humpty@humpty`, verify `$humpty` answers.
2. Rule the duplicate-skill question and quarantine the losing copy.
3. `npx @framer/agent setup` — user-run; then track it in dotfiles docs.
4. Package the 8 concepts; write `concepts/09-memory`.
