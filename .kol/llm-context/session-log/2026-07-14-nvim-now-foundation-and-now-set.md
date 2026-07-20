# Session: nvim-now — foundation + the full `now` set, live

**Date:** 2026-07-14
**Agent:** Grim (Fable 5)
**Summary:** The nvim from-scratch arc went from zero to a working editor in one sitting: `nvim-now/` built (foundation + 16 plugin specs, 31 plugins), run parallel to the daily `nvim/` via `NVIM_APPNAME`, verified live by the user. The map-triage gate was dropped on the user's call — the daily config served as the revealed preference.

## Changes Made

### Foundation (phases 1–3)
- `nvim-now/init.lua` + `lua/config/{options,keymaps,lazy}.lua` — Sin-cy's core with `ours` markers where grim habits won (2-space tabs, `jk`, `<leader>nh`, `+`/`-`, ignorecase/smartcase, cursorline). Skipped nightly-only bits (`vim._core.ui2`, `:restart`, lsp-restart).
- Wiring: `~/.config/nvim-now` symlink · `nnow` alias (`NVIM_APPNAME=nvim-now nvim`) in `shell/.zshrc` · bootstrap block — **which also fixed a found gap: `~/.config/nvim` was hand-linked, never in bootstrap** (MBP parity).

### The `now` set (phases 4–12) — 16 spec files
- **Triage rule (agent call, map export skipped):** now = video core ∩ daily usage + oil/harpoon/blink experiments. Full now/later/skip lists recorded in `12-nvim-from-scratch.md`.
- Built from Sin-cy's **current repo** (it moved past the video: blink-cmp replaces nvim-cmp; LSP on the new `vim.lsp.config/enable` API — the video's mason layout broke).
- Adaptations: prettier + eslint_d (not his biome) · servers trimmed to the JS/TS/Svelte/Tailwind/markdown stack · lualine `theme = "auto"` on gruvbox-material (daily's scheme + settings) · lazygit enabled · telescope carries the daily's `ff/fr/fs/fc/ft/fk` binds.

### Gotchas that cost time
- **Homebrew's `tree-sitter` formula is library-only now** — the CLI split into `tree-sitter-cli`. First brewfile line pointed at the lib; user installed it, parsers still failed ENOENT. Fixed: `brewfile-cli` carries `tree-sitter-cli` (the lib stays — neovim depends on it).
- `jsonc` isn't a main-branch parser (json covers it) — dropped from the install list.
- treesitter main-branch installs print per-language "Language installed" messages, no aggregate finish banner.

### Files Modified
- `nvim-now/` — new (21 files)
- `bootstrap.sh` — neovim block (nvim + nvim-now symlinks)
- `shell/.zshrc` — `nnow` alias
- `brewfile-cli` — `tree-sitter-cli` line
- `docs/kol-terminality/12-nvim-from-scratch.md` — triage record, progress, graduation notes
- `.kol/llm-context/playbook/2026-07-14-nvim-now-build.md` — the arc's live journal

## Current State

### Working
- `nnow` = the from-scratch editor: 31 plugins, 19/19 parsers compiled, gruvbox-material, LSP/completion/format-on-save/lint wired. **User-confirmed live.**
- Daily `nvim`/`vim` untouched; the two configs are fully isolated (`~/.local/share/nvim-now` vs `nvim`).

### Known Issues
- Harpoon's `<C-i>` (select file 2) shadows jumplist-forward — inherited from the reference; revisit if it grates.
- Mason server installs finish in the background over the first launch or two.

## Next Steps
1. **Live in `nnow`** — friction notes go to the playbook; that drives the next pass.
2. Graduation (when it's the reach-for editor): flip `~/.config/nvim` in bootstrap, archive old `nvim/`, catalog doc under `docs/documentation/`, sync `keys/keybinds.md` binds.
3. `later` shelf when wanted: snacks, undotree, render-markdown, fugitive… (list in the study doc).
