# Session: the spacer ruling — 385 rows stripped, and md/mc/mp

**Date:** 2026-07-31
**Agent:** Claude Code (Grim)
**Summary:** Blank spacer rows were being applied between *every* table row across the whole card system; the user's intent was breathers between categories. Stripped 385 of them, corrected the spec that taught the habit, trimmed `ref-lobby` from doctrine back to commands, and gave markdown mode the key it should always have had.

## Changes Made

### Files Modified
- **13 cards** — 385 blank spacer rows removed: `nvim` (123) · `tmux` (46) · `explorer` (36) · `desk` (27) · `skill` (26) · `shell` (25) · `git` (23) · `grep` (20) · `humpty` (15) · `repo` (14) · `media` (13) · `system` (11) · `terminal` (6).
- `ref/lobby.md` — **103 → 51 lines, 7 → 4 sections.** Cut `law`, `bar`, `entry`; kept `where` · `file` · `read` · `states`.
- `ref/llm.md`, `ref/textmodes.md` — rewritten to the same shape.
- `nvim/lua/grim/core/keymaps.lua` — `<leader>mm` → **`<leader>md`** (markdown mode).
- `nvim/after/ftplugin/markdown.lua` — `<leader>md` → **`<leader>mc`** (conceal toggle).
- `ref/nvim.md` — the three `m*` rows.
- `docs/scripts/ref-system/{02-cards,01-system,03-glow,INDEX}.md` + `claude/skills/ref-add/SKILL.md` — the spacer rule corrected at source.
- `docs/documentation/04-dev-languages/10-neovim-config.md` — keybinding table + the where-each-key-lives split.
- `.kol/llm-context/playbook/2026-07-31-lobby-system.md` — two entries appended.

## The spacer ruling

> "I proposed line breaks for categories/sections within a table, as breathers, but you just apply them everywhere without exception."

Measured before touching anything — **12 of 16 cards were every-row**, blank:content ratios 0.60–0.76. `ref-nvim` carried 123 spacers against 162 content rows.

**The habit was documented, which is why it kept regrowing.** `docs/scripts/ref-system/02-cards.md` stated *"spacer row `| | |` between data rows"* as a dialect rule, echoed in `01-system.md`, `03-glow.md`, `INDEX.md` and the `ref-add` skill. Fixing the cards without fixing the spec would have rebuilt them on the next `/ref-add`. All five now state: a blank row is a **category break inside a table with genuine groups**, never a per-row separator.

**Measurement bug worth remembering:** the first ratio script scored every card `0.00`. The separator regex `^\s*\|[\s:|-]+\|\s*$` also matches a blank row (spaces and pipes are in its class) and `continue`d before the blank test ran. Fixed by requiring a dash. A sweep that reports all-zero is a bug until proven otherwise.

## `ref-lobby` — a lookup, not a manual

Three of its seven sections were doctrine: `law` (5 rules + consequences), `bar` (per-repo closing cost), `entry` (the entry file's shape) — 43 lines. All three already existed verbatim in `docs/operations/systems/lobby/02-lifecycle.md` and `04-conventions.md`, so cutting them removed a **second copy that could drift**, not information. The card now matches the house style: `ref-git` 5 sections, `ref-llm` 4, `ref-lobby` 4.

## `md` · `mc` · `mp`

`<leader>md` was the conceal toggle, which forced markdown-mode onto a meaningless `mm`. Now each letter is its own word's initial, and the pair splits by **where each has to work**:

| key | lives in | because |
|---|---|---|
| `md` markdown on | `core/keymaps.lua` | must fire on a buffer that is *not* markdown yet |
| `mc` conceal | `after/ftplugin/markdown.lua` | only meaningful once markdown is on |
| `mp` prettier | `plugins/formatting.lua` | conform owns it, all filetypes |

That chicken-and-egg is now written into the nvim doc rather than left as folklore.

## Current State

### Working
- All **17 cards render**; 10 filters re-tested across 9 cards, zero regressions.
- Headless gate: `<leader>md` on an unnamed buffer → `ft=markdown wrap=true conceal=2`; then `<leader>mc` → `conceal=0`.
- Backup of `ref/` taken to the session scratchpad before the sweep.

### Known Issues
- **71 lines still exceed the 79-col guide** across all cards — mostly `[e]` command lines, which are protected content and yield the cap by rule. Not audited row-by-row.
- `ref-desk` (280 lines) and `ref-nvim` (285) are still the two largest cards. Shorter than before, but density is now the only thing holding them together — they are the next candidates for a section-level trim.

## Next Steps
1. Decide whether `ref-desk` and `ref-nvim` want splitting the way `keys` was dissolved into topical cards.
2. Re-run `/ref-add` once and confirm it no longer emits a spacer row.
