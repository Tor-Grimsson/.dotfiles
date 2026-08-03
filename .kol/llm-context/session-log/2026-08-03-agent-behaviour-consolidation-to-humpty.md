# Session: Agent behaviour consolidated into humpty — hooks moved, concepts specced

**Date:** 2026-08-03
**Agent:** Claude Code (Grim)
**Summary:** Every agent-behaviour hook, the statusline and 35 skills moved from `claude/` into the humpty plugin; `settings.json` lost its `hooks` key entirely. Eight adoptable patterns were **specced but not packaged** — which was the goal's actual ask and is the main thing left undone.

## Changes Made

### Files Modified — humpty (`~/dev/projects/kol-dumpty/humpty`)
- `hooks/humpty_footer.py` + `.sh` — **new**, ported from dotfiles `footer-gate.sh`; now importable and unit-tested (4/4)
- `hooks/humpty_goal.py` + `.sh` — **new**, ported from `goal-loop.sh`; `.kol` hardcode became the `HUMPTY_CTX_DIR` seam (4/4 behaviours verified)
- `hooks/humpty_rm.py` + `.sh` — **new**, ported from `rm-gate.sh` (7/7); **registered for the first time ever**
- `hooks/humpty_docsync.py` + `.sh` — **new**, ported from `doc-sync-reminder.sh`; docs root became `HUMPTY_DOCS_DIR` (2/2)
- `bin/humpty-statusline` — **new**, ported from `statusline.sh`; grant badge now names each open pipeline
- `hooks/humpty_gate.py` — gained `SUBST`: command-substitution downgrade to `ask`, the one check git-gate had and this did not
- `hooks/humpty_tokens.py` — `--kol-*` hardcode replaced by namespace discovery + `VENDOR_NS`
- `hooks/humpty_lib.py` — `ESCAPE_PATHS` off the `.kol` hardcode, bare-filename fallback added
- `hooks/humpty_activate.py` — gained the **self-install nudge** for `statusLine` (owed since `sl-ponytail/04`)
- `hooks/fixtures.sh` → `hooks/tests.sh`; banners `FIXTURES OK` → `TESTS OK`
- `hooks/hooks.json` — 10 registrations across 6 events (was 5 across 5)
- `skills/laws/SKILL.md` — 7 rules added to the level-2 inject block (never-mention-git, label-block, sentence case, doc-sync, ports, audience split, **the delete law**); 3 false "the gate enforces it" claims corrected
- `skills/` — 35 dotfiles behaviour skills **copied** in (37 total)
- `concepts/` — **new**, 8 pattern specs + README
- `docs/documentation/10-family-names/` — **new**, the three-family naming system + glossary
- `README.md` — anatomy resynced; the false "enforced modes" claim corrected

### Files Modified — dotfiles
- `claude/settings.json` — **entire `hooks` key removed**; `statusLine` repointed at humpty
- `tmux/.tmux.conf` — `prefix g` → `humpty-grant`
- `ref/humpty.md` — new `## delete` section; grant rows repointed. `ref/tmux.md` — grant rows repointed
- `docs/operations/systems/agent-system/{INDEX,08-behavior,11-grant}.md` — canon-vs-superseded verdict; 2 marked superseded
- `docs/operations/systems/{INDEX,claude-harness/INDEX}.md` — dependency-in-use table; hooks-left-the-repo note
- `_tmp/2026-08-03-agent-behaviour-to-humpty/` — 11 files quarantined + receipt

### Features Added/Removed
- Added: the statusline self-install nudge; per-pipeline grant badge; `HUMPTY_CTX_DIR` / `HUMPTY_DOCS_DIR` seams
- Removed from dotfiles: all 7 hooks (quarantined, never deleted)

## Current State

### Working
- `hooks/tests.sh` — 192 asserts, 0 failures, `TESTS OK`
- Payload token screen clean — no personal paths in skills/commands/hooks/bin/concepts/manifest
- `ref --lint` — 17 cards clean
- memory-glass verified: 6 of 6 opted-in repos correctly symlinked; README accurate

### Known Issues
- **Nothing is enforcing until a restart** — `settings.json` no longer registers the hooks and `hooks.json` is only read at plugin load
- **The 8 concepts are specs, not packages.** The goal said package; READMEs describing payload were produced instead. This is the main gap
- **Memory is missing as a concept entirely** — belongs as `concepts/09-memory`
- 35 skills live in **both** places; a plugin skill is namespaced (`/humpty:tmpl-clear`), so the rename is the user's call
- `docs/operations/systems/agent-system/12-setup-a-to-z.md` still describes the old hook wiring

## Next Steps
1. Restart the session so humpty's `hooks.json` loads and the gates are live again.
2. **Package the 8 concepts for real** — execute each strip list, `04-docs-spec` first (05 points into it).
3. Write `concepts/09-memory` — the memory pattern was never specced.
4. Rule the 35-skill namespacing question, then delete the losing copy.
5. Then the repo decision (marketplace source, what ships) — everything else is staged for it.
