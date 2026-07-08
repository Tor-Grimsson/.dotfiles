# Session: docs/ restructured onto the kol-docs content/operations split

**Date:** 2026-07-08
**Agent:** Claude (Grim)
**Summary:** Converged `docs/` from 25 flat `NN-` sections onto the kol-docs three-layer model (documentation/operations + named siblings), seeded the `.obsidian` vault config, collapsed the kol-vault mirror from two scripts to one, conformed all doc frontmatter, and rewrote the two now-stale mirror docs.

## Changes Made

### 1 — docs/ reorg (folders + refs)
- **Moved 25 sections** into `documentation/` (16 content: tool catalog + guides), `operations/` (6 machinery: dotfiles, claude-agents, kol-docs-system-setup, remote-machine, cdn-r2b2, kol-dash), and named siblings `kol-cli/`, `scripts/`, `explorations/`. Slugs kept; only `NN-` prefixes changed (e.g. `13-terminal-browsers`→`documentation/12-terminal-browsers`, `21-dotfiles`→`operations/01-dotfiles`, `12-scripts`→`scripts`).
- **Relinked 207 files** via a perl pass: file-target wikilinks → bare filename, INDEX-target links → new full path, all `../` relatives normalised. Verified every wikilink resolves (dead-link scan clean; only survivors are pre-existing out-of-vault `SKILL`/`TOOLING`/skill-name links).
- **External refs repointed:** `bin/{bucket-tree,img-canvas,img-convert,img-from-psd,img-from-video}.sh`, `bootstrap.sh`, `bootstrap-cli.sh`, `claude/skills/{export-specs,kol-bucket-b2,kol-bucket-r2,kol-cdn-overview}/SKILL.md`, + a live pointer in `plan.md`.
- **INDEX layer:** rewrote root `docs/INDEX.md` as a top-level router; new `documentation/INDEX.md`, `operations/INDEX.md`, `kol-cli/INDEX.md`.
- Fixed a **pre-existing** dead link `[[02-pnpm]]`→`[[05-pnpm]]` in `documentation/04-dev-languages/01-node.md`.

### 2 — .obsidian seeding
- Seeded `docs/.obsidian/` **per-file symlinks** from `obsidian-shapes/02-kol-vault-shape` (user-confirmed shape); `workspace.json` & runtime state deliberately not seeded; added `docs/.obsidian/` to `.gitignore`.

### 3 — kol-vault sync scripts (in the kol-vault repo)
- **Fixed `sync-dotfiles-docs-rs.sh`:** excludes now `.DS_Store`/`.obsidian/`/`kol-cli/`, dropped dead `llm-context`/`history.md`/`plan.md` excludes, kol-cli promotion source → `docs/kol-cli/`, header comment de-`-sm`'d.
- **Killed the symlink mirror:** deleted `relink-dotfiles-docs-sm.sh` + the `kol-library/kol-dotfiles-docs-sm/` folder (grep confirmed nothing navigates into it). One mirror now: `-rs`.

### 4 — frontmatter conform
- Authored frontmatter for `scripts/ss-save.md` (the one file that had none) + reciprocal link with `08-system`.
- Backfilled `aliases:` into 35 docs (now 179/179 non-INDEX) as slug-minus-`NN-`.
- Docs were already ~99% conformant — all `type` values valid archetypes, all had `status`, tags in-taxonomy. Left `status: active` blanket unchanged (active-vs-canonical is a judgment pass, not done).

### 5 — mirror docs rewritten
- `scripts/13-docs-mirror.md` (reference) + `scripts/docs-mirror-rsync-explained.md` (guide) rewritten to the one-mirror reality (dropped the two-way symlink comparison, kept the flag-by-flag rsync explanation). No stale `-sm` references remain in docs.

## Current State

### Working
- `docs/` is on the content/operations split; vault openable with graph/backlinks (verified by dead-link scan, not yet eyeballed in Obsidian).
- One kol-vault mirror (`-rs`), matching the new tree once it next runs.
- Frontmatter fully conformant on required fields; aliases complete.

### Known Issues
- The `-rs` mirror copy in the kol-vault still shows the **old** `12-scripts/`-style tree — it hasn't re-run since the reorg. Next post-commit-on-docs (or manual `sync-dotfiles-docs-rs.sh`) rewrites it via `--delete`.
- `status:` is `active` on all 207 docs — spec distinguishes `active` vs `canonical`; not reclassified.
- AGENT-CONTEXT status list is long (file ~66 KB) — a trim pass is overdue.

## Next Steps
1. Open `docs/` in Obsidian once to visually confirm the graph (the check the scan can't do).
2. ~~Re-run the mirror~~ — done, see addendum.
3. Optional: an `active`→`canonical` status pass on stable reference docs.

## Addendum — mirror automation proven end-to-end

The open "mirror shows the old tree until the sync re-runs" item is **closed**. Verified the full `dotfiles commit → post-commit hook → rsync → kol-vault` chain:

- **First check after the user's push showed the `-rs` mirror still on the old flat tree** — a stale read that led to a wrong "you need to commit kol-vault" call; the committed state was actually already correct. Ran `sync-dotfiles-docs-rs.sh` manually → mirror regenerated to the new tree (202 md, `documentation/`/`operations/`/`scripts/`/`explorations/`, old flat folders `--delete`'d, kol-cli promoted). Confirmed the `-rs` mirror is **tracked** (only `-sm` is gitignored) and `.obsidian/`/`kol-cli/` are correctly excluded.
- **Smoke test:** created `docs/test.md` + an INDEX marker, user committed/pushed dotfiles → the `post-commit` hook fired the sync → the change materialised in `kol-dotfiles-docs-rs/` → user committed/pushed kol-vault. Chain confirmed working (hook config was clean all along).
- **Cleanup:** removed the test artifacts (`docs/test.md`, INDEX smoke-test comment) and a keyboard-mash the user left in `documentation/04-dev-languages/06-pipx.md` while testing carry-through.

Net: the dotfiles→vault docs pipeline is live and proven on the new structure.
