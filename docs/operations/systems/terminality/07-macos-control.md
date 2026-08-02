---
title: macOS control — bypass the GUI
type: plan
status: draft
updated: 2026-07-12
description: Taking hard control over the macOS features that get in the way — osascript CLI to bypass the Apple GUI (auto-hide menubar + dock, each on its own keybind), Karabiner-Elements shortcuts, GNU Stow for symlink management, and Raycast.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|kol-terminality]]"
  - "[[04-desk-visual-layer|The desk]]"
  - "[[11-ricing-backlog#6. osascript — hide the macOS menubar|ricing backlog: osascript]]"
---

# macOS control

Stop fighting macOS's "impossible to deal with" features — script over them and bind the controls.

## osascript — bypass the GUI
The CLI door into AppleScript/JXA — it skips the Apple GUI and just calls the function. The two to own, **each mapped to its own keybind** for permanent control:

```sh
# menubar auto-hide
osascript -e 'tell application "System Events" to set autohide menu bar of dock preferences to true'
# dock auto-hide (same surface)
osascript -e 'tell application "System Events" to set autohide of dock preferences to true'
```

- This is the **best "hide menubar" solution found** (from linkarzu's SketchyBar post) — works even without SketchyBar. See [[04-desk-visual-layer|the desk]].
- Worth a real osascript primer (`man osascript`, `-e` inline, `-l JavaScript` for JXA) — the same automation surface as our `bin/qa-make.sh` Finder Quick Actions. Detail in [[11-ricing-backlog#7. osascript — learn more|the backlog]].
- **Built (2026-07-12):** `bin/menubar-toggle` (`cmd-alt-m`) — a true toggle (`set … to not …`), bound in `aerospace.toml`, carded in `ref-desk toggles`. First press = one-time Automation permission prompt.
- **`bin/dock-toggle` retired 2026-07-31.** macOS already owns **⌥⌘D** natively (`com.apple.symbolichotkeys` key **52**, *"Turn Dock Hiding On/Off"*, `enabled = 1`, params `100 · 2 · 1572864` = `d` + ⌥⌘). Binding the same chord in `aerospace.toml` meant both fired and autohide flipped twice per press — net zero, so the dock looked broken. The native chord still works; there is nothing to replace. **Check for a native shortcut before scripting a macOS toggle.**

## Karabiner-Elements
- Shortcuts worth noting (linkarzu uses it for viewing/pasting images in nvim, among others). Candidate for a Hyper key + app-specific remaps. Ties to [[03-neovim|nvim image paste]].

## GNU Stow
- Symlink management (agent-flagged; Sin-cy uses it instead of a `bootstrap.sh` symlink loop). Evaluate Stow vs our current bootstrap symlinking — cleaner per-package linking vs one more dependency. (A real architectural call — our bootstrap works; Stow is a "would this be better" not a need.)

## Raycast
- linkarzu's [Raindrop/Raycast](https://linkarzu.com/posts/macos/raindrop/) — launcher/automation surface. Evaluate as the GUI-side command palette that complements the terminal.

## Open questions
- osascript toggles as `bin/` scripts + keybinds — which keys?
- GNU Stow: migrate off bootstrap symlinks, or leave bootstrap as-is?
- Raycast: adopt, or is fzf/tmux-popups + Quick Actions already enough?
