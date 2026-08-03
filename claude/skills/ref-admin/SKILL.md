---
name: ref-admin
description: Add or fix an entry in any ref card (~/.dotfiles/ref/*.md, files/folders.md) the right way — the one table dialect (glow-rendered, NO per-row spacer rows, single-word sections, [e] blocks, doc: folds), the files/to path contract, and the keep-it-in-sync-with-the-actual-config discipline. Use after rebinding/adding a tool command or moving a folder, or on /ref-admin. Replaces the retired keys-add + files-add skills (2026-07-29); renamed from ref-add 2026-08-02 (ref-skill was rejected as the new name — that's the live terminal lookup for ref/skill.md, a different thing).
---

# ref-admin — maintain the ref cards

`ref <card> [word …]` glow-renders hand-kept reference cards as box tables, filtered by words in section titles. Cards: tmux · nvim · git · explorer · grep · media · desk · terminal · shell · system · files. This skill is how to **add to them correctly**.

## The files
| File | Role |
|---|---|
| `~/.dotfiles/ref/<card>.md` | **the data** — one file per card; the only thing you touch to add an entry |
| `~/.dotfiles/files/folders.md` | the `files` card — paths; also feeds the `to` jumper |
| `~/.dotfiles/bin/ref` | the engine (registry `card_def()` · word filter · glow render). Touch only to add a whole card |
| `docs/scripts/ref-system/` | the system docs — `02-cards.md` is the authoring law in full |

## The dialect (the law, short form)
```
## word

| keys | does           |
|------|----------------|
| key  | terse command  |
| key2 | terse command  |
|      |                |
| **## group** | what it is |
| key3 | terse command  |

[e] — as typed:

```sh
real-command --with real-values
```

----
doc: docs/<the file that homes the depth>
```

- **Section titles = single words** where possible (`## pane`, `## branch`) — they ARE the filter.
- **NO spacer row between data rows.** A blank `|  |  |` is a **category break** and
  nothing else — 385 per-row spacers were stripped on 2026-07-31 because this line
  used to say the opposite, and the wrong version is why the habit kept regrowing.
- **A group inside a table is marked `| **## name** | what it is |`**, preceded by one
  blank spacer row. That is how seven tools live in ONE table instead of seven
  scattered `## sections` (user ruling 2026-08-01, `ref-explorer trial` is the model).
- **Group markers get bolded** — `glow-style.json`'s `strong` style carries the accent
  color (256-color 214), so a category header reads distinct from a plain key row.
  Bold is otherwise almost unused in these cards, so this doesn't fight anything else.
- **Categories are optional, not default.** Group only when a card genuinely holds
  multiple tools/topics that belong in one table. A card about one tool stays a plain
  table — don't invent categories to look thorough.
- **Cells stay glance-length** — a sentence in a cell is a doc in a table costume; depth is EVICTED to the `doc:` fold target (moved there first, never dropped).
- **`[e]` blocks below the table**, real terminal strings, one command per line — never `&&` chains, never `[e]` as a table row.
- Backtick angle tokens (`` `<leader>` ``); escape literal `|` as `\|`; command sequences may be ```sh blocks.
- `doc:` fold paths must exist on disk.

## The files-card extra contract
`to()` (zshrc) extracts the **first cell** of rows starting `| ~` — path leads the row, no spaces in paths, every path must exist (`[ -d ]` before saving).

## To add
1. Entry: find the section by word, add `| key | does |`. **No spacer row.**
   A blank `|  |  |` is a CATEGORY BREAK inside a table with genuine groups —
   never a per-row separator (user ruling 2026-07-31; 385 were stripped that day).
2. Section: single-word `## title`, table skeleton, fold at the group end.
3. Card: data file in `ref/` + one `card_def()` line + a `usage()` line + a 3-line `bin/ref-<card>` alias.
4. **Verify — run the check, don't promise it:**
   ```sh
   ref --lint
   ref <card> <word>
   ```
   `ref --lint` is the dialect as a **machine check** (`bin/ref`, python3 — macOS awk
   counts bytes, and these cards are full of `·` and `→`). It fails on a per-row
   spacer, a cell over **46 characters**, a `doc:` target that doesn't exist, and a
   card with no `## section`. **A card is not done until the lint passes.** For the
   files card also confirm `to <word>` still reaches it.

## The discipline
Cards are hand-kept copies of what's really bound/installed — when a config changes, the card changes in the **same edit** (the repo's sync-docs rule). Read the config, don't guess.
