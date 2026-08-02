# docs/ systems home · repo-map · the dump muzzle

**Date:** 2026-07-30
**Agent:** Claude Code (Grim)

Three deliverables from one goal: the docs root stopped being a dumpster, the repo estate got a map that can't silently go stale, and the research-dump failure got a named muzzle ported to the repo that owns agent behaviour.

## 1 — docs/ root cleanup

The root had drifted: `kol-agent-system`, `kol-claude-memory`, `kol-terminality` sat as top-level "siblings" because an earlier INDEX rationalised them as *"neither pure content nor pure machinery"*. That rationalisation was the bug.

- New home **`docs/operations/systems/`** — one folder per interconnected system, **plain names, no `NN-` sequencing** (deliberately sized to grow, per the user's "buy a size too large").
- Moved in: `agent-system` · `claude-memory` · `terminality` (from the root) + `claude-harness` · `docs-framework` · `cdn` (out of the numbered operations sequence — same class, same reason).
- **39 files repointed** across docs/, claude/, .kol/. Operations keeps 01/04/06/07 with number gaps left rather than churning live links.
- `docs/INDEX.md` rewritten to **three shelves** (content · machinery+systems · this-repo's-own) carrying the standing rule: **a system does not live at the root**.
- Left at root deliberately: `scripts/` (this repo's own bin/ docs) and `kol-cli/` (printable cards — flagged as possibly redundant with the ref cards now, undecided).

## 2 — repo-map system

`docs/operations/systems/repo-map/`:
- **INDEX.md** — the estate as ASCII (29 repos · 6 top-level · 2 families) plus two wiring diagrams: the code (one publisher `kol-ds-ui` → five consumers, evidence-derived from package.json) and the agent stack (dotfiles ↔ ~/.claude, the kol-dumpty trio, kol-glass as the lens). Each diagram ends in "where do I complain" routing.
- **01-repos.md** — hand-kept meaning per repo (READMEs are Vite boilerplate, worthless as a source) + a marker-delimited generated block.
- **`bin/repo-map.sh`** — read-only walk: prints the live estate, flags drift ("on disk, not in the map"), `--update` refreshes only the generated block. Bucket-pattern: structure derived, meaning authored, drift reported not overwritten.
- Two bugs caught in build: `awk -v` breaks on a multi-line value (→ sed splice), and brace-shorthand repo names hid 6 repos from the drift grep (→ longhand names; the map must be greppable by design). Final run: 29 repos, 2 families, **zero drift**.

## 3 — the dump muzzle

- `claude/skills/dump/SKILL.md` — `/dump`: the **technical** half of word soup (research printed unparsed, verdict buried under defect walls and gap tables). Distinct from `/stfu` (human-coded noise) and `st`/`stf` (length): a dump can be perfectly shaped and still fail, because the defect is synthesis.
- Ported to **`kol-dumpty/humpty/lobby/research-dump.md`** — humpty is the repo that sources agent behaviour (asked three times before it was answered plainly; that failure is itself the memory below).
- Note carried in the port: the sibling issue `text-overload.md` still sits in the untracked `kol-dumpty/lobby/`.

## Also

- `/s` → **`/r`** (rosa's alias, user correction); `/rosa` itself born earlier this session — research with tools, changes nothing.
- Memory: **`lead-first`** — the answer is the first line, never behind framing or evidence (third strike).

## Open

- `kol-dumpty/lobby/` is untracked (kol-dumpty is a plain folder, not a repo) — `text-overload.md` + `agent-grant.md` should move into humpty/jabberwocky respectively.
- `_kol-lobby` · `_kol-quick` · `kol-ds-type` · `kol-studio` are neither repos nor families — flagged in the map, undecided.
- `kol-cli/` vs the ref cards — possible redundancy, not touched.
