# Session: nvim-now retired — references swept, dashboard label fix

**Date:** 2026-07-28
**Agent:** Claude Code (Grim)
**Summary:** User scrapped the nvim-now config (features already merged into daily nvim 2026-07-20 via nmix); agent swept every live reference out of scripts/configs/docs, guarded kol-theme's nvim leg, and relabeled the alpha dashboard `SPC` → `<Leader>`.

## Changes Made

### Files Modified
- `nvim/lua/grim/plugins/alpha.lua` — dashboard buttons relabeled `SPC ee/ff/fs/wr` → `<Leader> ee/…` (alpha derives the keybind from the label; `<Leader>ee` is valid lhs, binds unchanged)
- `bin/ref` — nnow card removed (card_def, usage list, error message); `bin/ref-pick` — CARDS array
- `ref/nvim.md` — sibling line + `(nnow: mx)` stripped; `ref/system.md` — nvim-now out of the kol-theme switch line
- `shell/.zshrc` — `nnow` alias removed; `bootstrap.sh` — nvim-now symlink block removed
- `bin/kol-theme` — nvim cp now `[ -d nvim-now/lua ] &&`-guarded (no-op until daily nvim adopts the selector); header updated
- Docs synced: `docs/scripts/22-ref.md`, `docs/scripts/INDEX.md`, `docs/documentation/09-productivity-desktop/{08-kol-theme.md,INDEX.md}`, `docs/kol-terminality/12-nvim-from-scratch.md` (retirement note — doc kept as the learning record)

### Features Added/Removed
- **Removed (user-deleted, agent-swept):** `nvim-now/`, `~/.config/nvim-now`, `ref/nnow.md`, `bin/ref-nnow`, `nnow` alias, runtime data dirs. Historical mentions in backlog/session logs left as record.

## Current State

### Working
- `bash -n`/`zsh -n` clean on all edited scripts; nvim headless boot clean; `help-lint` clean (80 scripts)
- ref family = 6 cards (keys · tmux · files · widgets · system · nvim)

### Known Issues
- kol-theme's nvim leg is dormant — `themes/*/nvim.lua` files stay shelved until the daily `nvim/` adopts the selector (the standing graduation item, see 08-kol-theme gotchas).

## Next Steps
1. (parked) Daily nvim adopts the kol-theme selector — revives the guarded leg.
