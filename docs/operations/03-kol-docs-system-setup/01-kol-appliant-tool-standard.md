---
title: kol-appliant — the tool & solution documentation standard
type: reference
status: active
updated: 2026-07-11
audience: internal
aliases:
  - kol-appliant
  - tool-doc-standard
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|kol-docs system setup]]"
  - "[[scripts/INDEX|scripts catalog]]"
  - "[[02-claude-agents/02-skills|skills]]"
---

# kol-appliant — tool & solution documentation standard

## The principle

Every tool or solution this repo produces has an **immediate, accessible answer** — quick to reach, **never buried** as a child of an unrelated process or an un-greppable mention. One home, one contract, individually and thoroughly documented. A tool that meets the contract below is **kol-appliant**.

The failure this prevents: a real, working tool (`clip-drop.sh` on `prefix C-p`) that the author can't *find* because its only home was a comment inside a tmux keybind. Never again.

## The contract (5 points)

| # | Point | Means |
|---|---|---|
| 1 | **In-point** | The install/enable chain in **one** place: `brew install` → brewfile line → `bootstrap` → dependencies → usage. Reproducible from zero. |
| 2 | **Home** | Its category + neighbours — which `docs/` family it lives in, and its row in that family's `INDEX`. |
| 3 | **Purpose** | The doc answers all of: **usage · hotkeys · use-cases · sources · external links**. |
| 4 | **KOL-accessible** | Its keybinds are registered in **`keys`**, its folders in **`files`** — the cat-to-shell surfaces. Greppable from the shell, not doc-only. |
| 5 | **Dups & redundancy** | Its other locations + mentions are mapped in the doc, so nothing goes stale silently. |

## Definition of done

A tool/solution ships **kol-appliant** only when every box holds:

- [ ] brewfile line (or a documented non-brew install path — pipx/uv/built-in)
- [ ] a catalog doc under the correct `docs/` family **+ an INDEX row**
- [ ] the doc answers usage · hotkeys · use-cases · sources · links
- [ ] `--help` works, for any `bin/` script (the house convention)
- [ ] keybinds registered in `keys` / folder registered in `files` (if it has them), via `/keys-add` · `/files-add`
- [ ] known mentions/dups mapped in the doc

## Enforcement

- **`--help` lint.** Every `bin/` script services `--help` (gold standard: `fs-rm-folder-smart.sh`). A lint (skill or hook) flags offenders. (`keys` was the first offender — fixed 2026-07-11.)
- **`keys`/`files` registration is mandatory**, not optional — a tool with binds that isn't in `keys` is not done.

## Section edit-tracking = git

Decided: **git is the section-level changelog** (`git blame`, `git log -L`) — no per-section hash→frontmatter system. Keep doc-level `updated:` for the at-a-glance. Add in-markdown section-date markers only if a real need for in-doc dates appears.

## Applying it

- **New tool:** run the Definition-of-done before calling it "done."
- **Retrofit:** sweep the existing catalog against the DoD — the `--help` lint + a `keys`/`files` coverage check surface the gaps.

## Status

Standard authored 2026-07-11 (Phase 3 of the kol-terminality initiative; plan `.kol/llm-plan/03-…md`). Follow-on builds: the `--help` lint skill/hook, and a `keys`/`files` coverage audit of the existing catalog.
