---
title: Neovim config (IDE setup)
type: guide
status: active
updated: 2026-07-02
audience: internal
description: The full lazy.nvim-based Neovim IDE config in this repo — structure, plugin roster, and keybindings. A replication of josean-dev's setup under the `grim` namespace, tracked at nvim/ and symlinked to ~/.config/nvim.
aliases:
  - nvim-config
  - neovim-setup
  - grim-nvim
tags:
  - domain/dev/editor
  - pattern/tui
related:
  - "[[01-cli-cheatsheet|CLI cheatsheet]]"
  - "[[11-neovim-cheatsheet|Neovim cheatsheet (beginner)]]"
  - "[[03-neovim|Neovim]]"
  - "[[02-visual-studio-code|VS Code]]"
  - "[[02-yazi|yazi]]"
---

# Neovim config (IDE setup)

## Purpose

Turns [Neovim](03-neovim.md) from a quick-edit tool into a full terminal IDE: LSP completion and diagnostics, fuzzy finding, Tree-sitter syntax, formatting/linting on save, a file tree, and git integration — all on `lazy.nvim`, one plugin per file. It's a replication of [josean-dev's config](https://github.com/josean-dev/dev-environment-files) (the YouTube setup), copied verbatim except the lua namespace was renamed `josean` → **`grim`**.

The config is tracked at `nvim/` in this repo and `~/.config/nvim` is a whole-directory symlink to it (`bootstrap.sh`), so edits to either side are the same files.

## Prerequisites

- **Neovim ≥ 0.11** — the LSP layer uses the native `vim.lsp.enable` + `after/lsp/` style (this machine runs 0.12.2). See [Neovim](03-neovim.md).
- **node + npm** — most LSP servers mason installs are node-based (ts_ls, html, cssls, tailwindcss, svelte, graphql, emmet_ls, prismals, eslint, pyright).
- **git + a C compiler + `make`** — lazy.nvim clones itself on first run; `telescope-fzf-native` compiles via `make`.
- **A Nerd Font** in the terminal for the icons — see [Fonts](../10-fonts/INDEX.md).

## First launch

Open `nvim`. On the very first start:

1. `lazy.nvim` clones itself (the bootstrap block in `lua/grim/lazy.lua`) and installs every plugin.
2. **mason** auto-installs the LSP servers, formatters, and linters listed in `lua/grim/plugins/lsp/mason.lua`.
3. `telescope-fzf-native` builds, and the python tools (black/isort/pylint) install into mason's own env.

Expect noise — errors and a half-drawn UI — while downloads finish. **Quit and reopen once** and it's clean. The mason tools live in `~/.local/share/nvim/mason/`, outside the repo (not tracked). Check state with `:Lazy` and `:Mason`.

## Layout

```
nvim/
├── init.lua                     -- loads grim.core, grim.lazy, grim.lsp
├── lazy-lock.json               -- pinned plugin versions (synced across machines)
├── .stylua.toml                 -- lua formatter config
├── after/
│   ├── ftplugin/markdown.lua    -- per-filetype prose settings (wrap/conceal/textwidth)
│   ├── lsp/*.lua                -- per-server overrides (eslint, svelte, graphql, emmet_ls)
│   └── queries/ecma/            -- custom Tree-sitter textobjects
└── lua/grim/
    ├── core/
    │   ├── options.lua          -- vim.opt settings (no plugins)
    │   └── keymaps.lua          -- non-plugin keybinds
    ├── lazy.lua                 -- bootstraps lazy.nvim, imports plugins/ + plugins/lsp/
    ├── lsp.lua                  -- LspAttach keymaps + diagnostic signs
    └── plugins/                 -- one file per plugin; lazy auto-imports the folder
        ├── lsp/{lsp,mason}.lua
        └── <plugin>.lua ×30
```

`init.lua` is a three-line loader; the namespace folder (`lua/grim/`) keeps these modules from colliding with plugin module names.

## Filetype overrides (`after/ftplugin/`)

`core/options.lua` sets editor-wide defaults (notably `wrap = false`). Per-filetype
tweaks live in `after/ftplugin/<ft>.lua` — Neovim sources these automatically when a
buffer of that filetype opens, *after* the globals, so they win without any autocmd.
Use `vim.opt_local` (not `vim.opt`) so the change stays scoped to that buffer.

- **`markdown.lua`** — prose mode for `.md`: `wrap = true` (re-enables soft wrap that
  the global turns off), `conceallevel = 2` (hides `**`/`_`/link markup), `textwidth = 80`
  (hard-wrap column). This is the only filetype override so far; add a sibling file to
  cover another (e.g. `gitcommit.lua`).

## Plugin roster

| Function | Plugin(s) |
|---|---|
| Plugin manager | `lazy.nvim` |
| Colorscheme | `gruvbox-material` (sainnhe) — active; `tokyonight` (folke, `night` + josean's "coolnight" navy override), `catppuccin`, `dracula`, `shades-of-purple` kept as disabled specs to flip |
| File explorer | `nvim-tree` |
| Fuzzy finder | `telescope` + `telescope-fzf-native` + `plenary` |
| LSP | `nvim-lspconfig`, `mason`, `mason-lspconfig`, `mason-tool-installer` |
| Completion | `nvim-cmp` + `LuaSnip` + `friendly-snippets` + buffer/path sources + `lspkind` |
| Syntax | `nvim-treesitter`, `treesitter-text-objects`, `nvim-ts-autotag` |
| Formatting | `conform.nvim` — prettier (web), stylua (lua), isort+black (python); **format on save** |
| Linting | `nvim-lint` — pylint (python); lints on save / leave-insert |
| Git | `gitsigns` (gutter + hunk ops), `lazygit` (full TUI) |
| UI | `lualine` (statusline), `bufferline` (tabs mode), `alpha` (dashboard), `dressing`, `indent-blankline` |
| Editing | `autopairs`, `nvim-surround`, `substitute`, `flash` (jump motions), `vim-maximizer`, `todo-comments`, `trouble` |
| Navigation | `vim-tmux-navigator` (Ctrl-h/j/k/l across splits + tmux panes), `auto-session`, `yazi.nvim` (`<leader>fy` — floating [yazi](../02-file-management/02-yazi.md) at the current file) |
| Disabled | `which-key`, `ai` (ChatGPT) — present but fully commented out (no-op placeholders) |

## Keybindings

**Leader is `Space`.** **`<leader>fk`** searches every keybind via Telescope. (**which-key** is present in the plugin roster but fully commented out — no popup menu on leader-wait; `<leader>fk` is the actual way to discover keys.)

### Core & windows
| Key | Action |
|---|---|
| `jk` | exit insert mode |
| `<leader>nh` | clear search highlight |
| `<leader>+` / `<leader>-` | increment / decrement number |
| `<leader>sv` `sh` `se` `sx` | split vertical / horizontal / equalize / close |
| `<leader>sm` | maximize / restore a split |
| `<leader>to` `tx` `tn` `tp` `tf` | tab new / close / next / prev / current-buffer-in-new-tab |
| `Ctrl-h/j/k/l` | move between splits (and tmux panes) |

### Files & search
| Key | Action |
|---|---|
| `<leader>ee` `ef` `ec` `er` | file tree: toggle / reveal current file / collapse / refresh |
| `<leader>ff` | find files |
| `<leader>fs` | live grep (search contents) |
| `<leader>fc` | grep word under cursor |
| `<leader>fr` | recent files |
| `<leader>ft` | find todos |
| `<leader>fy` | open [yazi](../02-file-management/02-yazi.md) at the current file (yazi.nvim, floating) |

### Code intelligence (LSP — active once mason finishes)
| Key | Action |
|---|---|
| `gd` `gD` `gR` `gi` `gt` | definition / declaration / references / implementations / type defs |
| `K` | hover docs |
| `<leader>ca` | code action |
| `<leader>rn` | rename symbol |
| `<leader>d` / `<leader>D` | line / buffer diagnostics |
| `[d` / `]d` | previous / next diagnostic |
| `<leader>rs` | restart LSP |

### Completion (insert mode)
`Ctrl-Space` trigger · `Ctrl-j` / `Ctrl-k` next / prev · `CR` confirm · `Ctrl-e` abort · `Ctrl-b` / `Ctrl-f` scroll docs.

### Format & lint
`<leader>mp` format file / selection (also runs on save) · `<leader>l` trigger lint.

### Git
| Key | Action |
|---|---|
| `]h` / `[h` | next / prev hunk |
| `<leader>hs` `hr` | stage / reset hunk (works in visual range too) |
| `<leader>hS` `hR` `hu` | stage buffer / reset buffer / undo stage |
| `<leader>hp` `hb` `hB` | preview hunk / blame line / toggle line blame |
| `<leader>hd` `hD` | diff this / diff against `~` |
| `<leader>lg` | open LazyGit (full TUI) |

### Diagnostics list & substitute
- Trouble: `<leader>xw` workspace · `<leader>xd` document · `<leader>xq` quickfix · `<leader>xl` loclist · `<leader>xt` todos.
- Substitute (replace text object with the yank register): `<leader>r{motion}` · `<leader>rr` line · `<leader>R` to end of line · `<leader>r` in visual mode.

## Adding / removing a plugin

- **Add:** drop a new file in `lua/grim/plugins/<name>.lua` that `return`s a lazy spec. lazy auto-imports the folder (`{ import = "grim.plugins" }` in `lazy.lua`), so there's nothing to register — restart nvim, lazy installs it.
- **Remove:** delete the file, then `:Lazy clean`.
- **LSP servers / tools:** edit the `ensure_installed` lists in `plugins/lsp/mason.lua`, restart; or add ad-hoc from the `:Mason` UI.

## Theme

tokyonight, configured in `plugins/colorscheme.lua`. It overrides the `night` palette with josean's "coolnight" navy (bg `#011628`) — matching the iTerm `coolnight` terminal theme. The statusline uses the matching `tokyonight` lualine theme (`plugins/lualine.lua`).

`colorscheme.lua` holds three specs; only the `enabled` one loads. To switch theme, flip `enabled` (tokyonight → catppuccin → gruvbox-material) — the other two are parked, not deleted. Flip `local transparent = false` to `true` for a transparent background.

## Cross-machine

`lazy-lock.json` pins exact plugin commits, so committing it makes the [Neovim](03-neovim.md) setup reproduce identically on the MBP via dot-sync. No hardcoded paths anywhere — `stdpath` everywhere — so it's cross-arch clean; the compiled bits (`fzf-native`, mason tools) rebuild per machine on first launch.

## Source

[josean-dev/dev-environment-files](https://github.com/josean-dev/dev-environment-files) `.config/nvim`, replicated 2026-06-13. Only change from upstream: the `josean` lua namespace renamed to `grim` (in `init.lua`, `lazy.lua`, `core/init.lua`). To follow along with josean's videos, mentally swap `josean` → `grim` in any `require(...)` path.
