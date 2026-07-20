---
title: Troubleshooting & FAQ
type: guide
status: active
updated: 2026-07-09
description: The papercuts of command-line vi-mode and how to fix them — escape lag, cursor not changing in tmux, lost keybindings, autosuggestions breaking, plus how to debug a keybind with cat -v. Grounded in the real-config survey.
tags:
  - domain/shell
related:
  - "[[INDEX|zsh vi-mode — complete guide]]"
  - "[[04-configuration|Configuration reference]]"
  - "[[05-configs-compared|Real configs compared]]"
---

# Troubleshooting & FAQ

The known rough edges, each with the fix. Most trace back to one of three things: the terminal not passing a sequence, the plugin re-initializing after your binds, or an option left on its default.

## Escape feels laggy

**Symptom:** a beat of delay after pressing `Esc` before the cursor turns to a block.

**Why:** the NEX readkey engine waits `ZVM_ESCAPE_KEYTIMEOUT` (default `0.03`s) after Esc to tell a standalone Esc from the start of an escape sequence.

**Fixes, in order:**

```zsh
# in zvm_config()
ZVM_ESCAPE_KEYTIMEOUT=0.01                 # tighten the wait (seblyng/dotfiles uses 0.00)
# or, if it still feels off, revert to zsh's native engine:
ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_ZLE # what SeniorMars/dotfiles runs
```

Also confirm tmux isn't adding its own delay — `escape-time 10` is already set in your `tmux.conf` (`:25`), which is the other half of this.

## Cursor doesn't change shape

**Symptom:** same cursor in insert and normal mode.

**Checks:**
1. `ZVM_CURSOR_STYLE_ENABLED=true` (it is, in our `zvm_config`).
2. **Inside tmux?** tmux must forward the cursor-shape (DECSCUSR) escape. We set `ZVM_TERM=xterm-256color` to emit the right sequence; if it still doesn't change, add to `tmux/.tmux.conf`:
   ```tmux
   set -ga terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[ q'
   ```
   then `tmux kill-server` (or reload) and reopen.
3. Some terminals need the term type hinted — linkarzu's config notes wezterm needed `$TERM` massaging; ours targets tmux+Ghostty.

Even with no cursor change, every prompt starts in insert and p10k shows the mode, so you're never blind.

## A keybinding stopped working (Ctrl-R, atuin, Up)

**Symptom:** after enabling vi-mode, fzf `Ctrl-R` / atuin `Ctrl-P` / the `Up` history tiers do nothing.

**Why:** zsh-vi-mode rebuilds the keymaps at the first prompt, wiping binds set earlier in `.zshrc`. This is the single most common zsh-vi-mode issue.

**Fix:** those binds must be re-applied in `zvm_after_init` — which our config does. If you *add* a new insert-mode bind, put it there too, not at the top level. Normal-mode binds go in `zvm_after_lazy_keybindings` instead. See [[04-configuration|configuration]].

## zsh-autosuggestions grey text disappeared

**Symptom:** the fish-style grey suggestion stops showing once vi-mode is on.

**Why:** load-order / re-init interaction — the autosuggestion widget wrapping can get clobbered by the keymap reset.

**Fixes:**
1. Confirm `zsh-syntax-highlighting` is still sourced **last** and `zsh-autosuggestions` **before** the vi-mode block (our order).
2. If it's still missing, force a rebind by adding to `zvm_after_init`:
   ```zsh
   ZSH_AUTOSUGGEST_MANUAL_REBIND=1   # set before autosuggestions is sourced
   ```
   or re-source autosuggestions inside `zvm_after_init`.

## `jk` / `kj` escape inserts literal letters

**Symptom:** you enabled `ZVM_VI_INSERT_ESCAPE_BINDKEY=jk` but typing a word with "jk" in it (rare) pauses or misfires.

**Why:** the plugin waits `ZVM_KEYTIMEOUT` for the second key. That's inherent to any two-key escape.

**Fix:** lower `ZVM_KEYTIMEOUT`, or pick a rarer digraph (`jk`/`kj` are chosen precisely because they almost never occur in real words). Or keep real `Esc`.

## How to debug any key — `cat -v`

When a modified key (Shift+Up, Alt+something) does nothing, find out what your terminal actually sends:

```sh
cat -v      # then press the key; Ctrl-C to quit
```

It prints the raw sequence (e.g. `^[[1;2A` for Shift+Up). Bind *that* exact sequence. This is how the Shift/Opt history tiers were wired, and it's what linkarzu's config documents for finding `Alt-t` = `^[t`.

## FAQ

**Q: Does this change how scripts run?**
No — vi-mode only affects interactive command-line editing. Scripts, `source`, and non-interactive shells are untouched.

**Q: Can I use it and emacs keys?**
Yes — `Ctrl-A/E/K`, `Alt-b/f`, `Alt-⌫` are kept in insert mode on purpose ([[01-basics|chapter 1]]). You get vim in normal mode and emacs conveniences while typing.

**Q: Will `.` (repeat) and `u` (undo) survive a reconnect?**
They're per-command-line editing state, not persistent history — undo resets each new prompt, same as vim's per-buffer undo.

**Q: How do I turn it off for good?**
`VI_MODE=false` in `.zshrc` + `exec zsh`. To remove entirely: also `brew uninstall zsh-vi-mode` and delete the block. See [[01-basics|the off-switch]].

**Q: Does it work over SSH / inside tmux / in nvim's `:terminal`?**
tmux — yes (configured). SSH — yes, it's shell-side. nvim `:terminal` — yes, though you now have vim-in-vim; `Esc` goes to the shell's vi-mode first.
