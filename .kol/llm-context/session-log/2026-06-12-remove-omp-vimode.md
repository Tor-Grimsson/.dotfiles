# 2026-06-12 — Remove oh-my-posh + shell vi-mode, back to p10k/emacs

Reverted the two 2026-06-10 shell experiments: oh-my-posh (prompt) and `bindkey -v` (line editing). Prompt is unconditionally powerlevel10k again; line editing falls back to oh-my-zsh's default emacs bindings (the global `^[b`/`^[f`/`^[^?` word-nav bindings at the top of `.zshrc` were never removed and still apply).

## Changes
- `shell/.zshrc` — instant-prompt guard un-guarded; omp/p10k branch collapsed to plain p10k sourcing; `_omp_apply`/`omp-next`/`omp-set`/`omp-list` cycler deleted; entire vi-mode block (bindkey -v, viins re-binds, cursor-shape hooks) deleted. `zsh -n` clean.
- `Brewfile` — `oh-my-posh` line removed; p10k comment no longer says "fallback".
- `shell/oh-my-posh/` — deleted (all 27 vendored themes).
- `docs/01-shell-terminal/10-oh-my-posh.md` + `11-vi-mode.md` — deleted; category INDEX rows removed; reciprocal links stripped from `01-iterm2.md` and `03-powerlevel10k.md`; root `docs/INDEX.md` counts 69→68, cat 01 9→8, blurb back to "prompt (p10k)".
- `~/.cache/oh-my-posh-theme` (iMac, local) — deleted.

## Next
- User runs `brew uninstall oh-my-posh` on **both** machines (iMac + MBP). p10k is already installed on both — the prompt flips back the moment a new shell starts.
- The MBP's `~/.cache/oh-my-posh-theme` is harmless but can be deleted there too.
- Commit so dot-sync carries it to the MBP.
