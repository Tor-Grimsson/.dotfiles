---
title: Neovim from scratch — study doc
type: reference
status: active
updated: 2026-07-14
description: Study/build tracker for a Neovim config from scratch, following "The Ultimate Neovim Setup Guide From Scratch" + Sin-cy/dotfiles nvim. Learning notes, phase map, progress checkboxes. Building live at nvim-now/ (parallel via NVIM_APPNAME).
tags:
  - project/dotfiles
  - domain/shell
related:
  - "[[INDEX|kol-terminality]]"
  - "[[ricing-2025-backlog|ricing backlog]]"
---

# Neovim from scratch — study doc

Dedicated study space (split out of [`ricing-2025-backlog.md`](ricing-2025-backlog.md) on request). Goal: **understand and build a Neovim config from scratch** — not clone a distro. **Building live since 2026-07-14:** the config grows at `~/.dotfiles/nvim-now/`, run via `nnow` (`NVIM_APPNAME=nvim-now nvim`) parallel to the daily `nvim/` — work journal at `.kol/llm-context/playbook/2026-07-14-nvim-now-build.md`.

## Sources
- **Primary tutorial:** ["The Ultimate Neovim Setup Guide From Scratch"](https://youtu.be/FGVY7gbaoQI) (May 2025) — from-zero build: options → plugin manager → LSP → autocompletion → customization.
- **⭑ The interactive map (2026-07-11):** all 75 chapters as a triage tool — phases, per-section what-it-adds + ✎ from-the-talk notes, A+B→C dependency board, now/later/skip triage + export → `claude.ai/code/artifact/f13381d8`. Full transcript (whisper): [`_files/nvim-guide-transcript.md`](_files/nvim-guide-transcript.md). ⚠ Mason broke since the video — use his repo's updated `mason.lua`/`lspconfig.lua`.
- **Reference config:** [Sin-cy/dotfiles `nvim/.config/nvim`](https://github.com/Sin-cy/dotfiles) (65% Lua) — the finished rig the user is studying alongside the video.
- **Alt reference (deeper markdown/notes angle):** linkarzu's [neobean beginner guide](https://linkarzu.com/posts/neovim/all-neobean-basics/) + [markdown setup 2025](https://linkarzu.com/posts/neovim/markdown-setup-2025/).

## Why from scratch (vs LazyVim/NvChad)
A distro hides the wiring. Building it by hand means every plugin, keymap, and LSP server is understood and yours to debug. The tradeoff is time — that's the point of studying it.

## The build map (canonical modern arc)
The standard structure every from-scratch guide (incl. this one) follows. Check off as studied/built.

| # | Phase | Plugin(s) | What it gives you | Studied |
|---|-------|-----------|-------------------|:---:|
| 1 | Bootstrap | **lazy.nvim** | plugin manager; `init.lua` loads config + lazy | [ ] |
| 2 | Core options | *(none — `vim.opt`)* | line numbers, tabs, search, splits, clipboard | [ ] |
| 3 | Keymaps | *(none)* | leader = `Space`, core maps, window nav | [ ] |
| 4 | Colorscheme | tokyonight / catppuccin | the look | [ ] |
| 5 | Fuzzy find | **telescope** + `fzf-native` | files, live-grep, buffers | [ ] |
| 6 | Syntax | **nvim-treesitter** | real parsing → highlight, indent, textobjects | [ ] |
| 7 | LSP | **mason** + `mason-lspconfig` + **nvim-lspconfig** | install + attach language servers | [ ] |
| 8 | Completion | **nvim-cmp** + `LuaSnip` + cmp sources | autocompletion popup, snippets | [ ] |
| 9 | Format/lint | **conform.nvim** (or none-ls) | format-on-save, linters | [ ] |
| 10 | File tree | **neo-tree** (or nvim-tree) | sidebar explorer | [ ] |
| 11 | Statusline | **lualine** | mode/git/LSP status bar | [ ] |
| 12 | QoL | which-key · gitsigns · autopairs · Comment · indent-blankline | discoverability + editing polish | [ ] |

## Target layout (modular `lua/`)
```
~/.config/nvim/
├── init.lua                 # require config.* then bootstrap lazy
└── lua/
    ├── config/
    │   ├── options.lua       # vim.opt.*
    │   ├── keymaps.lua       # leader + core maps
    │   └── lazy.lua          # lazy.nvim bootstrap + import plugins/
    └── plugins/
        ├── colorscheme.lua
        ├── telescope.lua
        ├── treesitter.lua
        ├── lsp.lua           # mason + lspconfig
        ├── completion.lua    # nvim-cmp
        ├── formatting.lua
        ├── neo-tree.lua
        ├── lualine.lua
        └── qol.lua           # which-key, gitsigns, autopairs, comment
```
Each `plugins/*.lua` returns a lazy spec table → lazy auto-imports the whole folder. Add a file → it loads. No central plugin list to maintain.

## Study notes
*(fill as you go — gotchas, keymaps that stuck, what each LSP server needs)*

-

## Triage (2026-07-14 — agent call; the map export was skipped on request)
Rule: **now** = the video's core arc ∩ what the daily grim config actually uses, plus the video's experiments worth living with (oil, harpoon, blink).

- **now (built):** colorscheme — **Sin-cy's full theme shelf** (rose-pine · gruvbox · kanagawa · solarized-osaka · tokyonight-recolor · monokai-pro · catppuccin + our gruvbox-material; `<leader>ths` telescope switcher with live preview, pick persists to `lua/current-theme.lua`; default = solarized-osaka, his current) *(2026-07-14, moved from later on user ask)* · autopairs · blink-cmp (+LuaSnip; the repo's move — video taught nvim-cmp) · telescope+fzf-native (daily's `ff/fr/fs/fc/ft/fk` binds) · treesitter main+autotag · mason (installer only) · lspconfig (new `vim.lsp.config/enable` API; servers: lua_ls ts_ls html cssls tailwindcss svelte graphql emmet_ls eslint marksman) · conform (prettier+stylua, format-on-save) · nvim-lint (eslint_d) · oil · lualine (theme auto) · gitsigns+lazygit · harpoon2 · Comment+ts-context · todo-comments · trouble · vim-maximizer · plenary · vim-tmux-navigator · lazydev
- **later:** snacks · mini.* · fff · undotree · render-markdown · nvim-ufo · showkeys · wilder · incline · noice · colorizer · fugitive · git-worktree · image support · the tmux half of vim-tmux-navigator (changes shell `C-l`; user call)
- **skip:** biome (we're prettier/eslint) · gopls/rust/astro/angular/python servers (not the stack) · `vim._core.ui2` (nightly)

## Progress / next
- [ ] Watch the tutorial through once before building (get the whole arc).
- [x] Build phases 1–3 (bootstrap + options + keymaps) — the foundation. *(2026-07-14 — `nvim-now/`, built from Sin-cy's core with `ours` markers for kept grim habits; headless-verified.)*
- [x] Build the `now` set (phases 4–12). *(2026-07-14 — 16 spec files, 31 plugins, loads clean on gruvbox-material. Pending on first real launch: mason finishes server installs; treesitter parsers build once `tree-sitter` is installed — line added to `brewfile-cli`, user runs `brew install tree-sitter`.)*
- [ ] Live in it (`nnow`) — the real test; log friction in the playbook.
- [ ] Diff each phase against Sin-cy's `nvim/.config/nvim` to see a real-world version.
- [ ] Graduation (per below) — also the point where `keys/keybinds.md` picks up the nvim-now binds.
- [ ] Decide later: does this graduate into `~/.dotfiles` (new `nvim/` tracked config + catalog doc), or stay a personal `~/.config/nvim`?

## When it graduates
If this becomes the real editor config, it enters `~/.dotfiles` as a tracked `nvim/` dir + `bootstrap.sh` symlink + a catalog doc under `docs/documentation/` — same convention as every other tool. Until then it lives here as study.
