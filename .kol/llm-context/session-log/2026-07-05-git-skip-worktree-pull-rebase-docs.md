# Session: git skip-worktree behavior corrected + docs cross-referencing fixed

**Date:** 2026-07-05
**Agent:** Claude (Grim)
**Summary:** Diagnosed a real `git pull` failure on the `acyr` box (diverged history, resolved cleanly via `--rebase`), then corrected two wrong claims about `--skip-worktree` behavior with live empirical tests, and fixed broken doc cross-referencing that had made the existing skip-worktree docs hard to find.

## Changes Made

### Files Modified
- `docs/00-kol-cli/04-git-github.md` — new "sync with the remote" rows (`git diff HEAD origin/main --stat`, `log --oneline` both directions) + a `>> STOP GIT TRACKING A FILE'S LOCAL DRIFT <<` callout with the `--skip-worktree` commands, a `§7` quick-ref row, and a reciprocal `related:` link to `21-dotfiles/01-repo-model.md` (was missing — the cross-reference gap that made this hard to find in the first place)
- `docs/21-dotfiles/01-repo-model.md` — reciprocal `related:` link back to `04-git-github.md`; rewrote the skip-worktree section to drop the wrong "pull keeps flowing real updates through" framing; added a concrete "Live example — the `acyr` remote box" paragraph naming both actual flagged files (`claude/settings.json`, `nvim/lazy-lock.json`) instead of just the generic `lazy-lock.json` example
- `docs/00-kol-cli/01-cli-cheatsheet.md` — added the same highlighted skip-worktree callout (user explicitly asked for it in the cheatsheet too, highlighted)

### Corrected (verified live, not assumed — got this wrong twice before testing)
- **First wrong claim:** "skip-worktree doesn't protect a file through a pull/rebase, content updates regardless." Wrong.
- **Second wrong claim:** "skip-worktree fully protects the file — pull/rebase treats the local drift as authoritative and proceeds." Also wrong.
- **Actual tested behavior:** skip-worktree only silences `status`/`diff` *reporting*. If a pull/rebase/checkout needs to touch a file that has real local drift, git **aborts the entire operation** (`"local changes... would be overwritten by merge/checkout... Aborting"`) rather than either overwriting or silently preserving it. Verified with two from-scratch repo experiments (fast-forward pull, and rebase with an unrelated local commit) — both aborted identically with drift present, and a third test confirmed the skip-worktree flag itself survives a *successful* rebase that doesn't touch the flagged file.

### Real-world resolution (on the `acyr` box, user-driven)
- `git pull` failed with "Need to specify how to reconcile divergent branches" — the iMac had 1 local-only commit (`810ac32`, `df-005`) while origin had 4 the iMac didn't (`df-005`→`df-008`, different hash but same label — both sides independently used the same generic commit-message convention).
- `git pull --rebase` resolved it cleanly: git detected the local commit's change was already patch-equivalent to something upstream and skipped replaying it (`"skipped previously applied commit"`) — no conflict, no data loss.
- Confirmed both `claude/settings.json` and `nvim/lazy-lock.json` (the box's skip-worktree'd files) survived the rebase untouched, flags intact (`git ls-files -v | grep '^S'` before and after).
- Divergence traced to iMac-only activity — `acyr` itself never commits, only pulls and holds the two skip-worktree flags.

## Current State

### Working
- `acyr` is now fully synced with origin (`main`, no `↓/↑` divergence)
- Both skip-worktree'd files confirmed still flagged after the rebase
- Docs now correctly describe skip-worktree's actual guaranty and cross-link both directions

### Known Issues
- None outstanding — the divergence, the skip-worktree question, and the doc gap are all resolved

## Next Steps
- None outstanding from this session.

---

## Addendum (same day, later session): remote clipboard fixed, iTerm custom-folder tracking attempted and reverted after breaking live colors

**Summary:** Diagnosed and fixed the remote (`acyr`) tmux copy-to-local-clipboard workflow end to end (tmux side + the actual missing piece, an iTerm2 permission). Separately attempted to re-enable live tracking of the iTerm2 prefs plist and broke the user's live custom colors doing it — reverted, but the colors were not recovered before the user asked to stop.

### tmux-agent-sidebar popup on `prefix r` — diagnosed, not a bug
`prefix r` (config reload) also re-runs TPM (`.tmux.conf:184`), which re-runs every plugin's init script. `tmux-agent-sidebar.tmux` shows its first-time install wizard whenever it can't find its binary — that's what was popping up, not a keybinding conflict. Fixed by downloading the binary on `acyr`.

### Remote clipboard (OSC 52) — fixed, verified working
tmux's side (`set-clipboard on` + `allow-passthrough on`) was already correct. The actual blocker was **iTerm2**: "Applications in terminal may access clipboard" needs to be checked and "Allow sending of clipboard contents?" set to **Always Allow**, not "Ask Each Time" (which was silently denying with no error once a prior deny had been recorded). Fixed live, then added the one real key (`AllowClipboardAccess`) to the tracked `iterm/com.googlecode.iterm2.plist`. Docs updated: `docs/01-shell-terminal/01-iterm2.md`, `docs/22-remote-machine/02-remote-dev-workflow.md` §3, `docs/00-kol-cli/01-cli-cheatsheet.md`.

### nvim `"+y` "gap" — confirmed a non-issue
User confirmed tmux's own visual-mode copy (`prefix [`, `v`, `y`) already fully covers getting text off a remote nvim session onto the local clipboard — it never goes through nvim's `unnamedplus`/pbcopy path at all. No OSC52 clipboard provider or `vim-oscyank` needed. Doc unchanged (already recommended this workaround).

### iTerm custom-folder tracking — attempted, broke live colors, reverted
User agreed to re-enable `LoadPrefsFromCustomFolder` (off since ~2026-06-10, tracked plist stale since 2026-06-24) so future iTerm settings would sync to git, on the explicit condition that nothing visibly change. Before flipping the switch, only diffed color-preset keys and the one clipboard key — did **not** diff the active Default profile (font/colors/keybindings) against the 11-day-stale tracked file. Flipped `LoadPrefsFromCustomFolder` on; the live app loaded the stale tracked plist and **wiped the user's live custom colors**. Reverted `LoadPrefsFromCustomFolder` to `false` and deleted `PrefsCustomFolder` same session. **The custom colors were not recovered** — user asked to stop before a Time Machine recovery could be attempted. Decision: custom-folder loading stays **off**; `iterm/com.googlecode.iterm2.plist` is documented as a point-in-time export only, not a live sync (`docs/01-shell-terminal/01-iterm2.md`).

### Known Issues
- **User's custom iTerm2 colors are lost**, not recovered. No Time Machine check was performed (user stopped the session before it could happen). If revisited: check `tmutil listlocalsnapshots /` for a snapshot predating this session's edits.
- iTerm2's `PrefsCustomFolder`/`LoadPrefsFromCustomFolder` remain off — deliberate, do not re-enable without an explicit ask and a full profile diff first.

### Next Steps
1. If the user wants to pursue recovering the lost custom colors, check for a local Time Machine snapshot of `~/Library/Preferences/com.googlecode.iterm2.plist` from before this session.
2. Otherwise, none — the user asked to stop.
