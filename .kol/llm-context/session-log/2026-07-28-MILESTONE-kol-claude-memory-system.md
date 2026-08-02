# 🏁 Milestone: kol-claude-memory — repo-backed shared agent memory

**Date:** 2026-07-28
**Agent:** Grim (Fable 5)
**Arc:** From "where does Claude memory actually live" to a designed, documented, built, and pushed system — memory in git, shared across repos, look-up-able through one vault.
**Delivered:** Two memory tiers (global `claude/memory/` · per-repo `.kol/llm-memory/`), write-path symlinks so the harness writes straight into git, the kol-glass vault (renamed from kol-symlink) with docs + memory lenses and an idempotent `sync.sh`, and a 5-doc design space at `docs/operations/systems/claude-memory/` — all live, vault pushed private to github.com/Tor-Grimsson/kol-glass.

## What closed
- MemPalace evaluation → done: concept adopted (shared, content-addressed memory), implementation rejected (grep-scale corpus; zero new deps).
- Design docs → done: `docs/operations/systems/claude-memory/` (INDEX + 01-memory-system, 02-repo-contract, 03-kol-glass-vault, 04-sharing), synced to build reality + rename.
- Global tier → done: `claude/memory/` — 21 cross-repo facts (19 from dotfiles memory + 2 from the home key); home key symlinked in.
- dotfiles repo tier → done: `.kol/llm-memory/` — 3 facts (two-machines, popup-50, brewfile-canonical).
- Repo tiers → done: 5 seeded by moving live-key facts — `_kol-quick`(3) `kol-chess`(1) `kol-ds-ui`(5) `kol-studio`(3) `kol-website`(4), each index opening with the global-pointer line.
- Write path → done: all 7 `~/.claude/projects/<key>/memory` dirs are symlinks into repo tiers.
- Vault → done: kol-glass — `repos/` 36 docs links (4 dead pruned, renames traced), `memory/` 7 tier links, `sync.sh` (ROOTS/DOTFILES/EXCLUDE seam; membership = `.git ∨ docs/ ∨ .kol/llm-memory/`), policy `.gitignore`; user renamed, gitted, pushed **private** (INDEX carries the client roster — public ruled out).
- Sensitivity screen → done: every moved fact read — process rules only, no secrets; `_kol-quick` holds client work detail → that repo stays private.
- MBP bring-up → closed as documented routine: one `sync.sh` run, covered by docs 02 failure modes + vault INDEX.
- Tier commits in dotfiles + 5 repos → closed: user's own git flow, never a tracked item.
- Dead-key memory triage (~30 orphaned dirs) → parked at `llm-plan/01-parking-lot.md`.
- Shareable scaffold (public template) → parked at `llm-plan/01-parking-lot.md` — the designated next arc; spec in `docs/operations/systems/claude-memory/04-sharing.md`.

## The arc (brief)
- Started as a question — where memory lives, how it's produced — answered by audit: 41 path-keyed dirs, most orphaned by the `~/dev` reshuffle, none shared.
- MemPalace (github.com/MemPalace/mempalace) evaluated as the outside option; its architecture validated the diagnosis, its weight didn't fit — the repo's own symlink pattern won.
- Designed before building at the user's call: 5 docs, ASCII diagrams, tier split rule, sync spec, sharing requirements.
- Built in one tracked pass (journal: `playbook/2026-07-28-kol-claude-memory-build.md`): split → seed → link → lens; two catches fixed en route (git-less project dirs, macOS grep vs lens symlinks).
- Vault renamed kol-symlink → kol-glass (looking-glass lineage: a read-only window into live systems), gitted and pushed private by the user.
