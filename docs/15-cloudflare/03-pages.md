---
title: Cloudflare Pages — static hosting explained
type: guide
status: active
updated: 2026-06-19
description: What Cloudflare Pages is, how a static site deploy works, what Pages Functions are, and why local dev against Pages is awkward.
audience: internal
aliases:
  - cloudflare-pages
tags:
  - provider/cloudflare
  - domain/hosting
related:
  - "[[04-wrangler|Wrangler CLI]]"
  - "[[05-kol-media-setup|kol-media setup]]"
---

# Cloudflare Pages — static hosting explained

## 1. What "static" means

A **static site** is a bundle of files: HTML, CSS, JavaScript, images. There's no server running code — you just put the files somewhere and a CDN serves them.

A React app built with Vite is static. `pnpm build` produces a `dist/` folder full of files. You can take that folder, drop it anywhere, and the app works.

**Cloudflare Pages is the "anywhere."** You give it the `dist/` folder; it puts those files on Cloudflare's global network; users load your site from the nearest edge server.

## 2. But we also need server-side code

The admin tool isn't purely static — it needs to talk to R2 (list files, upload, delete). R2 credentials must never go in the browser (they'd be exposed to anyone who opens DevTools).

This is where **Pages Functions** come in.

### Pages Functions

Pages Functions are small server-side scripts that live alongside your static site. They run on Cloudflare's edge — same network, no separate server to manage.

In the kol-media-admin repo, the folder structure looks like this:

```
dist/          ← the built React app (static files)
functions/
  api/
    list.js    ← GET /api/list → lists R2 objects
    upload.js  ← POST /api/upload → writes a file to R2
    object.js  ← DELETE /api/object → deletes a file
    rename.js  ← POST /api/rename → copies + deletes
    download.js
    _middleware.js  ← checks ADMIN_PASSWORD on every request
```

When you visit `admin.kolkrabbi.io/api/list`, Cloudflare runs `functions/api/list.js`. That function has access to the R2 bucket binding (a secure server-side connection to `kol-media`) and returns a list of objects as JSON. The browser never sees the credentials.

## 3. Bindings — how Functions talk to R2

A **binding** is how Cloudflare injects a service into your Function. In `wrangler.toml`:

```toml
[[r2_buckets]]
binding = "MEDIA_BUCKET"
bucket_name = "kol-media"
```

This says: inside any Function, `env.MEDIA_BUCKET` is a live connection to the `kol-media` R2 bucket. The Function can call `env.MEDIA_BUCKET.put(key, file)` to upload, `env.MEDIA_BUCKET.list()` to list, etc.

The connection is server-side only. The browser cannot access `env.MEDIA_BUCKET` — it's only available inside the Function.

## 4. Branches and environments

Cloudflare Pages has a concept of **branches**. Every deploy goes to a branch:

- `--branch main` → the production domain (`admin.kolkrabbi.io`)
- no `--branch` flag or any other name → a random preview URL (like `abc123.kol-media-admin.pages.dev`)

Every deploy (including previews) gets a unique immutable URL. The production domain always points to the latest `main` deploy.

## 5. Why local dev is annoying

When you run `pnpm dev` (just Vite), the Functions don't run. The React app loads, but every call to `/api/list` returns a 404.

To run Functions locally you need **Wrangler Pages dev mode**, which wraps Vite and intercepts `/api/*` requests:

```bash
pnpm wrangler pages dev --proxy 5174
```

But this uses a **local simulation** of R2 — an empty fake bucket on your machine. It doesn't connect to the real `kol-media` bucket. So locally you'd see no files.

**The practical answer: don't develop locally for bucket work. Use `admin.kolkrabbi.io` directly.** It's a small internal tool — it's fine.

---

**Next:** [[04-wrangler|Wrangler — the CLI and every command that matters]]
