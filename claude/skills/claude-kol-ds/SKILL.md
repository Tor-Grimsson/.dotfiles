---
name: claude-kol-ds
description: Mandatory orientation gate for any agent working in the kol-design-system repo — read EVERY theme + framework CSS file and the foundations docs to build a real overview of the design system BEFORE touching, proposing, or answering anything. The non-negotiable minimum: no edits and no DS answers until the @import cascade, tokens, color, and type systems have actually been read, not skimmed. Use when starting work in kol-design-system, before any component/token/color/type change there, or on /claude-kol-ds.
---

# claude-kol-ds — read the whole design system first (non-negotiable)

You do **not** touch, propose, or answer anything in `kol-design-system` until you have read the CSS below and can describe the system. This is the floor, not a nice-to-have. Reading filenames is not reading files. If you skip this, you will hardcode a value that's already a token, put a rule in the wrong cascade layer, or invent a class that already exists — every time.

## 0. Locate
Repo root = the kol-design-system checkout — `packages/theme/`, `packages/framework/`, and `LLM_RULES.md` are present (on this machine: `~/dev/projects/kol-apparat/kol-design-system`). Not in it → `cd` there or ask for the path. Then obey its own `LLM_RULES.md`.

## 1. Read the cascade entry FIRST
`packages/theme/kol-theme.css` is the entry point — it `@import`s the whole theme in **cascade order**, all inside `@layer components`. Read it first so every other file has a place in the order (later import wins). The order is load-bearing:

```
base-tokens → color → opacity → opaque → typography → typography-mono
→ type-mono-classes → utilities → components-atoms → -molecules → -organisms
→ -dashboards → -chess → -workshop → -foundry
```

## 2. Read EVERY core CSS file — all of them, not a sample
The full theme + framework layer. Discovery first (don't trust this list to stay current): `fd -e css . packages | sort`

**Framework** (layered on top by consumers, *not* imported by kol-theme) — `kol-framework.css`, `kol-brand-color.css`
**Tokens & theme** — `kol-base-tokens.css`, `kol-color.css`, `kol-opacity.css`, `kol-opaque.css`, `kol-theme.css`
**Type** — `kol-typography.css`, `kol-typography-mono.css`, `kol-type-mono-classes.css`
**Utilities** — `kol-utilities.css`
**Components** — `kol-components-{atoms,molecules,organisms,dashboards,chess,workshop,foundry}.css`

App CSS (`showcase/src/*`, `workbench/src/*`) is consumer glue, not the system — read it only if the task touches those apps.

## 3. Read the foundations docs — the human map of what you just read
Reconcile the two; if a doc and the CSS disagree, the CSS is truth (and flag the drift).
- `docs/documentation/00-overview/01-package-topology.md`
- `docs/documentation/01-foundations/01-tokens.md` · `02-color.md` · `03-typography.md` · `04-layout-breakpoints.md`
- `docs/documentation/03-components/00-taxonomy.md` + `01-inventory.md` — if the task touches components.

## 4. Prove you read it — the overview (before any edit or answer)
Produce this. If you can't fill a row, you haven't read enough — go back to §2.

| Layer | What it defines | Key file(s) |
|---|---|---|
| Tokens | the primitive scale (space, radius, etc.) | `kol-base-tokens.css` |
| Color | light/dark mechanism, brand vs semantic | `kol-color.css`, `kol-brand-color.css` |
| Type | scale, families, the mono **wrap vs no-wrap** fault line | `kol-typography*.css`, `kol-type-mono-classes.css` |
| Utilities | the utility class surface | `kol-utilities.css` |
| Components | atoms → molecules → organisms + system packs | `kol-components-*.css` |

Plus, in prose: the `@import` cascade order (§1), how light/dark is switched, and the `kol-*` naming discipline (every custom class/var is `kol-*`; tokens over hardcoded values).

## 5. Only now, work
With the overview done, do the task inside the system's conventions — `kol-*` prefix, tokens over literals, the correct `@layer`/cascade position, JetBrains mono via the `kol-mono-*` / `kol-helper-*` split (see `kol-type-conform`). Color / type / layout work → route to `kol-color-agent` / `kol-type-agent` / `kol-div-agent`, which assume this orientation is already done.
