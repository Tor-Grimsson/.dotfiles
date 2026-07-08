---
title: Console map & direct links
type: reference
status: active
updated: 2026-07-08
description: The two Google billing systems, the org-vs-personal billing-account gotcha, the authuser trap, and copy-paste console links — plus the kolkrabbi.io footprint as of 2026-07-08.
aliases:
  - google-console-map
tags:
  - provider/google
  - domain/cloud
related:
  - "[[INDEX|Google console guide]]"
  - "[[14-gcalcli|gcalcli]]"
---

# Console map & direct links

## The one thing to internalise: two separate billing systems

Google bills the same business across **two ledgers that never reconcile**. Paying one does **not** clear the other.

| | Google Workspace | Google Cloud (GCP) |
|---|---|---|
| **What** | Gmail-for-business, Drive, per-seat subscription | pay-as-you-go GCP / Firebase / API usage |
| **Console** | `admin.google.com` | `console.cloud.google.com` |
| **Billing page** | `admin.google.com/ac/billing/subscriptions` | `console.cloud.google.com/billing` |
| **Bill shape** | a subscription with a **payment due** | a **billing account** (`XXXXXX-XXXXXX-XXXXXX`) charged for usage |
| **"suspended" email means** | your seats/email are at risk | a *billing account* lapsed — may affect nothing if no project uses it |

They're usually on the **same card** — when it expires, both go delinquent, and you get two separate dunning flows. Fix the card in **each** system.

## Three gotchas that cost the time

1. **Project ≠ billing account.** A project's *"linked account"* page (`…/billing/linkedaccount?project=…`) only says whether *that project* points at a billing account. It tells you nothing about the billing account itself. The billing account is a separate object at the **org / account** level.
2. **Billing accounts are org-owned OR personal.** The org-scoped view (**Billing account management → "Your billing accounts"**, filtered by org `kolkrabbi.io`) shows only **org-owned** accounts. A **self-serve/personal** billing account — created under a personal Gmail login even if the contact email is the work address — **will never appear there.** You have to switch to the Google login that owns it.
3. **The `authuser=N` trap.** Console URLs pin a signed-in identity: `?authuser=0`, `1`, `2`… A **404 on a billing-account URL usually means a *different* login owns it**, not that the account is gone. Try other `authuser` values, or switch account via the top-right avatar.

## Direct links (swap `<ACCT>` for the billing-account ID, e.g. `019B32-337BA5-902E6F`)

| Goal | URL |
|---|---|
| **Cloud billing accounts list** | `console.cloud.google.com/billing` |
| **A specific billing account** | `console.cloud.google.com/billing/<ACCT>` |
| **↳ Transactions** (balance / past-due) | `console.cloud.google.com/billing/<ACCT>/transactions` |
| **↳ Account management** (linked projects + **Close billing account**) | `console.cloud.google.com/billing/<ACCT>/manage` |
| **↳ Payment method** (fix the card) | `console.cloud.google.com/billing/<ACCT>/payment` |
| **Billing account management** (org: accounts + projects tabs) | `console.cloud.google.com/billing/projects` |
| **Workspace subscriptions** (seats, payment due) | `admin.google.com/ac/billing/subscriptions` |
| **Workspace payment accounts** | `admin.google.com/ac/billing/payment` |
| **AI Studio** (where `gen-lang-client-*` Gemini projects come from) | `aistudio.google.com` |
| **APIs & Services** (gcalcli's OAuth client lives here) | `console.cloud.google.com/apis` |

> Deep sub-paths (`/transactions`) sometimes 404 on a suspended account — open the plain `/billing/<ACCT>` overview first, then use the left sidebar.

## Closing an orphaned billing account

If a billing account is suspended but **no project links to it** (all projects show *"Billing is disabled"*), it's dead weight — closing it breaks nothing and stops the emails:

1. Open `console.cloud.google.com/billing/<ACCT>/transactions` — confirm the **balance is €0** (settle it first if not).
2. `…/manage` → **Close billing account**.
3. Or just **ignore it** — an orphaned account auto-terminates ~30 days after the suspension notice.

## The kolkrabbi.io footprint (as of 2026-07-08)

Snapshot from the day this guide was written — verify live, but it orients:

- **Org:** `kolkrabbi.io` (ID `345436221466`).
- **Projects (4, all billing-disabled / free tier):**
  - `Gemini API` (`gen-lang-client-0917029230`), `gemini-buu` (`gen-lang-client-0772205805`), `bingo` (`gen-lang-client-0228813595`) — **AI Studio / Gemini API** projects (the `gen-lang-client-*` prefix is auto-assigned by AI Studio).
  - `My First Project` (`alert-cursor-479211-k6`) — created by **Cursor** (the editor); the `alert-cursor-` prefix is its default GCP project.
- **Suspended billing account** `019B32-337BA5-902E6F` — **orphaned** (no project links to it), from a lapsed card. Not owned by the org (the org "Your billing accounts" tab was empty; `authuser=1` 404'd) → owned by a personal login. Left to auto-terminate.
- **gcalcli** ([[14-gcalcli|gcalcli]]) is the only intentional Google-API use — free **Calendar API**, no billing account. See its own doc for the OAuth-client setup.

**Takeaway:** nothing in this org needs a paid billing account. Workspace (email) is the only bill that actually matters — keep *that* card valid.
