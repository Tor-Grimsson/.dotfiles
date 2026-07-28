---
title: 07.04 · Dependencies & license
type: reference
status: active
updated: 2026-07-28
description: Runtime dependencies (node, stdlib-only), what is markdown vs code, and the MIT provenance that makes the fork clean with attribution.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[07-ponytail-fork/INDEX|ponytail fork]]"
  - "[[07-ponytail-fork/03-fork-plan|fork plan]]"
---

# Dependencies & license

## Runtime dependencies

| Dependency | Needed by | Note |
|---|---|---|
| **node** (any modern) | the 5 hook scripts + optional MCP server | stdlib-only — `package.json` declares **zero** npm dependencies; no `node_modules` at runtime |
| a POSIX shell / PowerShell | the hook command lines + optional statusline | both variants shipped |
| nothing else | — | skills and rules are plain markdown; state is one flag file |

So: **not** everything is `.md` — the answer to the fork-evaluation question is *markdown skills + five small stdlib-node scripts + JSON manifests*. The benchmarks' python/js/promptfoo stack is dev-only and never runs on an adopter's machine.

## License & provenance

| Fact | Value |
|---|---|
| License | **MIT** (both `LICENSE` and `package.json` agree) |
| Copyright | © 2026 Dietrich Gebert (github.com/DietrichGebert) |
| Install source | marketplace git clone at `~/.claude/plugins/marketplaces/ponytail/` |
| Fork legality | clean — MIT permits forks, modification, and redistribution |
| Obligations | keep the upstream LICENSE text + copyright notice in the fork; add our own line above it; attribution in the fork's README is good practice, not just courtesy |

## Risk notes

- The plugin auto-updates via the marketplace; a fork freezes at 4.8.1 semantics — upstream improvements arrive only by manual diff (that's the price of owning the cadence).
- The multi-platform rule copies are kept in sync by upstream build scripts; if the fork keeps any adapters, it inherits that sync duty (`scripts/check-rule-copies.js`).
