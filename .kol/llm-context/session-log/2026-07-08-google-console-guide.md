# Session: Google console guide + billing-suspension triage

**Date:** 2026-07-08
**Agent:** Claude (Grim)
**Summary:** Triaged a "Google Cloud billing account suspended" email (turned out to be an orphaned, harmless Cloud billing account — separate from the just-paid Workspace bill), then wrote a Google-console reference guide so the next time costs minutes, not an hour.

## Changes Made

### Files Added
- `docs/documentation/19-google-cloud/INDEX.md` — new **Guide category 19** ("Google console, from the trenches").
- `docs/documentation/19-google-cloud/01-console-map.md` — the reference: two-billing-systems table (Workspace vs Cloud), the three gotchas (project ≠ billing account, org-owned vs personal billing accounts, the `authuser=N` 404 trap), a direct-links table, how to close an orphaned billing account, and the kolkrabbi.io footprint snapshot.

### Files Modified
- `docs/documentation/INDEX.md` — registered guide 19 under `## Guides` (1 chapter).
- `docs/documentation/01-shell-terminal/14-gcalcli.md` — reciprocal `related:` link to `[[01-console-map]]`.

## Current State

### Working
- Guide live under `documentation/19-google-cloud/`. Tool count unchanged (it's a Guide, not a per-tool doc).

### Resolved (the billing scare)
- **Workspace (Gmail-for-business)** is **Active / paid** — the bill the user paid yesterday; the one that actually matters (runs the email).
- The **Cloud billing account `019B32-337BA5-902E6F`** is **orphaned** — no project links to it (all 4 kolkrabbi.io projects show "Billing is disabled"), owned by a personal login (not the org; `authuser=1` 404'd). From a lapsed card. **Left to auto-terminate** — nothing depends on it, no action needed.
- The 4 projects: 3× AI Studio/Gemini (`gen-lang-client-*`), 1× Cursor default (`alert-cursor-479211-k6`). All free tier. gcalcli remains the only intentional Google-API use (free Calendar API, no billing).

### Known Issues
- None. The suspended-account email is noise; if a real invoice/collections notice ever appears, revisit.

## Next Steps
1. (Optional) If the dunning emails annoy: sign in as the owning personal login → `console.cloud.google.com/billing/019B32-337BA5-902E6F/manage` → Close billing account.
2. Still open from the prior session: user to reload tmux (`Ctrl-a r`) and live-test `C-p` / `C-d` / `C-o`.
