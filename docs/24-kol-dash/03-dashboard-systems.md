---
title: Dashboard systems
type: reference
status: active
updated: 2026-07-05
description: The three things that have all been called "the dashboard" — what each actually is, what's live vs. mock per widget. The R2-bucket-browser gap this doc originally found is now closed — see 04-ipad-kiosk.
tags:
  - project/dotfiles
  - domain/dashboard
related:
  - "[[INDEX|kol-dash]]"
  - "[[04-ipad-kiosk|iPad kiosk]]"
  - "[[../12-scripts/17-kol-dashboard-cli|Dashboard CLI]]"
---

# Dashboard systems

Investigated directly (read the actual source, not the READMEs' claims) before building anything new, since three different things share the "dashboard" name.

## 1. Obsidian `kol-dashboard` plugin

Lives in the `kol-vault` repo (`.obsidian/plugins/kol-dashboard/`, content home `kol-library/_kol-dashboard/kol-tracks/`). A "view over files" — kanban (`inbox.md` + the plugin's `data.json`), tracks (folders flagged `dashboard: true`), pinned notes, socials/growth, week entries. Terminal twins already exist and read the *same* files, no API/daemon: `kol-kb` (kanban, print + move) and `kol-dash <links|growth|pinned|tracks|week>` (read-only). Full reference: [[../12-scripts/17-kol-dashboard-cli|17-kol-dashboard-cli]].

Shares exactly one file with kol-studio's Capture tab (`inbox.md`) — otherwise fully independent, own runtime state.

## 2. kol-studio's `Dashboard.jsx`

A real route in the `kol-studio` Vite/React app (`app/src/pages/Dashboard.jsx`), separate from the confidential Résumé/Business/Clients/Finances/Records pages that make kol-studio "local-only" per its own README. Verified directly, not assumed — nothing here is mock:

| Component | Data source | Live? |
|---|---|---|
| Tasks / Projects / Cards | `data/dashboard/board.json`, via `/api/dashboard` | Live, local file |
| Calendar | `/api/calendar` shells to real `gcalcli` | Live, real Google Calendar |
| Capture | `/api/inbox` (kol-vault's `inbox.md`), `/api/todoist` (Todoist v1 REST), `/api/calendar` | Live, three real integrations |
| Metrics | `/api/metrics` queries **self-hosted Umami's Neon Postgres directly** via `pg` | Live, real — this already covers "Umami metrics in the app" |
| Media | Renders whatever URL an inbox/kanban item already carries | **Not a bucket browser** — just inline display of already-embedded URLs |

Secrets (`TODOIST_TOKEN`, `UMAMI_DB_URL`, `UMAMI_WEBSITE_ID`) are read server-side from `~/.secrets` in dev-only Vite middleware — never sent to the browser.

**The R2 gap — closed.** kol-studio's media widget was Backblaze **B2** only (`kol-vault-media`) — no browser for the Cloudflare **R2** bucket (`kol-media`, managed by `kol-media-admin`). A new **Bucket** tab now covers it, via the real `@kolkrabbi/kol-media-client` npm package. See [[04-ipad-kiosk|iPad kiosk]] for what was built.

**The nav-safety blocker — closed.** Every route used to render through one shared `AppShell` → `SideNav` (`sidebars.config.js`), including `/dashboard` — all five top-level nav hops (Home, Dashboard, Résumé, Studio, Archive) always visible, no route guard. A new `/kiosk` route now renders `Dashboard.jsx` standalone, no sidebar, safe for an always-on device. See [[04-ipad-kiosk|iPad kiosk]].

## 3. `_kol-dashboard`

`dev/projects/_kol-dashboard` — a completely empty directory, 0 files, not even `git init`'d. Not a scaffold, not superseded-by-anything, not a thing. Mentioned here only to close the question, not because it needs any action.
