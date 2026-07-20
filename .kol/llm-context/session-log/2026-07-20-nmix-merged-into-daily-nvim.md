# Session: nmix merged into the daily nvim — overlay retired

**Date:** 2026-07-20
**Agent:** Grim (Fable 5)
**Summary:** User accepted the nmix graft as permanent — Oil, harpoon, and the nnow QoL keymaps merged straight into the daily `nvim/` config; the whole `nvim-mix` overlay (config, alias, symlink, bootstrap block, ref card) deleted. Plain `nvim` is now the best-of-both editor.

## Changes Made

### Files Modified
- `nvim/lua/grim/plugins/oil.lua` + `harpoon.lua` — NEW, copied from the overlay (headers retitled "merged from the nmix overlay 2026-07-20"). Oil keeps the merge-era deviations: `default_file_explorer=false` (nvim-tree owns `nvim <dir>`), no `<leader>-` float bind (decrement).
- `nvim/lua/grim/core/keymaps.lua` — nnow QoL block appended: visual `J/K` move, centered `ctrl-d/u n N`, `J` join-in-place, `< >` keep selection, `x`/visual-`p` register hygiene, `<leader>s` replace, `<leader>X` chmod, `<leader>fp` copy path. **No `<leader>d` black-hole** — daily lsp keeps it as diagnostic-float.
- `ref/nvim.md` — merged binds folded in (new `#harpoon` section, Oil lines in `#files`, QoL keys in `#edit`/`#visual`/`#move`); header notes the merge date.
- `ref/nnow.md` — sibling line updated (nmix gone).
- `docs/scripts/22-ref.md` + `INDEX.md` — card list back to 7 (nmix row removed), nvim row notes the merge.

### Features Added/Removed
- **Removed entirely:** `nvim-mix/` (all 4 files), `~/.config/nvim-mix` symlink, `nmix` alias in `.zshrc`, bootstrap.sh nvim-mix block, `bin/ref-nmix`, `ref/nmix.md`.

## Current State

### Working (verified)
- Daily `nvim` headless boot: 45 plugins, oil `-` / harpoon `<leader>a` / `<leader>s` / visual `J` all bound, `<leader>d` still diagnostic-float, `:NvimTreeToggle` present.
- `ref nmix` errors correctly (7 cards listed); help-lint clean.

### Known Issues
- Already-open nvim windows keep pre-merge behavior until restarted.
- Behavior changes now default everywhere: `x` no longer yanks, visual `p` keeps the yank, visual `J/K` move lines (stock join was `J`) — flagged to the user at merge time.
- Daily config still has **no code-action keybind** (`<leader>vca` stayed nnow-only; noted in the cards).

## Next Steps
1. `nnow` config + `ref-nnow` still exist as the from-scratch reference — decide someday whether to retire or keep as lab.
2. Arcs unchanged: simple-bar settings-panel tune; raindrop links layer.
