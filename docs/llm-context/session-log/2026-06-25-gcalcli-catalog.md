# Session: gcalcli added — Google Calendar from the terminal

**Date:** 2026-06-25
**Agent:** Grim (Claude Opus, `~/.dotfiles`, iMac)
**Summary:** Added `gcalcli` (Google Calendar CLI) to the Brewfile + catalog. Picked it over khal+vdirsyncer / calcurse / Nylas after a landscape check — gcalcli is the best for a Google-only workflow; the alternatives win only for CalDAV/multi-provider/local-first, which isn't the case here.

## Changes Made

### Files Modified
- `Brewfile` — `+ brew "gcalcli"` (after `w3m`, the terminal-apps block).
- `docs/01-shell-terminal/INDEX.md` — new `[[14-gcalcli|gcalcli]]` row; `updated: 2026-06-25`.
- `docs/INDEX.md` — catalog **75 → 76**; cat 01 **10 → 11**; `updated: 2026-06-25`.

### Features Added
- New catalog doc `docs/01-shell-terminal/14-gcalcli.md` (kol-docs `reference`). Filed in **cat 01 (Shell & Terminal)**, not 09 (Productivity & **Desktop** = GUI apps) — gcalcli is a terminal app, consistent with `08-glow` (also a CLI app in 01). Covers the one-time Google Cloud OAuth-client setup, the view/add/edit/import commands, config (`~/.config/gcalcli/config.toml`), and the secret-handling note.

## Current State

### Working
- Doc + INDEX wiring landed and count-consistent (cat-01 has 12 doc files but `13-shell-functions` is a meta doc, not a counted tool → 11 tools).

### Findings / gotchas
- gcalcli **no longer ships a bundled API client** — user must create their own Google Cloud OAuth "Desktop app" client (enable Calendar API, add self as Test user → no Google verification needed), then `gcalcli --client-id=… init`. This is the only friction.
- OAuth **token is a secret** → gcalcli's data dir (`~/.local/share/gcalcli/oauth`), machine-local, **not** repo-tracked (ARCHITECTURE §3). Only the Brewfile line + aliases live in the repo.
- Google-only by design; khal+vdirsyncer is the provider-agnostic/local-first alternative if a non-Google calendar ever enters the mix.

## Next Steps
1. **Both machines:** `brew bundle` to install gcalcli (no-provisioning rule — user runs it).
2. **Per machine:** create the OAuth client once + run `gcalcli … init` (token is local, not synced — same as `gh auth login`).
3. **Catalog gap to resolve (separate):** `mdcat` (added earlier today as the yazi `.md` previewer) is installed but has no standalone catalog doc — yet sibling preview backends `sevenzip`/`resvg` are counted tools in cat 02, and `glow` has `01-shell-terminal/08-glow.md`. Either give mdcat its own doc (bump count) or leave it as a yazi-backend mention; user's call.
