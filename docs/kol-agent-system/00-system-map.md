---
title: 00 · The system map — review outpoint
type: reference
status: active
updated: 2026-07-28
description: The one-page ASCII map of the entire agent operating system — private sources in dotfiles, per-repo state, the harness seam, the lens instance, and the two public exports (memory-glass, jabberwocky) — with module numbers, export statuses, and the review checklist.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|kol-agent-system]]"
  - "[[10-naming|10 — naming]]"
---

# 00 · The system map

Start here to review everything built 2026-07-28. Numbers = module docs in this folder; statuses: **✓ live** · **⬆ shipped** (public repo staged, your git) · **▷ port-next** (designed, tracked in jabberwocky MANIFEST).

```
━━━━━━━━━━━━━━━━━━━━━━━━━ PRIVATE — your machines, your repos ━━━━━━━━━━━━━━━━━━━━━━━━━━

  ~/.dotfiles  (the source of everything global)
  ├── claude/               = repo-backed ~/.claude via bootstrap symlinks   [01 ✓]
  │   ├── CLAUDE.md            persona (private name)                        [08 ✓]
  │   ├── skills/  ×44         see jabberwocky MANIFEST for the full census  [08 ✓]
  │   ├── hooks/               reinforce · gates: footer/goal/doc/git        [08 ✓]
  │   ├── packages/            kol-docs canon · scaffolds                    [06 ▷]
  │   └── memory/              GLOBAL memory tier (24 facts)                 [04 ✓]
  ├── .kol/
  │   ├── llm-context/         ARCHITECTURE · AGENT-CONTEXT · logs · NAMING  [02·03 ✓]
  │   ├── llm-memory/          dotfiles' own repo tier                       [04 ✓]
  │   └── llm-plan/            parking lot                                   [05 ✓]
  └── docs/                    the human vault (this folder lives here)      [07 ✓]
       └── kol-agent-system/   the design suite: 00-map + INDEX + 10 modules

  every project repo                      ~/.claude/projects/  (harness runtime)
  ├── LLM_RULES.md → dotfiles  [01 ✓]     └── <flat-key>/memory ──symlink──▶ repo tier
  ├── .kol/llm-context/        [02 ✓]         (7 keys wired; the ONE harness
  ├── .kol/llm-memory/         [04 ✓]          seam, isolated in sync.sh)   [04 ✓]
  └── docs/                    [07 ✓]

  ~/dev/projects/kol-glass  (PRIVATE lens instance — pushed)                 [09 ✓]
  ├── repos/   ──▶ 36 × <repo>/docs          one Obsidian meta-vault,
  ├── memory/  ──▶ 7 tiers + _global         one grep surface
  └── sync.sh     idempotent; 6 bugs found + fixed in the phase-0 audit

━━━━━━━━━━━━━━━━━━━━━━━━━ PUBLIC — the exports (your git, your push) ━━━━━━━━━━━━━━━━━━━

  Both exports are SELF-HOSTING since the 2026-07-28 restructure: boot file at root,
  .kol/ state (ARCHITECTURE·AGENT-CONTEXT·HISTORY·plan), conforming docs/ vault
  (INDEX routers, NN- frontmattered docs), tracked 3-file .obsidian seed
  (runtime pattern-gitignored), LICENSE (MIT).

  memory-glass  ⬆  (~/dev/projects/kol-humpty-dumpty/memory-glass)
  ├── sync.sh          seams ROOTS·DOTFILES·EXCLUDE·TIER_DIR·GLOBAL_TIER;
  │                    7 audit fixes total (incl. bash-3.2 empty-EXCLUDE blocker)
  ├── docs/            CATEGORY FOLDERS — documentation/{01-system,02-repo-
  │                    contract,03-portability}/ + operations/01-sync/
  └── INDEX.md         the vault home note (post-sync orientation)

  jabberwocky   ⬆  (~/dev/projects/kol-humpty-dumpty/jabberwocky)   ← THE umbrella
  ├── docs/documentation/   CATEGORY FOLDERS 00-overview/…09-routing/ — each
  │                         INDEX + numbered docs (08 · 03 embeds both .py)
  ├── docs/operations/      01-manifest/ (44/7/4/4 accounted) · 02-publish/ protocol
  └── modules/  (payload only, pointer READMEs)
      ├── 01-init · 02-context · 03-journaling · 04→memory-glass · 05-plans  ⬆
      ├── 06-docs-framework   full kol-docs CANON shipped (fm/md/lib+examples) ⬆
      ├── 07-human-tier       .obsidian seed shipped (3-file, license-clean)  ⬆
      ├── 08-behavior         UBU-ROI.md · 4 hooks — Stop-gates as .sh+.py
      │                       pairs (parity-proven) · 5 signal skills         ⬆
      └── 09-routing          lens pattern + reference sync.sh                ⬆
      remaining ▷: the stamping/reading SKILLS (scaffolds, docs-fm/md,
      migrate) — parked in jabberwocky's own .kol/llm-plan

  humpty-dumpty ⬆  (~/dev/projects/kol-humpty-dumpty/humpty-dumpty)  ← the wall-sitter
  ├── clean-room plugin (python+bash, no upstream obligations): reuse doctrine
  │   (use-what-we-have · reference-don't-improvise · high-reference→canon)
  ├── 4-level MUZZLE STEPPER (/humpty 1..4, persists across clear/compact;
  │   injection built live from the skill; step-up suggester, never auto)
  └── skills: humpty-dumpty · humpty-match · humpty-survey (usage ledger)

━━━━━━━━━━━━━━━━━━━━━━━━━ NAMING (10) ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Glass = state        memory-glass ✓ · kol-glass ✓ · seeds: hourglass, spyglass
  Ubu   = actors       Ubu Roi ✓ (public persona — private name never ships)
  Alice = motion       jabberwocky ✓ (umbrella) · chambered: humpty-dumpty
```

## Review checklist

- [ ] `jabberwocky/README.md` → `docs/INDEX.md` → `docs/documentation/00-overview.md` — the front door and the vault route (5 min)
- [ ] `docs/operations/01-manifest.md` — agree with every stays-private / port-next call
- [ ] `modules/08-behavior/UBU-ROI.md` + `hooks/reinforce-*.txt` — the public persona reads right (one leak already caught + scrubbed in the canon example vault)
- [ ] `memory-glass/` — README → `docs/` → root `INDEX.md`; sync.sh post-fix
- [ ] Both repos' `.kol/llm-context/ARCHITECTURE.md` — the laws future agents obey there
- [ ] The remaining ▷ (stamping/reading skills) — accept as parked, or order the port
- [ ] Publish: from inside each repo — `git init && git add -A && git commit`, then `gh repo create <name> --public --source . --push`

Audit trail: `.kol/llm-context/playbook/2026-07-28-agent-system-outline.md`.
