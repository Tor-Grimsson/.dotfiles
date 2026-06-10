# 2026-06-10 — tmux config into dotfiles + tips guide

Brought the tmux config (built in a kol-claude session on the **MBP**) into the repo. tmux was already half-integrated — `brew "tmux"` in the Brewfile and a `docs/01-shell-terminal/02-tmux.md` reference doc whose "Future use" section literally described this config (`~/.tmux.conf` with mouse mode + prefix tweaks). The only missing pieces were the config file and the bootstrap symlink.

## Changes
- `tmux/.tmux.conf` — **new.** The config: `mouse on`, `base-index 1` + renumber, 50k scrollback, true-colour passthrough; `prefix |` / `prefix -` splits opening in the current folder, `h/j/k/l` nav + `H/J/K/L` resize; vi copy mode with `v`/`y` → `pbcopy` (mouse-drag copies too); a quiet two-row top status bar (faint `#I:#W#F` window list flush top-left, blank second row for breathing space above the p10k prompt). Header notes it's repo-managed.
- `bootstrap.sh` — added a guarded `# tmux` block: `[ -f "$DOT/tmux/.tmux.conf" ] && ln -sf … "$HOME/.tmux.conf"` (after the `bin` symlink, with the other home dotfiles).
- `docs/01-shell-terminal/02-tmux.md` — reference updated: corrected the in-tmux keybind list (was stock `"`/`%`/`o`; now the configured `|`/`-`/`hjkl`/`z`/`r`), replaced "Future use" with a realized **Configuration** section + a slimmed "Future use" (tpm/resurrect across reboots, deliberately not adopted). `related` += `09-tmux-tips`; `updated` 06-10.
- `docs/01-shell-terminal/09-tmux-tips.md` — **new guide.** Copy mode explained in full (enter, vi movement, `/`-`?` search, `v`/`y` select-copy to `pbcopy`, `prefix ]` paste, mouse caveat), plus pane/window/session tricks and troubleshooting. A `guide`, not a tool reference — so the root catalog tool count (8 / 64) is unchanged; routed from the category INDEX's own **Guides** line, not the tools table.
- `docs/01-shell-terminal/INDEX.md` — added a Guides line routing to `09-tmux-tips`; `updated` 06-10.
- `docs/llm-context/AGENT-CONTEXT.md` — status bullet + `tmux/` added to the repo-layout row.

## Two calls made
- **Dropped the `unbind '"'` / `unbind %` lines** (they were in the kol-claude draft). Binding `|`/`-` doesn't require unbinding the stock splits, and keeping `"`/`%` live means every tutorial the user reads still works on their setup. Net: more forgiving, costs nothing.
- **Plugin-free.** The doc's "Future use" floats tpm + `tmux-resurrect`/`continuum` (layout persistence across reboots). Left as a documented future option, not adopted — it adds a plugin-clone bootstrap step, exactly the churn we removed from the zsh plugins. Native detach/reattach already covers "survive a disconnect."

## Not a Brewfile change
`brew "tmux"` was already present. Nothing to install.

## Wiring (done this session)
`~/.tmux.conf` symlinked to `tmux/.tmux.conf` — the live config IS the repo file now.

## Next
1. Reload if a tmux session is already open: `prefix r` (new sessions pick it up automatically).
2. Commit on the MBP so the **iMac** picks up `tmux/.tmux.conf`, the bootstrap block, and the doc changes (its dot-sync daemon pulls committed work).
