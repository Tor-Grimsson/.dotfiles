---
title: Torrent scripts
type: reference
status: active
updated: 2026-06-04
description: tor-* — Jackett torrent indexer + search.
tags:
  - project/dotfiles
  - domain/scripts/torrent
---

# Torrent (`tor-`)

| Script | Does | Usage |
|--------|------|-------|
| `tor-jackett` | Symlink → the local Jackett binary (`~/.local/share/jackett/jackett`). Torrent indexer proxy. Gitignored (machine-local) | `tor-jackett` |
| `tor-search` | Query Jackett from the CLI | `tor-search <search term>` |

> Renamed from `jackett` / `jsearch`. `.gitignore` updated `bin/jackett` → `bin/tor-jackett`.
