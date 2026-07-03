---
_template:
  version: 1
  path: .llm-context/session-log/SESSION.md
  sync: skip
date: 2026-06-04
summary: Consolidated ~/.claude into the repo (skills/agents/packages/MCP, caveman removed), extracted skill deps into claude/packages/, rewrote kol-docs as a self-contained spec, and re-prefixed + documented all bin/ scripts.
---

# 2026-06-04 — Claude config consolidation + skills/packages + bin reorg

Continues the earlier `2026-06-04-tooling-audit-and-reorg` log (Brewfile + initial `.claude` dotfiling).

## Changes made

**Claude config → repo (single source of truth, iCloud demoted)**
- Skills curated to: `kol-bucket`, `kol-docs`, `init-agent-context(+sync)`, `init-scaffold`, plus salvaged from iCloud `c1/c2/c3`: GSAP suite (8), `algorithmic-art`, `glif-art`. Sourced from canonical `kol-system`.
- 4 KOL design agents salvaged + modernized (added frontmatter) → `kol-{color,div,docs,type}-agent`.
- **Caveman fully removed** — plugin, hooks, skill, settings blocks, doc mentions. Off this session, won't return.
- **glif MCP** wired into `settings.json` (`@glifxyz/glif-mcp-server`, token as `${GLIF_API_TOKEN}` env ref — no literal in repo).

**`claude/packages/` — deps out of skills**
- `bucket` (rclone CLI → `~/.local/bin`), `kol-docs-framework`, `init-agent-context-templates`, `algorithmic-art-templates`. All skills repointed at `~/.dotfiles/claude/packages/`.
- **`kol-docs` SKILL.md rewritten as the self-contained framework spec** (frontmatter contract, 9 archetypes, status enum, 10-namespace tag taxonomy, filename/folder law, `_assets`/`_files`, wikilinks, maintenance). The `_framework/` folder is now backup-only (`_example/` copy-shapes + `_templates/`).

**bin/ scripts**
- Re-prefixed by domain: `au- vid- img- pdf- art- batch- tor- fs- ss-` (32 scripts). 9 redundant → `_bak/`. Fixed `covert`→`convert` typo, `art-process`→`art-export.yml` ref, `.gitignore` (`bin/jackett`→`bin/tor-jackett`).
- Salvaged `ss-save.sh` (clipboard→png) + `ss-save.md`. Captured `macos/prefs/*.plist`. Filled `macos/defaults.sh` + wrote teaching `defaults.md`.
- `docs/12-scripts/` catalog (INDEX + 8 family docs), linked into root docs INDEX.

## Current state
- Working tree ready for the user's commit. **Agent did not touch git.**
- `bucket` symlinked to `~/.local/bin`; all `~/.claude/*` symlinks confirmed.

## Next steps
- **mbp `~/.claude` reconcile** before bootstrapping it (iCloud Workbox divergence).
- **kol-monorepo is the live DS source** (`apps/brand`); `kol-system` is frozen. `init-scaffold` + the kol agents still point at the dead kol-system — fixing them = the monorepo's **Phase 6 "invert upstream"** (structural remap, deferred).
- Outstanding: p10k/zsh dedup, pipx→uv, `rm ~/.claude-server-commander`.
