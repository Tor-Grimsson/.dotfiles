---
title: kol-appliant tool-doc standard + vault lean-up
description: The forward plan from the 2026-07-11 terminality session — three phases: quick captures + the keys --help fix, leaning the docs vault (research→terminality, explorations→operations, 06-kol-dash→terminality), and the big one — the "kol-appliant" per-tool documentation standard that makes every tool/solution instantly findable and enforced. Nothing committed; this is the plan to review.
_template:
  version: 1
  path: .kol/llm-plan/03-kol-appliant-and-docs-lean.md
  sync: skip
---

# kol-appliant tool-doc standard + vault lean-up

Forward plan captured for review. Nothing here is committed. Continues [`02-docs-restructure.md`](02-docs-restructure.md); feeds [`docs/kol-terminality/`](../../docs/kol-terminality/INDEX.md).

---

## Phase 1 — captures & a bug (mechanical, minutes)

- **The sticky-widget idea** → `docs/kol-terminality/06-notes-and-tasks.md`: a persistent widget = notes **+ bookmarks + links**, realised via **Übersicht** (the engine under simple-bar). Ties the raindrop/raycast bookmark angle to the widget layer. Distinct from skitty-notes (notes-only) — this is the superset.
- **`keys` breaks the `--help` convention** — flagged, to confirm + fix. Every `bin/` script is supposed to service `--help` (house standard); `keys` doesn't. Fix it, then see Phase 3's lint so it can't recur.

## Phase 2 — lean the vault ✅ DONE (2026-07-11)

Applied: siblings 5 → 3 (kol-cli · scripts · kol-terminality). `research/` → terminality as `11-ricing-backlog` / `12-nvim-from-scratch` / `13-awesome-tuis`; `explorations/` → `operations/06-explorations.md`; `06-kol-dash/` → `kol-terminality/kol-dash/` (subfolder, kept its own numbering). All refs rerouted; final grep = zero stale refs.

The vault has stretched to 5 top-level siblings; collapse two and relocate the dashboard lineage.

**Pre-flight audit (2026-07-11, read-only, done).** Terminality QA: all 11 new docs' cross-folder wikilinks resolve (8/8 targets exist) — clean. Blast radius + forks mapped below so the move is mechanical once the forks are settled.

### What moves
| Folder | Contents |
|---|---|
| `docs/research/` → **kol-terminality** | INDEX · ricing-2025-backlog · nvim-from-scratch-study · awesome-tuis (4) |
| `docs/explorations/` → **operations** | INDEX only (the bookmark-sidebar content already lives in `documentation/18-tui-shell-layout/03-bookmarks.md`) |
| `docs/operations/06-kol-dash/` → **kol-terminality** | INDEX · 01-automation · 02-process · 03-dashboard-systems · 04-ipad-kiosk (5) |

### Reroute list (inbound refs that break on move)
- **research → terminality:** `docs/INDEX.md` sibling row · **7 terminality docs** link `[[research/ricing-2025-backlog|…]]` / `[[research/nvim-from-scratch-study|…]]` (INDEX, 03, 04, 05, 06, 07, 10) · research's own INDEX + awesome-tuis internal links.
- **explorations → operations:** `docs/INDEX.md` sibling row · `documentation/18-tui-shell-layout/03-bookmarks.md` (×2) · `research/INDEX.md` (×2, moves with research).
- **06-kol-dash → terminality:** `docs/operations/INDEX.md` row · `docs/scripts/18-appearance.md:68` path string · `docs/INDEX.md:23` prose mention.
- **Not touched (audit false positives):** `bin/kol-dash` + `bin/kol-kb` (the CLI tools) and `scripts/{17-kol-dashboard-cli,16-capture}.md` reference the **kol-dashboard plugin/CLI**, not the docs folder — they stay. `reinforce-full.txt:38` uses `docs/research/` as a generic example — leave or genericize.

### Forks — resolved & applied (no longer open)
| Fork | The snag | Resolution (applied) |
|---|---|---|
| research docs' landing | NN- numbering law — `ricing-2025-backlog` etc. are non-NN; and doc 10 already absorbs the ricing backlog | fold ricing-backlog into doc 10 (archive the standalone); move nvim-from-scratch + awesome-tuis in as `11-`/`12-` |
| 06-kol-dash collision | its `01–04` collide head-on with terminality's `01–04` | land it as a **subfolder** `kol-terminality/kol-dash/` — keeps its own numbering |
| explorations | it's only an INDEX | fold to one `operations/NN-explorations.md`, or drop it (content already in 18-bookmarks) |

Then: plain `mv` + reroute every ref above; user owns git.

## Phase 3 — the "kol-appliant" standard ✅ DONE (2026-07-11)

Built: the standard spec (`docs/operations/03-kol-docs-system-setup/01-kol-appliant-tool-standard.md`); `bin/help-lint` (the `--help` lint — static, skips binaries; `bin/` scan clean, 64 pass; caught + fixed `keys`/`files`/`vid-h264-web`/`vid-reframe`); the `/kol-appliant` enforcement skill (registered, local-authored); help-lint's own catalog doc (`docs/scripts/21-help-lint.md`). Section-changelog = git (no hash system). Retrofit backlog: run `/kol-appliant` per existing tool + a `keys`/`files` coverage sweep.

**Principle:** every tool or solution we produce has an *immediate, accessible* answer — quick, greppable, never buried as a child of an unrelated process or an un-findable mention. Individually and thoroughly documented, one home, one contract.

### The per-tool contract (5 points)

1. **In-point** — the install/enable chain in one place: `brew install` → brewfile line → bootstrap → dependencies → usage.
2. **Home** — what category it belongs to and who its neighbours are.
3. **Purpose** — answers: usage · hotkeys · use-cases · sources · external links.
4. **KOL-accessible** — its keybinds are registered in **`keys`**, its folders in **`files`** — the cat-to-shell surfaces. Instantly greppable from the shell, not only in docs. Registration via `/keys-add` / `/files-add` becomes **mandatory** per tool. (This is "kol-appliant.")
5. **Dups & redundancy** — its locations + mentions are mapped, so docs don't go stale.

### Enforcement

- **`--help` lint** — a hook or skill that flags any `bin/` script missing the `--help` convention (`keys` is offender #1). Candidate: a Stop/commit-adjacent check, or a `/`-skill audit.
- **`keys`/`files` registration** — part of the "definition of done" for shipping any tool: if it has binds, they're in `keys`; if it has a home folder, it's in `files`.
- Likely graduates into its own **spec doc** (in `.kol/docs-framework/` or `docs/operations/`) + a **skill** (like the kol-docs framework has kol-docs-md/fm) — the standard authored once, applied per tool.

### Section edit-tracking (decided: lean on git)

- **git is already the section-level changelog** — `git blame` / `git log -L` give per-section authorship + dates for free.
- Keep the doc-level `updated:` frontmatter field (already in use — bumped per edit this session).
- **Do not build** a per-section hash→frontmatter changelog system: it's a lot of tooling for what git already provides. Add lightweight in-doc section markers only if in-markdown dates are genuinely needed later.

---

## Open forks (recommendation noted; decision is the user's)

| Fork | Recommendation |
|---|---|
| `research/` → operations *or* terminality | **terminality** (content home) |
| section changelog | **lean on git**, no hash tooling |

## Sequencing

Phase 1 + 2 are mechanical and safe → run together. Phase 3 is a focused design session (spec doc + skill) → sit down for it separately.
