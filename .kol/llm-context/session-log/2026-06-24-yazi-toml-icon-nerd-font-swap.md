# Session: yazi `.toml` missing-glyph fixed (iTerm font swap) + stale tracked iTerm plist finally re-exported

**Date:** 2026-06-24
**Agent:** Grim (Claude Opus, `~/.dotfiles`, iMac)
**Summary:** `.toml` files showed a `?`-in-box (missing glyph) in yazi because iTerm was using romkatv's older `MesloLGS NF`; swapped iTerm to the full `MesloLGS Nerd Font` v3 cask (already installed) → fixed. Then re-exported the live iTerm prefs into the tracked `iterm/com.googlecode.iterm2.plist` (the 3-session-old open thread) and patched it to the correct good state.

## Changes Made

### Files Modified
- `iterm/com.googlecode.iterm2.plist` — **re-exported** from live prefs (`defaults export`, now xml1 not binary), then hand-patched because the live domain hadn't flushed the GUI font change yet:
  - Default profile `Normal Font` → `MesloLGSNF-Regular 16` (was the old romkatv `MesloLGS-NF-Regular 16`; `MesloLGSNF` = the full v3 font's PostScript name, distinct from the old hyphenated `MesloLGS-NF`).
  - `NoSyncIgnoreSystemWindowRestoration` → `false` (export captured iTerm's reverted `true`; baked in last session's restoration fix so the snapshot is the good state). `NSQuitAlwaysKeepsWindows` was already `false`.
  - Now also carries the **coolnight** preset (the prior tracked plist predated it). Validated `plutil -lint OK`.

### Live-machine change (not repo)
- iTerm → Profiles → Text → Font set to **`MesloLGS Nerd Font`** (plain, no `Mono`/`Propo`).

## Current State

### Working
- `.toml` (and other previously-missing md-range glyphs) render in yazi — verified live by the user.
- Tracked iTerm plist is no longer stale: carries the new font, coolnight, and the restoration fix.

### Findings / gotchas
- Two Meslo families installed: **`MesloLGS NF`** (romkatv p10k patch, pre-v3 — lacks the Material Design icon block yazi 26 maps `.toml` to) vs the full **`MesloLGS Nerd Font`** (brew `font-meslo-lg-nerd-font` v3, complete set). Picked the plain `MesloLGS Nerd Font` to match the old NF's double-width icon behavior.
- yazi needs **no** icon config: `yazi/theme.toml` is colors-only → yazi uses its compiled-in default icon ruleset (already covers `.toml`). The gap was purely the font.
- **iTerm holds prefs in memory and only writes them on quit.** Right after a GUI change, `defaults read`/`defaults export` still return the *old* value — that's why the first export grabbed the stale font and a reverted restoration flag. The repo plist was hand-patched to the value iTerm will itself write on next Cmd-Q (`MesloLGSNF-Regular 16`), so they'll match.

## Next Steps
1. **MBP:** apply the same iTerm font swap (`MesloLGS NF` → `MesloLGS Nerd Font`).
2. After the next iTerm **Cmd-Q**, the live on-disk prefs catch up to the repo value (already pre-matched); no further export needed unless other iTerm settings change.
