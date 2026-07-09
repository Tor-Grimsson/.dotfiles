# Session: p10k → starship switch + Catppuccin Mocha sweep + Shift+Enter fix

**Date:** 2026-07-09
**Agent:** Claude (Grim)
**Summary:** Chased a "prompt looks weak" thread through two p10k reskins, then abandoned p10k for **starship** (ported from ericmckevitt's dotfiles); swept yazi + tmux onto Catppuccin Mocha; darkened + heavily expanded the Ghostty config (font-size + Sin-cy's settings block); and fixed Shift+Enter in Claude Code under tmux.

## Changes Made

### Prompt: p10k reskin → abandoned → starship
- `shell/.p10k.zsh` — two reskins (dark-text-on-pastel, then deep-Latte-bg + light-text). Both read weak; user pointed at ericmckevitt's starship as the target. **File kept in repo for revert but no longer sourced.**
- `starship/starship.toml` — **NEW**, ported verbatim from [ericmckevitt/Dotfiles](https://github.com/ericmckevitt/Dotfiles) (Catppuccin Mocha gradient ribbon: os→user→dir→git→langs→docker→clock). Fixed one upstream typo (`fg:creen`→`green`).
- `shell/.zshrc` — ripped out p10k (instant-prompt block + both source blocks), added `command -v starship >/dev/null && eval "$(starship init zsh)"` as the last prompt line; `ZSH_THEME` comment updated. `zsh -n` clean.
- `brewfile-cli` — `powerlevel10k` → `starship`.
- `bootstrap.sh` — new starship symlink block (after ghostty). **Hand-linked live on the iMac** (`~/.config/starship.toml` → repo); `starship prompt` renders the full ribbon.
- Docs: `27-starship.md` **NEW**; `03-powerlevel10k.md` → `status: archived` + replaced-by banner; `01-shell-terminal/INDEX.md` (starship row + p10k marked replaced); root `documentation/INDEX.md` (cat 01 desc p10k→starship, count stays 23 — a swap).

### Catppuccin Mocha sweep
- `yazi/theme.toml` — flavor `gruvbox-dark` → `catppuccin-mocha` (was already vendored). Doc `02-file-management/02-yazi.md` synced (3 stale "no flavor / coolnight" spots corrected — doc had been wrong even before).
- `tmux/.tmux.conf` — `window-status-current-style` `#c8bca0` (pale khaki) → `#cdd6f4` (Mocha light text).

### Ghostty
- `ghostty/config` — `background = #181825` (darker base to match nvim, also gives yazi its darker bg since yazi has no base knob); `font-size = 16` (was unset → default 13, felt small); then merged Sin-cy's pasted block: `background-opacity = 0.88` + `background-blur-radius = 25`, `font-feature = -liga,-calt,-dlig`, block cursor (no blink, cell colours), `unfocused-split-opacity = 0.55` + `split-divider-color = #585b70` (swapped from pasted Rosé Pine `#524f67`), `macos-titlebar-style = hidden`, `confirm-close-surface = false`, `window-decoration = auto`, `window-padding-y` 8→10, `auto-update = check`/`stable`. Deduped the keys already present.
- Doc `26-ghostty.md` synced throughout (bg, font row, full settings table, shift+enter row corrected).

### Shift+Enter fix (Claude Code under tmux)
- `ghostty/config` — **removed** `keybind = shift+enter=text:\n`. Per Claude Code's terminal-config docs Ghostty handles Shift+Enter natively; the raw-newline override *breaks* it under tmux (tmux can't forward a raw `\n` as a distinct key).
- `tmux/.tmux.conf` — `set -g extended-keys on` → `set -s extended-keys on`. It's a **server** option; with `-g` it never applied, so tmux flattened Shift+Enter to Enter (the bug). `allow-passthrough on` + extkeys were already present.

## Current State

### Working (validated)
- starship renders the Mocha ribbon (`starship prompt`), symlink live, `zsh -n` clean.
- Ghostty config parses with **no errors** (`ghostty +show-config`), all new keys resolve.

### Known Issues / needs reload
- Nothing is live until reloaded: `exec zsh` (prompt), `Cmd+Shift+,` (Ghostty), `tmux source-file ~/.tmux.conf` (extended-keys), then **restart Claude Code** so it re-runs the key handshake for Shift+Enter.
- `shell/.p10k.zsh` is now dead code (kept only to revert).
- `background-opacity = 0.88` makes the window translucent — set `1.0` if it hurts readability.

## Next Steps
1. After reloads, confirm Shift+Enter inserts a newline in Claude Code (the whole point).
2. Look at ericmckevitt's `rmpc-config` repo — same music player the user runs.
3. Eventually delete `shell/.p10k.zsh` once starship is confirmed keeper; optionally `brew uninstall powerlevel10k`.
4. Still open from prior: cava visualiser, Torrent guide (`plan.md`).
