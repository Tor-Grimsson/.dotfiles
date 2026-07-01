---
title: CLI cheatsheet
type: reference
status: active
updated: 2026-06-26
description: One-page printable keymap for the daily drivers — Neovim, tmux, yazi, fzf, AeroSpace. Keys only; each section links to the tool's full doc for the why.
aliases:
  - cli-cheatsheet
  - kol-cli
  - keymap
tags:
  - domain/shell
  - pattern/tui
covers:
  - Neovim edit grammar (verb + target), motions, find/filter/replace, surround
  - tmux prefix keys — panes, windows, sessions, copy mode
  - yazi, fzf, and AeroSpace keymaps
related:
  - "[[10-neovim-config|Neovim config (IDE setup)]]"
  - "[[11-neovim-cheatsheet|Neovim cheatsheet (beginner)]]"
  - "[[10-tmux-help|tmux help & cheat sheet]]"
  - "[[02-yazi|Yazi]]"
  - "[[12-fzf|fzf]]"
  - "[[05-aerospace|AeroSpace]]"
  - "[[04-git-github|Git & GitHub]]"
  - "[[05-network-security|Network, remote & secrets]]"
---

# CLI cheatsheet

The daily drivers on one page. **Keys only** — for the *why* and the full tables, follow the section's doc link. Built for print: read across the columns, not down. Trigger key (leader / prefix / modifier) is noted per tool.

| § | Tool | Role | Trigger | Full doc |
|---|------|------|---------|----------|
| **1** | **Neovim** | text editor | leader = `Space` | [[10-neovim-config\|config]] · [[11-neovim-cheatsheet\|beginner]] |
| **2** | **tmux** | terminal multiplexer | prefix = `Ctrl-a` | [[10-tmux-help\|help]] · [[09-tmux-tips\|tips]] |
| **3** | **yazi** | file manager | launch `y` | [[02-yazi\|yazi]] |
| **4** | **fzf** | fuzzy finder | `Ctrl-R` `Ctrl-T` `Alt-C` | [[12-fzf\|fzf]] |
| **5** | **AeroSpace** | window manager | mod = `Alt` | [[05-aerospace\|aerospace]] |

---

## 1. Neovim → [[10-neovim-config|config]] · [[11-neovim-cheatsheet|beginner]]

Leader = `Space`. **Esc** (or `jk`) → Normal mode. Lost? Press **Esc** and start over.

**Modes** · `i`/`a`/`o` → Insert · `v`/`V`/`Ctrl-v` → Visual · `:` → Command · `Esc` → Normal.

### Get in & out

| Key | Insert at | Key | Save / quit |
|---|---|---|---|
| `i` `a` | before / after cursor | `:w` | save |
| `I` `A` | line start / end | `:wq` `:x` | save + quit |
| `o` `O` | new line below / above | `:q` `:q!` | quit / discard |
| `jk` `Esc` | back to Normal | `:wqa` | save + quit all |

### Move

| Key | Moves | Key | Moves |
|---|---|---|---|
| `h j k l` | ← ↓ ↑ → | `gg` `G` | file top / bottom |
| `w` `b` `e` | word fwd / back / end | `5G` | line 5 (any number) |
| `0` `^` `$` | line start / 1st word / end | `{` `}` | paragraph ↑ / ↓ |
| `f x` `t x` | to / till char **x** (`;` `,` repeat) | `Ctrl-d` `Ctrl-u` | half-page ↓ / ↑ |
| `F x` `T x` | back to / till **x** | `%` | matching `()[]{}` |

### Edit grammar — **verb + target**

Most edits = a **verb** then a **target**. `ciw` = change inner word. `dap` = delete a paragraph. Add a count: `2dd`, `3cw`. `.` repeats the whole thing.

| Verb | Does | Verb | Does |
|---|---|---|---|
| `d` | delete (cut) | `>` `<` | indent / dedent |
| `c` | change (delete → Insert) | `=` | auto-indent |
| `y` | yank (copy) | `gU` `gu` `g~` | upper / lower / toggle case |
| `v` | select | `!` | **filter** target through a shell cmd |

| Target | inner `i` | around `a` | Target | inner `i` | around `a` |
|---|---|---|---|---|---|
| word | `iw` | `aw` | `( )` `{ }` `[ ]` `< >` | `i(` `i{` `i[` `i<` | `a(` … |
| WORD (punct-glued) | `iW` | `aW` | `" "` `' '` `` ` ` `` | `i"` `i'` `` i` `` | `a"` … |
| sentence | `is` | `as` | HTML tag | `it` | `at` |
| paragraph | `ip` | `ap` | (bare motion) | `w` `$` `}` `/pat` | also work as targets |

**Worked combos** — the ones you reach for:

