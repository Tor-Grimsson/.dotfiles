# ref — the card system itself · bin/ref

Filter: `ref-ref <word …>` · the engine, its files, and where the law for
editing a card is written. The tmux prefix is `C-a`, so `pfx C-f` browses.

## ref — usage

| you type            | you get                                |
|---------------------|----------------------------------------|
| `ref-<card>`        | the whole card, every section          |
| `ref-<card> ping`   | sections whose title contains "ping"   |
| `ref-<card> a b`    | sections whose title has BOTH words    |
| `ref <card> ping`   | same — `ref-<card>` is a wrapper       |
| `ref-<card> --help` | that card's own section list           |
| `ref --lint`        | check every card against the dialect   |

words NARROW, they don't drill — every word is matched against the same
section title, case-insensitive, substring. cards have no subsections.

## ref — the card index

don't hand-copy the list anywhere; these three print the live one

| you type       | you get                                |
|----------------|----------------------------------------|
| `ref`          | the index — every card and its topics  |
| `ref --cards`  | just the names, one per line           |
| `ref-pick`     | fzf-browse card → section → read       |
| pfx C-f        | the same picker, in a tmux popup       |

## ref — where it lives

| thing        | path                                  |
|--------------|---------------------------------------|
| engine       | `bin/ref`                             |
| wrappers     | `bin/ref-<card>` — one per card       |
| picker       | `bin/ref-pick`                        |
| card data    | `ref/<card>.md`                       |
| the odd one  | files → `files/folders.md`            |
| theme        | `ref/glow-style.json`                 |
| system docs  | `docs/scripts/ref-system/`            |
| how to edit  | that folder's `02-cards.md`           |
| the skill    | `ref-admin` — same rules, for agents  |

## ref — editing a card

| step | what                                  |
|------|---------------------------------------|
| 1    | edit `ref/<card>.md` by hand          |
| 2    | obey the dialect — see the doc: fold  |
| 3    | run `ref --lint` before calling it done |

[e] lint · `ref --lint`

a NEW card is five edits, not one — the wrapper alone does nothing

| step | what                                  |
|------|---------------------------------------|
| 1    | write `ref/<card>.md`                 |
| 2    | add the name to `card_list` in `bin/ref` |
| 3    | add its line to `card_def`            |
| 4    | add a row to `usage()` — the index    |
| 5    | create `bin/ref-<card>`, chmod +x     |

## ref — the dialect, in one breath

the full law is the doc: fold — this is what `ref --lint` refuses

| rule                                | limit                     |
|-------------------------------------|---------------------------|
| second cell length                  | 46 characters             |
| blank table row                     | only before a `## ` group |
| `doc:` fold target                  | must exist on disk        |
| a card with no `## ` section        | nothing is filterable     |

bare `<angle>` tokens get swallowed by glow — always backtick them

----
doc: docs/scripts/ref-system/02-cards.md
