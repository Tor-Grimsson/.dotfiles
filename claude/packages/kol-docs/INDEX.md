# kol-docs

The doc-spec canon, three nested tiers, `fm ⊂ md ⊂ lib`.

| Package | Serves | Has folder |
|---|---|---|
| `kol-docs-fm/` | `kol-docs-fm` skill | yes |
| `kol-docs-md/` | `kol-docs-md` skill | yes |
| `kol-docs-lib/` | `scaffold-docs-system` skill (renamed from `kol-docs-lib`; package name kept, independent of skill name) | yes |
| `kol-docs-overview` | orientation-only skill for this whole family | **no** — self-contained in its own SKILL.md, no canon package needed |

`scaffold-docs-system` also depends on `../scaffold/02-scaffold-docs/` for the `.obsidian` shapes — see that folder for the setup workflow; this one is the canon it applies.