| Goal | Keys | Goal | Keys |
|---|---|---|---|
| change a word | `ciw` | delete inside `( )` | `di(` / `dib` |
| delete a word (+space) | `daw` | change inside `{ }` | `ci{` / `ciB` |
| copy a word | `yiw` | yank inside `[ ]` | `yi[` |
| change to end of line | `C` (=`c$`) | change inside quotes | `ci"` |
| delete to end of line | `D` (=`d$`) | delete a sentence | `das` |
| delete / copy whole line | `dd` / `yy` | delete a paragraph | `dap` |
| delete to char x | `dtx` / `dfx` | UPPERCASE a word | `gUiw` |
| delete to end / top of file | `dG` / `dgg` | wrap word in `"` | `ysiw"` ¹ |
| change up to search match | `c/word⏎` | replace word w/ yank | `<leader>riw` ² |
| indent a paragraph | `>ip` | join lines | `J` |

¹ surround · ² substitute — see below. **Repeat last change anywhere:** `.`

### Quick single-key edits

| Key | Does | Key | Does |
|---|---|---|---|
| `x` | delete char | `r` `R` | replace char / overtype mode |
| `s` `S` | sub char / whole line | `~` | toggle case of char |
| `p` `P` | paste after / before | `u` `Ctrl-r` | undo / redo |
| `>>` `<<` | indent / dedent line | `.` | repeat last change |

### Select (Visual)

`v` char · `V` line · `Ctrl-v` block · then a verb (`d`/`y`/`c`/`>`). `o` jump to other end · `gv` reselect last · `:'<,'>` = range over selection.

### Find · filter · replace

| Key / cmd | Does | Key / cmd | Does |
|---|---|---|---|
| `/pat` ⏎ | search fwd (`n` `N` next/prev) | `:%s/old/new/g` | replace in whole file |
| `?pat` | search back | `:%s/old/new/gc` | …confirm each (`y`/`n`) |
| `*` `#` | search word under cursor | `:'<,'>s/old/new/g` | replace within selection |
| `:noh` / `<leader>nh` | clear highlight | `:g/pat/d` | **filter:** delete lines matching |
| `:s/old/new/` | replace 1st on line | `:%!sort` | **filter:** pipe file thru `sort` |
| `:s/old/new/g` | all on current line | `!ip sort` | filter a paragraph thru `sort` |

### Surround (`nvim-surround`)

| Keys | Does | Keys | Does |
|---|---|---|---|
| `ysiw)` | surround word with `( )` | `cs"'` | change `"` → `'` |
| `yss"` | surround whole line | `ds(` | delete surrounding `( )` |
| `S"` *(visual)* | surround the selection | | |

### This config — leader shortcuts (`Space` …)

| Key | Does | Key | Does |
|---|---|---|---|
| `<leader>ee` | toggle file tree | `<leader>sv` `sh` | split vert / horiz |
| `<leader>ff` | find files | `<leader>sx` `sm` | close / maximize split |
| `<leader>fs` | live grep (project) | `Ctrl-h/j/k/l` | move between splits/panes |
| `<leader>fc` | grep word under cursor | `<leader>mp` | format file |
| `<leader>fr` | recent files | `gd` `gR` `K` | def / refs / hover (LSP) |
| `<leader>ft` | find TODOs | `<leader>rn` `<leader>ca` | rename / code action |
| `[d` `]d` | prev / next diagnostic | `<leader>lg` | LazyGit |

**Discover everything:** `<leader>fk` searches every active keymap · press `Space` and wait → which-key menu · `:Tutor` = 30-min built-in lesson.

---

## 2. tmux → [[10-tmux-help|help]] · [[09-tmux-tips|tips]]

**Prefix = `Ctrl-a`** (press, release, then the key — written `pfx`). Double-tap `Ctrl-a Ctrl-a` sends a literal Ctrl-a.

### Sessions (outlive the terminal) — mostly from the shell

| Cmd | Does | Key | Does |
|---|---|---|---|
| `tmux new -s work` | start named session | `pfx d` | detach (keeps running) |
| `tmux a -t work` | reattach (`tmux a` = last) | `pfx s` | session switcher |
| `tmux ls` | list sessions | `pfx $` | rename session |

### Windows (tabs) & Panes (splits)

| Key | Window | Key | Pane |
|---|---|---|---|
| `pfx c` | new (in cwd) | `pfx \|` | split left / right (cwd) |
| `pfx 1`…`9` | jump by number | `pfx -` | split top / bottom (cwd) |
| `pfx n` `p` | next / prev | `pfx h j k l` | move between panes |
| `pfx ,` | rename | `pfx H J K L` | resize (tap repeatedly) |
| `pfx w` | pick from list | `pfx z` | **zoom** pane (tap again to pop) |
| `pfx &` | close (confirms) | `pfx x` | close pane (confirms) |
| `pfx space` | cycle layouts | `pfx q` | flash pane numbers → tap to jump |

