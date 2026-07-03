# Session: bucket-drift.sh — read-only CDN drift check

**Date:** 2026-06-25
**Agent:** Grim (Claude Opus, ~/.dotfiles, iMac)
**Summary:** New generic `bin/` verb that flags drift between a saved file-list baseline and a live rclone bucket lane. Built for the kol-vault's new `_kol-cdn` home (which owns the remote→baseline map and wraps this verb), but it's bucket-agnostic.

## Changes Made

### Files Added
- `bin/bucket-drift.sh` — `bucket-drift.sh <remote> <baseline> [--update]`. Read-only (`rclone lsf -R`, `segment_*.ts` filtered), reuses `diff` (no engine). check mode exits 1 on drift with `only in baseline` / `only on bucket` lines; `--update` refreshes the baseline. `usage()` heredoc, `bash -n` clean, no hardcoded paths (§1/§N-safe).
- `docs/12-scripts/14-bucket-drift.md` — reference doc (split-design rationale, modes, read-only note).

### Files Modified
- `docs/12-scripts/INDEX.md` — `bucket-` row in the prefix table (family count 1).

## Current State

### Working
- Verified both directions against the live `kol-vault-media` bucket: in-sync → exit 0; tampered baseline (1 dropped + 1 fake line) → DRIFT + exit 1, both lines reported correctly.
- On PATH via `~/bin`.

### Notes
- **Not a root-catalog tool** (a `bin/` script, no install) — catalog count unchanged.
- The consumer + baselines live in the **vault** (`_system/_kol-cdn/_scripts/cdn-drift.sh`, `_snapshot.txt` per lane), logged on the vault side.
- **Website-bucket drift is expected** (that bucket is externally managed — site deploys from the kol-monorepo change it); **vault-media drift is the meaningful signal**.

## Next Steps
1. If drift checking should be ambient, bolt the vault's `cdn-drift.sh` onto the `dot-sync` launchd daemon — but on-demand is fine until drift actually bites.
