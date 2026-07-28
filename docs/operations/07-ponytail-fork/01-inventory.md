---
title: 07.01 · Inventory — ponytail 4.8.1 on disk
type: reference
status: active
updated: 2026-07-28
description: Where the plugin lives locally and the full anatomy of the installed 4.8.1 — runtime core vs multi-platform adapters vs dev bulk.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[07-ponytail-fork/INDEX|ponytail fork]]"
  - "[[07-ponytail-fork/02-mechanics|mechanics]]"
---

# Inventory — ponytail 4.8.1 on disk

## Where it lives locally

| Path | Role |
|---|---|
| `~/.claude/plugins/cache/ponytail/ponytail/4.8.1/` | the **installed plugin** (version-pinned cache, 1.6 MB) |
| `~/.claude/plugins/marketplaces/ponytail/` | the marketplace git clone it installs from (2.5 MB, has `.git`) |
| `~/.claude/.ponytail-active` | the **mode state file** — currently contains `full` |

## Anatomy of 4.8.1

**Runtime core for Claude Code (what a fork actually needs):**

| Piece | Files |
|---|---|
| Manifest | `.claude-plugin/plugin.json` (name, version, author, `hooks` pointer) + `marketplace.json` |
| Hook wiring | `hooks/claude-codex-hooks.json` — SessionStart (matcher `startup\|resume\|clear\|compact`) + UserPromptSubmit, both node, both fail-open, 5 s timeouts |
| Hook scripts (node, stdlib-only) | `ponytail-activate.js` (inject mode text at boot) · `ponytail-mode-tracker.js` (parse `/ponytail` commands, persist mode) · `ponytail-instructions.js` (build the injected text from the skill) · `ponytail-config.js` (modes, defaults) · `ponytail-runtime.js` (state IO) |
| Skills | `skills/{ponytail, ponytail-audit, ponytail-debt, ponytail-gain, ponytail-help, ponytail-review}/SKILL.md` — 6 markdown skills; `skills/ponytail/SKILL.md` is ALSO the source the instruction builder reads |
| Statusline | `ponytail-statusline.sh` / `.ps1` (optional cosmetic) |

**Multi-platform adapters (each a copy of the rules for another harness):** `.codex-plugin/`, `.cursor/rules/*.mdc`, `.clinerules/`, `.windsurf/`, `.kiro/`, `.github/copilot-instructions.md`, `.opencode/` (commands + an `.mjs` plugin), `.openclaw/skills/`, `gemini-extension.json` + `commands/*.toml`, `pi-extension/` (node), `.agents/` — kept in sync by `scripts/check-rule-copies.js`.

**Optional server:** `ponytail-mcp/` — a small node MCP server exposing the instructions.

**Dev bulk (not runtime):** `benchmarks/` (js + python + promptfoo configs + results), `tests/` (js), `assets/` (logos/PNGs/SVGs), `examples/`, `docs/`, `.github/workflows/`.
