# Session: `docs/research/` folder + audience rule in reinforce hooks

**Date:** 2026-07-11
**Agent:** Grim (Opus 4.8)
**Summary:** Created `docs/research/` as a 4th named vault sibling for study/reference material, migrated the ricing/nvim/TUI study material out of `plan.md` into it, and baked the `.kol/` vs `docs/` **audience rule** into the reinforce hooks. This was an unlogged early-morning session (04:24–04:30) that a tmux disconnect dropped before `/log-work` ran — reconstructed from file mtimes and logged retroactively.

## Changes Made

### Files Added — `docs/research/`
- `docs/research/INDEX.md` — the sibling index. Frames `research/` as **things being read/worked through**, distinct from `explorations/` (design surveys for unbuilt things) and `documentation/` (finished per-tool reference).
- `docs/research/ricing-2025-backlog.md` — macOS ricing 2025 wishlist (btop, simple-bar, skitty-notes, colorscheme selector, tmux plugins; linkarzu + Sin-cy rigs). **Migrated out of `plan.md`.**
- `docs/research/nvim-from-scratch-study.md` — study tracker for building an nvim config from scratch.
- `docs/research/awesome-tuis.md` — curated TUI-tools list to browse/pick from.

### Files Modified
- `.kol/llm-context/plan.md` — the "macOS ricing 2025" parking-lot entry trimmed to a one-line pointer at `docs/research/ricing-2025-backlog.md` (content moved to the user-facing vault; `.kol/` is agent-only).
- `docs/INDEX.md` — added `research` as the 4th named sibling (row + description + `related`); `updated: 2026-07-11`.
- `claude/hooks/reinforce-full.txt` + `reinforce-compact.txt` — added the **AUDIENCE rule**: `.kol/` = agent-only state (ARCHITECTURE, AGENT-CONTEXT, session-log, plan, history — the agent reads these); `docs/` = the user's vault (he reads it); user-facing study/reference material goes to `docs/` (e.g. `docs/research/`), never `.kol/`.

## Design
- **Why a new sibling, not a plan.md entry.** The ricing/nvim/TUI material is stuff the *user* reads and works through — per the audience rule it belongs in the `docs/` vault, not in `.kol/llm-context/plan.md` (agent state). `research/` sits beside `explorations/` because the two are different: explorations = surveys of options for things not yet built; research = tutorials/wishlists/lists actively being consumed.
- **Rule promoted to the hooks.** The `.kol/` vs `docs/` split kept getting violated, so it moved from tribal knowledge into the reinforcement hooks that re-ground every turn.

## Current State
### Working (validated)
- `docs/research/` — 4 files, coherent, frontmatter valid, root `docs/INDEX.md` routes to it.
- `plan.md` ricing entry links the doc; no orphaned content.
- Audience rule present in both reinforce hooks.

### Recovery note
- Connection loss point was **~04:30** (last writes = the two reinforce-hook files). The session finished its edits — nothing was left half-written; only the log + AGENT-CONTEXT bump were missing. Both closed now.

## Next Steps
- **Open (this session):** finalise the `.kol/llm-context/` meta-file layout — a home/sequence for the plan file(s) and the uppercase-meta-file rename of `history.md`. Not yet specified in detail; reconstructing intent with the user.
- Possible tmux-drop root cause under discussion: running `bin/keys` (or another cat/bat-to-shell alias) over mosh/ssh — investigate whether a name-based leak filter or a control-sequence in the output tore the connection.
