# Session: Up/Down history tiers + zsh-vi-mode (config + 9-chapter guide) + AeroSpace Alt-conflict found

**Date:** 2026-07-09
**Agent:** Claude (Grim)
**Summary:** Split the Up/Down keys into three history tiers, then set up zsh-vi-mode end-to-end (toggle-gated config verified against the upstream README, catalog doc, and a 9-chapter guide folder benchmarked against 8 real GitHub configs) — and discovered that AeroSpace's Alt modifier shadows most terminal Alt-keys at the OS level.

## Changes Made

### Files Modified
- `shell/.zshrc` — **history tiers**: atuin now inits `--disable-up-arrow`; `Up`/`Down` → `up-line-or-beginning-search` (prefix search), `Shift-Up/Down` (`^[[1;2A/B`) → `atuin-up-search`, `Opt-Up/Down` (`^[[1;3A/B`) → `up-line-or-history`. **vi-mode block** (guarded by `VI_MODE=true` + plugin-exists): `zvm_config()` (cursor block/beam, `ZVM_TERM=xterm-256color`, `ZVM_LINE_INIT_MODE=insert`) + `zvm_after_init()` re-applying fzf/atuin/history/emacs-insert binds. Source path = `$HB/opt/zsh-vi-mode/share/...` (README-documented). `zsh -n` clean.
- `brewfile-cli` — `brew "zsh-vi-mode"`.
- `keys/keybinds.md` — new `#history` + `#vimode` sections (the latter renamed from `#vi` — "vi" substring-collides with "n**vi**m"); `#atuin` Up→S-Up row; tmux `#layout` Alt-1..5 line de-crypted.
- `docs/…/25-atuin.md` — up-arrow → Shift-Up (5 edits).
- `docs/…/28-zsh-vi-mode.md` — new catalog reference (trimmed cheat-sheet → points to the guide folder).
- `docs/…/01-shell-terminal/zsh-vi-mode/` — **NEW guide folder**: `INDEX` + `01-basics`, `02-motions-and-editing`, `03-power-and-setup`, `04-configuration`, `05-configs-compared`, `06-visual-mode`, `07-surround`, `08-search-and-history`, `09-troubleshooting-faq`.
- INDEXes — `01-shell-terminal/INDEX` (row + Guides route), root `documentation/INDEX` count `01: 23→24`.

### Features Added/Removed
- **Three-tier history nav** — Up=prefix search (type `git`, walk git-* history), Shift-Up=atuin, Opt-Up=plain. Built-in zle widgets, no plugin.
- **zsh-vi-mode** — modal command-line editing behind a one-line off-switch (`VI_MODE=false` + `exec zsh`). User installed it this session.
- **9-chapter learning guide** — grounded in 8 real GitHub configs fetched via `gh api` (wookayin/linkarzu/seblyng/SeniorMars/radleylewis/XXiaoA/maxhu08/PraveenGongada). Finding: 5/8 rebind the escape key; **none set `ZVM_TERM`** (ours is more tmux-aware).

## Current State

### Working (validated)
- `zsh -n` clean throughout; vi-mode config reconciled line-by-line to the upstream README; `keys history`/`vimode`/`tmux layout` render; guide internal links resolve.
- The `Opt-Up`/`Opt-Down` history tier **survives** AeroSpace (it binds `hjkl`, not arrows).

### Known Issues
- **AeroSpace Alt-conflict — found, then RESOLVED same session.** AeroSpace's `[mode.main.binding]` bound `alt-1..9` + `alt-a..z` (workspaces) + `alt-hjkl` (focus), captured OS-level before the terminal, so tmux `Alt-1..5`, fzf `Alt-C`, word-nav `Alt-b`/`Alt-f` were dead. **Fix applied:** remapped AeroSpace's modifier to `ctrl-alt` (all main-mode `alt-*`→`ctrl-alt-*`, `alt-shift-*`→`ctrl-alt-shift-*`; `cmd-alt-*` + service/resize modes untouched; TOML validated). Docs synced: `keys` `#aerospace` + tmux `#layout`, `05-aerospace.md`, `kol-cli/01-cli-cheatsheet.md`. **Needs `aerospace reload-config`.**
- **"Muted theme"** user report — unconfirmed; likely Ghostty unfocused-dim (`unfocused-split-opacity = 0.55` / window losing focus) triggered when an `Alt-1..5` press jumped AeroSpace workspace. `alpha-blending = linear` is currently **commented** in `ghostty/config`, so not that.
- vi-mode **verify-on-boot** still pending: cursor-shape-in-tmux + zsh-autosuggestions survival.

## Next Steps
1. ~~Resolve the AeroSpace Alt conflict~~ — **done this session** (ctrl-alt remap); run `aerospace reload-config` to load it.
2. `exec zsh`; run the vi-mode verify-on-boot checklist (guide ch.9).
3. Confirm what "muted" was (focus-dim vs a real theme change).
