# Session: Shift+Enter-in-tmux diagnosis (pinned) + nvim Gruvbox Material swap

**Date:** 2026-06-13
**Machine:** iMac (x86_64)
**Agent:** Grim (Opus 4.8)
**Summary:** Diagnosed why Shift+Enter submits instead of inserting a newline in Claude Code under tmux (three stacked faults; tmux layer fixed live, iTerm layer pending a test) and swapped the Neovim colorscheme TokyoNight → Gruvbox Material with the old theme archived.

## The pinned issue — Shift+Enter ≠ newline in Claude Code (under tmux + iTerm2)

User reported "added it a couple of times, doesn't stick." Three separate faults, in the order the keystroke travels:

1. **tmux was flattening the key (root cause — FIXED live).** The running tmux server had `extended-keys off` and no `xterm*:extkeys` in `terminal-features`, even though `tmux/.tmux.conf:40-41` sets both (`set -g extended-keys on` / `set -as terminal-features 'xterm*:extkeys'`). tmux options are **per-server**; this server predates the config line and never re-read it, so it kept collapsing Shift+Enter → plain CR → Claude submitted. Fixed this session with `tmux source-file ~/.tmux.conf` — live server now `extended-keys on` + `xterm*:extkeys`. **The repo config was always correct; only the stale long-lived server was wrong.**

2. **iTerm is NOT loading the tracked plist on this iMac.** `defaults read com.googlecode.iterm2 LoadPrefsFromCustomFolder` → **unset**; `PrefsCustomFolder` → unset. iTerm runs off native `~/Library/Preferences/com.googlecode.iterm2.plist`, not `~/.dotfiles/iterm`. So the Shift+Enter binding the 2026-06-10 session added to the *repo* plist (`GlobalKeyMap` key `0xd-0x20000`) **was never live** — that is the "doesn't stick" mystery: edits went into a file the live app ignores. (Contradicts the older AGENT-CONTEXT claim that the iMac loads the custom folder — drift since 2026-06-10.)

3. **Wrong escape format in the tracked binding.** The repo plist sends modifyOtherKeys form `\e[27;2;13~`. Per claude-code-guide (official terminal-config docs + the iTerm2-tmux gist), Claude Code recognizes **only the CSI-u form `\e[13;2u`**; the modifyOtherKeys form is not interpreted as a newline. Left uncorrected on purpose (see Next).

## Changes Made

### Files Modified
- `nvim/lua/grim/plugins/colorscheme.lua` — replaced the TokyoNight spec with **Gruvbox Material** (`sainnhe/gruvbox-material`; medium background, material foreground, bold+italic, `better_performance`).
- `nvim/lua/grim/core/options.lua:22` — de-tokyonight'd the `termguicolors` comment (now "for truecolor colorschemes").
- **Live tmux server only** (not a file) — `extended-keys` flipped `off`→`on` via `source-file`.

### Files Added
- `nvim/_archive/colorscheme-tokyonight.lua` — the old TokyoNight config **verbatim** (custom navy palette), parked **outside** lazy's import path (`grim.plugins`) so it never loads. Header documents restore = copy back over `colorscheme.lua`.

### Untouched on purpose
- `nvim/lua/grim/plugins/lualine.lua:8` — statusline uses its own hand-rolled blue palette, independent of the theme; still reads blue against gruvbox. Offered to retune to gruvbox tones, not done.
- The iTerm repo plist — not edited until we know whether an iTerm binding is even needed (see Next).

## Current State

### Working
- tmux now forwards extended keys on the live server (`extended-keys on`, `xterm*:extkeys`). The repo tmux config was already correct.
- nvim colorscheme files swapped + syntax-checked (`luac -p` clean on all three).

### Known Issues
- Shift+Enter fix is **not yet verified** — needs a test (below).
- iTerm on this iMac is off the tracked custom folder → **no iTerm setting is in git on this machine**; this is the real root of the recurring loss.

## Next Steps
1. **Test Shift+Enter:** restart `claude` inside this (now-reloaded) tmux session and try it. iTerm2 emits a distinct Shift+Enter natively, so with tmux now passing extended keys through, it may work with **zero** iTerm changes.
2. **If it still submits:** add the binding in iTerm GUI → Settings → **Keys → Key Bindings** → `+` → Shift+Enter → **Send Escape Sequence** → `[13;2u`. Then correct the tracked plist `0xd-0x20000` Text `[27;2;13~`→`[13;2u` so it's right whenever the custom folder is reloaded.
3. **Reconcile the iTerm custom-folder drift** (separate task): re-point iTerm at `~/.dotfiles/iterm` (Settings → General → Settings → load from custom folder, save = Manually) so iTerm settings are tracked again — this is what makes the binding actually stick across machines. Heavy (pulls repo colors/arrangement) → user's call.
4. nvim: open `nvim` so lazy installs gruvbox-material + rewrites `lazy-lock.json` (user owns git/commits).
