---
title: Bucket drift
type: reference
status: active
updated: 2026-07-05
description: bucket-drift.sh — read-only drift check between a saved file-list baseline and a live rclone bucket. Reuses diff; the generic verb lives here, the remote→baseline map lives with the consumer.
tags:
  - project/dotfiles
  - domain/scripts/sync
related:
  - "[[INDEX|Scripts index]]"
  - "[[11-dot-sync|Dotfiles sync]]"
---

# Bucket drift (`bucket-`)

| Script | Does | Usage |
|--------|------|-------|
| `bucket-drift.sh` | Diff a saved file-list baseline against a live rclone remote | `bucket-drift.sh <remote> <baseline> [--update]` — run `--help` |

A read-only drift detector. It implements **no** diff and parses nothing — it lists the
remote (`rclone lsf -R`, `segment_*.ts` filtered), sorts, and `diff`s against a flat
baseline file. Non-empty diff = drift, exit 1, with `only in baseline` / `only on bucket`
lines.

## Split design: generic verb here, map at the consumer

The script is deliberately dumb and machine-agnostic — it takes a full rclone remote and
a baseline path, nothing hardcoded (§1/§N-safe), so it works on **any** bucket lane. The
knowledge of *which* local manifest pairs with *which* remote lives with whoever consumes
it, not here.

Example consumer — the **kol-vault** keeps the map + baselines and wraps this verb:

```sh
# _system/_kol-cdn/_scripts/cdn-drift.sh (in the vault, not this repo)
bucket-drift.sh kolkrabbi:kolkrabbi/website   .../01-website-cdn/_snapshot.txt     "$mode"
bucket-drift.sh kolkrabbi:kol-vault-media     .../02-vault-media-cdn/_snapshot.txt "$mode"
```

## Modes

- **check** (default) — diff live vs baseline; exit 1 on drift.
- **`--update`** — overwrite the baseline from live (after an intentional upload).

## Notes

- **Read-only on the remote** — `lsf` only, never writes. Safe against live hosting.
- Baseline is a flat sorted `rclone lsf -R` snapshot — the "last known good" state.
- Buckets are otherwise driven by the `bucket` CLI (`kol-bucket-b2`/`kol-bucket-r2` skills, `~/.local/bin/bucket`);
  `bucket-drift.sh` calls `rclone` directly so it accepts any remote, not just the website default.
