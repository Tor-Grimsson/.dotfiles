---
title: Wrangler — the CLI
type: reference
status: active
updated: 2026-06-19
description: What Wrangler is, how to install it, and every command used in the kol-labs setup.
audience: internal
aliases:
  - wrangler
tags:
  - provider/cloudflare
  - domain/tooling
  - pattern/cli
related:
  - "[[03-pages|Cloudflare Pages]]"
  - "[[05-kol-media-setup|kol-media setup]]"
---

# Wrangler — the CLI

## What it is

**Wrangler** is Cloudflare's official command-line tool. It's how you:
- Log in to your Cloudflare account from the terminal
- Deploy a site to Cloudflare Pages
- Interact with R2 buckets
- Run Pages Functions locally

It's installed as an npm package and run via `pnpm wrangler …` (or `npx wrangler …` if not installed locally).

## Installation

Wrangler is declared as a `devDependency` in the kol-media-admin `package.json`. Running `pnpm install` in that repo gives you it. No global install needed.

If you want it globally: `npm install -g wrangler`

## Login

Before any Wrangler command touches your real Cloudflare account, you need to authenticate:

```bash
pnpm wrangler login
```

This opens a browser window, you click "Allow", and Wrangler stores an auth token on your machine. You stay logged in until you explicitly log out or the token expires.

**If a deploy fails with `400 Bad Request` or `auth token` errors → run `pnpm wrangler login` again.**

## Deploy to Pages

```bash
pnpm wrangler pages deploy dist --project-name kol-media-admin --branch main
```

Breaking it down:
- `pages deploy` — deploy a Pages project
- `dist` — the local folder to upload (your built site)
- `--project-name kol-media-admin` — which Pages project on your account to deploy to
- `--branch main` — deploy to the `main` branch = production domain (`admin.kolkrabbi.io`)

Without `--branch main` you get a preview URL, not the real domain.

**You must build first:**
```bash
CI=true pnpm build && pnpm wrangler pages deploy dist --project-name kol-media-admin --branch main
```

`CI=true` prevents pnpm from prompting for interactive approval of build scripts (it would hang in a non-interactive terminal).

## Local dev (Pages)

```bash
pnpm wrangler pages dev --proxy 5174
```

- `pages dev` — run Pages locally (Functions + static assets)
- `--proxy 5174` — instead of serving its own static files, proxy through to Vite running on port 5174

You still need Vite running in a separate terminal:
```bash
pnpm dev   # terminal 1 — Vite on 5174 (or whatever port it picks)
pnpm wrangler pages dev --proxy 5174   # terminal 2 — Wrangler wrapping Vite
```

Then open `localhost:8788` (Wrangler's port), not Vite's port.

**Caveat:** Pages dev uses a local empty R2 simulation. No real files. Only useful for UI iteration, not bucket work.

## R2 commands

You can manage R2 directly from Wrangler without the admin tool. Useful for bulk operations or emergencies.

```bash
# List buckets
pnpm wrangler r2 bucket list

# Create a bucket
pnpm wrangler r2 bucket create my-bucket

# List objects in a bucket
pnpm wrangler r2 object list kol-media

# Upload a file
pnpm wrangler r2 object put kol-media/video/test.mp4 --file ./test.mp4

# Delete an object
pnpm wrangler r2 object delete kol-media/video/test.mp4
```

## Check who you're logged in as

```bash
pnpm wrangler whoami
```

Prints your account name and account ID. If this fails you're not authenticated — run `pnpm wrangler login`.

## Common errors

| Error | Cause | Fix |
|---|---|---|
| `400 Bad Request` on deploy | Auth token expired | `pnpm wrangler login` |
| `Unknown argument: remote` | `--remote` flag doesn't exist on Pages dev | Remove it; use `--proxy` instead |
| `Specify either a directory OR a proxy command, not both` | Old `-- pnpm dev` syntax removed from Pages dev | Use `--proxy <port>` instead |
| `ERR_PNPM_ABORTED_REMOVE_MODULES_DIR_NO_TTY` | Build ran in non-interactive shell | Prefix with `CI=true` |
| Port 5173 already in use | Vite picks the next available port (5174, 5175…) | Pass whichever port Vite actually started on to `--proxy` |

---

**Next:** [kol-media — the actual setup, bucket, and deploy process](05-kol-media-setup.md)
