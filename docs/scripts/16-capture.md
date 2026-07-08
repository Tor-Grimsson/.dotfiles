---
title: Capture pipeline
type: reference
status: active
updated: 2026-06-26
description: tg-inbox.sh — one frictionless inbox (a Telegram bot) that routes fleeting thoughts to their home — Todoist, the Obsidian vault, or the calendar — from phone or desktop, hands-free via a launchd timer.
aliases:
  - capture
tags:
  - project/dotfiles
  - domain/scripts/capture
  - integration/telegram
  - integration/todoist
related:
  - "[[INDEX|Scripts index]]"
  - "[[11-dot-sync|Dotfiles sync]]"
  - "[[16-kanban-tui|kanban-tui]]"
  - "[[14-gcalcli|gcalcli]]"
---

# Capture pipeline (`tg-`)

| Script | Does | Usage |
|--------|------|-------|
| `tg-inbox.sh` | Poll a personal Telegram bot, route each message to its home | `tg-inbox.sh` · `--selftest` · `--help` |

**The problem it solves:** scattered post-its, calendar events that are "too much," and a stream of headerless self-emails. One trusted inbox you can hit from anywhere, that *sorts itself* into the right destination.

## Architecture

```
  phone / desktop                      mac (launchd, every 2 min)
 ┌───────────────┐   Telegram    ┌──────────────────────────────┐
 │  Telegram app │ ───────────▶  │  tg-inbox.sh  (poll getUpdates)│
 │  → your bot   │   Bot API     │        │ classify by #tag       │
 └───────────────┘               │        ▼                        │
                                 │   #kol-td  → Todoist  (API v1)  │
                                 │   #kol-cal → gcalcli quick      │
                                 │   #kol-ob  → kol-inbox/inbox.md │
                                 │   (untagged) → vault note       │
                                 │   photo/video → bucket lobby    │
                                 │                 + inbox embed   │
                                 └──────────────────────────────┘
```

The vault's **kol-dashboard** plugin surfaces `inbox.md` two ways: the **INBOX** tab (full kanban) and a triage **list + mini-board** on WORK, with a per-card action menu (→ new note / file-to-group / board / delete). So capture (here) and triage (there) read the same `inbox.md`.

**Capture is universal** — the Telegram client runs on iPhone, Mac, web, everywhere, and they all sync to the same bot chat. So a thought caught on the phone in a queue lands in Todoist on the Mac without you touching either app.

## Tags

| Tag (alias) | Goes to |
|---|---|
| `#kol-td` (`#t`) | **Todoist** task |
| `#kol-cal` (`#e`) | **calendar** event ([[14-gcalcli|gcalcli]] `quick`, natural-language date) |
| `#kol-ob` (`#n`) | **Obsidian** vault — appended to `kol-vault/kol-inbox/inbox.md` (folder note `INDEX.md` explains it), timestamped |
| _(no tag)_ | vault note (catch-all — nothing is ever lost) |
| _(photo / video / document / voice)_ | **media** — uploaded to the CDN, embedded in `inbox.md` (see below) |

Tags are just strings in a `case` in `classify()`; multiple aliases map to one destination via `|`. Add a route = one `case` arm + one `route_*` function.

## Media
A message bearing an attachment (not text) is handled by `route_media()`, **not** the tag classifier:
1. `getFile` → download the largest size to a temp file.
2. `bucket up` → **`kol-vault-media/lobby/<ts>-<kind>.<ext>`** (a dedicated lobby lane).
3. `inbox.md` gets `- ts ![](CDN-url) <caption>` — the image/video renders inline in Obsidian.

**Nothing binary touches the vault or git** — media lives in the bucket, matching the vault's git-light media law. The `lobby/` lane is a clean unit for future maintenance pipelines (purge-after-review, relocate). Destination is env-overridable: `MEDIA_BUCKET` / `MEDIA_CDN_BASE` / `MEDIA_LOBBY`. Needs the `bucket` CLI + rclone creds (already present where the vault offloads media).

## The pieces

| Piece | Role | Tracked? |
|---|---|---|
| `bin/tg-inbox.sh` | the poller + router | ✅ repo |
| `macos/launchd/com.kolkrabbi.tg-inbox.plist` | runs it every 2 min via `zsh -lc` (sources `~/.secrets` → tokens + PATH) | ✅ repo (installed by `bootstrap.sh`) |
| `~/.secrets` | `export TG_BOT_TOKEN` / `TODOIST_TOKEN` | ❌ machine-local, **never** in git (§3) |
| Telegram bot | the capture surface (made via @BotFather) | external |
| Todoist | task destination (personal API token) | external |

State (the last-seen update id) lives at `~/.local/state/tg-inbox/offset` so messages aren't re-processed.

## Setup / reproduce on another machine
1. `brew bundle` (needs `curl`+`jq`; `gcalcli` for `#kol-cal`).
2. Telegram: @BotFather → `/newbot` → bot token; @userinfobot → your chat id (already in the script as `TG_CHAT_ID`).
3. Todoist: Settings → Integrations → Developer → API token.
4. Put both in `~/.secrets`:
   ```sh
   export TG_BOT_TOKEN="…"
   export TODOIST_TOKEN="…"
   ```
5. Load the timer:
   ```sh
   cp ~/.dotfiles/macos/launchd/com.kolkrabbi.tg-inbox.plist ~/Library/LaunchAgents/
   launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.kolkrabbi.tg-inbox.plist
   ```
   (or run `bootstrap.sh`, which does this). Verify: `launchctl list | grep tg-inbox` → a line = on.

## Gotchas
- **Todoist API:** the old `/rest/v2/` is **gone (410)** — this uses the unified `/api/v1/tasks` (2025).
- **`set -e` + `cat`:** the offset read uses `|| true` then `${offset:-0}` — a *missing* state file makes `cat` exit 1, which would otherwise kill the script silently.
- **Tokens stay out of the repo.** `~/.secrets` is sourced by `.zshrc` (interactive) and by the plist's `zsh -lc` (timer) — same file, both paths. No Bitwarden unlock needed at runtime.
- **Stop the timer:** `launchctl bootout gui/$(id -u)/com.kolkrabbi.tg-inbox`.

## Why it's the hub
Telegram is the only capture layer that is *both* phone-native *and* scriptable — so it can fan out to anywhere a shell can reach. [[16-kanban-tui|kanban-tui]] can't be this (local-only, no mobile); a paid Raycast/Obsidian-sync can't either. This is the "send a fleeting thought to its optimal location" system, built from a 90-line script + a 2-minute timer.
