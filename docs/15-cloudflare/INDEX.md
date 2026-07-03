---
title: Cloudflare, from zero
type: index
status: active
updated: 2026-06-19
description: Beginner guide to Cloudflare R2, Pages, and Wrangler — what they are, how they work, and the exact commands used in the kol-labs media setup.
aliases:
  - cloudflare-guide
tags:
  - provider/cloudflare
  - domain/hosting
  - domain/storage
related:
  - "[[01-what-is-cloudflare|what is Cloudflare]]"
  - "[[03-pages|Cloudflare Pages]]"
  - "[[05-kol-media-setup|kol-media setup]]"
---

# Cloudflare, from zero

This guide assumes you know nothing about Cloudflare. You've heard the name, you've seen the dashboard, and now you're using it for real files and real deploys — and you want to understand what the hell is going on.

It covers **R2** (file storage), **Pages** (static site hosting), and **Wrangler** (the CLI tool that ties it together) — then walks through the exact setup used in kol-labs.

## Chapters

| # | Chapter | Read it when |
|---|---|---|
| 01 | [What is Cloudflare](01-what-is-cloudflare.md) | You want to know what Cloudflare actually is and why we use it. |
| 02 | [R2 & buckets — object storage explained](02-r2-and-buckets.md) | You want to understand what a "bucket" is and why files live there. |
| 03 | [Cloudflare Pages — static hosting explained](03-pages.md) | You want to understand how a website gets deployed and what "Pages" means. |
| 04 | [Wrangler — the CLI](04-wrangler.md) | You want to know what `wrangler` does and which commands matter. |
| 05 | [kol-media — our actual setup](05-kol-media-setup.md) | You want the specific bucket, admin tool, deploy commands, and gotchas for kol-labs. |

## The one-paragraph version

**Cloudflare is a company that runs a global network of servers.** We use two products: **R2** (like a hard drive in the cloud — you put files in, they get a public URL) and **Pages** (you push a built website, Cloudflare serves it globally). **Wrangler** is Cloudflare's command-line tool — the thing you type in the terminal to deploy, manage buckets, and log in. In kol-labs, R2 holds all media files (images, videos) at `media.kolkrabbi.io`, and Pages hosts the `kol-media-admin` tool at `admin.kolkrabbi.io`.
