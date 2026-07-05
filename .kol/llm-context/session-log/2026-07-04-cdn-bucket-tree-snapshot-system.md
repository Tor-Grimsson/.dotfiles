# Session: CDN bucket-tree snapshot system (`docs/18-cdn-r2b2/`)

**Date:** 2026-07-04
**Agent:** Grim (Claude Opus, `~/.dotfiles`, iMac)
**Summary:** Built a system that snapshots every CDN bucket's file tree into the dotfiles —
raw json/txt for nvim + a readable markdown tree for Obsidian — refreshed on every write via a
hook baked into the `bucket`/`bucket-r2` wrappers, and carried to consumers by the existing
docs→vault mirror. Two providers (B2, R2), three buckets. Dotfiles = source of truth.

## Context

Grew out of a kol-monorepo task (moving Sanity video to the B2 CDN). The user pointed at
`bin/bucket-drift.sh` + the docs→vault mirror and asked to expand into a documented snapshot
system. Source-of-truth decision: **producer moves into dotfiles** (was baselines-in-vault) —
dotfiles is machine-global; the vault is just one consumer.

## Changes Made (this repo)

### New
- **`bin/bucket-tree.sh`** — the generator. Two listers (B2 `rclone lsjson -R`, R2 paginated
  `admin.kolkrabbi.io/api/list`), grouped by provider. Per run writes
  `_files/<bucket>/{tree.json,tree.full.txt}` (raw) + `NN-<provider>-tree.md` (readable tree
  view). bash-3.2-safe (case-based registry, no assoc arrays). Verbs: `<bucket|provider>`,
  `all`, `--for-remote <rc>` (hook entry; quiet no-op on unknown), `-h`.
- **`docs/18-cdn-r2b2/`** — new **Systems** category:
  - `INDEX.md` — 2-providers/3-buckets map, boxed ASCII diagram, how-it-works, links.
  - `01-b2.md` / `03-r2.md` — per-provider explainers (location, CLI, consumers, skill).
  - `02-b2-tree.md` / `04-r2-tree.md` — **generated** tree views (340K / 28K).
  - `05-scripts.md` — mechanics (bucket-tree, the hook, bucket-drift, the mirror).
  - `_files/{website,vault-media,kol-media}/{tree.json,tree.full.txt}` + `_files/README.md`.

### Moved (drift fix)
- **`~/.local/bin/bucket-r2`** (untracked real file) → **`claude/packages/bucket-r2`** +
  symlinked back. Now tracked + machine-portable like `bucket` (bootstrap auto-links
  `claude/packages/*`), so it can carry the hook.

### Modified
- `claude/packages/bucket` — `snapshot_after_write` hook after `up`/`sync`/`rm`.
- `claude/packages/bucket-r2` — same hook after `up`/`rm`.
- `docs/INDEX.md` — new `## Systems` section (18); `12` scripts count 35→36.
- `docs/12-scripts/INDEX.md` — `bucket-` family 1→2 (drift + tree).
- `claude/skills/kol-bucket-b2/SKILL.md` — **replaced** the stale `refresh-cdn.sh → cdn-tree.md`
  line (old snapshot approach this supersedes) with a `bucket-tree` pointer.
- `claude/skills/kol-bucket-r2/SKILL.md` — added the `bucket-tree` pointer.

## Key decisions

- **Provider-first, not bucket-first.** First cut used 3 bucket folders → confusing (2 vs 3).
  Reorganized around 2 providers with buckets as their contents.
- **Markdown = tree view ONLY; json manifest stays in `_files/`.** They're separate systems for
  separate consumers (ascii-tree for Obsidian reading, json for nvim/machines). Embedding json
  in the md was noise in the one place it isn't wanted — stripped (592K→340K).
- **`_files/` kept** — raw json for nvim is a real use, zero maintenance (generated).
- **Hook lives in the wrapper**, not a git or Claude hook — the bucket changes headlessly (no
  session, no commit). Claude's own writes go through the same wrapper, so they're covered.
- **hls `segment_*.ts` collapsed** to `[N segments]` in tree.json + the md; `tree.full.txt` is
  1:1 (doubles as the `bucket-drift` baseline).

## Current State

### Working (verified)
- `bucket-tree.sh all` → website 3428 · vault-media 4095 · kol-media 433 objects; both md +
  6 `_files` outputs. `bash -n` clean; segment-collapse fires; R2 pagination works;
  `--for-remote` exit-0 on unknown; 0 broken doc links; old process/scripts/services docs
  removed with no dangling refs.

### Notes
- `02-b2-tree.md` is 340K (full inventory, both B2 buckets) — a data doc; Obsidian handles it.
- launchd reconcile net = **documented, not built** (the hook covers day-to-day).
- R2 hook fires only with a live `wrangler` OAuth session.

## Next Steps

1. **User commits** — nothing is committed (user owns git). The trees + docs reach the vault
   and other consumers via the docs→vault mirror on the next `docs/`-touching commit.
2. **MBP:** dot-sync + `bootstrap.sh` re-link `claude/packages/bucket-r2` (packages glob);
   `bucket-tree.sh` is on PATH via the `bin/` symlink — no manual steps expected.
3. Optional later: the launchd timer plist for the reconcile net (sibling of dot-sync).
