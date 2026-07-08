---
name: kol-cdn-overview
description: Orientation reference for the Kolkrabbi CDN — which provider (B2 or R2), which bucket, what lives where, and who consumes it. Not action-based (no commands) — for browsing/uploading use kol-bucket-b2 (Backblaze) or kol-bucket-r2 (Cloudflare). Use this when the question is "where is X stored", "what's the CDN layout", "which bucket holds Y", or orienting to the CDN for the first time.
---

# kol-cdn-overview

Pure orientation — answers *where is it, what's the shape*, not *run this command*. For commands: [[kol-bucket-b2]] (Backblaze) / [[kol-bucket-r2]] (Cloudflare). Canon + live tree snapshots: `~/.dotfiles/docs/operations/05-cdn-r2b2/`.

## Two providers, three buckets

| Provider | Bucket | Location | Holds | Public? |
|---|---|---|---|---|
| **B2** (Backblaze) | `website` | `kolkrabbi:kolkrabbi/website` | The public site's media: `art-prints/` (print library), `asset-library/` (collections, homepage, foundry, studio assets), `hls-library/` (HLS + MP4 video — e.g. `video-library/work/` for kol-monorepo's work pages), `data-library/` (chess JSON/PGN) | Yes — `https://f005.backblazeb2.com/file/kolkrabbi/website/<path>` |
| **B2** (Backblaze) | `vault-media` | `kolkrabbi:kol-vault-media` | The Obsidian **kol-vault**'s media offload — `tg-inbox` captures land in `lobby/`, vault embeds by CDN URL so binaries never touch git | No (private-ish) |
| **R2** (Cloudflare) | `kol-media` | via `admin.kolkrabbi.io` / served at `media.kolkrabbi.io` | The `kol-media-admin` project's media store | Yes, via `media.kolkrabbi.io` |

## Who reads what

- **`website`** — `kol-monorepo` (public site + foundry) is the primary consumer.
- **`vault-media`** — Obsidian kol-vault only.
- **`kol-media`** (R2) — kol-system tools under kol-media-admin.

## Where the current tree lives

Live, auto-refreshed snapshots — never hand-paste a tree into a repo's own docs, link here instead:

- `~/.dotfiles/docs/operations/05-cdn-r2b2/02-b2-tree.md` / `04-r2-tree.md` — readable tree per provider (Obsidian)
- `~/.dotfiles/docs/operations/05-cdn-r2b2/_files/<bucket>/{tree.json, tree.full.txt}` — raw (scripts/nvim)

Refreshed automatically by a post-write hook on every `bucket`/`bucket-r2` write (see `05-scripts.md`) — nothing here goes stale by hand-editing.

## Related

- [[kol-bucket-b2]] / [[kol-bucket-r2]] — the action skills (ls/tree/upload/sync/rm)
- `~/.dotfiles/docs/operations/05-cdn-r2b2/INDEX.md` — full canon: bucket-tree mechanics, drift detection, distribution to Obsidian/consumers
