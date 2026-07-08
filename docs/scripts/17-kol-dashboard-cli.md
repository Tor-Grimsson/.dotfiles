---
title: kol-dashboard CLI
type: reference
status: active
updated: 2026-06-26
description: kol-kb + kol-dash — terminal twins of the Obsidian kol-dashboard plugin. They read the same files (inbox.md, data.json, _kol-config registries), so iTerm shows the same board / links / growth — no API, no daemon.
aliases:
  - kol-dashboard-cli
tags:
  - project/dotfiles
  - domain/scripts/obsidian
related:
  - "[[INDEX|Scripts index]]"
  - "[[16-capture|Capture pipeline]]"
  - "[[16-kanban-tui|kanban-tui]]"
---

# kol-dashboard CLI (`kol-`)

| Script | Does | Usage |
|--------|------|-------|
| `kol-kb`   | print **and edit** the capture kanban | `kol-kb` · `kol-kb move <n> <col>` · `--selftest` |
| `kol-dash` | print the other dashboard surfaces | `kol-dash links\|growth\|pinned\|tracks\|week` |

Terminal twins of the vault's **kol-dashboard** plugin. The plugin is a *view over files* (see its `SYSTEM.md`), so these read the **same state** — edit in one, re-run to see it in the other. Like `cplan` is to gcalcli.

## kol-kb — the kanban
Reads `kol-inbox/inbox.md` (the cards) + the plugin's `data.json` (`inboxState` = the column per card).
- `kol-kb` → Triage / Todo / Doing / Done, colored, each card tagged `[n]`.
- `kol-kb move <n> <column>` → writes `inboxState` (full-file load+dump, so the plugin's other settings survive).

## kol-dash — the read-only surfaces
| `kol-dash <x>` | Reads | Shows |
|---|---|---|
| `links`  | `_kol-config/links/*.md` | label · url · note, grouped by `group` |
| `growth` | `_kol-config/socials/*.md` | followers vs `goal-followers` (a bar) |
| `pinned` | notes with `pinned: true` | title + path |
| `tracks` | folders with `dashboard: true` | the project + its open `- [ ]` tasks |
| `week`   | `data.json` `weekEntries` | this week's reminders / notes |

## Gotchas
- **Vault-coupled.** Both hardcode `~/dev/projects/kol-vault` + the plugin path (the consumer-owns-the-map pattern, like `cplan`↔gcalcli). Non-prefixed `kol-` names, callable directly.
- **`data.json` race.** `kol-kb move` writes the file the live plugin also writes — if a move reverts, reload Obsidian. Edit from one side at a time.
- **Empty is normal.** `growth` / `week` show "not set" until you fill `followers:` / `weekEntries` in Obsidian.
- **No `pyyaml`** — frontmatter is parsed by a small regex (scalar keys only), so these stay dependency-free.
