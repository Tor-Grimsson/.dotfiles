# Session: TUI cockpit + git category + lazygit — buildout

**Date:** 2026-07-08
**Agent:** Claude (Grim)
**Summary:** Follow-on to the docs restructure — reconciled lazygit, built the fastfetch shell-home + a new `18-tui-shell-layout` category (dashboards + bookmark system), created a `17-git` category by consolidating the git tools, and fixed a reorg miss (stale doc-paths in extensionless configs).

## Changes Made

### lazygit — reconciled (was installed but untracked)
- `brewfile-cli` += `brew "lazygit"`; **added `bind C-g`** lazygit popup to `tmux/.tmux.conf` (the user's "done" hadn't landed in the tracked config); catalog doc `documentation/04-dev-languages/15-lazygit.md` → **moved to `17-git/03-lazygit.md`** (below); git cheat card + popup docs updated.

### Reorg miss fixed
- The docs-restructure link scan only covered `*.md/*.sh/*.json`, so extensionless configs kept **stale `docs/NN-` paths**. Repointed `brewfile-cli`, `tmux/.tmux.conf`, `shell/.zshrc`, the `kol-cdn` wrappers, and one live pointer in `AGENT-CONTEXT`. Full repo re-scan clean.

### fastfetch shell-home + chafa
- New `fastfetch/` (config.jsonc + chafa-rendered `logo.txt` from a user image + `logo-source.jpeg`); symlinked `~/.config/fastfetch` + `bootstrap.sh` block; `07-fastfetch.md` rewritten. New catalog doc `01-shell-terminal/21-chafa.md` (chafa was already in the Brewfile, undocumented).

### New category `18-tui-shell-layout`
- `01-fastfetch-home.md` (the greeting playbook), `02-tmux-dashboards.md` (tmuxinator `home` + `torrent` layouts — tracked at `tmuxinator/*.yml`, symlinked; `bootstrap.sh` block), `03-bookmarks.md` (the bookmark system), + INDEX.

### New category `17-git`
- `01-git.md` (general git — commands by task, undo/reflog, stash, tags+semver+`npm version`, work-losing commands), + `02-gh`/`03-lazygit`/`04-git-worktrees` **moved from dev-languages**; `13-ponytail`→`12-ponytail` (close the gap); dev-lang intro/count fixed; all inbound `[[12-gh]]`/`[[15-lazygit]]`/`[[14-git-worktrees]]`/`[[13-ponytail]]` repointed.

### tmux popups — layouts + bookmarks
- `bind C-d` → fzf-pick a tmuxinator layout (popup-safe: `switch-client`, verified). Bookmark system: `tmux/bookmarks.txt` (paths + URLs) + `bookmark-{add,open,input}.sh`; `bind C-b` (open — URL→browser, path→nvim), `bind B` (add cwd), `bind A` (typed input popup). Documented in `03-bookmarks.md`; the `19-kol-tui-plugin` exploration marked first-cut-built.

### Parked in `plan.md`
- mpd+rmpc terminal-music setup, AeroSpace Ctrl+Alt modifier, AGENT-CONTEXT status-list trim, active→canonical status pass.

## Current State

### Working
- lazygit + both new categories + all popups built; docs conformant; every dead-link scan clean; tmux config parses on an isolated socket; tmuxinator layouts + bookmark scripts validated.

### Known Issues
- tmux binds (`C-d`/`C-b`/`B`/`A`/`C-g`) are in the tracked config but **not live until `prefix r`**.
- `mactop` (the reference monitor) is Apple-Silicon only + uninstalled — `home` layout uses `htop`; mactop is the MBP upgrade.
- `fastfetch` not yet auto-run on shell start (optional `.zshrc` line).

## Next Steps
1. `prefix r` to load the new tmux binds; commit + push (user owns git).
2. Optional: mactop on the MBP; a music panel (mpd+rmpc, parked) for the dashboards.
3. Trim the AGENT-CONTEXT status list (overdue, parked in plan.md).
