---
name: kol-bucket-r2
description: Browse, fetch, and upload to the kol-media Cloudflare R2 bucket (the kol-media-admin project's media store) via the `bucket-r2` CLI wrapper. Use when the user asks about kol-media-admin's bucket, media.kolkrabbi.io files, or uploading media for kol-system tools. For the Kolkrabbi Backblaze B2 CDN bucket (art-prints, asset-library, HLS), use kol-bucket-b2 instead.
---

# kol-bucket-r2

Thin wrapper for the `kol-media` Cloudflare R2 bucket used by the `kol-media-admin` project. Lives at `~/.local/bin/bucket-r2`. (Backend is R2, not B2 — see [[kol-bucket-b2]] for the separate Backblaze bucket.)

## Bucket model

- **Bucket:** `kol-media` (Cloudflare R2), managed by the `kol-media-admin` repo (`/Users/biskup/dev/projects/kol-apparat/kol-plugin/kol-media-admin`)
- **Public CDN URL pattern:** `https://media.kolkrabbi.io/<key>`
- **Admin/API origin:** `https://admin.kolkrabbi.io` — `GET /api/list` is public (no auth, CORS `*`); upload/rename/delete require the admin's Basic Auth and aren't exposed through this CLI (use the admin UI, or `wrangler` directly, for those)
- No folders as first-class objects — "folders" are just common key prefixes (e.g. `video/`, `type/`)
- No tagging/metadata layer — deliberate non-goal, see the project's `ARCHITECTURE.md` §N

## Commands

| Verb | Args | What | How |
|---|---|---|---|
| `bucket-r2 ls` | `[prefix]` | List objects under prefix | public `/api/list` |
| `bucket-r2 url` | `<key>` | Print the public CDN URL | — |
| `bucket-r2 cat` | `<key>` | Stream a file to stdout | public CDN URL |
| `bucket-r2 up` | `<local> <remote-key>` | Upload a single file | `wrangler r2 object put --remote` |
| `bucket-r2 down` | `<remote> [local]` | Download | public CDN URL |
| `bucket-r2 rm` | `<key>` | Delete a single object | `wrangler r2 object delete --remote` |

No `tree`, `sync`, or bulk/recursive upload in this wrapper — kill criteria: add only if single-file use stops being enough. For uploading a whole local folder, use the project's own `scripts/bulk-upload.sh <local-dir> <remote-prefix>` in `kol-media-admin` (parallelized, preserves relative paths) — that's a separate, more deliberate tool, not something to fold into this thin wrapper.

## Why no R2 API token / rclone remote

Unlike the B2 wrapper (which needs an rclone remote + account key), this one needs **zero new credentials**:
- Reads go through the already-public admin API.
- Writes go through `wrangler`, which is already OAuth-authenticated for this Cloudflare account (`wrangler whoami` from inside `kol-media-admin` confirms R2 write access) — no R2 API token to generate in the dashboard.

`wrangler` is invoked via `npx --yes wrangler` if not globally installed, so `bucket-r2` works from any directory without needing to `cd` into the project.

## How to use

- **Browse / lookup:** `bucket-r2 ls`, `bucket-r2 ls video/`, `bucket-r2 url <key>` — read-only, safe to run freely.
- **Upload/delete:** confirm scope with the user first — these mutate the real bucket that kol-system tools read from live.
- **`command not found`:** wrapper lives at `~/.local/bin/bucket-r2` — check it's on PATH or invoke by absolute path.

## Related

- Project: `kol-media-admin` (`docs/llm-context/ARCHITECTURE.md`, `AGENT-CONTEXT.md`)
- Bulk upload: `kol-media-admin/scripts/bulk-upload.sh`
- Sibling skill: [[kol-bucket-b2]] — different bucket, different backend, don't conflate
- Tree snapshots: `bucket-tree.sh kol-media` → readable JSON in the dotfiles, auto-refreshed on every write. System doc: `docs/operations/05-cdn-r2b2/`.
