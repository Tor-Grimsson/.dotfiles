# 2026-06-13 (4) — ss-save.sh default dir → current directory (was ~/Desktop)

**Machine:** iMac (x86_64)
**Summary:** `ss-save.sh` now drops the clipboard image in `$PWD` when no DIR arg is given, instead of always `~/Desktop`. Docs updated to match.

## Change
- `bin/ss-save.sh:43` — `DEFAULT_DIR="$HOME/Desktop"` → `DEFAULT_DIR="$PWD"`. Arg 2 (DIR) still overrides; everything else (NAME default, `.png` auto-append, leading-`~` expansion, `mkdir -p`) unchanged. `zsh -n` clean.
- `bin/ss-save.sh` help text — the `DIR` default line + the three `~/Desktop` examples rewritten to `$PWD` / `./`.
- `docs/12-scripts/ss-save.md` — rules table (`DIR` default), the "dumps it on the Desktop" mental-model note, and the first three examples all moved to current-dir wording.

## Verified
- Syntax check passes.
- Confirmed **no Quick Action** references `ss-save` (`macos/services/` grep clean), so the cwd default is safe — Quick Actions run with cwd `/` and would have written to root, but nothing wires it that way. Terminal-only tool.
- `08-system.md` and `12-scripts/INDEX.md` mention ss-save but not the default dir → no edit needed.

## Next
- Commit `bin/ss-save.sh` + `docs/12-scripts/ss-save.md`; dot-sync carries to the MBP (user owns git).
- Still pending from session (3): commit the neovim 0.12.2 compat files (`treesitter.lua`, `nvim-treesitter-text-objects.lua`, `lazy-lock.json`).
