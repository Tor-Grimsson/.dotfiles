# Session: Telegram capture pipeline + kanban-tui catalog

**Date:** 2026-06-26
**Agent:** Grim (Claude Opus, `~/.dotfiles`, iMac)
**Summary:** Built a frictionless capture system — a personal Telegram bot whose messages a launchd-timed poller routes to Todoist / the Obsidian vault / the calendar by `#kol-*` tag. Solves the "scattered post-its + headerless self-emails" problem with one inbox reachable from phone or desktop. Also cataloged `kanban-tui` (uv tool) earlier in the session.

## Changes Made

### Files Added
- `bin/tg-inbox.sh` — polls a Telegram bot (`getUpdates`), classifies each message by leading tag, routes it. `--selftest` (offline parser asserts) + `--help`. bash-3.2 safe.
- `macos/launchd/com.kolkrabbi.tg-inbox.plist` — runs the poller every **120 s** via `/bin/zsh -lc` (login shell → sources `~/.secrets` for tokens + full PATH). `plutil -lint` OK.
- `docs/12-scripts/16-capture.md` — full system reference (architecture diagram, tags, pieces, setup, gotchas).
- `docs/01-shell-terminal/16-kanban-tui.md` — kanban-tui catalog doc (cataloged earlier this session).

### Files Modified
- `bootstrap.sh` — new tg-inbox launchd install block (cp + bootout + bootstrap), mirroring dot-sync.
- `docs/12-scripts/INDEX.md` — bold `tg-` family row, prefix list, date.
- `docs/01-shell-terminal/INDEX.md` + `docs/INDEX.md` — kanban-tui row; **catalog 76 → 77 → 78**, cat 01 **11 → 13** (gcalcli + mdcat + kanban-tui across the session); maintenance note lists kanban-tui as a uv tool.
- `docs/01-shell-terminal/14-gcalcli.md` — reciprocal `related` to kanban-tui + the capture pipeline.

### Routing (tags → destination)
- `#kol-td` / `#t` → **Todoist** (`POST /api/v1/tasks`)
- `#kol-cal` / `#e` → **calendar** (`gcalcli quick`)
- `#kol-ob` / `#n` → **Obsidian** `kol-vault/Inbox.md` (timestamped append)
- untagged → vault note (catch-all). Multiple tags → one destination via `case … | …`.

## Current State

### Working
- End-to-end verified: `#t buy milk` / `call mom` → Todoist; selftest green with both tag sets.
- launchd timer **loaded and healthy** on the iMac (`launchctl list | grep tg-inbox` → exit 0). Runs hands-free every 2 min.
- Tokens in `~/.secrets` (machine-local, exported, sourced by `.zshrc` + the plist's `zsh -lc`). No Bitwarden unlock needed at runtime.

### Findings / gotchas (all fixed)
- **Todoist deprecated `/rest/v2`** → 410 Gone. Now uses unified **`/api/v1/tasks`** (2025).
- **`set -e` + `cat` of a missing state file** exits the script silently → offset read is `… || true; ${offset:-0}`.
- **bitwarden-cli was unlinked** (Node-dependency upgrade broke the `bw` symlink — not a cleanup policy); `brew install bitwarden-cli` relinked it. The CLI vault cache was stale → `bw sync` pulled app-added items.
- Tokens were stored as **Secure Notes** (notes field), not password — but the pipeline now reads `~/.secrets` env exports, bypassing Bitwarden entirely.

### Known issues
- `#kol-cal` events need gcalcli **authed** (OAuth) first — still pending until the gcalcli setup is run; until then `#kol-cal` silently no-ops.

## Next Steps
1. **MBP:** create its own `~/.secrets` (tokens don't sync) + run `bootstrap.sh` to install the timer there.
2. Finish gcalcli OAuth so `#kol-cal` routes.
3. Optional: more routes (e.g. a `#kol-tg`→kanban-tui board) — one `case` arm + one `route_*` function.
