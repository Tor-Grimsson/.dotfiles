# yazi — quick reference

Filter: `ref-yazi <word …>` · the daily-driver file manager · vi grammar

## yazi — keys

vi grammar · daily driver

| keys      | does                                 |
|-----------|--------------------------------------|
| **## ops**    |                                  |
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
|           |                                       |
| **## select** |                                  |
| Space     | toggle selection                     |
| C-a · C-r | select all / invert                  |
| v · V     | visual: add / remove                 |
| Esc       | clear / exit visual                  |
|           |                                       |
| **## nav**    |                                  |
| h · l       | parent / enter dir                 |
| H · L       | history back / forward             |
| gg · G      | top / bottom                       |
| z · Z       | jump via fzf / via zoxide          |
| gh gd gc    | go: home · Downloads · .config     |
| gD g. gt gp | go: Desktop · dotfiles · _temp · dev-projects |
| gf          | follow the hovered symlink         |
|           |                                       |
| **## copy**   |                                  |
| cc   | copy full path                       |
| cd   | copy directory path                  |
| cf   | copy filename                        |
| cn   | copy filename, no extension          |
|           |                                       |
| **## find**   |                                  |
| f     | filter list (live)                  |
| / · ? | find next / previous by name        |
| s · S | search by name (fd) / content (rg)  |
|           |                                       |
| **## view**   |                                  |
| .       | toggle hidden files                |
| Tab     | spot — metadata/preview popup      |
| C-y     | Quick Look                         |
| M       | markdown fullscreen (mdcat)        |
| T       | maximize / restore preview         |
| ,m ,s ,a | sort: mtime · size · alpha (,d reset) |
|           |                                       |
| **## tabs**   |                                  |
| tt · tr | new tab · rename tab                |
| 1 … 9   | switch to tab N                     |
| [ · ]   | previous / next tab                 |
|           |                                       |
| **## quit**   |                                  |
| ; · :  | shell command (`: ` blocks)          |
| ~ · F1 | help (full keymap)                   |
| q · Q  | quit / quit without cwd-file         |

`a` — creating a folder vs a file:
Folder: name ends with / → some-folder-name/, then Enter. Supports nested paths too (a/b/c/ makes all three).
File: no trailing slash → some-file.txt, then Enter.

----
doc: docs/documentation/02-file-management/02-yazi.md

## md-preview — yazi markdown-preview modes

`bin/md-preview` · frontmatter is visible or not

| keys / cmd | does                                 |
|------------|--------------------------------------|
| **## switch** |                                   |
| prefix v   | cycle mode, reports it in status bar |
|            | move cursor off the file + back      |
|            | to redraw a running yazi             |
|            |                                       |
| **## modes** |                                    |
| full       | frontmatter block + mdcat (default)  |
| mdcat      | plain mdcat, frontmatter hidden      |
| glow       | plain glow, ref-card styling         |
|            |                                       |
| **## cmd** |                                      |
| md-preview --mode  | print current mode           |
| md-preview --cycle | switch, print the new one    |
| MD_PREVIEW_PAD=N   | left inset, default 2        |

Both renderers DROP color when output is not a terminal, and
yazi always captures the pane — mdcat needs `--ansi`, glow needs
`CLICOLOR_FORCE=1`. Without them the preview is flat grey.

Mode persists in `~/.cache/md-preview.mode`, read per render.

----
doc: docs/documentation/02-file-management/02-yazi.md
