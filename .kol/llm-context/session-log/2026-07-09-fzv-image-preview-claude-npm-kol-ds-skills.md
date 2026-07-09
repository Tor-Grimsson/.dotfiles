# Session: fzv image preview + claude-npm + claude-kol-ds skills

**Date:** 2026-07-09
**Agent:** Claude (Grim)
**Summary:** Added an `fzv` fzf-with-image-preview shell function (chafa, svg/png/jpg), then authored two new local skills — `claude-npm` (dependency-update checker) and `claude-kol-ds` (mandatory design-system orientation gate) — syncing the skills catalog each time.

## Changes Made

### Files Modified
- `shell/.zshrc` — new `fzv()` function beside `fe` (line ~227): fzf whose preview renders images via `chafa -f symbols` (svg/png/jpg/gif/webp/bmp), dirs → eza tree, everything else → bat. Plain `fzf` left text-only. `zsh -n` clean.
- `keys/keybinds.md` — `#fzf` section: added `fzv` row (verified via `keys fzf`).
- `docs/operations/02-claude-agents/02-skills.md` — synced twice: Utility 3→4 (`claude-npm`), Design/brand 4→5 (`claude-kol-ds`); count 36→38; header "installed set" 32→38; local-authored list += both; `updated` 2026-07-08→2026-07-09.

### Features Added/Removed
- **`fzv`** — on-demand image preview in fzf. Chose a separate command over changing default `fzf` (user wanted opt-in). chafa symbol output is plain colored text, so it survives tmux + fzf redraws where the Kitty/Sixel graphics protocols don't. All rasterizers already present (`chafa`, `resvg`, `rsvg-convert` — yazi backends).
- **`claude-npm` skill** — `/claude-npm`: detect PM from lockfile (pnpm/yarn/bun/npm) or `packageManager` field, run `outdated`, report current→wanted→latest with major bumps flagged. Read-only (never bumps/installs without OK). Covers non-zero-exit-is-normal, offline, workspace, yarn-berry-has-no-outdated caveats.
- **`claude-kol-ds` skill** — `/claude-kol-ds`: mandatory orientation gate for `~/dev/projects/kol-apparat/kol-design-system`. Forces reading `kol-theme.css` (15-`@import` cascade in `@layer components`) first, then all 20 theme+framework CSS files, then the foundations docs, then a prove-you-read-it overview table — before any edit/answer. Built against the real repo layout (verified the `@import` graph).

## Current State

### Working
- Both skills live immediately (whole-dir symlink `claude/skills` → `~/.claude/skills`; picker registered both this session — no restart needed).
- `fzv` staged in `.zshrc` (`zsh -n` clean); goes live on `exec zsh`.
- Skills catalog (`02-skills.md`) counts reconciled to 38 for this change.

### Known Issues
- `02-skills.md` internal group-sum arithmetic was already inconsistent before this session (count-check terms don't cleanly map to group headers); only bumped the terms my additions touched, didn't reconcile the whole counter.
- `claude-npm` yarn-berry path intentionally bails (no headless `outdated` equivalent).

## Next Steps
1. `exec zsh` to load `fzv`.
2. Both skills are local-authored → won't ride a kol-system re-sync (noted in the catalog's local-authored list).
3. Still open from prior sessions: SketchyBar not swept to Gruvbox; cava visualiser + Torrent guide in `plan.md`.
