---
title: CDN tree snapshots (r2b2)
type: index
status: active
updated: 2026-07-04
description: bucket-tree snapshots every CDN bucket's file tree into the dotfiles — a readable markdown view for Obsidian + raw json for nvim — refreshed on every write and mirrored to other consumers. Two providers (B2, R2), three buckets.
tags:
  - project/dotfiles
  - domain/cloud
  - domain/scripts/sync
related:
  - "[[INDEX|tooling catalog]]"
  - "[[01-b2|B2 buckets]]"
  - "[[03-r2|R2 bucket]]"
  - "[[documentation/15-cloudflare/INDEX|Cloudflare R2 guide]]"
---

# CDN tree snapshots (`r2b2`)

Keeps a **versioned snapshot of what's in each CDN bucket** inside the dotfiles, so the tree is
browsable without hitting the bucket. `~/.dotfiles` is the **source of truth**; every consumer
(Obsidian, kol-monorepo, dashboards, agents) reads from here.

## Two providers, three buckets

`r2b2` = both providers: **B2** (Backblaze) and **R2** (Cloudflare). B2 holds two buckets, R2 one.

| Provider | Bucket | Location | Written by | Docs |
|----------|--------|----------|-----------|------|
| **B2** | `website` | `kolkrabbi:kolkrabbi/website` | [`bucket`](../../claude/packages/kol-cdn/kol-bucket-b2/kol-bucket-b2) | [[01-b2|01-b2]] · [[02-b2-tree|tree]] |
| **B2** | `vault-media` | `kolkrabbi:kol-vault-media` | `bucket` (env override) | [[01-b2|01-b2]] · [[02-b2-tree|tree]] |
| **R2** | `kol-media` | `admin.kolkrabbi.io` / `media.kolkrabbi.io` | [`bucket-r2`](../../claude/packages/kol-cdn/kol-bucket-r2/kol-bucket-r2) | [[03-r2|03-r2]] · [[04-r2-tree|tree]] |

## Docs

| # | Doc | What |
|---|-----|------|
| 01 | [[01-b2|B2 buckets]] | Backblaze — the two buckets, locations, how to use, consumers, skill |
| 02 | [[02-b2-tree|B2 bucket tree]] | **generated** — readable tree view for `website` + `vault-media` |
| 03 | [[03-r2|R2 bucket]] | Cloudflare — `kol-media`, locations, how to use, consumers, skill |
| 04 | [[04-r2-tree|R2 bucket tree]] | **generated** — readable tree view for `kol-media` |
| 05 | [[05-scripts|Scripts & services]] | `bucket-tree`, the post-write hook, `bucket-drift` |
| 06 | [[06-kol-cdn-overview|kol-cdn-overview skill]] | the orientation-only skill — why it exists, what it covers |

Raw per-bucket json/txt (for nvim / machine consumers) lives in [`_files/`](_files/); the
`02`/`04` tree docs are the Obsidian-readable face of the same snapshot.

## How it works

```
   ┌───────────────────────── TRIGGERS ───────────────────────────┐
   │  you · Claude · scripts ──► bucket  up│sync│rm   (B2)         │
   │                          ──► bucket-r2  up│rm    (R2)         │
   │                               └─(on success)─┐   ← the hook   │
   │  launchd timer ───────────────────────────────┤  (in each    │
   │                                               ▼   wrapper)    │
   └───────────────────────────────────────────────┼──────────────┘
                                                    ▼
   ┌──────────── PRODUCER · ~/.dotfiles  (source of truth) ────────┐
   │   bucket-tree.sh                                              │
   │      B2 ─► rclone lsjson -R      R2 ─► admin API (paginated)  │
   │                    └──► normalize (collapse hls segments)     │
   │                                                              │
   │   ▸ _files/<bucket>/{tree.json, tree.full.txt}   raw · nvim   │
   │   ▸ 02-b2-tree.md · 04-r2-tree.md            readable · Obsidian │
   └───────────────────────────────┼──────────────────────────────┘
                                    ▼   (commit touches docs/)
   ┌───────── DISTRIBUTION · existing docs→vault mirror ───────────┐
   │   post-commit ─► rsync docs/ ─► kol-vault ─► Obsidian         │
   │                                    └─► kol-monorepo ·          │
   │                                        dashboards · agents     │
   └───────────────────────────────────────────────────────────────┘

   BACKSTOP   out-of-band writes (other machine, B2/R2 web console)
              skip the hook ─► bucket-drift flags the drift (B2)
```

Details in [[05-scripts|05-scripts]]. Propagation is **commit-gated** — the trees reach the
vault when the `docs/` change is committed (you own git; the agent never commits).

## See also

- [[documentation/15-cloudflare/INDEX|Cloudflare R2 guide]] — R2 / Wrangler / the `admin.kolkrabbi.io` API the R2 lister reads.
- [`kol-bucket-b2`](../../claude/skills/kol-bucket-b2/SKILL.md) / [`kol-bucket-r2`](../../claude/skills/kol-bucket-r2/SKILL.md) skills — action (ls/tree/upload/sync/rm).
- [`kol-cdn-overview`](../../claude/skills/kol-cdn-overview/SKILL.md) skill — orientation only, no commands.
- [[13-docs-mirror|docs → vault mirror]] — the post-commit rsync that carries these trees.
