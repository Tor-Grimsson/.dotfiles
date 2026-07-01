# Session: tg-inbox media→bucket + kol-kb / kol-dash terminal twins

**Date:** 2026-06-26
**Agent:** Grim (Claude Opus, `~/.dotfiles` + kol-vault added)
**Summary:** Expanded the capture bot to handle media (→ CDN bucket, never git), and built two terminal twins of the Obsidian kol-dashboard (`kol-kb`, `kol-dash`) that read the plugin's own files. (Calendar tab + the inbox kanban/action-menu were the vault-plugin side — logged in the vault's context.)

## Changes Made

### `bin/tg-inbox.sh` — media pipeline
- Poller now extends the jq select to detect `photo`/`video`/`document`/`voice` (largest photo size) and branches: media → `route_media()`, else text → classifier (unchanged).
- `route_media()`: `getFile` → download (named correctly) → **`bucket up` into `kol-vault-media/lobby/<ts>-<kind>.<ext>`** → `inbox.md` gets `- ts ![](CDN-url) caption`. **Nothing binary touches the vault/git** (matches the vault's git-light media law). Env-overridable: `MEDIA_BUCKET` / `MEDIA_CDN_BASE` / `MEDIA_LOBBY` (default kol-vault-media/lobby).
- **Bug found+fixed:** `bucket up <file> lobby/$fn` made `$fn` a *directory* (rclone-copy semantics) → URL 404. Fix: name the temp file, upload **into** `lobby/`. Verified round-trip → HTTP 200; test artifacts purged.

### New `bin/` scripts (terminal twins of the kol-dashboard plugin)
- **`kol-kb`** (Python) — the capture kanban: `kol-kb` prints Triage/Todo/Doing/Done (colored, `[n]` ids); `kol-kb move <n> <col>` writes `inboxState` in the plugin's `data.json` (full-file load+dump preserves other settings). Reads `kol-inbox/inbox.md` + `data.json`. `--selftest` green.
- **`kol-dash`** (Python) — read-only surfaces: `links` / `growth` / `pinned` / `tracks` / `week`, reading `_kol-config/*` + `data.json` + frontmatter markers. Regex frontmatter parse (no pyyaml). Consolidated 5 surfaces into one tool (vs 5 scripts).

### Docs
- `docs/12-scripts/16-capture.md` — media route in the diagram + a **Media** section + the dashboard-surface note.
- New `docs/12-scripts/17-kol-dashboard-cli.md` (`kol-` family); scripts INDEX gained the `kol-` row + prefix.

## Current State
### Working
- Verified: text routing (selftest), media jq-extraction (photo→largest), bucket round-trip (200), kol-kb print+move round-trip, all 5 kol-dash surfaces against real vault data.

### Known issues / ceilings
- **Vault-coupled:** `kol-kb`/`kol-dash` + the media route hardcode `~/dev/projects/kol-vault` (consumer-owns-map pattern, like `cplan`↔gcalcli). `tg-inbox` media needs the `bucket` CLI + rclone creds (present where the vault offloads).
- `kol-kb move` vs a live Obsidian save can race — reload if a move reverts.
- Media "link to the Telegram message" isn't possible (private bot chat = no permalink) — caption+ts is the trace.

## Next Steps
1. **MBP:** the whole bot stack (tokens in `~/.secrets`, launchd timer, gcalcli auth) + the `bucket`/rclone creds.
2. Media-lobby maintenance pipelines (purge-after-review, relocate within bucket / bucket→local) — the `lobby/` lane is the unit.
3. Roadmap: voice→`au-transcribe`, the YT/TT-link transcriber → inbox.
