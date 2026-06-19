---
title: kol-media — our actual setup
type: reference
status: active
updated: 2026-06-19
description: The specific Cloudflare R2 bucket and Pages admin tool used in kol-labs. Domains, repos, commands, limits, gotchas.
audience: internal
aliases:
  - kol-media-setup
tags:
  - provider/cloudflare
  - domain/media
  - domain/storage
sources:
  - /Users/biskup/dev/projects/kol-apparat/kol-plugin/kol-media-admin
related:
  - "[[02-r2-and-buckets|R2 & buckets]]"
  - "[[03-pages|Cloudflare Pages]]"
  - "[[04-wrangler|Wrangler]]"
---

# kol-media — our actual setup

## What we have

| Thing | What it is | Where |
|---|---|---|
| `kol-media` | R2 bucket holding all media files | Cloudflare dashboard |
| `media.kolkrabbi.io` | Public CDN URL for the bucket | Served by Cloudflare |
| `admin.kolkrabbi.io` | Admin web tool to manage the bucket | Cloudflare Pages |
| `kol-media-admin` | The repo for the admin tool | `/Users/biskup/dev/projects/kol-apparat/kol-plugin/kol-media-admin` |
| `kol-labs /library` | Read-only browser inside kol-labs | `labs.kolkrabbi.io/library` |

## The admin tool

`admin.kolkrabbi.io` is a React app (Vite) deployed to Cloudflare Pages. It has:

- **Drag-and-drop upload** — set a folder prefix first (e.g. `video/`) then drop files
- **Folder browsing** — folders appear above files; click to descend; breadcrumb to go back
- **Lightbox** — click any image or video thumbnail → full-screen preview; video autoplays with controls; `←`/`→` navigate; `Escape` closes
- **Rename** — click a filename to edit inline
- **Delete** — with confirm dialog
- **Copy URL** — copies the public CDN URL to clipboard
- **Grid / list toggle** — top-right of the files section

It's protected by HTTP Basic Auth (`ADMIN_PASSWORD` set in Cloudflare Pages environment variables).

## Deploy the admin tool

Every time you change the admin tool code, rebuild and redeploy:

```bash
cd /Users/biskup/dev/projects/kol-apparat/kol-plugin/kol-media-admin
CI=true pnpm build
pnpm wrangler pages deploy dist --project-name kol-media-admin --branch main
```

If Wrangler isn't authenticated: `pnpm wrangler login` first.

## The wrangler.toml

The repo's `wrangler.toml` wires the R2 bucket to the Pages Function:

```toml
name = "kol-media-admin"
pages_build_output_dir = "dist"
compatibility_date = "2025-01-01"

[[r2_buckets]]
binding = "MEDIA_BUCKET"
bucket_name = "kol-media"
```

- `pages_build_output_dir = "dist"` — tells Wrangler where the built files are
- `binding = "MEDIA_BUCKET"` — in every Function, `env.MEDIA_BUCKET` is the live R2 connection

## Consuming media in kol-labs

`src/lib/mediaLibrary.js` is the client:

```js
import { mediaUrl, listMedia } from '../lib/mediaLibrary'

// Get the public URL for a key
mediaUrl('video/handshake.mp4')
// → https://media.kolkrabbi.io/video/handshake.mp4

// List everything (or under a prefix)
const objects = await listMedia('')
// → [{ key, contentType, size }, ...]
```

`listMedia` calls the admin tool's public `/api/list` endpoint (no auth required for reads). The Library page (`/library`) calls it on load, then partitions client-side into folders + files.

## Folder conventions

R2 has no real folders. Everything is a flat key. "Folders" are just keys that share a prefix:

```
video/asmr-sharp.mp4   → appears in "video/" folder
video/knlt-ms-02.mp4   → appears in "video/" folder
photoshoot/01.jpg      → appears in "photoshoot/" folder
01.jpg                 → appears at root
```

When uploading, set the prefix field in the admin tool to land files in the right place.

## Upload limit

**100 MB per file.** Files larger than this will fail silently or return a 500 error. This is a hard Cloudflare Workers limit — the upload Function reads the entire file into memory.

For larger files, the workaround is presigned R2 URLs (the browser uploads directly to R2, skipping the Function). This isn't implemented yet.

## Local dev

Don't bother for bucket work. The local Wrangler Pages dev environment connects to an empty fake R2, not the real bucket.

Use `admin.kolkrabbi.io` for all real file management.

If you need to iterate on the admin tool's UI without touching real files:

```bash
# Terminal 1
pnpm dev   # Vite — pick the port it prints (5173 or 5174)

# Terminal 2
pnpm wrangler pages dev --proxy 5174   # match the port above
# → open localhost:8788
```

API calls will hit the local R2 simulation (empty). UI will render. Good enough for layout work.
