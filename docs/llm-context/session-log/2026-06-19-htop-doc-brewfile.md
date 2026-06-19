# Session: htop reconciled — Brewfile + beginner catalog doc

**Date:** 2026-06-19
**Agent:** Grim (Claude Opus, `~/.dotfiles`)
**Summary:** `htop` was installed but untracked (absent from the Brewfile and the catalog); added it to the Brewfile and wrote a detailed beginner-oriented catalog doc, wired into both INDEXes with reciprocal links and a tool-count bump.

## Changes Made

### Files Modified
- `Brewfile` — added `brew "htop"` in the "System & cloud" section, right after `fastfetch`.
- `docs/01-shell-terminal/11-htop.md` — **new** `reference` doc. Deliberately dummy-friendly per user request: 30-second loop → reading the meters (CPU/Mem/Swp) and process columns (RES vs VIRT, CPU%/MEM%, state) → finding CPU vs memory hoggers (`P`/`M` sort) → killing safely (SIGTERM 15 → SIGKILL 9, what not to kill, `sudo htop`, Space to multi-tag) → sort/search/filter/tree distinction → F-key cheat sheet → F2 setup → CLI flags (verified against `htop --help`, v3.5.1) → macOS gotchas → "my Mac is slow" walkthrough → why/win/future. Frontmatter mirrors `07-fastfetch` (`domain/shell`, `pattern/tui`, `integration/brew-formula`).
- `docs/01-shell-terminal/INDEX.md` — htop tool row added; `updated` → 2026-06-19.
- `docs/INDEX.md` — catalog count **71 → 72**, category 01 **8 → 9**, "What lives here" gains "process monitor"; `updated` → 2026-06-19.
- `docs/01-shell-terminal/07-fastfetch.md` + `docs/09-productivity-desktop/04-stats.md` — reciprocal `related:` links to htop (sibling-link convention; htop is the CLI counterpart to fastfetch's static banner and Stats' menu-bar gauge).

### Features Added/Removed
- No code/script changes. Catalog + manifest reconciliation only.

## Current State

### Working
- htop is installed on this machine (v3.5.1) and now documented + manifested. Doc routes from the category INDEX and root catalog; cross-links resolve both ways.
- Placed in `01-shell-terminal` (terminal-resident TUI, beside `fastfetch`/sysinfo) — there is no `08-system` category (08 is screen-capture); 09 holds the GUI monitor (Stats).

### Known Issues
- **Drift now closed:** htop was the "installed but untracked" tool flagged earlier this session. Brewfile + catalog now agree.
- The **other machine** doesn't have htop yet — it lands on the next `brew bundle` there.

## Next Steps
1. **User runs `brew bundle`** on the other machine to install htop (no-op on this one — already present).
2. Optional: hand-tune an `~/.config/htop/htoprc` (preferred meters, tree-by-default, decluttered columns) and commit it to the dotfiles so both machines open the same layout — the doc's "Future use" note.
