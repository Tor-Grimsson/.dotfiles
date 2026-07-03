---
name: kol-lobby
description: Stage a UI component into the kol-design-system "lobby" — a spec/brief (purpose, anatomy, variants, props, styling tokens, states, dependencies) that a design-system agent uses to recreate the component properly in the DS. Emits a SPEC, not a file copy. Use when the user says "lobby this", "/kol-lobby", "throw <component> to the design system", "stage <component> for the DS", or otherwise wants to hand a consumer-app component to kol-design-system.
---

# kol-lobby

Fling a component from any consumer app into the **design-system lobby** — a staging bay where component *briefs* wait to be recreated properly in `kol-design-system`. The output is a **spec the DS agent rebuilds from**, not the raw source file: consumer JSX carries app-specific wiring (fetch, routing, local state) and sometimes non-DS tokens, so the DS recreates clean rather than importing mess.

## Where the lobby is

`kol-design-system/lobby/` — a repo-root intake bay (deliberately *not* under `docs/`; it's a work queue, not published documentation, so it doesn't ride the DS `docs/_framework` conventions).

Find the repo: it's a sibling under the `kol-apparat/` workspace (e.g. `…/dev/projects/kol-apparat/kol-design-system`). If you can't locate it, ask rather than guess.

- `lobby/<ComponentName>.md` — one spec per component.
- `lobby/INDEX.md` — the queue: a row per staged component (name, source, date, status).

## What to do

1. **Identify the component.** A file, or an inline JSX block the user points at. If it's inline (not yet its own component), give it a PascalCase name and treat the block as the anatomy.
2. **Read it fully** — markup, props, every `className` and inline style, its imports (which DS atoms/molecules it leans on), and its interactive states. Note the exact line range.
3. **Write `lobby/<Name>.md`** using the spec shape below.
4. **Append a row to `lobby/INDEX.md`** (create the file from the template if missing).
5. Tell the user what landed and that the DS agent can now recreate it.

## Spec shape — `lobby/<Name>.md`

```
---
component: <Name>
source: <repo>/<path>#L<start>-L<end>
date: <YYYY-MM-DD>
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

## `lobby/INDEX.md` template (create if missing)

```
# Component lobby

Staging bay for components flung in from consumer apps via the `kol-lobby` skill.
Each entry is a spec the DS **recreates from** — not source. To promote: build the
component under `packages/component/src/{atoms,molecules,organisms}/` to spec, then
delete its lobby entry.

| Component | Source | Staged | Status |
|-----------|--------|--------|--------|
```

## Rules

- **Spec, not source.** Never copy the raw component file into the lobby. Capture what's needed to *rebuild* it clean.
- **Exact tokens.** The DS agent can't infer `text-fg-48` from "greyish" — record the real class/var.
- **Flag app coupling** (fetch, router, consumer state, non-DS tokens) as things to drop.
- **Don't build it in the DS.** The lobby is a queue; recreation is the DS agent's job. This skill only stages the brief.
- Skills dir is a whole-dir symlink into dotfiles — a new skill subdir needs no `bootstrap.sh` edit; it's live once the files exist.
