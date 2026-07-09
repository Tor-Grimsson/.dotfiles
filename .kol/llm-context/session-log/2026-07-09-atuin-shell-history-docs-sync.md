# Session: atuin shell-history search wired up + doc sync sweep

**Date:** 2026-07-09
**Agent:** Claude (Grim)
**Summary:** Installed and wired up atuin (SQLite-backed shell history, scoped search) to take over fzf's Ctrl-R; then swept every doc that referenced the old Ctrl-R-is-fzf reality and fixed it, including a self-caught wikilink-convention slip.

## Changes Made

### atuin setup
- `brewfile-cli` += `brew "atuin"` (Modern CLI core, beside fzf).
- `shell/.zshrc`: atuin's init (`eval "$(atuin init zsh)"`) sourced right after `source <(fzf --zsh)` — last bind wins, so atuin owns Ctrl-R; fzf keeps Ctrl-T/Alt-C. `FZF_CTRL_R_OPTS` kept as a fallback for a machine without atuin installed.
- New tracked `atuin/config.toml` (history.db/key/session stay local/untracked in `~/.local/share/atuin/`) — three deliberate settings: `update_check = false` (no startup network call), `enter_accept = true` (Enter runs immediately, Tab edits), `filter_mode_shell_up_key_binding = "directory"` (Up stays cwd-scoped while Ctrl-R stays global).
- `bootstrap.sh`: new symlink block, same single-file pattern as mpd/rmpc/gcalcli.
- **Live on the iMac:** symlinked, `atuin import auto` pulled in 1,614 history rows (verified via sqlite3), `bindkey '^R'` confirmed resolving to `atuin-search`.

### Docs synced to the new Ctrl-R reality
- New `documentation/01-shell-terminal/25-atuin.md` (full reference doc); INDEX rows bumped 21→22 in both `01-shell-terminal/INDEX.md` and the root `documentation/INDEX.md`.
- `documentation/02-file-management/12-fzf.md` — corrected its Ctrl-R claims (summary, keybindings line, Why-installed/Biggest-win), cross-linked to atuin.
- `documentation/02-file-management/INDEX.md` + `02-file-management/17-yazi-cheatsheet.md` — both still claimed fzf powered Ctrl-R; fixed (user caught this — docs were lacking after the first pass).
- `kol-cli/01-cli-cheatsheet.md` — section 4's fzf table lost the stale Ctrl-R row; added a new `### atuin` subsection nested under it (anchor-safe, no renumbering the rest of the doc) with its full key table; summary + help tables at the top updated. `kol-cli/INDEX.md` covers-column updated.
- `keys/keybinds.md` — new `## #fzf` section (Ctrl-T/Alt-C/Tab/`fe`, previously undocumented) and `## #atuin` section (Ctrl-R/Up/Ctrl-S/Enter/Tab/Ctrl-O/prefix-mode delete), both verified via `keys fzf` / `keys atuin`.
- Self-caught: my first pass linked `25-atuin.md` ↔ `12-fzf.md` with `../folder/`-relative wikilinks — every other cross-folder link in this vault is bare (`[[12-fzf|fzf]]`). Normalized both files to match.
- Stale `updated:` frontmatter dates fixed on `02-file-management/INDEX.md` and `17-yazi-cheatsheet.md` (were still 2026-06-14 despite this session's edits).

## Current State

### Working
- Ctrl-R → atuin, scoped search (global/host/session/directory), Up-arrow → directory-scoped, verified live on the iMac.
- All doc/cheat-card/keys-reference mentions of Ctrl-R now agree with reality. Swept the whole repo for stragglers — only hits left are past-tense session logs/AGENT-CONTEXT (historical, correctly untouched).

### Known issues
- None outstanding on the iMac side.

## Next Steps
1. **MBP:** `brew bundle` (installs atuin) then a bootstrap re-run (symlinks `atuin/config.toml`) — dot-sync carries the files but doesn't install/symlink.
2. Sync (`atuin register`/`login`) is opt-in and deliberately not enabled yet — revisit once the local scoped-search workflow has been lived with.