### Copy mode (grab scrollback) & one-offs

| Key | Does | Key | Does |
|---|---|---|---|
| `pfx [` | enter copy mode (or scroll up) | `/` `?` | search fwd / back (`n` `N`) |
| `v` | start selecting | `g` `G` | top / bottom of buffer |
| `Ctrl-v` | block select | `y` | copy → macOS clipboard, exit |
| `q` | leave copy mode | `pfx ]` | paste tmux buffer |
| `pfx r` | reload `~/.tmux.conf` | `pfx !` | break pane into its own window |

> Built-in help: `pfx ?` = every binding (scrollable) · `tmux lsk \| grep <x>` from the shell.

---

## 3. yazi → [[02-yazi|yazi]]

Launch with **`y`** (cd's the shell to wherever you quit). `q` quits · `~` help.

### Navigate & select

| Key | Does | Key | Does |
|---|---|---|---|
| `h j k l` | parent · ↓ · ↑ · open/enter | `<Space>` | toggle select + move down |
| `H` `L` | history back / fwd | `v` `V` | visual select / unselect |
| `gg` `G` | top / bottom | `<C-a>` `<C-r>` | select all / invert |
| `K` `J` | scroll preview ↑ / ↓ | `<Tab>` | spot info (metadata) |

### Act on files & jump

| Key | Does | Key | Does (custom) |
|---|---|---|---|
| `y` `x` `p` | copy · cut · paste | `<Enter>` | smart-enter (dir or open file) |
| `d` `D` | trash / delete forever | `T` | maximize preview (toggle) |
| `a` `r` | create (`/`=dir) / rename | `<C-y>` | Quick Look (macOS) |
| `f` `/` | filter listing / find by name (`n` `N`) | `o` `O` | open / open-with (pick app) |
| `s` `S` `z` `Z` | search fd · rg / jump fzf · zoxide | `.` `M` | toggle hidden / markdown full-screen |
| `g h` `g .` `g d` `g D` `g t` | goto home · dotfiles · Downloads · Desktop · _temp | `g p` `g <Space>` | projects / cd interactive |

---

## 4. fzf → [[12-fzf|fzf]]

Wired into the shell — **typing is the search**, `Enter` picks, `Esc` cancels.

| Key | Does | In-picker syntax | Matches |
|---|---|---|---|
| `Ctrl-R` | fuzzy command history | `foo` | fuzzy |
| `Ctrl-T` | insert a file path | `'foo` | exact |
| `Alt-C` | cd into a dir | `^foo` `foo$` | prefix / suffix |
| `Tab` | fzf-tab completion | `!foo` | exclude |
| `fe` | fd → fzf → open in nvim | `a b` | both (AND) |

```sh
vim "$(fzf)"                            # pick a file, open it
fd -e md | fzf                          # fuzzy-filter any list
rg --line-number . | fzf --ansi        # live-grep file contents
```

---

## 5. AeroSpace → [[05-aerospace|aerospace]]

Modifier = **`Alt`**. Tiling WM with its own fast virtual workspaces.

| Keys | Does | Keys | Does |
|---|---|---|---|
| `Alt+H/J/K/L` | focus ← ↓ ↑ → | `Alt+1`…`9` `Alt+A`…`Z` | go to workspace |
| `Alt+Shift+H/J/K/L` | move window ← ↓ ↑ → | `Alt+Shift+1`…`Z` | throw window to workspace |
| `Alt+-` `Alt+=` | resize − / + 50 | `Alt+Tab` | last workspace (back-and-forth) |
| `Alt+/` `Alt+,` | tiles / accordion layout | `Alt+Shift+Tab` | move workspace to next monitor |
| `Cmd+Alt+Shift+F` | fullscreen | `Cmd+Alt+Shift+R` | enter **resize mode** |
| `Alt+Shift+;` | enter **service mode** | `Cmd+Alt+Shift+D` | **disable** AeroSpace (`enable on` / Raycast to undo) |

**Service mode** (`Alt+Shift+;`, each returns to main): `Esc` reload · `R` reset layout · `F` float↔tile · `Backspace` close others · `Alt+Shift+H/J/K/L` join with neighbour.
**Resize mode** (`Cmd+Alt+Shift+R`): `h`/`l` width ∓50 · `j`/`k` height ±50 · `b` balance · `Enter`/`Esc` exit.

**Auto-assigned workspaces:** `T` iTerm · `B` browsers · `P` Figma/Affinity · `O` Obsidian/TextEdit · `M` Spotify/Mail · `S` Messages · `W` Finder · `A` Telegram/Todoist.

---

*Living doc — iterate here as the keymaps change. Companions: [[02-workflows|CLI workflows]] (keystroke recipes) · [[03-scripts|Scripts at a glance]] (the `bin/` family map). Symlinked into the kol-vault for print.*
