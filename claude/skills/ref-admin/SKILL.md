---
name: ref-admin
description: Add or fix an entry in any ref OR notes card (~/.dotfiles/ref/*.md, notes/*.md, files/folders.md) the right way — one dialect governs both families, and `ref --lint` checks both — the one table dialect (glow-rendered, NO per-row spacer rows, single-word sections, [e] blocks, doc: folds), the files/to path contract, and the keep-it-in-sync-with-the-actual-config discipline. Use after rebinding/adding a tool command or moving a folder, or on /ref-admin. Replaces the retired keys-add + files-add skills (2026-07-29); renamed from ref-add 2026-08-02 (ref-skill was rejected as the new name — that's the live terminal lookup for ref/skill.md, a different thing).
---

# ref-admin — maintain the ref cards

`ref <card> [word …]` glow-renders hand-kept reference cards as box tables, filtered by words in section titles. `ref --cards` is the live card list — this skill deliberately does not copy it. This skill is how to **add to them correctly**.

## This skill is the arbiter for BOTH families (2026-08-05)
`ref` and `notes` are two **engines**, not two formats. ref cards say what a *tool does*; notes cards (`~/.dotfiles/notes/*.md`, `bin/notes`, `notes-<card>`) explain what a thing *means*. **The dialect below governs both** — table form, group markers, no per-row spacers, 46-char cells, `[e]` blocks, `doc:` folds, section titles as the filter.

`ref --lint` lints `notes/*.md` too. A card is not done until it passes, whichever family it is.

**Do not invent a second dialect for a new family.** It was tried on 2026-08-04 — notes was exempted on the grounds that a 46-char cell is right for keybinds and wrong for prose. Wrong call: prose lives in the paragraphs *around* the table, exactly as `ref/yazi.md` already does it, and the cells stay glance-length regardless. Two ways to express the same thing always drift.

## The files
| File | Role |
|---|---|
| `~/.dotfiles/ref/<card>.md` | **the data** — one file per card; the only thing you touch to add an entry |
| `~/.dotfiles/notes/<card>.md` | same dialect, the `notes` family — concepts rather than tools |
| `~/.dotfiles/files/folders.md` | the `files` card — paths; also feeds the `to` jumper |
| `~/.dotfiles/bin/ref` | the engine (registry `card_def()` · word filter · glow render · `--lint` for both families). Touch only to add a whole card |
| `~/.dotfiles/bin/notes` | the notes engine — no registry, the directory IS the card list |
| `docs/scripts/ref-system/` | the system docs — `02-cards.md` is the authoring law in full |
| `docs/scripts/notes-system.md` | the notes family's own record |

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
- **Cells stay glance-length** — a sentence in a cell is a doc in a table costume; depth is EVICTED to the `doc:` fold target (moved there first, never dropped). **This holds for a notes card too**: the explanation goes in the paragraphs above and below the table, never inside a cell.
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
3. Card — **five** edits for `ref`, **two** for `notes`:
   - `ref`: data file in `ref/` + `card_list()` + `card_def()` + a `usage()` row + a 3-line `bin/ref-<card>` alias. The easiest to miss is `card_list()`, because a card omitted there still prints by name while being invisible to `ref --cards` and `ref-pick`.
   - `notes`: data file in `notes/` + a 3-line `bin/notes-<card>` alias. **No registry** — `bin/notes` reads the directory, so there is nothing to keep in sync.
4. **Verify — run the check, don't promise it:**
   ```sh
   ref --lint
   ref <card> <word>      # or: notes-<card> <word>
   ```
   `ref --lint` is the dialect as a **machine check** (`bin/ref`, python3 — macOS awk
   counts bytes, and these cards are full of `·` and `→`). It covers `ref/*.md`,
   `files/folders.md` **and `notes/*.md`**, and fails on a per-row spacer, a cell over
   **46 characters**, a `doc:` target that doesn't exist, and a card with no
   `## section`. **A card is not done until the lint passes**, whichever family it
   belongs to. For the files card also confirm `to <word>` still reaches it.

## The discipline
Cards are hand-kept copies of what's really bound/installed — when a config changes, the card changes in the **same edit** (the repo's sync-docs rule). Read the config, don't guess.
