# Session: iTerm session-restoration garbage root-caused + fixed (live-machine only)

**Date:** 2026-06-24
**Agent:** Grim (Claude Opus, `~/.dotfiles`, iMac)
**Summary:** The recurring "Session Contents Restored" / overlapping-replayed-panes garbage on every iTerm launch was finally root-caused to `NoSyncIgnoreSystemWindowRestoration = 1` (not NSQuitAlwaysKeepsWindows, not the macOS Saved Application State dir, not tmux) and fixed. **No repo files changed.**

## Changes Made

### Files Modified
- None tracked. All actions were on live machine state (`defaults` + `~/Library/...`).

### Live-machine actions (all `defaults`, iTerm closed during the writes)
- `defaults write com.googlecode.iterm2 NoSyncIgnoreSystemWindowRestoration -bool false` — **the actual fix.** This key was `1`, meaning iTerm *overrode* its own "Use System Window Restoration Setting" dropdown and replayed its session cache regardless of the system flag. Set to `0` → iTerm respects the system setting (which is "don't restore").
- `defaults write com.googlecode.iterm2 NSQuitAlwaysKeepsWindows -bool false` + `defaults write -g NSQuitAlwaysKeepsWindows -bool false` — opt iTerm out of macOS window restoration in both its own domain and global. (Did *not* fix it alone — the IgnoreSystemWindowRestoration override was bypassing it.)
- `defaults write com.apple.loginwindow TALLogoutSavesState -bool false` — disables "reopen windows on login" so a future *Mac* reboot won't force-restore. Belt only — **not the cause** (user confirmed they did NOT restart the iMac; it was a plain iTerm quit/relaunch).
- `rm -f ~/Library/Application Support/iTerm2/SavedState/restorable-state.sqlite{,-shm,-wal}` + `lock` — deleted the 1.2 MB session-content cache that was being replayed.

## Current State

### Working
- **iTerm launches clean** — verified live: user reopened iTerm, no restored garbage, window landed at `~` (the prior log's "lands in `kol-labs-single` not `~`" working-dir gripe also resolved).
- All four restoration flags read `0`; SavedState dir empty.

### Known Issues / Findings
- **Prior diagnosis was wrong twice.** The 2026-06-24 (2) log blamed macOS `NSQuitAlwaysKeepsWindows=1` + armed a detached watcher. The watcher never worked: it cleared the macOS *Saved Application State* dir (empty for iTerm) and flipped only the *global* flag, which iTerm ignored because `NoSyncIgnoreSystemWindowRestoration=1` made it restore from its own `Application Support/iTerm2/SavedState/restorable-state.sqlite` unconditionally. That sqlite — not the macOS dir — was the source.
- **Self-perpetuating loop:** each launch restored the old scrollback, each quit re-saved it, so the garbage survived every "restart." Deleting the sqlite while iTerm was closed + disabling the override broke the chain.
- **External-settings box stays OFF (deliberate).** Settings→Settings→"Load settings from a custom folder or URL" is unchecked/empty. Enabling it now would load the **stale** tracked `iterm/com.googlecode.iterm2.plist` (predates coolnight + this fix) over the good live prefs. Correct order: export live→repo first, *then* optionally point it at `~/.dotfiles/iterm` with Save-changes=Manually.
- These `defaults` are live/runtime state, not repo-tracked (ARCHITECTURE §N).

## Next Steps
1. **Reconcile the stale tracked iTerm plist** (carried over from the prior log): re-export live `~/Library/Preferences/com.googlecode.iterm2.plist` → repo `iterm/com.googlecode.iterm2.plist` so it carries coolnight + the restoration fix. Until then the repo plist is stale.
2. If the MBP ever shows the same restoration garbage, apply the identical one-liner: `defaults write com.googlecode.iterm2 NoSyncIgnoreSystemWindowRestoration -bool false` + clear the SavedState sqlite.
