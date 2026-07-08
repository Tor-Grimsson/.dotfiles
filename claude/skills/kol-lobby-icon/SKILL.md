---
name: kol-lobby-icon
description: Promote an icon from any consumer repo UP into the shared kol-icon-set — pull its SVG, clean it (currentColor, strip Figma/export junk, normalise the filename, stroke-weight + keyline checks, dedupe), and drop it into the set under a group. Unlike /kol-lobby (which emits a component SPEC to re-author), this emits the cleaned SVG itself — an icon needs no re-authoring. Use when the user says "/kol-lobby-icon", "lobby this icon", "promote <icon> to kol-icon-set", "merge <repo>'s icon into the set", or hands you SVG code / a path to fold into the design system.
---

# kol-lobby-icon

The **up** direction of the icon loop. Repos consume the shared set and register their own local SVGs (`registerIcons`, the down direction); when a local icon earns its place, this skill promotes it into the shared **kol-icon-set** — cleaned and normalised so the set stays coherent. Sibling to `/kol-lobby`, but an icon is just an SVG: there's nothing to re-author, so this emits the **cleaned file**, not a spec.

## Where the set is

`kol-design-system/showcase/src/kol-icon-set-v1/<group>/<name>.svg` — grouped, single stroke cut, every icon `currentColor`. (It lives under the showcase for now; it moves into `packages/icons/` when the package slims. Put icons where the set currently is — check both.)

Find the repo: sibling under `kol-apparat/` (e.g. `…/dev/projects/kol-apparat/kol-design-system`). If you can't locate it, ask rather than guess.

## Input forms

- **A path** — a file or folder of SVGs in a consumer repo.
- **Pasted SVG code** — the raw `<svg>…</svg>` in the message.
- Either way the user may name the **group** and/or **name**; infer them if not given (see below).

## What to do

1. **Collect the SVG(s).** Read the file(s) or take the pasted markup.
2. **Clean each** (pipeline below) — this is the whole job.
3. **Run the checks** and surface anything that fails (stroke weight, keyline fit, collision).
4. **Place** the cleaned file at `…/kol-icon-set-v1/<group>/<name>.svg`. Create the group folder if new.
5. **Report** per icon: final `<group>/<name>`, and any flags (weight fixed, oversize, collision, needs-a-look).

## Clean pipeline (apply in order)

1. **Strip export junk.** Remove `<defs>…</defs>` and unwrap `<g clip-path="…">…</g>` (Figma's clip wrapper). Drop `<title>`, `id=`, `data-*`, and any `<rect fill="white">` clip mask.
2. **currentColor.** `stroke="black"|"#000…"` → `stroke="currentColor"`; `fill="black"|"#…"` → `fill="currentColor"`. Leave a deliberate `fill="none"` on the svg root. Genuine solid glyphs (filled carets, dots) keep their fill — as `currentColor`.
3. **viewBox.** Must be `0 0 24 24`. If it's a different box, note it — don't silently rescale.
4. **Filename.** Strip any frame/group prefix and trailing ` N` export counter; camelCase→kebab (`BugBeetle`→`bug-beetle`); spaces→hyphens; lowercase. The name is the standalone icon name (`external-link`, not `nav-external-link`) unless the prefix is semantic (`chevron-`, `arrow-`, `caret-`, `atomic-`).

## Checks (report, don't silently pass)

- **Stroke weight.** A stroked icon must carry `stroke-width="1.5"`. **Missing `stroke-width` is the trap** — it silently renders at the SVG default 1.0 and reads lighter than the set. Add `1.5` (on the root or each stroked path).
- **False stroke / expanded.** If linework is drawn as a *filled outline* (fill tracing what should be a stroke, no real `stroke`) it's an expanded export — reject it, ask for the real stroke. (Filled *dots* and intentionally-solid glyphs like carets are fine.)
- **Keyline fit.** Geometry should sit inside ~18–20 on the 24-grid like the rest of the set. If it reaches ~0/24 it's oversized — flag for a refit, don't ship it mismatched.
- **Collision.** Icons resolve by basename across the whole set. If `<name>` already exists in another group, STOP — pick one canonical home (delete the other) or rename; never ship two.

## Rules

- **Cleaned file, not a spec.** Opposite of `/kol-lobby`: the icon *is* the deliverable. Emit the normalised SVG into the set.
- **One name, one icon.** The set is flat-by-name even though it's foldered by group — enforce no basename collisions.
- **Don't invent geometry.** Clean colours/markup/names and check fit; if the drawing itself is wrong (expanded, oversized, off-weight), flag it back — redrawing is a Figma job, not this skill's.
- **currentColor always**, so the icon themes against its plate.
- **Never touch git.** Place files; the user commits.
- Skills dir is a whole-dir symlink into dotfiles — this subdir is live once the files exist; no `bootstrap.sh` edit needed.
