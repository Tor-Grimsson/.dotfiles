---
name: lobby-ds
description: Stage a UI component into the kol-ds-ui "lobby" — a spec/brief (purpose, anatomy, variants, props, styling tokens, states, dependencies) that a design-system agent uses to recreate the component properly in the DS. Emits a SPEC, not a file copy. Use when the user says "lobby this", "/lobby-ds", "throw <component> to the design system", "stage <component> for the DS", or otherwise wants to hand a consumer-app component to kol-ds-ui.
---

# lobby-ds

Fling a component from any consumer app into the **design-system lobby** — a staging bay where component *briefs* wait to be recreated properly in `kol-ds-ui`. The output is a **spec the DS agent rebuilds from**, not the raw source file: consumer JSX carries app-specific wiring (fetch, routing, local state) and sometimes non-DS tokens, so the DS recreates clean rather than importing mess.

## Where the lobby is

`kol-ds-ui/lobby/` — a repo-root intake bay (deliberately *not* under `docs/`; it's a work queue, not published documentation, so it doesn't ride the DS `docs/_framework` conventions).

Find the repo at **`~/dev/projects/kol-ds-ui`** — top-level, NOT under `kol-apparat/`. It was renamed from `kol-design-system`; that path is dead (corrected 2026-07-31 after both lobby writers were found pointing at it).

- `lobby/inbox/<ComponentName>.md` — one spec per component (live queue).
- `lobby/INDEX.md` — THE LEDGER: a row per staged component (emoji state, name, source, staged date). `done/` holds recreated specs, `archive/` rejects and notes.

## What to do

1. **Identify the component.** A file, or an inline JSX block the user points at. If it's inline (not yet its own component), give it a PascalCase name and treat the block as the anatomy.
2. **Read it fully** — markup, props, every `className` and inline style, its imports (which DS atoms/molecules it leans on), and its interactive states. Note the exact line range.
3. **Write `lobby/inbox/<Name>.md`** using the spec shape below. Its `staged:` date is the one field the protocol reads mechanically — `~/.dotfiles/docs/operations/systems/lobby/04-conventions.md` § The staged date. (This shape is the one entry type that carries frontmatter, because a component spec has structured fields the DS queue reads; the plain `**Staged:**` header block is the default everywhere else.)
4. **Append a 🔵 `filed` row to `lobby/INDEX.md`** — same pass, an entry without a row is drift the moment it lands (create the file from the template if missing).
5. **Write the receipt in THIS repo** — `lobby/outbox/<Name>.md`, plus its row under **Filed elsewhere** in this repo's own ledger. Same pass again. A spec sits in the DS queue until someone builds it, and the consumer repo that staged it has no other way to learn it shipped — or that it still has a local copy to delete once it did. Current repo has no `lobby/` → skip it and say so. Shape: `~/.dotfiles/docs/operations/systems/lobby/04-conventions.md` § A receipt.
6. Tell the user what landed and that the DS agent can now recreate it.

## Spec shape — `lobby/inbox/<Name>.md`

```
---
component: <Name>
source: <repo>/<path>#L<start>-L<end>
staged: <YYYY-MM-DD>     # THE field. Never `date:` — the staleness rule and
                         # /lobby-hygiene read `staged:`, and emitting `date:`
                         # here is why the ageing pass found nothing in 113 files
status: draft            # draft → recreated → promoted (then delete the entry)
deps: [Button, Icon, …]  # DS atoms/molecules it composes
---

# <Name>

## Purpose
One or two lines — what it is, where it's used.

## Anatomy
Structural shape (container → children) as a small nested list or ASCII tree. Structure only, no app logic.

## Variants
Each visual/behavioral variant and what changes between them. "None (single form)" if there's only one.

## Props
| prop | type | default | controls |
|------|------|---------|----------|

## Styling
Exact classes + tokens, so the look reproduces without guessing:
- Tailwind utilities (layout/spacing/type — e.g. `flex items-center gap-3`, `kol-mono-12`, `aspect-square`).
- KOL tokens referenced (e.g. `text-fg-48`, `bg-fg-absolute-12`, `var(--kol-fg-08)`).
- Inline styles / CSS vars / pseudo-elements / transitions.
- **App-specific bits to DROP** on recreation (non-DS colors, hardcoded sizes that should be props).

## States & interactions
hover / active / selected / disabled / focus — what each looks like.

## Dependencies
DS components it composes (Button, Icon, Divider…), plus any consumer-only helpers the DS must replace with its own.

## Recreation notes
How to build it to DS conventions: which tier (atom / molecule / organism), which values become props, tokens to swap, and text casing handled at the call site (no auto text-transform).
```

## `lobby/INDEX.md` ledger template (create if missing)

```
# Component lobby

Staging bay for components flung in from consumer apps via the `/lobby-ds` skill.
Each entry is a spec the DS **recreates from** — not source. Live entries in
`inbox/`, recreated ones in `done/`, rejects and notes in `archive/`.

THIS FILE IS THE LEDGER — the truth, never a raw `ls`.

## States

| | state | means | lives in |
|---|---|---|---|
| 🔵 | `filed` | captured, unread | `inbox/` |
| 🟡 | `read` | understood — the row restates it | `inbox/` |
| 🟠 | `addressed` | a change shipped that is *meant* to close it | `inbox/` |
| 🟢 | `closed` | shipped + cited; resolution appended | `done/` |
| ⚪ | `parked` | deliberately not-now, reason recorded | `archive/` |
| 🔴 | `needs-ruling` | **flag, not a state** — blocked on the user | wherever it is |

**Bar for 🟢 in this repo:** a shipped version / changeset cited in the
resolution. `read` and `addressed` are never `closed`.

## Queue — N entries

| | Entry | Source | Staged | State |
|---|-------|--------|--------|-------|

## Closed
## Archived
## History
```

## Rules

- **Spec, not source.** Never copy the raw component file into the lobby. Capture what's needed to *rebuild* it clean.
- **Exact tokens.** The DS agent can't infer `text-fg-48` from "greyish" — record the real class/var.
- **Flag app coupling** (fetch, router, consumer state, non-DS tokens) as things to drop.
- **Don't build it in the DS.** The lobby is a queue; recreation is the DS agent's job. This skill only stages the brief.
- **No entry without a ledger row, and no ticket without a receipt.** Write the spec, the row and the `outbox/` stub in the same pass. Full protocol: `~/.dotfiles/docs/operations/systems/lobby/02-lifecycle.md` · card: `ref-lobby`.
- Skills dir is a whole-dir symlink into dotfiles — a new skill subdir needs no `bootstrap.sh` edit; it's live once the files exist.
