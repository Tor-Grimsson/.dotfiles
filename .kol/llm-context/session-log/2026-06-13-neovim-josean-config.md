# 2026-06-13 — Neovim: full lazy.nvim IDE config (josean replication)

Replaced the stale 3-plugin `nvim/` config with josean-dev/dev-environment-files' entire `.config/nvim` setup (~33 plugins) and wrote a dedicated catalog guide for it. The only change from upstream is the lua namespace, renamed `josean` → `grim`. Verified it launches clean (lazy + mason installed all plugins/servers on first run; user confirmed).

## Changes
- `nvim/` — old `init.lua` (lazy bootstrap + nvim-tree only) and `lazy-lock.json` removed; josean's full tree copied in: `init.lua` loader, `after/lsp/` + `after/queries/`, `.stylua.toml`, `lazy-lock.json` (his pinned versions), and `lua/grim/` (`core/`, `lazy.lua`, `lsp.lua`, `plugins/` ×30 incl. `plugins/lsp/`).
- Namespace rename `josean` → `grim` — `init.lua`, `lua/grim/lazy.lua` (the two `import` specs), `lua/grim/core/init.lua`. `grep josean nvim/` is clean.
- Stack: LSP via `mason` + `mason-lspconfig` + `nvim-lspconfig` (new native `after/lsp/` + `vim.lsp.enable` style — needs nvim ≥0.11, running 0.12.2); `nvim-cmp`+LuaSnip; telescope (+fzf-native, `make`); treesitter; conform (format-on-save) + nvim-lint; gitsigns + lazygit; nvim-tree; lualine/bufferline/alpha/dressing/indent-blankline; which-key, trouble, surround, substitute, autopairs, vim-maximizer, todo-comments, auto-session, vim-tmux-navigator. `flash.lua` + `ai.lua` are commented-out placeholders (no-ops).
- No bootstrap or Brewfile change — `~/.config/nvim` was already a whole-dir symlink to `nvim/` (bootstrap.sh:92); neovim + node already in the Brewfile; plugins/servers install via lazy/mason into `~/.local/share/nvim/` (runtime state, not tracked).
- Docs — new guide `docs/04-dev-languages/10-neovim-config.md` (layout, plugin roster, verified keybind tables, add/remove-plugin, theme, cross-machine, source). Routed via a new `## Guides` line in `04-dev-languages/INDEX.md` (tool count unchanged — guide, not a tool). `03-neovim.md`: stale "Future use" section (which had predicted exactly this setup) rewritten to point at the guide; reciprocal `related` link added; both `updated` bumped to today.

## Next
- Commit so dot-sync carries the config + `lazy-lock.json` to the MBP; first `nvim` there installs the identical pinned versions (compiled bits — fzf-native, mason tools — rebuild per machine).
