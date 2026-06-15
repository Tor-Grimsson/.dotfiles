# Session: Supabase Brewfile tap reconciliation

**Date:** 2026-06-15
**Agent:** Grim (Opus 4.8, iMac)
**Summary:** Added the missing `tap "supabase/tap"` line to the Brewfile so `brew bundle` can resolve the `supabase` CLI formula on a clean machine.

## Changes Made

### Files Modified
- `Brewfile` — added `tap "supabase/tap"` under the **Taps** section (line 9). The formula line `brew "supabase/tap/supabase"` (Dev & languages, line 54) was already present from an earlier unlogged session; without the tap declaration `brew bundle` would fail to find the formula on the MBP.

### Features Added/Removed
- None. Pure Brewfile reconciliation — closes a real `brew bundle` gap.

## Current State

### Working
- Brewfile now carries both halves of the supabase install: `tap "supabase/tap"` + `brew "supabase/tap/supabase"`. `brew bundle` is self-contained again.
- `supabase` CLI installed on the **iMac** (user ran `brew install supabase/tap/supabase`, v2.106.0).
- Full guide already exists at `docs/14-supabase/` (9 chapters + INDEX), registered in the root `docs/INDEX.md` as **category 14 under `## Guides`** — documented as a guide, not a per-tool reference, so the catalog stays **70 tools / 13 categories**.

### Known Issues
- **MBP doesn't have supabase yet** — needs `brew bundle` after the commit lands (tap + formula both reproduce from the Brewfile then).
- The earlier supabase-guide session (created `docs/14-supabase/` + INDEX entry + the Brewfile formula line, ~2026-06-14 22:30–22:48) **never wrote a session log or updated AGENT-CONTEXT** — this session backfills the context entry for the whole arc.

## Next Steps
1. **MBP:** `brew bundle` to install the supabase CLI (tap auto-taps from the Brewfile).
2. Nothing else pending on supabase — docs, INDEX, and Brewfile all agree.
