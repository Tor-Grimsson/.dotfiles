# 2026-06-09 — fzf/bat/eza/fd stack + zsh plugin expansion (Brewfile + nanorc tracked)

Shell-side changes from a kol-claude session, reconciled into the repo so the MBP reproduces them. The fzf finder stack + oh-my-zsh plugins were set up live; this entry closes the Brewfile gap, tracks `.nanorc`, and **flags an unresolved plugin-source decision** (TOOLING.md:135).

## Changes (tracked, sync to MBP on next commit)
- `shell/.zshrc` (already symlinked, so already in repo):
  - `plugins=()` expanded → `git sudo brew macos extract copypath copyfile colored-man-pages dirhistory command-not-found gh web-search fzf-tab zsh-autosuggestions zsh-syntax-highlighting` (fzf-tab before the wrappers; syntax-highlighting last).
  - Fixed a **nano-hard-wrapped** fzf `--preview` line (had split across two lines → `zsh:2: permission denied`; rejoined to one line).
  - Added an fzf/bat/eza/fd config block (`FZF_DEFAULT_OPTS` dir-aware preview, `FZF_DEFAULT_COMMAND='fd …'`, `BAT_THEME`, `source <(fzf --zsh)`) + an `fzf-tab` `zstyle` preview block. No hardcoded brew prefixes (bare command names).
- `Brewfile`: new **Modern CLI core** group — `fzf fd bat eza ripgrep` (all five installed on the iMac, none were tracked).
- `shell/.nanorc`: **new tracked file** (`set nowrap`) + `bootstrap.sh` symlink line (`$HOME/.nanorc`). Stops nano inserting hard newlines into pasted config — the root cause of the preview bug above.

## Decision — RESOLVED: zsh plugins via Homebrew (closes the zsh-plugin half of TOOLING.md:135)
Chose **brew on both machines, drop the oh-my-zsh copies** — the repo's documented direction. `fzf-tab` confirmed a brew formula (1.3.0), so brew covers all three and reproduces via plain `brew bundle` (no clone step in bootstrap). Implemented this session:
- `Brewfile`: added `zsh-autosuggestions` + `fzf-tab` next to the existing `zsh-syntax-highlighting`.
- `shell/.zshrc`: removed the three from `plugins=()`; they're now `source`d from `${HOMEBREW_PREFIX:-/usr/local}/share/…` at the end of the file (fzf-tab + its `zstyle`s first, then autosuggestions, then syntax-highlighting **last**). Each guarded with `[[ -r … ]]` so a not-yet-bundled machine won't error. `zsh -n` clean. **Gotcha:** the `fzf-tab` brew formula installs its loader as `share/fzf-tab/fzf-tab.zsh` (NOT `fzf-tab.plugin.zsh` like the omz clone) — `.zshrc` sources that exact name. **Verified on the iMac:** `brew bundle` installed `fzf-tab` + `zsh-autosuggestions`; fresh shell → `bindkey '^I'` = `fzf-tab-complete`; p10k prompt renders.
- **p10k too** (same fix): `ZSH_THEME=""`; the theme is now `source`d from `${HOMEBREW_PREFIX:-/usr/local}/share/powerlevel10k/powerlevel10k.zsh-theme` directly after oh-my-zsh (brew formula already in the Brewfile). Drops the omz-theme indirection — the iMac had a `custom/themes/powerlevel10k` → `/usr/local/share/powerlevel10k` **symlink** (machine-local, not in bootstrap); the MBP a clone.
- The `~/.oh-my-zsh/custom/plugins/{fzf-tab,zsh-autosuggestions,zsh-syntax-highlighting}` clones **and** `custom/themes/powerlevel10k` are now unreferenced → to be deleted.

## Next (user-owned — agent never runs git/provisioning)
1. `brew bundle` — installs `fzf-tab` + `zsh-autosuggestions` (the CLI tools are already present). Until then those two are dormant (guards skip them); `zsh-syntax-highlighting` already works (was brew-installed).
2. `rm -rf ~/.oh-my-zsh/custom/plugins/{fzf-tab,zsh-autosuggestions,zsh-syntax-highlighting}` — drop the now-unused clones.
3. Open a **fresh terminal** (fzf-tab needs it) → verify `bindkey '^I'` = `fzf-tab-complete`.
4. `ln -sf ~/.dotfiles/shell/.nanorc ~/.nanorc` (or re-run bootstrap) for the new `.nanorc`.
5. Commit. On the MBP: `brew bundle` + `bootstrap.sh` + a fresh shell reproduces everything — no manual clones.
