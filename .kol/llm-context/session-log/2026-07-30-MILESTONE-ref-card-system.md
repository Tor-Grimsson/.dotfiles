# 🏁 Milestone: the ref-card system — from a broken keybind to a printed estate

**Date:** 2026-07-29 → 2026-07-30
**Agent:** Claude Code (Grim)
**Arc:** Opened on a ghost-cursor report and a "ref-nvim is messy" complaint; closed with 14 glow-rendered cards, a documented docs vault, a mapped repo estate, and an output-contract skill family.
**Delivered:** the reference system the user actually reaches for — plus the machinery that keeps it honest.

## What the arc produced

| tier | outcome |
|---|---|
| **cards** | **14** — tmux · nvim · git · explorer · grep · media · desk · terminal · shell · system · files · skill · humpty · repo. The `keys` card was **dissolved** into topical cards and retired entirely (command, data, folder, doc, skill — no alias, by explicit ruling) |
| **render** | bat → glow, hardened through three live failures: pager-on-alternate-screen (cat-pipe), colour stripped on pipe (`CLICOLOR_FORCE`), and glow's own config overriding `--pager=false` |
| **law** | cards are the muscle-memory surface, docs the knowledge home: row = name + command · `[e]` blocks below the table · non-command rows **evicted** to a `doc:` fold · single-word sections · spacer rows |
| **docs** | `docs/operations/systems/` born — a growing home for interconnected systems; three ex-root "siblings" moved in with three ex-numbered operations folders; 39 files repointed; the standing rule written into the router: **a system does not live at the root** |
| **estate** | `systems/repo-map/` — ASCII wiring (1 publisher → 5 consumers, evidence-derived; the agent stack), hand-kept meaning, and `repo-map.sh` walking it read-only with drift flagging + `--card` generation |
| **skills** | **17 new** — the `tmpl-` output-contract family (present · ask · human · uncanny · hl · stfu · bullet · clear · wl-100/80/60/40/10), `kolds`/`kolds-ref`, `lobby`, `rosa`/`r`, `dump`, `ref-add` |
| **scripts** | `nvim-port` (socket-addressable nvim + statusline badge) · `repo-map.sh` · `clip-drop` rebuilt (`~/_inbox` as home, repo lobby flags) |
| **config fixes** | ghostty Cmd+← vs the tmux prefix · zsh flow-control · kitty rewritten as a ghostty mirror (the font drift that made nvim look wrong) |

## Threads closed at the milestone

- **Ghost cursors** — resolved: gone after a reopen, stale editor state, no config change needed.
- **Three keybind checks** — all passed: extended keys survive ghostty → tmux → nvim intact; zero remaps.
- **Untracked lobby notes** — **resolved by rehoming**: `text-overload.md` + its screenshots → `humpty/lobby/`, `agent-grant.md` → `jabberwocky/lobby/`. The untracked `kol-dumpty/lobby/` folder is gone; every staged note now lives in a tracked repo.
- **Four non-repo folders** + **kol-cli vs the ref cards** — **parked** in `llm-plan/01-parking-lot.md` with kill criteria, not carried forward.
- **`tmpl-wl-*` enforcement** — parked where it belongs: `humpty/lobby/tmpl-family.md` asks the muzzle repo whether the budget becomes a Stop hook, as footer-gate already is for shape.

## The arc's own lesson

Every fix in it came from the same failure: **the agent printing rather than parsing**. The density law, the `/dump` skill, the word budgets and the `lead-first` memory are four expressions of one correction — and the three notes now sitting in humpty's lobby are that correction addressed to the repo that can enforce it.

No open threads.
