---
title: Google console, from the trenches
type: index
status: active
updated: 2026-07-08
description: Navigating the Google Cloud console + Workspace admin without losing an hour — the two separate billing systems, the org-vs-personal billing-account gotcha, the authuser trap, and the direct links.
aliases:
  - google-console-guide
  - gcp-guide
tags:
  - provider/google
  - domain/cloud
related:
  - "[[01-console-map|Console map & direct links]]"
  - "[[14-gcalcli|gcalcli]]"
---

# Google console, from the trenches

Google spreads one account across **two** consoles that don't talk to each other, hides billing accounts behind org filters, and 404s you when you're signed in as the wrong identity. This guide is the map that would have saved the hour it cost on 2026-07-08.

Written for the recurring "which Google thing is this and where do I even click" moment — not a from-zero product tour.

## Chapters

| # | Chapter | Read it when |
|---|---|---|
| 01 | [[01-console-map\|Console map & direct links]] | A Google billing/console email lands and you need the right page fast. |

## The one-paragraph version

**Google Workspace (Gmail for business) and Google Cloud (GCP/Firebase/API) are two separate billing systems** — different consoles, different ledgers; paying one never clears the other. Workspace lives at `admin.google.com`, Cloud at `console.cloud.google.com/billing`. A **Cloud billing account** is its own object (format `XXXXXX-XXXXXX-XXXXXX`), separate from any project, and can be owned by the **org** *or* a **personal Google login** — an org-scoped view won't show a personal one, and a `authuser=1` URL 404s if a different login owns it. See [[01-console-map|the console map]] for the links.
