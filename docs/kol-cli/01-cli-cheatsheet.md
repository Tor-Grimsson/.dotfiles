---
title: CLI cheatsheet
type: reference
status: active
updated: 2026-07-09
description: One-page printable keymap for the daily drivers — Neovim, tmux, yazi, fzf, atuin, AeroSpace — plus a highlight table of the most-reached-for bin/ scripts. Keys only; each section links to the tool's full doc for the why.
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
  - yazi, fzf, atuin, and AeroSpace keymaps
  - Installed plugins per tool, and cross-tool integrations (yazi↔fzf/zoxide, Neovim↔yazi, tmux↔Neovim, Telescope↔fzf)
  - How to call up help inside each tool — first line of every section
  - A handful of frequently-used bin/ scripts (img- family so far) — flags, not the full family map
related:
  - "[[10-neovim-config|Neovim config (IDE setup)]]"
  - "[[11-neovim-cheatsheet|Neovim cheatsheet (beginner)]]"
  - "[[10-tmux-help|tmux help & cheat sheet]]"
  - "[[02-yazi|Yazi]]"
  - "[[12-fzf|fzf]]"
  - "[[25-atuin|atuin]]"
  - "[[05-aerospace|AeroSpace]]"
  - "[[04-git-github|Git & GitHub]]"
  - "[[05-network-security|Network, remote & secrets]]"
  - "[[03-scripts|Scripts at a glance (full bin/ map)]]"
  - "[[03-image|Image / 2D scripts]]"
  - "[[23-stdin-pipes|stdin, stdout & pipes]]"
---

# CLI cheatsheet

**Stuck? Ask the tool itself:**

