---
title: What is Cloudflare
type: guide
status: active
updated: 2026-06-19
description: Ground-floor explanation of what Cloudflare is, what it does, and which products we actually use.
audience: internal
aliases:
  - what-is-cloudflare
tags:
  - provider/cloudflare
  - domain/hosting
related:
  - "[[02-r2-and-buckets|R2 & buckets]]"
  - "[[03-pages|Cloudflare Pages]]"
---

# What is Cloudflare

## 1. The simple version

Cloudflare is a company that owns a massive network of servers spread across the world — about 300 cities. When you use Cloudflare for something (a file, a website), your users get served from the server closest to them. London gets it from London. Tokyo gets it from Tokyo. Everything loads fast because nobody's waiting for a packet to cross an ocean.

That's it at the core. They started as a security company (protecting websites from attacks) but now sell a whole platform of services. We use two of them.

## 2. The two products we use

### R2 — file storage

Think of R2 as a hard drive that lives on the internet. You put files in it. Each file gets a public URL. Anyone in the world can load that URL and get the file, fast.

- You upload a video: `video/asmr-sharp.mp4`
- R2 gives it the URL: `https://media.kolkrabbi.io/video/asmr-sharp.mp4`
- Anyone anywhere loads that URL and gets the video served from the nearest Cloudflare server

This is called **object storage**. The full explanation is in [[02-r2-and-buckets|chapter 02]].

### Pages — website hosting

Cloudflare Pages lets you deploy a website. You build your site (a folder of HTML, CSS, JS files), push it to Pages, and Cloudflare serves it globally — same network trick as R2.

- Your admin tool lives at: `admin.kolkrabbi.io`
- It's a React app — you build it locally, then deploy
- Cloudflare handles HTTPS, caching, global delivery

The full explanation, including how deploys work, is in [[03-pages|chapter 03]].

## 3. How you talk to Cloudflare

Almost everything goes through the Cloudflare **dashboard** (their website) or through **Wrangler** (a command-line tool you type into the terminal). There is no GUI app you install.

- Dashboard: `dash.cloudflare.com` — click around, see your buckets, manage domains, check deploys
- Wrangler: `pnpm wrangler …` — the thing you type to actually deploy, upload, check logs

Wrangler is covered fully in [[04-wrangler|chapter 04]].

## 4. How it differs from other providers

You've probably heard of AWS (Amazon), Google Cloud, or Azure. They do similar things — storage, hosting, compute. Cloudflare's angle is:

- **Simpler pricing** — R2 has no egress fees (you don't pay every time someone downloads a file). AWS S3 charges for that. It adds up.
- **Simpler DX** — Pages deploys are one command. No servers to configure.
- **The network** — it's genuinely fast because of the 300-city edge network.

For our scale (images + videos for kol-labs, one admin tool) Cloudflare is essentially free and requires almost no maintenance.

---

**Next:** [[02-r2-and-buckets|What a bucket is and what R2 actually does]]
