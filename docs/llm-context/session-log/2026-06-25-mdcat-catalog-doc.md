# Session: mdcat catalog doc (gap closed) + two yazi diagnostics

**Date:** 2026-06-25
**Agent:** Grim (Claude Opus, `~/.dotfiles`, iMac)
**Summary:** Gave `mdcat` its own catalog doc — closing the gap flagged in the gcalcli session (mdcat was installed + the yazi `.md` previewer but had no standalone doc while `glow` did). Plus two diagnostics that changed no repo files: confirmed `$EDITOR=nvim` drives yazi's opener, and traced a "mdcat doesn't wrap" report to the wrong previewer + a stale yazi instance.

## Changes Made

### Files Modified
- `docs/01-shell-terminal/15-mdcat.md` — **new** kol-docs `reference` (cat 01, beside `08-glow` — both terminal markdown renderers). Covers render/pager + inline iTerm2 images, the piping flags (`--ansi`/`--local`/`--columns`), no-config-file note, and the yazi previewer + `M`-key role.
- `docs/01-shell-terminal/08-glow.md` — reciprocal `related: [[15-mdcat]]`; stale "wire it as the yazi previewer" line repointed to mdcat (glow stays for scripts + the "Open in glow" Quick Action).
- `docs/02-file-management/02-yazi.md` — reciprocal `related: [[../01-shell-terminal/15-mdcat]]`.
- `docs/01-shell-terminal/INDEX.md` — mdcat row.
- `docs/INDEX.md` — catalog **76 → 77**; cat 01 **11 → 12**.

## Diagnostics (no repo change)
- **`$EDITOR` / yazi opener:** `${EDITOR:-vi} %s` opens **nvim** because `shell/.zshrc:56` exports `EDITOR=nvim`. The `vi` is a fallback that only fires if `$EDITOR` is unset (then system vim at `/usr/bin/vi`, not nvim). No change needed.
- **"mdcat doesn't wrap":** the screenshot was `keymap.toml` → yazi's built-in **`code`** previewer (syntect), **not** mdcat (which only handles `.md`). `[preview] wrap = "yes"` is correctly set in the config yazi actually loads (`~/.config/yazi/yazi.toml`, no `YAZI_CONFIG_HOME` override). So the truncation = a **stale yazi process** launched before the wrap edit (yazi reads config only at startup); fix is a clean relaunch of that instance (tmux window 4 looked older than the one mdcat was tested in). mdcat itself wraps fine via `--columns <pane-width>`.

## Current State
### Working
- Catalog is internally consistent: 77 tools, cat 01 = 12 tools (13 doc files − `13-shell-functions` meta). Reciprocal links verified four ways (glow↔mdcat, yazi↔mdcat).

## Next Steps
1. **Verify (user):** clean-relaunch the stale yazi instance and confirm long code/TOML lines wrap. If they still truncate after a fresh launch, it's yazi's **unstable** ratatui-based code-wrap (open upstream issues) — revisit for a workaround then.
2. Still pending from earlier today: `brew bundle` on both machines for `gcalcli` + `mdcat`; gcalcli OAuth-client + `init` per machine.
