# Session: ponytail plugin installed + bootstrap wired

**Date:** 2026-06-23
**Agent:** Grim (Claude Opus, `~/.dotfiles`, iMac)
**Summary:** Installed the third-party `ponytail` Claude Code plugin (over-engineering / delete-code reviewer) on the iMac and tracked the install *intent* in `bootstrap.sh`, mirroring the existing MCP-server pattern. Runtime state (cloned repo + state JSON) deliberately NOT tracked per ARCHITECTURE §N.

## Changes Made

### Files Modified
- `bootstrap.sh` — new "Claude plugins" block after the MCP block (lines ~76–81): `claude plugin marketplace add DietrichGebert/ponytail` + `claude plugin install ponytail@ponytail`, same `command -v claude` guard and `2>/dev/null || true` idempotency. Comment notes the cloned repos + `*.json` in `~/.claude/plugins` are runtime state and not tracked.

### Features Added/Removed
- **ponytail plugin** (third-party, `DietrichGebert/ponytail`, v4.8.1) installed user-scope on the iMac. Ships 6 skills: `ponytail` (core delete-over-engineering reviewer), `ponytail-review`, `ponytail-audit`, `ponytail-debt`, `ponytail-gain`, `ponytail-help`.

## Current State

### Working
- iMac: marketplace `ponytail` added + plugin installed live (verified in `installed_plugins.json`, scope user, commit `763e04d`). Skills present under `~/.claude/plugins/marketplaces/ponytail/skills/`.
- `bootstrap.sh` reproduces the install on a fresh machine.

### Known Issues / Notes
- Skills won't appear in the available-skills list until the **session is restarted** — not yet verified in a live session.
- Marketplace is pinned to the third-party repo's `main` (whatever Dietrich pushes is reproduced). Fork + repoint the bootstrap line if a frozen version is ever wanted.
- Plugin is **not** in the repo (runtime state, ARCHITECTURE §N) — only the bootstrap intent is tracked. Catalog count unchanged (a plugin, not a Brewfile tool).

## Next Steps
1. Restart the session, confirm the 6 `ponytail-*` skills register, and point one at real code to see if it earns its keep.
2. MBP: run `bootstrap.sh` (or the two `claude plugin` commands) to install ponytail there.
3. bootstrap.sh edit is uncommitted — user pushes when ready (per no-commits rule).