| Tool | Help |
|---|---|
| [[01-cli-cheatsheet#1. Neovim → config · beginner|Neovim]] | `:help` / `:h` · `<leader>fk` (Telescope) |
| [[01-cli-cheatsheet#2. tmux → help · tips|tmux]] | `pfx ?` |
| [[01-cli-cheatsheet#3. yazi → yazi|yazi]] | `~` |
| [[01-cli-cheatsheet#4. fzf → fzf|fzf]] (+ atuin) | `fzf --help` · `atuin --help` (shell) |
| [[01-cli-cheatsheet#5. AeroSpace → aerospace|AeroSpace]] | `aerospace --help` (shell) |
| [[01-cli-cheatsheet#6. Scripts → all scripts|Scripts]] | `<script> -h` / `--help` (shell) |

The daily drivers on one page. **Keys only** — for the *why* and the full tables, follow the section's doc link. Built for print: read across the columns, not down. Trigger key (leader / prefix / modifier) is noted per tool. **Cross-tool shortcuts** — keys where one tool actually drives another — are called out separately, right below the summary table.

| § | Tool | Role | Trigger | Full doc |
|---|------|------|---------|----------|
| **1** | **[[01-cli-cheatsheet#1. Neovim → config · beginner|Neovim]]** | text editor | leader = `Space` | [[10-neovim-config|config]] · [[11-neovim-cheatsheet|beginner]] |
| **2** | **[[01-cli-cheatsheet#2. tmux → help · tips|tmux]]** | terminal multiplexer | prefix = `Ctrl-a` | [[10-tmux-help|help]] · [[09-tmux-tips|tips]] |
| **3** | **[[01-cli-cheatsheet#3. yazi → yazi|yazi]]** | file manager | launch `y` | [[02-yazi|yazi]] |
| **4** | **[[01-cli-cheatsheet#4. fzf → fzf|fzf]]** + atuin | fuzzy finder / history | `Ctrl-T` `Alt-C` (fzf) · `Ctrl-R` `Up` (atuin) | [[12-fzf|fzf]] · [[25-atuin|atuin]] |
| **5** | **[[01-cli-cheatsheet#5. AeroSpace → aerospace|AeroSpace]]** | window manager | mod = `Alt` | [[05-aerospace|aerospace]] |
| **6** | **[[01-cli-cheatsheet#6. Scripts → all scripts|Scripts]]** | `bin/` CLI tools | invoke by name | [[03-scripts|all scripts]] |

---

## Cross-tool shortcuts

Real integrations — one tool actually driving another, not just a similar key.

| Tools | Key | Where | Does |
|---|---|---|---|
| [[01-cli-cheatsheet#3. yazi → yazi|yazi]] → fzf | `z` | in yazi | jump to a file/dir via the real `fzf` binary (yazi's built-in `fzf` plugin) |
| [[01-cli-cheatsheet#3. yazi → yazi|yazi]] → zoxide | `Z` | in yazi | jump to a frecent dir via the real `zoxide` binary (yazi's built-in `zoxide` plugin) |
| [[01-cli-cheatsheet#1. Neovim → config · beginner|Neovim]] → yazi | `<leader>fy` | in nvim | open yazi in a floating window at the current file (`yazi.nvim`) — pick a file, land back in that buffer |
| [[01-cli-cheatsheet#2. tmux → help · tips|tmux]] ↔ [[01-cli-cheatsheet#1. Neovim → config · beginner|Neovim]] | `Ctrl-h/j/k/l` | in either | one nav key crosses tmux panes *and* nvim splits (`vim-tmux-navigator`) |
| [[01-cli-cheatsheet#1. Neovim → config · beginner|Neovim]] ↔ fzf | *(automatic)* | Telescope | Telescope's fuzzy sorter is `telescope-fzf-native` — fzf's matching **algorithm**, natively compiled — it does **not** shell out to the real `fzf` binary |

**Not wired, on purpose:** a literal `fzf` binary inside Neovim would duplicate what Telescope + fzf-native already does natively (with previews and LSP awareness).

---

## 1. Neovim → [[10-neovim-config|config]] · [[11-neovim-cheatsheet|beginner]]

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
| `gqap` / `gqq` | reflow paragraph / line to `textwidth` | `:%!par 80` | reflow whole file, balanced |
| `:` then `↑`/`Ctrl-p` | recall last `:` command (repeat, then edit) | **`q:`** | **command-line window** — full history, editable, `⏎` runs the line under cursor |

> **Reflow / wrap:** `gq` wraps to `textwidth` (`:set tw=80`) but is greedy — it can leave a one-word last line (orphan). `:%!par 80` pipes the buffer through **par** for balanced lines with no orphans; `:%!fmt -w 80` is the system-builtin greedy alt. Full walkthrough → [[02-nvim-workflows|Neovim workflows]].

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

> Powered by `telescope-fzf-native` (fzf's matching **algorithm**, compiled in) — not the `fzf` binary. See **Cross-tool shortcuts** above and [[01-cli-cheatsheet#4. fzf → fzf|fzf]] below.

### yazi — from inside Neovim

| Key | Does |
|---|---|
| `<leader>fy` | open [[02-yazi|yazi]] in a floating window at the current file (`yazi.nvim`) |

---

## 2. tmux → [[10-tmux-help|help]] · [[09-tmux-tips|tips]]

**Help:** `pfx ?` lists every binding, live and scrollable · `tmux lsk` from the shell (pipe to `grep <x>` to search one) · `man tmux` for the full manual.

**Prefix = `Ctrl-a`** (press, release, then the key — written `pfx`). Double-tap `Ctrl-a Ctrl-a` sends a literal Ctrl-a.

**Plugins:** tpm-managed — `tmux-sessionx` (`pfx O`) and `tmux-harpoon` (bookmarks, own key table `pfx a` — not `Alt` or `Ctrl+Shift`, both ruled out, see [[22-tmux-harpoon|full docs]]). Native detach/reattach still covers plain session persistence.

### Sessions (outlive the terminal) — mostly from the shell

| Cmd | Does | Key | Does |
|---|---|---|---|
| `tmux new -s work` | start named session | `pfx d` | detach (keeps running) |
| `tmux a -t work` | reattach (`tmux a` = last) | `pfx s` | session switcher |
| `tmux ls` | list sessions | `pfx $` | rename session |

### Session/project managers — [[02-tmux|full docs]]

| Key | Does | Key | Does |
|---|---|---|---|
| `pfx O` | [[20-tmux-sessionx|tmux-sessionx]] popup — vs. `sesh`, still deciding | `pfx a`, `a` | [[22-tmux-harpoon|tmux-harpoon]] — bookmark current session |
| `pfx a`, `1`…`4` | harpoon — jump to bookmark 1–4 | `pfx a`, `e` | harpoon — edit bookmark list (popup) |

Shell-only, no tmux binding: [[17-sesh|sesh]] (`sesh picker` or `sesh connect <name>` — vs. `tmux-sessionx`, still deciding), [[18-tmuxinator|tmuxinator]] (`tmuxinator start` — upfront-designed layouts) + [[19-tmuxp|tmuxp]] (`tmuxp freeze` — snapshot a layout you already built by hand), kept side by side, not a winner, and [[24-workmux|workmux]] (`workmux add <branch>` / `workmux merge` — git worktree + tmux window paired in one command).

### Popups (floating, vanish on exit)

| Key | Does | Key | Does |
|---|---|---|---|
| `pfx C-t` | scratch shell (cwd) | `pfx C-y` | [[02-yazi\|yazi]] file manager (cwd) |
| `pfx C-g` | [[03-lazygit\|lazygit]] git TUI (cwd) | `pfx C-s` | [[17-sesh\|sesh]] picker — running sessions only, switches in |
| `pfx C-n` | new session — prompts for a name, switches in | `pfx C-d` | [[02-tmux-dashboards\|layout]] picker (fzf → tmuxinator start) |
| `pfx C-b` | [[03-bookmarks\|bookmark]] picker (URL→browser, path→nvim) | `pfx B` | bookmark the current dir |
| `pfx A` | add bookmark (typed path/URL prompt) | | |

No popup from inside a popup — nested popups misbehave. `C-s`/`C-n`/`C-d` all use `switch-client`, never a raw attach from a bound key (crashed all sessions once — fixed 2026-07-08).

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
| `pfx N` `P` ¹ | move window fwd / back (repeatable) | `pfx F` `G` ¹ | move window to first / last |

¹ repo-added, not stock tmux — `N`/`P` pair with the stock `n`/`p` above (lowercase looks, uppercase takes the window with it); `F`/`G` borrow vim's `gg`/`G` start/end feel.

### Copy mode (grab scrollback) & one-offs

| Key | Does | Key | Does |
|---|---|---|---|
| `pfx [` | enter copy mode (or scroll up) | `/` `?` | search fwd / back (`n` `N`) |
| `v` | start selecting | `g` `G` | top / bottom of buffer |
| `Ctrl-v` | block select | `y` | copy → system clipboard, exit |
| `q` | leave copy mode | `pfx ]` | paste tmux buffer |
| `pfx r` | reload `~/.tmux.conf` | `pfx !` | break pane into its own window |
| `pfx m` | mark this pane (bg tint) | `pfx M` | clear the mark |

> **Search by keyword in tmux** — copy mode is also the pane's find: `pfx [` to enter → **`?keyword`** searches *back* toward earlier output (usually what you want, you're at the bottom; `/keyword` goes forward) → `n`/`N` next/prev match → `q` exits. **Use case — search a Claude conversation:** grep Claude's on-screen replies, your prompts, and tool output in one pass. Only reaches text still in scrollback; for the *whole* session grep the transcript on disk — `~/.claude/projects/<cwd-slug>/*.jsonl`.

> **>> REMOTE COPY <<** — `y` reaches your **local** clipboard even when tmux is running on a box you're SSH'd into. Steps, pane already focused:
> 1. Focus the remote pane (click it, or `pfx h/j/k/l`).
> 2. `pfx [` — enter copy mode.
> 3. Move to the start of the text (`h j k l`, or `/text⏎` to search for it).
> 4. `v` — start selecting.
> 5. Move to extend the selection to the end.
> 6. `y` — copies, exits copy mode.
> 7. `⌘V` in any local app — paste.
>
> Needs the *remote* box's `tmux.conf` to have `set -g set-clipboard on` + `allow-passthrough on` (2026-07-05) — if it's an older pulled dotfiles copy, `git pull` + `pfx r` on that box first. **Also needs iTerm2 locally** set to Always Allow clipboard access (Settings -> General -> Selection) — "Ask Each Time" silently fails with no error. **Verified working end-to-end 2026-07-05.** Full explanation: [[02-remote-dev-workflow#3. Clipboard over SSH + tmux|remote dev workflow §3]], [[01-iterm2|iTerm2 setup]].

---

## 3. yazi → [[02-yazi|yazi]]

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

**Sort/view:** `, n` natural (default) · `, a` alpha · `, e` ext · `, s` size · `, m` mtime · `, b` btime · `, r` random · add **Shift** to reverse · **`, d`** resets sort + linemode to defaults · `m s/b/m/o/p/n` sets the linemode (info column). A `,` sort is session-only — it overrides the config until you restart or hit `, d`.

### Sequences

| Flow | Keys |
|---|---|
| Copy files to another dir | mark `<Space>…` → `y` → target dir → `p` |
| Move (cut) instead | mark → `x` → target → `p` |
| Move across two open dirs | `t` new tab → open target → `1`/`2` switch → `p` |
| Bulk rename | mark → `r` → edit the list in nvim → `:wq` (all apply) |
| Browse → land the shell there | `y` → walk (`h`/`l`/`Z`/`/`) → `q` |
| Find → act | `s <name>` ⏎ → land on it → `o` / `x` / `r` |

---

## 4. fzf → [[12-fzf|fzf]]

**Help:** no in-picker help screen · `fzf --help` from the shell for the flag list · `man fzf` (or `fzf --man`) for the full manual.

Wired into the shell — **typing is the search**, `Enter` picks, `Esc` cancels.

**Plugins:** fzf-tab (fzf-powered Tab completion, the only fzf-specific zsh plugin) — Ctrl-T/Alt-C are fzf's own built-in shell integration, not plugins. **Ctrl-R now belongs to atuin** (below) — its init sources after fzf's in `.zshrc` and wins the bind.

| Key | Does | In-picker syntax | Matches |
|---|---|---|---|
| `Ctrl-T` | insert a file path | `foo` | fuzzy |
| `Alt-C` | cd into a dir | `'foo` | exact |
| `Tab` | fzf-tab completion | `^foo` `foo$` | prefix / suffix |
| `fe` | fd → fzf → open in nvim | `!foo` | exclude |

```sh
vim "$(fzf)"                            # pick a file, open it
fd -e md | fzf                          # fuzzy-filter any list
rg --line-number . | fzf --ansi        # live-grep file contents
```

**In Neovim:** Telescope (`<leader>ff`/`fs`/`fc`/`fr`/`ft`/`fk`, in the [[01-cli-cheatsheet#1. Neovim → config · beginner|Neovim]] section above) runs on `telescope-fzf-native` — fzf's matching **algorithm**, compiled in, not this `fzf` binary.

### atuin → [[25-atuin|atuin]]

**Help:** `atuin --help` (subcommands) · no in-picker help screen.

SQLite-backed shell history — replaces plain reverse-i-search with a scoped fuzzy picker. Config: `atuin/config.toml`.

| Key | Does |
|---|---|
| `Ctrl-R` | search history (global scope); press again to cycle scope (global/host/session/dir) |
| `Up` | search scoped to the current directory |
| `Ctrl-S` | cycle search mode (fuzzy/prefix/fulltext/skim) |
| `Enter` | run the selected command |
| `Tab` | paste it into the prompt instead of running |
| `Ctrl-O` | inspector (exit code, duration, cwd, host) |
| `Ctrl-A d` / `Ctrl-A D` | prefix: delete this entry / delete all matching |

```sh
atuin stats           # top commands, usage patterns
atuin import auto      # one-time backfill from existing shell history
```

Sync (`atuin register`/`login`, encrypted, multi-machine) is opt-in and not enabled here yet.

---

## 5. AeroSpace → [[05-aerospace|aerospace]]

**Help:** no in-app overlay — it's a background WM, nothing shows on-screen · `aerospace --help` lists every subcommand · `man aerospace` for the full manual · the live keybindings only exist in `aerospace.toml`.

Modifier = **`Alt`**. Tiling WM with its own fast virtual workspaces.

**Plugins:** none — AeroSpace has no plugin system; behavior is config-only (`on-window-detected` rules + callbacks) in `aerospace.toml`.

Modifier is **`Ctrl+Alt`** (bare `Alt` is left free for the terminal — fzf `Alt+C`, word-nav, tmux `prefix Alt+1..5`). `Cmd+Alt` macros unchanged.

| Keys | Does | Keys | Does |
|---|---|---|---|
| `Ctrl+Alt+H/J/K/L` | focus ← ↓ ↑ → | `Ctrl+Alt+1`…`9` `Ctrl+Alt+A`…`Z` | go to workspace |
| `Ctrl+Alt+Shift+H/J/K/L` | move window ← ↓ ↑ → | `Ctrl+Alt+Shift+1`…`Z` | throw window to workspace |
| `Ctrl+Alt+-` `Ctrl+Alt+=` | resize − / + 50 | `Ctrl+Alt+Tab` | last workspace (back-and-forth) |
| `Ctrl+Alt+/` `Ctrl+Alt+,` | tiles / accordion layout | `Ctrl+Alt+Shift+Tab` | move workspace to next monitor |
| `Cmd+Alt+G` | **2×2 grid** (4-win macro) | `Cmd+Alt+S` | **main+stack** (4-win macro) |
| `Cmd+Alt+Shift+F` | fullscreen | `Cmd+Alt+Shift+R` | enter **resize mode** |
| `Ctrl+Alt+Shift+;` | enter **service mode** | `Cmd+Alt+Shift+D` | **disable** AeroSpace (`enable on` / Raycast to undo) |

**Service mode** (`Ctrl+Alt+Shift+;`, each returns to main):

| Key | Does | Key | Does |
|---|---|---|---|
| `Esc` | reload config, exit | `f` | float ↔ tile |
| `r` | reset layout | `Backspace` | close all but current |
| `Alt+Shift+H/J/K/L` | join with neighbour | | |

> Service-mode keys are bare — no Shift. `Shift+F` isn't a service-mode binding at all; it collides with the main-mode `Ctrl+Alt+Shift+F` (throw window to workspace **F**), which just relocates the window rather than closing it — looks like a "kill" because the other window then expands to fill the screen.

**Resize mode** (`Cmd+Alt+Shift+R`, stays in mode until exit):

| Key | Does | Key | Does |
|---|---|---|---|
| `h` / `l` | width − / + 50 | `b` | balance sizes |
| `j` / `k` | height + / − 50 | `Enter` / `Esc` | exit |

**Auto-assigned workspaces:** `T` iTerm · `B` browsers · `P` Figma/Affinity · `O` Obsidian · `M` Spotify/Mail · `S` Messages · `W` Finder · `A` Telegram/Todoist.
**Always-floating** (`layout floating` via `on-window-detected`, no workspace assignment): TextEdit · Bitwarden · Claude.

---

## 6. Scripts → [[03-scripts|all scripts]]

**Help:** every script answers `-h` / `--help` with purpose, args, and examples — that's always the authoritative source. This table is a **highlight**, not the full map: img-, ss- and pdf- so far, more families added as they come up. Full `bin/` catalog: [[03-scripts|Scripts at a glance]].

| Script | Does | Key flags |
|---|---|---|
| `img-convert.sh` | any image/PDF → JPG/PNG, fit 2000px | `-f jpg\|png` · `-r` geom · `-e` force exact WxH · `-c` colors (PNG quantize, flat art only) · `-d` dpi (PDF) · `-a` all pages |
| `img-from-video.sh` | grab one video frame → JPG/PNG | `-t` frame # (bare int, 1-based) or timestamp (`HH:MM:SS`/decimal) · `-f` jpg\|png · `-r` geom · `-e` force exact WxH |
| `img-canvas.sh` | fit an image into a fixed-aspect canvas, exact pixels always | `-a` preset (`9:16`…`16:9`) or raw `WxH` · `-s 1\|2` scale · `-m cover\|fit\|stretch` · `-g` gravity · `-c` colors (PNG quantize) |
| `ss-save.sh` | save the clipboard image → PNG file (via pngpaste) | arg1 `NAME` (default `clip_<ts>`, `.png` auto-added) · arg2 `DIR` (default cwd, `~` ok, `mkdir -p`) — two **separate** positional args, name then dir |
| `pdf-from-md.sh` | Markdown → **A4 PDF** (Pandoc) | `-e typst\|weasyprint` engine (default typst) · `-w` watch · batch (`*.md` or args) |
| `os-mode.sh` / `theme-alarm.sh` | theme toggle + clock-time wake-alarm bundle | `Cmd+Alt+Shift+T` toggle theme · `Cmd+Alt+Shift+A` run wake-alarm test (both Raycast hotkeys — see [[18-appearance|Appearance & wake automation]]) |

> `-t` on `img-from-video.sh` is two modes in one flag: a bare integer (`-t 23`) is always a **frame number**, never seconds — for a timestamp use `HH:MM:SS` or a decimal (`-t 5.5`).
> `-e` on `img-convert.sh`/`img-from-video.sh` forces the literal `WxH` you asked for (crop/pad, no distortion) — plain `-r` is fit-inside and can land short on one axis from aspect-ratio rounding. `img-canvas.sh` does this by default (that's its whole job) plus aspect presets and a resolution multiplier — reach for it directly when you want presets, reach for `-e` when you already know the exact `WxH` and want to keep using `img-convert.sh`'s other flags (`-c`, `-d`, `-a`).

**A clean, standardized export** — pair `-e` with an [[img-canvas|export-specs]] size (short-side-1080 table: `4:5`→`1080x1350`, `1:1`→`1080x1080`, `9:16`→`1080x1920`, …) instead of an arbitrary number:

```sh
img-convert.sh -r 1080x1350 -e -f png -c 256 art.png   # 4:5 @1x, exact, quantized
img-from-video.sh -r 1080x1350 -e clip.mp4             # 4:5 @1x, exact, from a video frame
```

**`-c` vs `-q` — not an even split.** `-c` (palette colors) is the real size *and* quality lever for PNG — lossy, reduces color precision, dominates file size. `-q` on PNG is zlib compression *effort* only — always lossless, a few % at most, never visible. On jpg it flips: no `-c` (no palette concept), so `-q` becomes the real lossy lever.

Measured floor on a 1600×2000 flat illustration (~4 real colors + AA noise) — not a universal number, eyeball your own source before shipping low:

| `-c` | Size | Visible loss |
|---|---|---|
| 256 | 0.69 MB | none — safe default regardless of source |
| 64 | 0.50 MB | none |
| 32 | 0.39 MB | none |
| 16 | 0.33 MB | none, at normal viewing size |
| 8 | 0.25 MB | none for *this* source — sources with real gradients band much earlier |

---

## Shell aliases

**Help:** custom shortcuts defined in `shell/.zshrc` (repo-tracked) — not tool keymaps. Run a command with no args, or read the source.

| Command | Does |
|---|---|
| `cl` | `claude` — launch Claude Code |
| `cc` | `clear` — clear the terminal |
| `llm "..."` | one-shot question to an LLM — see the **4-part `llm` family** below |
| `cllm "..."` | `llm -c` — continue the previous [[09-llm|llm]] conversation |
| `llmc` | `llm chat` — interactive llm REPL |
| `cat file \| llm "..."` | pipe a file/command's output in as context (see below) |
| `reveal [PATH]` | open Finder at PATH (default: current dir); a file is selected in its folder |
| `reveal -f [PATH]` | new **floating** Finder window on the *current* AeroSpace workspace — bypasses the blanket Finder→W rule (`fs-reveal.sh`, see [[01-cli-cheatsheet#6. Scripts → all scripts|Scripts]]) |

### llm → [[09-llm|full doc]]

**Help:** `llm --help` · `llm prompt --help` for every prompting flag.

| Command | Does |
|---|---|
| `llm "..."` | one-shot question, prints and exits |
| `llm chat` / `llmc` | interactive REPL — stays open until `exit`/Ctrl-D |
| `llm -c "..."` / `cllm "..."` | continue the previous conversation (logged to SQLite) |
| `cat file \| llm "..."` | pipe file/command output in as context — no flag needed |

Piping feeds *content* into one prompt; `-c`/`cllm` continues *conversation memory* across separate calls — different things, both native, no custom system needed.

### Location shortcuts (g-nav) → `shell/functions/g-nav.zsh`

Mirrors yazi's `g`-keybinds at the shell level. Zsh **functions** (not aliases — they take flags; not scripts — a script's `cd` can't reach the parent shell, same reason the `y()` yazi wrapper needs a temp-file). `<cmd> -h` shows a command's own target flags.

**Shared flags — same on every command below:**

| Flag | Does |
|---|---|
| *(none)* | `cd` there |
| `-l` | `cd` + `ls` |
| `-e` | open in nvim |
| `-c` | copy path to clipboard |
| `-p` | print path, no `cd` |
| `-h` | this command's help |

| Command | Target | Extra flags |
|---|---|---|
| `ghome` | `~` | `--desktop` `--downloads` `--documents` |
| `gdot` | `~/.dotfiles` | `--shell` `--nvim` `--yazi` `--tmux` `--claude` `--aerospace` `--docs` `--bin` |
| `zshrc` | `~/.dotfiles/shell/.zshrc` (a file — own verbs) | `-e` edit · `-s` `source ~/.zshrc` · `-c`/`-p` as shared · default = print path |
| `gdev` | `~/dev` | `--monorepo` `--studio` `--typefaces` `--dashboard` `--chords` `--imweb` `--kclaude` |
| `gobs` | `~/dev/projects/kol-vault` | `-a`/`--app` open in Obsidian.app |
| `gapparat` | `~/dev/projects/kol-apparat` | `-1`…`-12`, alphabetical (`-h` lists names) |
| `gclient` | `~/dev/projects/kol-client` | `-1`…`-8`, alphabetical (`-h` lists names) |
| `gicloud` | iCloud Drive root | `--workbox` (used often) |

**Renamed from the original ask to avoid real collisions:** `gh`→`ghome` (`gh` is the GitHub CLI binary), `zsh`→`zshrc` (`zsh` is the shell itself), `gcloud`→`gicloud` (it's iCloud, not Google Cloud — also sidesteps a future collision if the real `gcloud` CLI ever gets installed). `gd`→`gdot` was already the plan, sidesteps the existing `gd='git diff'` alias.

> **>> GIT: STOP TRACKING A FILE'S LOCAL DRIFT <<** — a foreign/disposable box where some tool rewrites a tracked file (nvim's `lazy-lock.json` on first launch) makes `git status` dirty for a change you never made and don't want to push:
> ```sh
> git update-index --skip-worktree <file>     # this clone only, reverse: --no-skip-worktree
> git ls-files -v | grep '^S'                  # list every file currently skip-worktree'd
> ```
> Only silences `status`/`diff` — a pull/rebase that needs to touch a drifted skip-worktree'd file **aborts outright** rather than overwriting it (tested live). If that's blocking your pull: `--no-skip-worktree` it, reset/stash just that file, pull, restore, re-flag. Full reference: [[04-git-github#2. Everyday git — by task|Git & GitHub]].

---

*Living doc — iterate here as the keymaps change. Companions: [[02-nvim-workflows|Neovim workflows]] (text handling) · [[03-scripts|Scripts at a glance]] (the `bin/` family map). Symlinked into the kol-vault for print.*
