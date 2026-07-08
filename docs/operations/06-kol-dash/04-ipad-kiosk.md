---
title: iPad kiosk
type: plan
status: active
updated: 2026-07-05
description: The always-on iPad kiosk view — kol-studio's /kiosk route (Dashboard, no sidebar) and its new Bucket tab (kol-media R2 browser via @kolkrabbi/kol-media-client) are built and verified live. Pointing an actual iPad at it is the one remaining step.
aliases:
  - ipad-kiosk
tags:
  - project/dotfiles
  - domain/dashboard
related:
  - "[[INDEX|kol-dash]]"
  - "[[03-dashboard-systems|Dashboard systems]]"
---

# iPad kiosk

The ask: "a live wired HTML file to set always-on on my old iPad, to test how it works." Scoped against what actually exists ([[03-dashboard-systems|Dashboard systems]]) before deciding to build anything new.

## Don't build a new dashboard from scratch

kol-studio's `Dashboard.jsx` already has real Tasks, Projects, Calendar (live `gcalcli`), Capture (live Todoist/Obsidian-inbox), and Metrics (**already queries the real Umami database** — the "Umami metrics in the app" ask is already done, not new work). A hand-rolled static HTML page would be strictly *less* than what's already running there. The right move is pointing the iPad at kol-studio's existing Dashboard, not re-inventing it.

## The nav-safety fix — built

`/dashboard` shares one `AppShell`/`SideNav` with kol-studio's confidential pages (Business, Clients, Finances, Records — the reason the README calls the whole app "local-only"). Fixed in `kol-studio`: `App.jsx` now has a `/kiosk` route as a sibling **outside** the `AppShell`-wrapped route group, rendering `Dashboard.jsx` standalone — no `SideNav`, no confidential pages reachable. Safe because `Dashboard.jsx` has no dependency on `AppShell`'s `ModalProvider` (checked directly — no dashboard component imports the Modal context). Verified live: `GET /kiosk` → 200, serves the app shell; `/dashboard` (the normal, nav'd route) still works unchanged.

## The R2 bucket browser — built

kol-studio's media widget was Backblaze B2 only — no Cloudflare R2 (`kol-media-admin`'s bucket) browser existed anywhere. Added:

- **`@kolkrabbi/kol-media-client`** (`^0.1.0`) as a real dependency in `kol-studio/app/package.json` — a public npm package owned by **kol-design-system** (`kol-ds`, `github.com/Tor-Grimsson/kol-ds`, `packages/media-client`), not hand-rolled. `listMedia(prefix)` / `mediaUrl(key)` / `formatSize(bytes)`.
- **Ownership split, precisely:** `kol-media-admin` (`dev/projects/kol-apparat/kol-plugin/kol-media-admin`) still *manages the bucket* — the write side (upload/rename/delete, Basic Auth) and the original build folder — but kol-design-system owns and publishes the read-client API surface multiple consumers pull from.
- **`GET /api/media?prefix=`** — new dev-only Vite middleware in `vite.config.js` (`mediaApiPlugin`), calling `listMedia` server-side — kept on the server like every other integration (§4 of the dashboard's `ARCHITECTURE.md`), even though the admin list API is public/no-auth, to stay consistent with the app's one external-data boundary rather than carve out a browser-fetch exception.
- **`DashboardBucket.jsx`** — new tab ("Bucket") in `Dashboard.jsx`: a prefix input (R2 has no real folders, just key prefixes) + a thumbnail grid, images inline, other types as a labeled tile, all linking out to the real CDN URL.
- **Verified live**, not just written: `curl localhost:5599/api/media?prefix=` returned real bucket contents (actual keys/sizes/content-types from the production `kol-media` bucket) through the whole pipeline — package → middleware → JSON.

## Already confirmed, not assumed

- `kolkrabbi.io/metrics` sends no `X-Frame-Options` / `frame-ancestors` header — iframe-embeddable if a separate embed is ever wanted (kol-studio's own DB-backed Metrics tab already covers the same ask, so this is a footnote, not a to-do).
- Hosted admin origin is `https://admin.kolkrabbi.io` (the package's own default) — checked the package source directly; `admin.console.media` doesn't appear anywhere in kol-design-system, likely a misremembered domain.

## Status

**Built and verified server-side.** `/kiosk` (nav-safe Dashboard) and the Bucket tab are both live in `kol-studio` — confirmed via `curl`, not yet eyeballed in an actual browser (this repo's own convention: the user validates live, no Playwright drive-through). Remaining: open `/kiosk` in a real browser to confirm the visual render, then point Safari on the iPad at it (Guided Access for true kiosk lock-down, no chrome).
