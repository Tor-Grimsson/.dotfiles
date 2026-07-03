# 2026-06-14 (iMac) — tmux prefix Ctrl-b → Ctrl-a

Switched the tmux prefix from the default `Ctrl-b` to `Ctrl-a` (closer to the home row) in `tmux/.tmux.conf`. Added the literal-passthrough binding so the shell's "jump to start of line" isn't lost.

## Done
- `tmux/.tmux.conf` — `set -g prefix C-a` + `unbind C-b` + `bind C-a send-prefix` (double-tap `Ctrl-a Ctrl-a` sends a literal Ctrl-a to the shell). Section-2 comment rewritten to match; header reload line now says `prefix = Ctrl-a`.

## Trade-off (noted in the file)
- Ctrl-a is the shell's start-of-line — now claimed by tmux. Recovered via the double-tap. If it grates, revert is a three-line removal.

## Next / open
- **Docs still say "prefix is Ctrl-b"** — `02-tmux.md`, `09-tmux-tips.md`, `10-tmux-help.md`. Left as-is pending the user living with Ctrl-a; flip them (or revert the config) once decided.
- Make it live: `Ctrl-b r` once (old prefix) to reload; prefix is `Ctrl-a` after.
- (User owns git — commit + dot-sync carries it to the MBP, where it also needs a reload.)
