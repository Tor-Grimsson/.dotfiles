# scaffold

One folder per `scaffold-*` skill — the "building fresh" family (2026-07-05 naming convention:
`scaffold-*` for scaffolding something new, plain skill-specific names otherwise).

| # | Folder | Serves | Has package |
|---|---|---|---|
| 01 | `01-scaffold-dev-stack/` | `scaffold-dev-stack` + `scaffold-dev-stack-kol` | **no** — both install from npm/generate directly, nothing in `claude/packages/` |
| 02 | `02-scaffold-docs/` | `scaffold-docs-system` | pointer only — the real canon is `../kol-docs/kol-docs-lib/`; this folder also holds `obsidian-shapes/`, the `.obsidian` source picker's 3 reference shapes |
| 03 | `03-scaffold-llm-context/` | `scaffold-llm-context` | yes — `.kol/llm-context/` templates + `LLM_RULES.md` (the generic boot file every scaffolded repo symlinks) |
