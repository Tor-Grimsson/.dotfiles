# Session: coolnight theme (yazi/nvim/iTerm/tmux) + yazi full-reference configs + vim-tmux-navigator + flash + tldr

**Date:** 2026-06-24
**Agent:** Grim (Claude Opus, `~/.dotfiles`, iMac)
**Summary:** Rewrote the sparse yazi configs into full annotated references, then switched the whole stack from gruvbox → josean's "coolnight" look (iTerm-driven, NOT catppuccin), wired vim-tmux-navigator's tmux side, enabled flash, and added tldr.

## Changes Made

### Files Modified
- `yazi/yazi.toml` — replaced the 21-line delta config with the **complete yazi 26 default** (every section/key documented, defaults inline), user overrides marked `# ← custom` (linemode=size, sort_by=natural, preview max 1000×1400, lanczos3, q90).
- `yazi/keymap.toml` — replaced the prepend-only file with the **complete default keymap** across all 8 modes, customs marked `# ← custom`. `g p` repointed `~/thatComp--iMac` → `~/dev/projects` (was an iMac-only dead jump on the MBP, §1).
- `yazi/theme.toml` — **no flavor** now (yazi inherits the terminal palette — josean's model); catppuccin-mocha + gruvbox-dark left as commented `[flavor]` blocks.
- `yazi/package.toml` — `catppuccin-mocha` flavor dep added (vendored via `ya pkg add yazi-rs/flavors:catppuccin-mocha`).
- `nvim/lua/grim/plugins/colorscheme.lua` — **TokyoNight "night" + coolnight navy override** (josean's exact palette) active; catppuccin + gruvbox kept as `enabled = false` specs (flip to switch).
- `nvim/lua/grim/plugins/lualine.lua` — statusline `theme = "tokyonight"` (was the stale navy `my_lualine_theme`, kept commented for revert).
- `nvim/lua/grim/plugins/flash.lua` — **uncommented/enabled** (`s`/`S` jump). No clash: substitute.nvim uses `<leader>r`, not `s`.
- `nvim/lazy-lock.json` — updated by the headless `Lazy! sync`.
- `tmux/.tmux.conf` — new `## 5.` section: vim-tmux-navigator smart bindings (`C-h/j/k/l` + `C-\`, no-prefix), no tpm. nvim side was already declared in `plugins/init.lua:3`.
- `Brewfile` — `+ brew "tealdeer"` (the `tldr` client) in Modern CLI core.

### Files Added
- `iterm/coolnight.itermcolors` — josean's exact coolnight palette as an importable iTerm preset (generated, validated).
- `yazi/flavors/catppuccin-mocha.yazi/` — vendored flavor (kept for switching even though unused now).

### Files Modified (binary/state)
- `iterm/com.googlecode.iterm2.plist` — coolnight applied directly to the **Default** profile color keys + registered under `Custom Color Presets` as `coolnight`. Backup at `scratchpad/iterm-plist-backup-precoolnight.plist`.

## Current State

### Working
- **tmux** — config reloaded live (`tmux source-file`); `C-h/j/k/l` pane↔nvim-split nav active now.
- **nvim** — tokyonight + flash headless-installed (both verified on disk under `~/.local/share/nvim/lazy/`); themed + flash live on next launch.
- All edits validated: tmux loads clean (isolated socket), yazi TOML parses, nvim Lua compiles (`luac -p`).

### Known Issues
- **iTerm needs a restart** to load coolnight (reads colors at launch). If save-mode is *automatic* (not the documented manual), quitting iTerm overwrites the plist edit — fallback: pick the registered `coolnight` preset in Settings → Profiles → Colors.
- coolnight's ANSI **white = `#24EAF7` (cyan)** — faithful to josean, but unconventional; programs that emit literal "white" render cyan.
- The full-default `yazi.toml`/`keymap.toml` **freeze stock defaults** — they won't auto-track yazi upgrades. Re-pull the default files + re-apply `# ← custom` lines after a major bump (noted in each file's header).

## Next Steps
1. **User provisioning** (no-provisioning rule): `brew bundle` (installs tealdeer), then `tldr --update` once to fetch the cache.
2. **User**: restart iTerm to load coolnight (tmux survives; `tmux attach` to resume).
3. ~~Catalog debt~~ **DONE (same session):** tldr doc at `docs/01-shell-terminal/12-tldr.md`, root + cat-01 INDEX bumped (**catalog 74 → 75**, cat 01 9 → 10); coolnight theme reflected in the iTerm (`01-iterm2.md`), yazi (`02-yazi.md`), and nvim-config (`10-neovim-config.md`) docs.
