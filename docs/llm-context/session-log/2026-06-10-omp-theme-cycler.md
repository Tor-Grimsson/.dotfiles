# Session: oh-my-posh theme cycler + 27 vendored themes + catalog doc

**Date:** 2026-06-10
**Agent:** Claude Code (Grim), MBP
**Summary:** Built the `omp-*` live theme cycler, vendored 27 stock oh-my-posh themes (incl. one `.yaml`), tweaked atomicBit's input row down a line, and wrote the deferred oh-my-posh catalog doc.

## Changes Made

### Files Modified
- `shell/.zshrc` — prompt block now reads the active theme from `~/.cache/oh-my-posh-theme` (default `catppuccin_macchiato.omp.json`) instead of a hardcoded config string; added the `_omp_apply`/`omp-next`/`omp-set`/`omp-list` function block. Glob is `*.omp.(json|yaml)` so the yaml theme participates; `omp-set` resolves a bare name to either extension.
- `shell/oh-my-posh/` — +25 theme files this session (1_shell, atomicBit first, then 23 more). Now **27** total. `atomicBit.omp.json:170` locally tweaked: leading text `"╰─"` → `"\n╰─"` (blank line before the input row → row drops down one line).
- `docs/01-shell-terminal/10-oh-my-posh.md` — **new** catalog doc (lookup-first shape): `omp-*` helpers, vendored theme list, the direction knobs (`newline`=up/down, `alignment`=left/right, `invert_powerline`=separator flip), the `env -i` clean-render trick.
- `docs/01-shell-terminal/INDEX.md` — +oh-my-posh row.
- `docs/01-shell-terminal/03-powerlevel10k.md` — reciprocal `related:` link to oh-my-posh.
- `docs/INDEX.md` — cat 01 **8→9**, catalog **68→69**.

### Features Added
- **`omp-next` / `omp-set <name>` / `omp-list`** — cycle/jump/list vendored oh-my-posh themes; reloads the prompt live and persists the choice across shells. Rotation = every `*.omp.{json,yaml}` in `shell/oh-my-posh/` (drop a file in → it joins, no hardcoded list).

## Current State

### Working
- Cycler verified: `zsh -n` clean, 27-theme count, alphabetical wrap, bare-name→yaml resolution, `oh-my-posh init` accepts the yaml config. atomicBit's blank-line edit confirmed via a clean `env -i` render.
- Themes + `.zshrc` + docs all tracked → commit syncs to the iMac.

### Known Issues
- `oh-my-posh print --config <x>` is **overridden by the live shell's `$POSH_THEME`** — must render with `env -i HOME=… PATH=… oh-my-posh print primary --config … --shell zsh` to test a theme in isolation.
- Rotation is 27 deep and stylistically all over the place (minimal ↔ dense multi-line) — prune to keepers once a favourite lands.

## Next Steps
1. Still open from prior session: rip out p10k once oh-my-posh is firmly the keeper (fallback block + `shell/.p10k.zsh` + Brewfile line); pick + save a final iTerm preset. (User decided **not** to prune the 27-theme rotation — keep all options; don't nag about it.)

## Handoff → iMac (read this)
The cycler arrives via git (commit on the MBP → dot-sync pull, or `git pull`). To go live on the iMac:
1. **`brew bundle`** — installs `oh-my-posh` (in the Brewfile since 2026-06-10 #6). **Heads-up:** the `.zshrc` guard auto-switches to oh-my-posh the moment it's installed → this *also flips the iMac prompt from p10k → oh-my-posh* (catppuccin_macchiato default). To stay on p10k for now, just don't install oh-my-posh — the guard falls back cleanly.
2. New shell — `.zshrc` is already symlinked on the iMac, so `omp-next`/`omp-set`/`omp-list` come for free.
3. `omp-list` → `omp-next` to cycle. Choice persists in `~/.cache/oh-my-posh-theme` (local + untracked → iMac starts at the default until a theme is picked there).

Notes: Nerd Font already present on the iMac (p10k used it) → glyphs fine. Themes load straight from `~/.dotfiles/shell/oh-my-posh/` (absolute path, no symlink to create). `atomicBit`'s blank-line tweak travels in its JSON.
