# Obsidian vault-config source

The single source of `.obsidian/` config that repos across the machine symlink (or copy) into
their `docs/.obsidian/`. Symlink mode is per-file — `docs/.obsidian/` stays a real local directory
and each file inside it is individually symlinked back here, so the excluded per-vault files below
can stay local instead of becoming one shared file across every repo. Edit a shape here → every
symlinked repo inherits the change.

## Shapes

| Shape | Seeded from | For |
|---|---|---|
| `01-vault-shape/` | `kol-monorepo/docs/.obsidian` | The rich general vault — plugins, snippets, themes, hotkeys, folder-notes, dataview. Default for a full working vault. |
| `02-kol-vault-shape/` | `kol-vault/.obsidian` | The actual dedicated Obsidian vault — 30 enabled community plugins (`dataview`, `templater-obsidian`, `quickadd`, …). The 60+ installed-but-disabled plugins were stripped 2026-07-05 (dead weight in a template). |
| `03-kol-ds-shape/` | `kol-design-system/docs/.obsidian` | Minimal — core plugins only. For lightweight doc trees. |
| `04-plugin-kol-dashboard/` | `kol-vault/.obsidian/plugins/kol-dashboard` | Custom plugin, not a vault shape — lifted out to its own sibling so it drops into any vault's `plugins/` regardless of chosen shape. Own `node_modules` (gitignored) + `src/`. |

Each shape is itself an openable mini-vault (has a `.obsidian/` + a dummy note) — open the folder
in Obsidian to preview/test plugins; changes flow to every repo linked to that shape.

## How repos consume a shape

The `scaffold-docs-system` skill offers a picker on setup — symlink (per-file, see above) or copy (whole-directory `cp -R`), any of the 3 shapes above.

## Excluded from every shape

`workspace.json`, `workspaces.json`, `workspace-mobile.json`, `plugin-data/`, `bookmarks.json`,
`switcher.json`, `backlink.json`, `webviewer.json`, `note-composer.json` — per-vault local UI
state / runtime caches. Never seeded here; gitignore them in each target repo.

`remotely-save` was dropped from `02-kol-vault-shape/` (2026-07-05) — its bundled `main.js` ships
the plugin's own hardcoded OAuth client id/secret, which tripped GitHub push protection. Reinstall
from the community browser in-app if a repo needs cloud sync; don't re-vendor it here.
