---
name: keys-add
description: Add or fix a keybind entry in the `keys` shell reference (~/.dotfiles/keys/keybinds.md) the right way — the tag-section format, the existing tag taxonomy, column alignment, and the keep-it-in-sync-with-the-actual-config discipline. Use when adding a keybind to the `keys` tool, after rebinding something in tmux / nvim / aerospace, or when the user invokes /keys-add.
---

# keys-add — maintain the `keys` keybind reference

`keys` is a shell tool that bat-prints the user's own keybinds, filtered by tag: `keys tmux`, `keys tmux popover`, `keys bookmark`. This skill is how to **add to it correctly**.

## The three files
| File | Role |
|---|---|
| `~/.dotfiles/keys/keybinds.md` | **the data** — the flat list you edit. This is the only file you touch to add a keybind. |
| `~/.dotfiles/bin/keys` | the script — alias of `ref keys` (`bin/ref` owns the tag-filter engine). Don't touch it to add content. |
| `docs/scripts/19-keys.md` | the catalog doc — only touch if the *tool* changes, not for new entries. |

## The data format
Plain markdown. One section per header, entries below, key-first and column-aligned:

```
## #tool #subtopic
key            action, terse
another-key    another action
```

- **Header** = `## ` then space-separated `#tag`s. The first tag is the **tool**, the rest are **subtopics**. `keys <tag …>` shows a section only if its header contains *all* the given tags — so tags are how it's filtered.
- **Entry lines** = the key(s) on the left, the action on the right, padded so the actions line up within the section. Keep the action to one line, terse — this is a glance reference, not docs.
- The top `# ` title + intro paragraph are printed by bare `keys` only; ignore them when adding.

## The existing tag taxonomy — REUSE these, don't invent
- **Tool tags:** `#tmux` · `#nvim` · `#aerospace` · `#git` · `#gh` · `#ssh`
- **Subtopics in use:** `#popover` `#bookmark` `#layout` `#session` `#window` `#pane` `#copy` `#harpoon` (tmux) · `#modes` `#save` `#move` `#edit` (nvim) · `#focus` `#workspace` `#layout` `#mode` (aerospace) · `#lazygit` (git)

Add a keybind under the section whose tags already fit. Only start a new `## #tool #subtopic` section if none fits — and prefer an existing subtopic word over a synonym (`#move` not `#motion`).

## To add a keybind
1. Find the section whose `## #tags` match (e.g. a new tmux popup → `## #tmux #popover`).
2. Add a `key    action` line, aligned with the others in that section; terse action.
3. If it's a genuinely new area, add a new `## #tool #subtopic` block, reusing a tool tag + the closest existing subtopic (or a new one if truly novel).
4. **Verify:** run `keys <tag>` (or the fuller filter) and confirm the entry shows.

## The discipline that keeps it honest
`keybinds.md` is a **hand-kept copy** of what's really bound in the configs (`tmux/.tmux.conf`, `aerospace/aerospace.toml`, the nvim config, etc.). So:
- When you **change or remove** a keybind in a config, update `keybinds.md` in the **same change** — otherwise it drifts and lies (this is the repo's standing "sync docs on source edit" rule applied here).
- When adding, make sure the key you write is what's actually bound — read the config, don't guess.
- No `#` when the user *types* a tag (`keys tmux`, not `keys #tmux`) — but the data headers keep the `#` (it's the tag marker + reads as markdown).
