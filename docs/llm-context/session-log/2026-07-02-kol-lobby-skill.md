# Session: kol-lobby skill (component → design-system staging bay)

**Date:** 2026-07-02
**Agent:** Grim (Sonnet, iMac)
**Summary:** Authored a local Claude skill that stages a consumer-app UI component into a "lobby" in `kol-design-system` as a spec/brief — the info a DS agent needs to recreate the component (purpose, anatomy, variants, props, styling tokens, states, deps), NOT a raw file copy.

## Changes Made

### Files Modified
- `claude/skills/kol-lobby/SKILL.md` — **new.** The skill.
- `kol-design-system/lobby/INDEX.md` — **new** (in the DS repo, not dotfiles). Creates the intake bay + its queue table.

### Features Added
- New skill **kol-lobby** (a doer — it writes a spec, not a reference). Triggers on "lobby this", "/kol-lobby", "throw <component> to the design system", "stage for the DS".
- **Design decision (user's call):** the lobby holds a **spec the DS recreates from**, not the component's source. Consumer JSX carries app coupling (fetch/router/local state) and sometimes non-DS tokens, so the DS rebuilds clean. The spec captures exact Tailwind classes + KOL tokens (`text-fg-48`, `var(--kol-fg-08)`, …) so the look reproduces without guessing.
- **Lobby location:** `kol-design-system/lobby/` — repo-root intake bay, deliberately outside `docs/` so it does NOT ride the DS `docs/_framework` conventions (it's a work queue, not published docs). `lobby/<Name>.md` per component + `lobby/INDEX.md` queue.
- Spec shape: frontmatter (`component`, `source#L`, `date`, `status: draft→recreated→promoted`, `deps`) + sections Purpose / Anatomy / Variants / Props / Styling / States & interactions / Dependencies / Recreation notes.

## Current State

### Working
- Skill is live — appears in the available-skills list as `kol-lobby`.
- The DS lobby bay exists with its INDEX template; first `lobby/<Name>.md` will populate on first use.

### Known Issues
- **Local-authored, not from kol-system** — like `export-specs`, hand-authored in dotfiles; won't ride a kol-system re-sync. Fine for a personal workflow skill.
- Skills dir is a whole-dir symlink, so the new subdir needs **no `bootstrap.sh` edit** — live once committed + symlink present.
- Path to `kol-design-system` isn't hardcoded — the skill tells the agent to locate it as a sibling under `kol-apparat/` (portable across machines) and to ask if it can't find it.

## Next Steps
1. First real use: extract the `kol-media-admin` grid card + list row into components, then `kol-lobby` them (planned in that project's next session).
2. Commit so it syncs to the MBP (user owns git).
3. If a spec ever needs to follow the DS `docs/_framework` after promotion, that conversion happens when the DS agent builds the real component — not in the lobby.
