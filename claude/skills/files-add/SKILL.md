---
name: files-add
description: Add or fix a folder entry in the `files`/`to` navigation catalog (~/.dotfiles/files/folders.md) the right way — the tag-section format, the existing tag taxonomy, column alignment, and the keep-the-paths-real discipline. Use when adding a folder to the folder-navigation system, after moving or renaming a project folder, or when the user invokes /files-add.
---

# files-add — maintain the `files` / `to` folder-navigation catalog

`files` bat-prints your bookmarked folders filtered by tag (`files kol`); `to` jumps into one (`to kol` — one match cd's, several fzf-pick). Both read one hand-kept list. This skill is how to **add to it correctly**. It's the sibling of `keys-add`.

## The four files
| File | Role |
|---|---|
| `~/.dotfiles/files/folders.md` | **the data** — the flat list you edit. The only file you touch to add a folder. |
| `~/.dotfiles/bin/files` | the printer — alias of `ref files` (`bin/ref` owns the tag-filter engine). Don't touch it to add content. |
| `shell/.zshrc` → `to()` | the jumper — a shell function (a bin script can't cd your shell). Don't touch it to add content. |
| `docs/scripts/20-files.md` | the catalog doc — only touch if the *tool* changes, not for new entries. |

## The data format
Plain markdown. One section per header, entries below, path-first and column-aligned:

```
## #tag #subtag
~/path/to/folder        terse description
~/another/folder        what it is
```

- **Header** = `## ` then space-separated `#tag`s. The first is the broad group, the rest narrow it. `files <tags…>` / `to <tags…>` show a section only if its header contains *all* the given tags.
- **Entry lines** = the `~`/absolute path on the left, a terse description on the right, padded so descriptions line up within the section. The path is the **first whitespace token** — so **no spaces in paths**.
- The top `# ` title + intro are printed by bare `files` only; ignore them when adding.

## The existing tag taxonomy — REUSE these, don't invent
- **Group tags:** `#dev` · `#kol` · `#config`
- **Subtags in use:** `#root` `#apps` `#ds` `#vault` (dev/kol) · `#dotfiles` `#claude` (config)

Add a folder under the section whose tags already fit. Only start a new `## #group #subtag` section if none does — and prefer an existing subtag word over a synonym.

## To add a folder
1. Find the section whose `## #tags` match (e.g. a new app repo → `## #kol #apps`).
2. Add a `~/path    description` line, aligned with the others in that section; terse description.
3. Genuinely new area → a new `## #group #subtag` block, reusing a group tag + the closest existing subtag.
4. **Verify:** `files <tag>` shows it, and `to <tag>` reaches it (cd's in).

## The discipline that keeps it honest
`folders.md` is a **hand-kept map of real folders**, so:
- **Every path must exist.** Before you save, confirm the folder is really there (`[ -d <path> ]`) — a dead path makes `to` jump to nothing. Read the path, don't guess it.
- When you **move or rename** a folder, update `folders.md` in the **same change** — otherwise `to` breaks (the repo's standing "sync docs on source edit" rule applied here).
- No `#` when the user *types* a tag (`files kol`, `to kol`) — but the data headers keep the `#` (it's the tag marker + reads as markdown).
