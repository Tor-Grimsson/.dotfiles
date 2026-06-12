# 2026-06-10 — iTerm2 Shift+Enter → newline in Claude

Added the missing iTerm2 half of the Shift+Enter-inserts-a-newline chain. The tmux side was already correct (`extended-keys on` + `extkeys` in `tmux/.tmux.conf:40-41`), but iTerm2 had no key binding, so it sent a plain CR for Shift+Enter and tmux had no distinct key to forward.

## Changes
- `iterm/com.googlecode.iterm2.plist` — added a top-level `GlobalKeyMap` with one entry: `0xd-0x20000` (Shift+Return) → Action 10 (Send Escape Sequence), Text `[27;2;13~`. That's the modifyOtherKeys CSI sequence the tmux `extkeys` line forwards and Claude reads as a newline. Global (not per-profile) so it applies in every profile. Plist lints clean.

## Next
- iTerm2 must reload prefs to pick it up — quit/reopen (it rewrites the custom-folder plist on quit if left running), then start a fresh tmux/Claude session.
- Commit so the iMac picks up the binding via dot-sync.
