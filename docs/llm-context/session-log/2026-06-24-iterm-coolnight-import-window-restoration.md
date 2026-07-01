# Session: iTerm coolnight import + window-restoration diagnosis (live-machine only)

**Date:** 2026-06-24
**Agent:** Grim (Claude Opus, `~/.dotfiles`, iMac)
**Summary:** The prior session's coolnight got reproduced on the live iTerm (re-imported, user selected it), and the "garbled buffer on launch" was traced to iTerm window restoration — not tmux. **No repo files changed.**

## Changes Made

### Files Modified
- None tracked. All actions were on live machine state (`~/Library/...`).

### Live-machine actions
- **coolnight re-imported** — `open iterm/coolnight.itermcolors` → iTerm imported it as a Custom Color Preset; user selected **coolnight** in Profiles → Default → Colors. Now live.
- **Detached watcher armed** (scratchpad, not in repo) — `nohup setsid` script polls until iTerm quits, then `NSQuitAlwaysKeepsWindows -bool false` + `rm -rf` the iTerm `SavedState` / `Saved Application State` dirs + relaunches iTerm clean. Pending the user's Cmd-Q.

## Current State

### Working
- coolnight applied to the Default profile (was showing TokyoNight Night, a different theme).

### Known Issues / Findings
- **Prior log's claim was wrong.** 2026-06-24 (coolnight) said coolnight was "applied to the Default profile + registered as a preset in the iTerm plist." It wasn't, in the *live* prefs — iTerm overwrote that plistlib edit when it quit (live plist rewritten 04:49, after the 04:07 theme file). Only the repo `iterm/coolnight.itermcolors` survived. **Lesson: editing the iTerm plist while iTerm runs gets clobbered on quit — import via the app, or write with iTerm closed.**
- **The launch garbage is iTerm restoration, not tmux.** Confirmed no tmux auto-start in `shell/.zshrc`, no resurrect/continuum, no `~/.tmux/plugins`, no saved tmux state. The "Session Contents Restored" banner + replayed panes = iTerm replaying its 1.1 MB `SavedState` because macOS `NSQuitAlwaysKeepsWindows=1` (global).
- **Lands in `kol-labs-single`, not `~`** because the Default profile's Working Directory = `Recycle` ("Reuse previous session's directory"). Set it to **Home Directory** to always open at `~`.
- **Live plist diverged from the repo.** iTerm reads `~/Library/Preferences/com.googlecode.iterm2.plist` (`PrefsCustomFolder` empty — the custom-folder setup from an earlier session is not active). The tracked `iterm/com.googlecode.iterm2.plist` is stale relative to live. Repo-vs-live reconcile is outstanding.

## Next Steps
1. **User:** Cmd-Q iTerm — the armed watcher disables restoration, clears saved state, relaunches clean at `~`.
2. **User (optional):** set Default profile → General → Working Directory → **Home Directory** if it still doesn't land at `~`.
3. Reconcile the diverged iTerm plist: re-export live → repo `iterm/com.googlecode.iterm2.plist` (with coolnight now in it), or re-establish the custom-prefs-folder pointing at the repo. Until then the tracked plist won't carry coolnight or the restoration fix.
