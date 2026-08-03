# explorer — quick reference

Filter: `ref-explorer <word …>` · `[e]` = example · broot · the trial survey · the nvim explorers point home
yazi has its own card — `ref-yazi`

## broot

verbs need the `:` (or Space) prefix — bare letters go to the search input

| keys      | does                                  |
|-----------|---------------------------------------|
| b         | launch (cd-on-quit wrapper)           |
| :pp       | print path and quit                   |
| :e        | edit in $EDITOR (nvim), back on quit  |
| Enter     | macOS open (md lands in TextEdit)     |
| ?         | help — lists verbs (prefix-less)      |

----
doc: docs/documentation/02-file-management/INDEX.md

## trial

seven installed 2026-08-01 · mouse on in all seven

| keys        | does                                       |
|-------------|--------------------------------------------|
| **## vifm**   | vi grammar · vifmrc is a .vimrc dialect  |
| :only       | one pane — set at startup here             |
| :vsplit     | second pane · :split stacks instead        |
| `Ctrl+W x`  | exchange panes · Tab flips focus           |
| :t2 · :t1   | tree at depth 2 · depth 1                  |
| :tree       | UNBOUNDED — walks the subtree, slow        |
| :rename     | edit names in $EDITOR, :w applies          |
| gh          | leave tree view from any level             |
|             |                                            |
| **## mc**     | dual-pane commander · 39 skins           |
| `Alt+,`     | flip split vertical / horizontal           |
| `Alt+T`     | cycle listing mode on this panel           |
| `Ctrl+U`    | swap the two panels                        |
| F5 · F6     | copy · move to the other panel             |
| `Ctrl+O`    | drop to the shell, same key returns        |
|             |                                            |
| **## xplr**   | Lua-defined layouts · Rust               |
| Space       | add to the selection — SURVIVES a cd       |
| `Ctrl+A`    | select all · `Ctrl+U` clear                |
| `Ctrl+C`    | copy the selection list out                |
|             |                                            |
| **## ranger** | the original miller columns · Python     |
| :set viewmode multipane | tabs side by side              |
| gn · gt     | new tab · next tab                         |
| zm          | toggle mouse · S drops to a shell          |
|             |                                            |
| **## spf**    | superfile · live panel count · Go        |
| n · w       | open another panel · close it              |
| p · m · s   | process bar · metadata · sidebar           |
| :  ·  /     | built-in command line · search             |
|             |                                            |
| **## lf**     | fastest cold start · one Go binary       |
| lf/lfrc     | the config — ratios only, no view modes    |
|             |                                            |
| **## nnn**    | smallest · ~35KB of C                    |
| 1 … 4       | switch context (its version of tabs)       |
| NNN_COLORS  | the whole config, set in .zshrc            |

----
doc: docs/operations/08-research/01-tui-file-managers.md

## in nvim

| keys | does                                       |
|------|--------------------------------------------|
| tree · oil · yazi | live in ref-nvim — `ref-nvim plugins` |
