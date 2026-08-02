---
name: lobby-web
description: Port the current conversation into the kol-website lobby as a tracked ticket — a site content or UI issue found while working elsewhere, carried over with its evidence. Writes the entry, the ledger row and the history line in one pass. Use on /lobby-web, or when the user says "file that against the website", "that's a kol-website issue", "log it for the site".
---

# lobby-web — this conversation → the kol-website queue

The site lobby. Copy that's wrong, a section that breaks at a width, a page that leans on a pattern the design system already owns, a media asset pointing at a dead CDN path.

**Destination:** `~/dev/projects/kol-website/lobby/inbox/`
**Ledger:** `INDEX.md` at that lobby's root.

## Steps

1. **Name the ask, not the symptom.** The title is what someone scanning the ledger sees.
2. **Collect the evidence** — the route or page, the component file, a screenshot in `_assets/` if the failure is visual, and the viewport it happens at. A visual bug without a width is not reproducible.
3. **Decide it's really the website's.** If the defect is in a `@kolkrabbi/*` package the site merely consumes, it belongs in `/lobby-ds` — the site is a consumer, and fixing it here forks the system.
4. **Slugify** — kebab-case, or PascalCase when the entry is about one component.
5. **Write `lobby/inbox/<slug>.md`** in the shape below.
6. **Append the INDEX row** at 🔵 `filed` + a dated `History` line. Same pass.
7. **Write the receipt in THIS repo** — `lobby/outbox/<same-slug>.md`, plus its row under **Filed elsewhere** in this repo's own ledger. Same pass again. The ticket now exists at both ends: when kol-website closes it, its closer writes back into that stub, and `/ag-init` reports it here at boot. Current repo has no `lobby/` → skip it and say so. Shape: `04-conventions.md` § A receipt.
8. **Report** what landed, where, and that it is **not** started.

## Entry shape

```markdown
# <the ask, one line>

**Staged:** YYYY-MM-DD · from a <repo> session
**Change:** <how big it is>

---

## The problem, in one case
<route/page, the file, the viewport, the visible failure and its cost.
 Screenshot in _assets/ referenced here if there is one.>

## The fix
<what to do. Name files and lines wherever you can.>

## Rejected alternative
<what you considered and why it lost.>

## Definition of done
- [ ] <checkable>
- [ ] <checkable>
```

## The consumer test

kol-website is the **biggest consumer** of `kol-ds-ui`'s 15 packages. Before filing here, ask: would this fix live in `apps/web`, or in a package? A package fix filed against the site produces a local override that drifts from the system — that is the failure this test exists to catch.

## The bar for closing

🟢 `closed` when **the user confirms**. Append `## ✅ RESOLUTION — <date>`, move to `done/`, update the ledger, **and return the receipt** to the repo named in the entry's `from a <repo> session` line — naming the remainder, or `none`. Same turn as the work.

## Do not

- Do not set a state above `filed`.
- Do not start the work. This is an inbox.
- Do not file without a ledger row.
- Do not file without a receipt — invisible one repo over is still invisible.

Protocol: `~/.dotfiles/docs/operations/systems/lobby/02-lifecycle.md` · card: `ref-lobby`.
