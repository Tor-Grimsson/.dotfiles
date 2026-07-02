---
title: CLI cheatsheet
type: reference
status: active
updated: 2026-07-02
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
  - Installed plugins per tool, and cross-tool integrations (yazi↔fzf/zoxide, Neovim↔yazi, tmux↔Neovim, Telescope↔fzf)
  - How to call up help inside each tool — first line of every section
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

**Stuck? Ask the tool itself:**

| Tool | Help |
|---|---|
| [[#^sec-neovim\|Neovim]] | `:help` / `:h` · `<leader>fk` (Telescope) |
| [[#^sec-tmux\|tmux]] | `pfx ?` |
| [[#^sec-yazi\|yazi]] | `~` |
| [[#^sec-fzf\|fzf]] | `fzf --help` (shell) |
| [[#^sec-aerospace\|AeroSpace]] | `aerospace --help` (shell) |

The daily drivers on one page. **Keys only** — for the *why* and the full tables, follow the section's doc link. Built for print: read across the columns, not down. Trigger key (leader / prefix / modifier) is noted per tool. **Cross-tool shortcuts** — keys where one tool actually drives another — are called out separately, right below the summary table.

| § | Tool | Role | Trigger | Full doc |
|---|------|------|---------|----------|
| **1** | **[[#^sec-neovim\|Neovim]]** | text editor | leader = `Space` | [[10-neovim-config\|config]] · [[11-neovim-cheatsheet\|beginner]] |
| **2** | **[[#^sec-tmux\|tmux]]** | terminal multiplexer | prefix = `Ctrl-a` | [[10-tmux-help\|help]] · [[09-tmux-tips\|tips]] |
| **3** | **[[#^sec-yazi\|yazi]]** | file manager | launch `y` | [[02-yazi\|yazi]] |
| **4** | **[[#^sec-fzf\|fzf]]** | fuzzy finder | `Ctrl-R` `Ctrl-T` `Alt-C` | [[12-fzf\|fzf]] |
| **5** | **[[#^sec-aerospace\|AeroSpace]]** | window manager | mod = `Alt` | [[05-aerospace\|aerospace]] |

---

## Cross-tool shortcuts

Real integrations — one tool actually driving another, not just a similar key.

| Tools | Key | Where | Does |
|---|---|---|---|
| [[#^sec-yazi\|yazi]] → fzf | `z` | in yazi | jump to a file/dir via the real `fzf` binary (yazi's built-in `fzf` plugin) |
| [[#^sec-yazi\|yazi]] → zoxide | `Z` | in yazi | jump to a frecent dir via the real `zoxide` binary (yazi's built-in `zoxide` plugin) |
| [[#^sec-neovim\|Neovim]] → yazi | `<leader>fy` | in nvim | open yazi in a floating window at the current file (`yazi.nvim`) — pick a file, land back in that buffer |
| [[#^sec-tmux\|tmux]] ↔ [[#^sec-neovim\|Neovim]] | `Ctrl-h/j/k/l` | in either | one nav key crosses tmux panes *and* nvim splits (`vim-tmux-navigator`) |
| [[#^sec-neovim\|Neovim]] ↔ fzf | *(automatic)* | Telescope | Telescope's fuzzy sorter is `telescope-fzf-native` — fzf's matching **algorithm**, natively compiled — it does **not** shell out to the real `fzf` binary |

**Not wired, on purpose:** a literal `fzf` binary inside Neovim would duplicate what Telescope + fzf-native already does natively (with previews and LSP awareness).

---

## 1. Neovim → [[10-neovim-config|config]] · [[11-neovim-cheatsheet|beginner]] ^sec-neovim

**Help:** `:help` (`:h`) opens Vim's own docs · `:h <topic>` for something specific · `:helpgrep <pat>` searches all of them · `:Tutor` = 30-min interactive lesson · `<leader>fk` (Telescope) fuzzy-searches every active keymap in *this* config. (`which-key` is installed but fully commented out — no popup on leader-wait; `<leader>fk` is the real discovery key.)

Leader = `Space`. **Esc** (or `jk`) → Normal mode. Lost? Press **Esc** and start over.

**Modes** · `i`/`a`/`o` → Insert · `v`/`V`/`Ctrl-v` → Visual · `:` → Command · `Esc` → Normal.

**Plugins:** UI — alpha, bufferline, lualine, dressing, indent-blankline · Editing — autopairs, nvim-surround, substitute, flash, vim-maximizer, todo-comments, trouble · Nav — telescope (+fzf-native), nvim-tree, auto-session, vim-tmux-navigator · Git — gitsigns, lazygit · LSP — mason (+lspconfig, tool-installer), nvim-cmp (+LuaSnip) · Format/lint — conform, nvim-lint · Syntax — nvim-treesitter (+textobjects, ts-autotag) · Theme — gruvbox-material · **disabled** (commented out) — which-key, ai (ChatGPT)

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

---

**This config's plugins, grouped below** (vanilla Vim ends here — everything above works in any nvim):

### Windows, tabs & file tree

| Key | Does | Key | Does |
|---|---|---|---|
| `<leader>sv` `sh` | split vert / horiz | `<leader>sx` `sm` | close / maximize split |
| `<leader>ee` | toggle file tree (nvim-tree) | `Ctrl-h/j/k/l` | move splits **+ tmux panes** ¹ |
| `<leader>to` `tx` `tn` `tp` | tab new / close / next / prev | | |

¹ crosses into tmux via `vim-tmux-navigator` — see **Cross-tool shortcuts** above.

### LSP, format & git

| Key | Does | Key | Does |
|---|---|---|---|
| `gd` `gR` `K` | definition / references / hover | `<leader>rn` `<leader>ca` | rename / code action |
| `[d` `]d` | prev / next diagnostic | `<leader>mp` | format file (conform, also on save) |
| `<leader>lg` | LazyGit (full TUI) | | |

### Telescope — fuzzy finder

| Key | Does | Key | Does |
|---|---|---|---|
| `<leader>ff` | find files (cwd) | `<leader>fr` | recent files |
| `<leader>fs` | live grep (cwd) | `<leader>ft` | find TODOs |
| `<leader>fc` | grep word under cursor | `<leader>fk` | search every active keymap |

**In the picker:** `Ctrl-j`/`Ctrl-k` next/prev result · `Enter` open · `Esc`/`Ctrl-c` close · `Tab` multi-select · `Ctrl-x`/`Ctrl-v` open in split/vsplit · `Ctrl-q` send to quickfix (+ opens Trouble) · `Ctrl-t` open results in Trouble.

> Powered by `telescope-fzf-native` (fzf's matching **algorithm**, compiled in) — not the `fzf` binary. See **Cross-tool shortcuts** above and [[#^sec-fzf|fzf]] below.

### yazi — from inside Neovim

| Key | Does |
|---|---|
| `<leader>fy` | open [[02-yazi\|yazi]] in a floating window at the current file (`yazi.nvim`) |

---

## 2. tmux → [[10-tmux-help|help]] · [[09-tmux-tips|tips]] ^sec-tmux

**Help:** `pfx ?` lists every binding, live and scrollable · `tmux lsk` from the shell (pipe to `grep <x>` to search one) · `man tmux` for the full manual.

**Prefix = `Ctrl-a`** (press, release, then the key — written `pfx`). Double-tap `Ctrl-a Ctrl-a` sends a literal Ctrl-a.

**Plugins:** none — deliberately plugin-free (no tpm); native detach/reattach already covers session persistence.

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

---

## 3. yazi → [[02-yazi|yazi]] ^sec-yazi

**Help:** `~` opens yazi's own in-app help (context-aware — shows the keymap for whatever mode/screen you're in) · `yazi --help` from the shell for CLI flags.

Launch with **`y`** (cd's the shell to wherever you quit). `q` quits.

**Plugins:** full-border, smart-enter, toggle-pane (vendored via `ya pkg add`) · fzf, zoxide (yazi's built-in jump plugins — shell out to the real binaries, `z`/`Z`) · mdcat (hand-written previewer, not a `ya pkg` dep) · flavor: gruvbox-dark active (catppuccin-mocha vendored alt)

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

> `O` picks by file type: **.md/.markdown** → `$EDITOR`, **glow**, **mdcat**, **nano**, Reveal, Show EXIF · **.svg** (XML/text under the hood) → `$EDITOR` + Open (system viewer) + Reveal, Show EXIF · everything else under `text/*` (html/css/jsx/json/…) → just `$EDITOR`, Reveal, Show EXIF · other images (png/jpg/…) → just Open + Reveal, Show EXIF — no editor, not text.

---

## 4. fzf → [[12-fzf|fzf]] ^sec-fzf

**Help:** no in-picker help screen · `fzf --help` from the shell for the flag list · `man fzf` (or `fzf --man`) for the full manual.

Wired into the shell — **typing is the search**, `Enter` picks, `Esc` cancels.

**Plugins:** fzf-tab (fzf-powered Tab completion, the only fzf-specific zsh plugin) — Ctrl-R/Ctrl-T/Alt-C are fzf's own built-in shell integration, not plugins.

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

**In Neovim:** Telescope (`<leader>ff`/`fs`/`fc`/`fr`/`ft`/`fk`, in the [[#^sec-neovim|Neovim]] section above) runs on `telescope-fzf-native` — fzf's matching **algorithm**, compiled in, not this `fzf` binary.

---

## 5. AeroSpace → [[05-aerospace|aerospace]] ^sec-aerospace

**Help:** no in-app overlay — it's a background WM, nothing shows on-screen · `aerospace --help` lists every subcommand · `man aerospace` for the full manual · the live keybindings only exist in `aerospace.toml`.

Modifier = **`Alt`**. Tiling WM with its own fast virtual workspaces.

**Plugins:** none — AeroSpace has no plugin system; behavior is config-only (`on-window-detected` rules + callbacks) in `aerospace.toml`.

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

**Auto-assigned workspaces:** `T` iTerm · `B` browsers · `P` Figma/Affinity · `O` Obsidian · `M` Spotify/Mail · `S` Messages · `W` Finder · `A` Telegram/Todoist.
**Always-floating** (`layout floating` via `on-window-detected`, no workspace assignment): TextEdit · Bitwarden.

---

*Living doc — iterate here as the keymaps change. Companions: [[02-workflows|CLI workflows]] (keystroke recipes) · [[03-scripts|Scripts at a glance]] (the `bin/` family map). Symlinked into the kol-vault for print.*
