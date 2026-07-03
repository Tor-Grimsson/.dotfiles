# Session: kol-press-research skill

**Date:** 2026-07-03 (iMac)
**Summary:** New local-authored skill `claude/skills/kol-press-research/` — the durable form of the ad-hoc "public-web scrape" research sessions (the 2026-05-27 kolkrabbi-info press/timeline enrichment was one; nothing reusable survived it, which is why the task got re-explained per client).

## What it is

- **Input:** client/subject name + aliases, domains/handles, language/region, scope (studio vs person).
- **Process:** search fan-out (per alias × per angle × native-language + .is outlets) → **every hit verified by fetching** (via the `@kolkrabbi/kol-scrape` CLI from kol-design-system, or WebFetch) → curation rules (subject-vs-author, TBD-not-guessed, PII stays out of public packages).
- **Output:** entries in the **brand-manifest shape** (`press[]` / `timeline[]` / `presence`) ready to append to the client's local brand package (`@kolkrabbi/kol-brand-template` schema), or a `05-press.md`-style table when no package exists.

## Repo changes

- `claude/skills/kol-press-research/SKILL.md` — new; live immediately (whole-dir symlink), verified registered in-session.
- `docs/16-claude-agents/02-skills.md` — count 22→23, row added (Design system / brand group), local-authored list += `kol-press-research` (**won't ride the kol-system re-sync**, per the export-specs precedent).

## Notes

- Counterpart work lives in kol-design-system: `@kolkrabbi/kol-scrape` (mechanical CLI) + `@kolkrabbi/kol-brand-template` (the manifest schema the output conforms to) — built same day, see that repo's session log.
- User owns git — commit when ready; skill syncs to the MBP via dot-sync, no install steps.
