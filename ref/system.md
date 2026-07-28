# system — quick reference

Filter with `ref-system <tag …>` (e.g. `ref-system theme`, `ref-system raycast`, `ref-system gotcha`).

## #window-snapping #aerospace #raycast
⇧⌥⌘D          disable AeroSpace — hands every key to the focused app (aerospace bind: enable off)
⇧⌥⌘E          enable AeroSpace — Raycast script (aerospace-enable.sh; aerospace can't re-enable itself while off)
per-machine   add ~/.dotfiles/raycast/scripts once — Raycast → Extensions → Scripts → Add Directories
per-machine   hotkeys too — assign per command (⌘K → Configure) on each machine; they live in Raycast's DB, not the repo

## #theme #os #raycast
⇧⌥⌘T          Toggle Theme — OS light/dark (theme-toggle.sh, silent)
⇧⌥⌘A          Run Wake-Up Alarm Now (alarm-test.sh)
(search)      Set Theme: Day / Night · Theme Timer <delay> — Raycast search by name
engine        bin/os-mode.sh — toggle · set · -t 3h30m relative timer
alarm         bin/theme-alarm.sh — theme + Focus + Spotify + Telegram bundle (the launchd morning job)

## #theme #kol-theme #terminal
switch        kol-theme <name> — reskins ghostty · kitty · tmux · nvim-now · btop · widgets · bar
themes        gruvbox · kol-dark · solarized-osaka · linkarzu   (themes/<name>/, native files per tool)
current       ~/.config/kol-theme/current (symlink) — switch = relink + reloads
nvim          <leader>ths — Telescope theme switcher (Sin-cy's 7 schemes + gruvbox-material)

## #clipboard #capture #screenshots
save          ss-save.sh NAME DIR — clipboard image → named file (two args, NAME then DIR; default cwd, timestamped)
inbox         clip-drop.sh — clipboard image → ~/_inbox/clip_<timestamp>.png, save only (flat, no subfolders)
file it       clip-drop.sh --yazi — same save, then yazi opens hovering the file
menu          prefix C-p (tmux) — fzf capture menu: file (yazi) · drop · note… · review (clip-drop.sh --menu)
note          clip-drop.sh --note [name] — issue capture: own folder ~/_inbox/<name>/ + <name>.md (embed appended)
review        clip-drop.sh --review <name> starts/switches the CURRENT review; bare --review appends to it (.current-review pointer)
shots         ⌘⇧3/4 screenshots → ~/Screenshots (macos/defaults.sh), NOT ~/_inbox — that's clipboard-only
needs         pngpaste (brew) — both scripts; docs/scripts/08-system.md is the full writeup

## #theme #gotcha
ghostty       reload doesn't repaint existing surfaces — quit + relaunch after a switch
btop          rewrites its conf on exit — kol-theme re-asserts the pointer on every switch
glyphs        PUA powerline glyphs (E0B6/E0B4) don't survive normal file writes — inject by codepoint
nvim ports    kol-dark + linkarzu nvim halves are stand-ins (no real ports yet)
