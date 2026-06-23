---
title: ponytail
type: reference
status: active
updated: 2026-06-23
description: Third-party Claude Code plugin that forces the laziest solution that actually works — an over-engineering reviewer ("delete the code") with a persistent mode and six /ponytail-* skills.
aliases:
  - ponytail
tags:
  - domain/dev
  - domain/ai/llm
  - integration/claude-plugin
links:
  repo: https://github.com/DietrichGebert/ponytail
  marketplace: https://github.com/DietrichGebert/ponytail
covers:
  - What ponytail does (the laziness ladder) + the persistent mode
  - The six skills (core + review/audit/debt/gain/help)
  - How it's installed/tracked (plugin, not Brewfile) + the statusline badge
related:
  - "[[09-llm|llm]]"
---

## Summary
ponytail is a third-party **Claude Code plugin** (`DietrichGebert/ponytail`, v4.8.1) that makes the agent behave like a lazy senior developer — lazy meaning *efficient*, not careless. It enforces a "laziness ladder" on every change: does this need to exist at all (YAGNI) → reuse what's already here → stdlib → native platform feature → already-installed dependency → one line → only then minimal new code. The goal is the shortest working diff, deletion over addition, and no speculative abstractions. It's not a CLI or an app — it's a behavior layer for Claude Code.

## Why installed
A counterweight to over-engineering. Pointed at a diff or the whole repo it calls out reinvented stdlib, needless dependencies, and dead flexibility; left on in the background it shapes how new code gets written here so the dotfiles scripts stay small and boring.

## Most common use case
It mostly just cruises — a `SessionStart` hook activates it every session (default mode **full**), so responses are shaped by the ladder without you doing anything. When you want to point it deliberately:

| Skill | What it does |
| --- | --- |
| `/ponytail lite\|full\|ultra` | Switch intensity (or `stop ponytail` / `normal mode` to disable for the session) |
| `/ponytail-review` | Review the current diff for over-engineering — what to delete |
| `/ponytail-audit` | Scan the whole repo for bloat: a ranked delete/simplify/replace list |
| `/ponytail-debt` | Harvest every `ponytail:` comment into a debt ledger |
| `/ponytail-gain` | Scoreboard of its measured impact (less code/cost, more speed) |
| `/ponytail-help` | Quick-reference card for all modes and commands |

## Biggest win
Zero-effort default. The session hook means you don't have to remember to invoke anything — the "delete-the-code" reflex is always on — and the `/ponytail-*` skills are there for an explicit review or repo audit when you want a one-shot report.

## Config & setup
- **Not a Brewfile tool.** Installed as a Claude Code plugin, not via brew. Install/reproduce:
  ```sh
  claude plugin marketplace add DietrichGebert/ponytail
  claude plugin install ponytail@ponytail
  ```
  Both lines live in `bootstrap.sh` (the "Claude plugins" block, guarded by `command -v claude`). The marketplace + enable state are also declared in `claude/settings.json` (`extraKnownMarketplaces` + `enabledPlugins`).
- **Runtime state is not in the repo.** The cloned marketplace repo and `~/.claude/plugins/*.json` are runtime/cache per ARCHITECTURE §N — only the install *intent* (bootstrap + settings) is tracked. The MBP gets it on its next `bootstrap.sh` (or the two commands above).
- **Marketplace pins to `main`** — whatever upstream pushes is reproduced. Fork + repoint the bootstrap line if a frozen version is ever wanted.
- **Statusline badge:** `claude/settings.json` has a `statusLine` block running the plugin's `ponytail-statusline.sh`, so the active mode shows as `[PONYTAIL]` / `[PONYTAIL:ULTRA]`. Path uses the version-agnostic `~/.claude/plugins/marketplaces/ponytail/hooks/` copy via `$HOME` (not the version-pinned `cache/…/4.8.1/` path, which renames on every version bump). Renders from the next session start.

## Future use
Run `/ponytail-audit` on this repo's `bin/` scripts to find anything worth deleting, and `/ponytail-debt` periodically to surface the `ponytail:` shortcut comments before "later" becomes "never". If more Claude Code plugins get tracked, this and them could split into their own catalog category.
