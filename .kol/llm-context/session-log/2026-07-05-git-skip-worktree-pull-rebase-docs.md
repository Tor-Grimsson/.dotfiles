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
