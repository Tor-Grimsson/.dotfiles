# Session: Brewfile split + tmux session/project tooling + bookmark-sidebar exploration

**Date:** 2026-07-04
**Agent:** Claude (Sonnet 5)
**Summary:** Split the unified Brewfile into CLI-only vs GUI-only manifests (triggered by an SSH-into-a-foreign-Mac need), then used the CLI-only file as the entry point for a wave of tmux session/project-management tooling — six tools evaluated, three kept plus two more added later, TPM adopted for the first time. Closed with a scoped-but-unbuilt design exploration for a bookmark/worktree sidebar.

## Changes Made

### Files Modified
- `Brewfile` **deleted** → split into `brewfile-cli` (formulas only, safe to run standalone on a foreign/SSH box) + `brewfile-gui` (casks + VS Code extensions, daily-driver only). `bootstrap.sh` now runs `brew bundle` against both.
- `brewfile-cli` — dropped `supabase` (unused); `pdf2image` note moved from a stray comment to the same `uv-tool-managed` convention as `llm`; added `sesh`, `tmuxinator`, `tmuxp`, and `raine/workmux/workmux` (+ its tap).
- `tmux/.tmux.conf` — new **section 5** (session/project managers): TPM (`tmux-plugins/tpm`) adopted for the first time (previously deliberately plugin-free — reversed this session), running `tmux-sessionx` (`prefix O`), `tmux-harpoon` (own key table `prefix a` → `1`-`4`/`a`/`e`), and `tmux-agent-sidebar` (`prefix e`/`E`). Section renumbered 5→6 for the existing vim-tmux-navigator block (must stay last so its `Ctrl-h/j/k/l` wins over any plugin default).
- `bootstrap.sh` — clones TPM + runs its non-interactive `install_plugins` (closes the "still need `prefix I` by hand" gap).
- `aerospace/aerospace.toml` — Claude desktop (`com.anthropic.claudefordesktop`) added to the always-floating list.
- `docs/01-shell-terminal/`: new `17-sesh.md`, `18-tmuxinator.md`, `19-tmuxp.md`, `20-tmux-sessionx.md`, `22-tmux-harpoon.md`, `23-stdin-pipes.md`, `24-workmux.md`, `25-tmux-agent-sidebar.md`. `21-tmux-tea.md` created then deleted (dropped after evaluation — see below). Numbering left gapped at 19/21 rather than renumbering everything.
- `docs/01-shell-terminal/02-tmux.md`, `docs/01-shell-terminal/INDEX.md`, `docs/00-kol-cli/01-cli-cheatsheet.md`, `docs/INDEX.md`, `docs/09-productivity-desktop/05-aerospace.md`, `LLM_RULES.md` — updated for the Brewfile split, the new tools, and (twice) stale headline tool counts that had drifted from the category-row sum (root catalog now **85 tools / 14 categories**, was 82).
- `docs/19-kol-tui-plugin/INDEX.md` — **new**, plus a new root `## Explorations` section in `docs/INDEX.md` to route it (design surveys not yet built, not counted toward the tool total).
- `.kol/llm-context/AGENT-CONTEXT.md` — Repo-layout table's `Brewfile` row and tool count fixed to match this session's reality.

### Features Added/Removed
- **Added:** `sesh`, `tmuxinator`, `tmuxp`, `tmux-sessionx`, `tmux-harpoon`, `workmux`, `tmux-agent-sidebar`. TPM adopted.
- **Evaluated and dropped:** `tmux-tea` (lost the sesh/sessionx/tea three-way; sesh vs sessionx is still open, user's call to make).
- **Evaluated, dropped, then restored:** `tmuxp` — initially dropped when `tmuxinator` "won," reinstated the same day once the user clarified they needed `tmuxp freeze` (snapshot an already-running layout) — `tmuxinator` has no equivalent. Kept side by side on purpose now, not a winner/loser pair.

## Current State

### Working
- Brewfile split live and installing cleanly (`sesh`/`tmuxinator` confirmed installed; `workmux` install command handed to the user, not yet confirmed run).
- TPM live, `tmux-sessionx` + `tmux-harpoon` confirmed installed and working (`prefix O`, `prefix a`→`1`-`4`/`a`/`e` all user-tested). `tmux-agent-sidebar` wired but not yet confirmed installed/tested by the user.
- AeroSpace floating rule for Claude confirmed reloaded.

### Known Issues
- **`tmux-harpoon` key-binding took three iterations** before landing — worth the next agent knowing the failure modes, not just the final answer: (1) `Alt` (`M-1`..`M-4`/`M-a`/`M-e`) — silently dead, AeroSpace claims every Alt+letter/digit globally for workspace switching and intercepts before tmux ever sees it. (2) `Ctrl+Shift` (`C-S-*`) — also dead, confirmed live: this iTerm2 doesn't report Shift on Ctrl-letter combos, so `Ctrl+Shift+A` arrives at tmux as plain `Ctrl+A` (the prefix itself), silently entering prefix-wait. (3) **Landed on its own key table** (`bind a switch-client -T harpoon`, matching the modal pattern `aerospace.toml`'s `mode.resize`/`mode.service` already use) — this is what's actually live now, fully inside tmux's own prefix system, no terminal/OS-modifier dependency.
- `workmux` ships its **own** `workmux sidebar` command that overlaps with `tmux-agent-sidebar`'s job (both show agent status) — flagged in both docs, not resolved; worth comparing once both are in daily use.
- `tmux-agent-sidebar` needs Claude Code registered via its own `/plugin` command before it'll show anything for Claude sessions specifically — not yet done.

## Next Steps
1. User runs `workmux` install + confirms `tmux-agent-sidebar` (`prefix e`/`E`) actually shows agent status once Claude Code is registered with it.
2. Decide `sesh` vs `tmux-sessionx` (user's own head-to-head, no urgency).
3. `docs/19-kol-tui-plugin/INDEX.md` is an unbuilt design survey (AeroSpace-floating-window vs. fixed-tmux-pane as the sidebar's layer; OSC-8/iTerm2-command-URLs vs. existing yazi bookmark plugins — `yamb.yazi` etc. — vs. a custom tmux plugin) — revisit only if it comes up again, explicitly not scheduled work.
