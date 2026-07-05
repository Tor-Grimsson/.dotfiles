# Obsidian vault-config source

The single source of `.obsidian/` config that repos across the machine symlink (or copy) into their `docs/.obsidian/`. Edit a shape here → every symlinked repo inherits it.

## Shapes

| Shape | Seeded from | For |
|---|---|---|
| `01-vault-shape/` | `kol-monorepo/docs/.obsidian` | The rich general vault — plugins, snippets, themes, hotkeys, folder-notes, dataview. Default for a full working vault. |
| `02-kol-ds-shape/` | `kol-design-system/docs/.obsidian` | Minimal — core plugins only. For lightweight doc trees. |

Each shape is itself an openable mini-vault (has a `.obsidian/` + a dummy note) — open the folder in Obsidian to preview/test plugins; changes flow to every repo linked to that shape.

## How repos consume a shape

The `kol-docs-lib` skill offers four choices on setup:

1. **Symlink** `01-vault-shape/.obsidian` → shared, no drift, `workspace.json` churn shared.
2. **Symlink** `02-kol-ds-shape/.obsidian` → same, minimal.
3. **Copy** `01-vault-shape/.obsidian` → repo owns it, drifts independently.
4. **Copy** `02-kol-ds-shape/.obsidian` → same, minimal.

## Excluded from the source

`workspace.json`, `workspaces.json`, `workspace-mobile.json` — per-vault local UI state. Never seeded here; gitignore them in each target repo.
