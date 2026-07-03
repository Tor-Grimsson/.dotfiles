# Session: Neovim workflows doc — yazi→cheatsheet, par/fmt reflow, text-handling process

**Date:** 2026-07-03
**Agent:** Grim (Claude Opus 4.8, `~/.dotfiles`)
**Summary:** Restructured the `00-kol-cli` docs so shortcuts and process live in the right places: moved the yazi section out of the workflows doc into the cheatsheet (it's shortcuts, not process), renamed `02-workflows.md` → `02-nvim-workflows.md` and grew it into the full Neovim text-handling guide (the messy-paste→clean-block workflow, `gq`/`gqap` anatomy, wrap/reflow with `par`/`fmt`, `:%!` filters, regex, worked examples), and logged `par`/`fmt` as reflow tools. Seeded from a kol-claude session (`summaries/23-nvim-text-parsing.md`).

## Changes Made

### Files Modified
- `docs/00-kol-cli/01-cli-cheatsheet.md` — (1) added a **reflow row** to the Neovim find/filter/replace table (`gqap`/`gqq` + `:%!par 80`) plus a `>` note explaining greedy `gq` vs balanced `par` vs system `fmt`, linking the walkthrough; (2) added a **Sequences** mini-table to the yazi section (`^sec-yazi`) — the additive task-flows lifted from the old workflows doc (copy/move via mark→`y`/`x`→`p`, move-across-tabs, bulk rename, browse→cd, find→act), deduped against the existing flat yazi keymaps rather than pasted whole; (3) footer companion link `[[02-workflows]]` → `[[02-nvim-workflows]]`.
- `docs/INDEX.md` — root catalog row 29 relinked `02-workflows` → `02-nvim-workflows` + description retargeted to nvim/text-only (was "…navigating/moving/opening in yazi").
- `Brewfile` — `brew "par"` added to the Modern CLI core (after `ripgrep`). **Deliberately NO catalog doc + no count bump** (stays 73/13) — par is a filter called from nvim (`:%!par N`), not a standalone daily driver; user approved treating it inline. See the exception note below so a future drift audit doesn't "reconcile" it.

### Files Added
- `docs/00-kol-cli/02-nvim-workflows.md` — the renamed + expanded guide. Keeps the old doc's nvim key-tables verbatim (words/blocks/Visual-block/find-replace-filter/surround) and adds a **Reshaping messy text** part: the golden rule (blank lines are `gq`'s paragraph fences → keep while wrapping, delete last), the core cleanup sequence (`:set tw`, `:%left`, `gggqG`, blank/space normalisers), the `gggqG`/`gqG`/`gqap`/`gqq` anatomy table, spacing control, the `gq` vs `par` vs `fmt` comparison (orphans), the `:%!` shell-filter table (sort/jq/column/awk/python), the `\v` very-magic regex note, `:g`+`:normal` combos, and a 10-row worked-examples table + two fuller recipes.

### Files Removed
- `docs/00-kol-cli/02-workflows.md` — superseded by `02-nvim-workflows.md` (rename). Its yazi content moved to the cheatsheet; its nvim content carried forward and expanded.

## Current State

### Working
- Link integrity verified: no live `02-workflows` references remain (only a historical mention in `session-log/2026-06-26-kol-cli-reference-cards.md`, correctly left untouched). Both inbound links (`INDEX.md`, cheatsheet footer) resolve to `02-nvim-workflows`.
- Cheatsheet stays `type: reference` (keys only); the process/narrative lives in `02-nvim-workflows` (`type: guide`). Split is clean: shortcuts in the cheatsheet, process in the workflow doc.

### Known Issues / deliberate exception
- **`par` is in the Brewfile with no catalog doc** — intentional, user-approved (it's an nvim `:%!` filter, documented in `02-nvim-workflows`, not a catalogued daily-driver tool). Do **not** flag this as Brewfile↔catalog drift; either leave it, or if a catalog stub is ever wanted, that's a separate deliberate call. `fmt` is the system `/usr/bin/fmt` (no install, no Brewfile line).

## Next Steps
1. **User runs `brew bundle`** to install `par` (both machines). `fmt` needs nothing.
2. Optional: if the "Sequences" pattern reads well in the cheatsheet, the same could fold a couple of tmux/nvim sequence-flows in later — held off to keep the cheatsheet one-page.
