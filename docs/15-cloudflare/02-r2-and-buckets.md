---
title: R2 & buckets — object storage explained
type: guide
status: active
updated: 2026-06-19
description: What object storage is, what a bucket is, how R2 works, and why files live here instead of in a database or a regular folder.
audience: internal
aliases:
  - r2-and-buckets
tags:
  - provider/cloudflare
  - domain/storage
related:
  - "[[01-what-is-cloudflare|what is Cloudflare]]"
  - "[[05-kol-media-setup|kol-media setup]]"
---

# R2 & buckets — object storage explained

## 1. Why files don't go in a database

A database is great at storing small, structured data — names, dates, numbers, tags. It is terrible at storing big files. If you put a 50 MB video in a database row, the whole database slows down, backups balloon, and every query becomes sluggish.

The right answer is **object storage** — a separate system designed specifically for files. The database stores a link to the file; the file itself lives in object storage.

This is the same split you see in the Supabase setup: small data in Supabase, big files in Backblaze B2. In kol-labs we use Cloudflare R2 for the files.

## 2. What a bucket is

A **bucket** is a container for files. Think of it like a folder — except it lives in the cloud and every file in it can have a public URL.

- A bucket has a **name**: ours is called `kol-media`
- Files inside have **keys**: basically a path like `video/asmr-sharp.mp4` or `photoshoot/01.jpg`
- There are no real folders — a key is just a string. `video/` appears to be a folder because multiple keys start with `video/`, but it's just a naming convention

When you "browse folders" in the admin tool, it's actually reading all keys that start with `video/` and grouping them — not navigating a real directory.

## 3. What R2 is specifically

**R2 is Cloudflare's object storage product.** It does exactly what Amazon S3 does (S3 was the original, invented the whole category) — but without egress fees.

**Egress fees** = what you pay every time someone downloads a file. S3 charges for this. On a busy site with lots of video, that gets expensive fast. R2 charges nothing for downloads. You only pay for storage (how many GB you're holding) — and at our scale that's basically nothing.

R2 is also S3-compatible — any tool that knows how to talk to S3 can talk to R2 with a config change. This matters if you ever want to switch tools.

## 4. How public access works

By default a bucket is private — only you can read files. To make files publicly accessible you set up a **custom domain** pointing at the bucket.

Our setup:
- Bucket name: `kol-media`
- Public domain: `media.kolkrabbi.io`
- Any key in the bucket → `https://media.kolkrabbi.io/<key>`

So a file with key `video/handshake.mp4` is publicly accessible at `https://media.kolkrabbi.io/video/handshake.mp4`. No auth, no expiry, globally cached.

## 5. What you can do with a bucket

| Action | How |
|---|---|
| Upload a file | Admin tool (`admin.kolkrabbi.io`) or Wrangler CLI |
| Download / view a file | Public URL — just load it in a browser |
| List all files | Admin tool, or the `/api/list` endpoint |
| Rename a file | Admin tool (copies key + deletes old — R2 has no native rename) |
| Delete a file | Admin tool |
| Create a "folder" | Upload a file with a key that includes `/` — the folder appears automatically |

## 6. The 100 MB upload limit

There's one important constraint: **uploads through the admin tool are capped at 100 MB per file.**

Why: the admin tool is a Cloudflare Pages app. Its upload handler is a **Pages Function** (a small serverless script). That script reads the entire file into memory before writing it to R2. Cloudflare caps that memory at 100 MB.

For images this is never a problem. For long videos it can be. The workaround (presigned URLs — letting the browser write directly to R2, bypassing the Function entirely) isn't implemented yet.

---

**Next:** [What Cloudflare Pages is and how deploys work](03-pages.md)
