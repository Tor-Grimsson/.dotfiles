# explorer — quick reference

Filter: `ref-explorer <word …>` · `[e]` = example · yazi · broot · the nvim explorers point home

## yazi — ops

| keys      | does                                 |
|-----------|--------------------------------------|
| o · O     | open (default app) · open with…      |
| Enter     | smart-enter: dir / file              |
| y · x     | yank = COPY · cut = MOVE             |
| p · P     | paste · paste-overwrite              |
| y then p  | duplicate (paste in same dir)        |
| Y · X     | cancel the yank/cut mark             |
| d · D     | trash / delete permanently           |
| a · A     | create file (`/` = folder) · bulk    |
| r         | rename (cursor before extension)     |
| - · _     | symlink yanked: absolute / relative  |

## yazi — select

| keys      | does                              |
|-----------|-----------------------------------|
| Space     | toggle selection                  |
| C-a · C-r | select all / invert               |
| v · V     | visual: add / remove              |
| Esc       | clear / exit visual               |

## yazi — nav

| keys        | does                                |
|-------------|-------------------------------------|
| h · l       | parent / enter dir                  |
| H · L       | history back / forward              |
| gg · G      | top / bottom                        |
| z · Z       | jump via fzf / via zoxide           |
| gh gd gc    | go: home · Downloads · .config      |
| gD g. gt gp | go: Desktop · dotfiles · _temp · dev-projects |
| gf          | follow the hovered symlink          |

## yazi — copy

| keys | does                        |
|------|-----------------------------|
| cc   | copy full path              |
| cd   | copy directory path         |
| cf   | copy filename               |
| cn   | copy filename, no extension |

## yazi — find

| keys  | does                             |
|-------|----------------------------------|
| f     | filter list (live)               |
| / · ? | find next / previous by name     |
| s · S | search by name (fd) / content (rg) |

## yazi — view

| keys    | does                            |
|---------|---------------------------------|
| .       | toggle hidden files             |
| Tab     | spot — metadata/preview popup   |
| C-y     | Quick Look                      |
| M       | markdown fullscreen (mdcat)     |
| T       | maximize / restore preview      |
| ,m ,s ,a | sort: mtime · size · alpha (,d reset) |

## yazi — tabs

| keys    | does                      |
|---------|---------------------------|
| tt · tr | new tab · rename tab      |
| 1 … 9   | switch to tab N           |
| [ · ]   | previous / next tab       |

## yazi — quit

| keys   | does                              |
|--------|-----------------------------------|
| ; · :  | shell command (`: ` blocks)       |
| ~ · F1 | help (full keymap)                |
| q · Q  | quit / quit without cwd-file      |

----
doc: docs/documentation/02-file-management/02-yazi.md

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
| ## vifm     | vi grammar · vifmrc is a .vimrc dialect    |
| :only       | one pane — set at startup here             |
| :vsplit     | second pane · :split stacks instead        |
| `Ctrl+W x`  | exchange panes · Tab flips focus           |
| :t2 · :t1   | tree at depth 2 · depth 1                  |
| :tree       | UNBOUNDED — walks the subtree, slow        |
| :rename     | edit names in $EDITOR, :w applies          |
| gh          | leave tree view from any level             |
|             |                                            |
| ## mc       | dual-pane commander · 39 skins             |
| `Alt+,`     | flip split vertical / horizontal           |
| `Alt+T`     | cycle listing mode on this panel           |
| `Ctrl+U`    | swap the two panels                        |
| F5 · F6     | copy · move to the other panel             |
| `Ctrl+O`    | drop to the shell, same key returns        |
|             |                                            |
| ## xplr     | Lua-defined layouts · Rust                 |
| Space       | add to the selection — SURVIVES a cd       |
| `Ctrl+A`    | select all · `Ctrl+U` clear                |
| `Ctrl+C`    | copy the selection list out                |
|             |                                            |
| ## ranger   | the original miller columns · Python       |
| :set viewmode multipane | tabs side by side              |
| gn · gt     | new tab · next tab                         |
| zm          | toggle mouse · S drops to a shell          |
|             |                                            |
| ## spf      | superfile · live panel count · Go          |
| n · w       | open another panel · close it              |
| p · m · s   | process bar · metadata · sidebar           |
| :  ·  /     | built-in command line · search             |
|             |                                            |
| ## lf       | fastest cold start · one Go binary         |
| lf/lfrc     | the config — ratios only, no view modes    |
|             |                                            |
| ## nnn      | smallest · ~35KB of C                      |
| 1 … 4       | switch context (its version of tabs)       |
| NNN_COLORS  | the whole config, set in .zshrc            |

----
doc: docs/operations/08-research/01-tui-file-managers.md

## in nvim

| keys | does                                       |
|------|--------------------------------------------|
| tree · oil · yazi | live in ref-nvim — `ref-nvim plugins` |
