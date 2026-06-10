# Session: oh-my-posh migration + iTerm theme preview + shell vi-mode

**Date:** 2026-06-10
**Agent:** Claude Code (Grim), MBP
**Summary:** Switched the prompt from powerlevel10k to oh-my-posh (night-owl, p10k kept as fallback), bulk-imported iTerm color presets for previewing, and turned on shell vi-mode with a cursor-shape indicator.

## Changes Made
- **Prompt → oh-my-posh** — `shell/oh-my-posh/night-owl.omp.json` vendored (tracked); `Brewfile` += `oh-my-posh` (powerlevel10k retained as fallback); `shell/.zshrc` prompt block now picks **oh-my-posh + night-owl when installed, else p10k**, and the p10k instant-prompt block is suppressed when oh-my-posh is present. **oh-my-posh 29.15.1 installed via `brew install`** — agent ran it at the user's explicit instruction (deliberate one-off exception to the no-provisioning contract). Init + night-owl render verified.
- **Shell vi-mode** — `shell/.zshrc` end block: `bindkey -v`, `KEYTIMEOUT=1`, emacs line-nav preserved in insert mode (`^A`/`^E`/`^K`/`^U`/`^W`/`^?`), fzf `^R` re-bound in both vi keymaps, cursor-shape mode indicator via `add-zle-hook-widget` (block=normal, beam=insert). `zsh -n` clean.
- **iTerm color presets (live plist only, NOT saved/committed)** — imported for previewing: Gruvbox ×7, Catppuccin ×4 (Mocha/Macchiato/Frappé/Latte), TokyoNight ×5, Rose Pine ×3 (Main/Moon/Dawn), Dracula(+), Nord ×3. Files in `~/Downloads`. Palette-inheritance model confirmed: iTerm owns the 16 ANSI slots; p10k/tmux/bat inherit. No preset chosen yet.
- **Memory** — saved `verify-state-before-handoff` (check installed/done state before telling the user to run/install).

## Current State
- New shell → **oh-my-posh + night-owl** (installed, verified) + **vi-mode** with cursor indicator. p10k still present as the guarded fallback. Current/old shells stay on p10k until `exec zsh`.
- iTerm presets imported but **live-only (uncommitted)** — iTerm prefs are manual-save; the profile keeps its prior colors until a preset is picked and saved.
- dust + yt-dlp confirmed installed (user ran `brew bundle`); au-transcribe proven on a real TikTok (prior log).

## Known Issues / caveats
- **night-owl hardcodes hex** → the prompt won't track the iTerm theme (deliberate; flagged to user).
- Stray **"Gruvbox Dark (2)"** duplicate + ~20 un-chosen presets in the iTerm plist to clean once a theme is picked.
- **oh-my-posh catalog doc NOT written and p10k NOT removed** — deferred until the user confirms keeping oh-my-posh (no doc churn on a trial).

## Next Steps
1. Pick a final iTerm preset → **iTerm Settings → General → Save Current Settings to Folder** → commit (manual-save mode, or it won't persist).
2. Decide on oh-my-posh: **keep** → write its catalog doc (cat 01-shell-terminal) + rip out p10k (Brewfile line, `shell/.p10k.zsh`, the fallback + instant-prompt blocks); **drop** → `brew uninstall oh-my-posh` + revert the `.zshrc`/`Brewfile` edits.
3. Clean the unused iTerm presets + the `Gruvbox Dark (2)` dup.
4. Deferred: **zsh-XDG relocation** (`~/.zshenv` + `ZDOTDIR` → `~/.config/zsh`) — its own focused session. History **substring-search** declined (fzf `^R` + autosuggestions already cover history).
