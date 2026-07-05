---
title: Scripts & services
type: reference
status: active
updated: 2026-07-04
description: The mechanics of the snapshot system — bucket-tree.sh (two listers, two outputs), the post-write hook baked into each wrapper, the launchd net, and the docs→vault mirror that distributes the trees.
tags:
  - project/dotfiles
  - domain/cloud
  - domain/scripts/sync
related:
  - "[[INDEX|r2b2 index]]"
  - "[[14-bucket-drift|Bucket drift]]"
  - "[[13-docs-mirror|docs → vault mirror]]"
---

# Scripts & services

| Piece | Role |
|-------|------|
| `bucket-tree.sh` | list a bucket → write raw `_files/` + the readable provider `.md` |
| post-write hook | in each wrapper — refresh the snapshot after a write |
| [`bucket-drift.sh`](../12-scripts/14-bucket-drift.md) | read-only alarm for out-of-band changes |
| [docs → vault mirror](../12-scripts/13-docs-mirror.md) | carries the trees to Obsidian + consumers |

## `bucket-tree.sh`

Lives in `~/.dotfiles/bin` (on PATH). Read-only on every bucket.

```sh
bucket-tree.sh b2                # snapshot a provider (both B2 buckets) → 02-b2-tree.md
bucket-tree.sh website           # snapshot one bucket (still renders its provider's md)
bucket-tree.sh all               # every bucket, both provider docs
bucket-tree.sh --for-remote "$REMOTE"   # rclone remote → provider (the hook's entry point)
```

**Outputs per run** (both generated, no hand-editing):

| Output | Fidelity | Consumer |
|--------|----------|----------|
| `_files/<bucket>/tree.json` | nested, `segment_*.ts` collapsed | nvim / machines |
| `_files/<bucket>/tree.full.txt` | 1:1 sorted path list | exact record + drift baseline |
| `NN-<provider>-tree.md` | readable tree view per bucket | Obsidian |

**Two listers, one shape:** B2 → `rclone lsjson -R`; R2 → `curl admin.kolkrabbi.io/api/list`
(paginated on `cursor`). Both emit `<size>\t<path>` → a Python step writes all three outputs.
R2 has no rclone remote (writes go through Wrangler OAuth), which is why it needs its own lister.

**Adding a bucket** = one `case` line in `resolve()` (+ `buckets_of()`/`for_remote()` if it's a
new provider or a B2 lane a wrapper writes). bash 3.2-safe (no associative arrays).

## The post-write hook

Both wrappers call `snapshot_after_write` after a successful write — `bucket` on
`up`/`sync`/`rm`, `bucket-r2` on `up`/`rm`. It lives **inside the wrapper**, because the
bucket changes when the CLI runs — headless, no Claude session, no commit. (Claude's own writes
use the same wrapper, so they're covered.)

- **Backgrounded + debounced** — a `${TMPDIR}/bucket-tree-pending-*` flag coalesces a burst into one snapshot (≈3 s); the write never blocks.
- **Non-fatal** — a missing `bucket-tree.sh` or a snapshot error can't break the upload.
- **Tracked** — both wrappers live in `claude/packages/` (symlinked to `~/.local/bin` by `bootstrap.sh`), so the hook syncs to every machine.

## The launchd net

The hook only fires for writes through *your* CLI; a write from another machine or the
B2/R2 web console bypasses it. A periodic `bucket-tree.sh all` (launchd, like
[dot-sync](../12-scripts/11-dot-sync.md)) reconciles those, and
[`bucket-drift`](../12-scripts/14-bucket-drift.md) is the read-only alarm that a reconcile is
overdue. *(Timer plist: future — the hook covers day-to-day.)*

## Distribution

The outputs are plain files under `docs/`, so the existing
[docs → vault mirror](../12-scripts/13-docs-mirror.md) carries them: a `post-commit` hook
rsyncs `docs/` into the kol-vault on any commit that touches it. Propagation is **commit-gated**
— commit the change and the snapshot reaches Obsidian and every other consumer. The agent never
commits (you own git).
