# nvim — daily driver · ~/.dotfiles/nvim (lua/grim) · leader = Space

The daily config, mode-first. Filter by any word in a section title:
`ref-nvim insert` · `ref-nvim plugins git` · `ref-nvim mac` · `ref-nvim drill`

## Porting paths — into a running nvim (sockets)

The first nvim opened in a tmux session answers at a predictable address —
port files into it from any pane, they open as new tabs.

| command                 | does                                          |
|-------------------------|-----------------------------------------------|
| nvim-port `<path>`      | open path as a new tab there, focus the pane  |
| nvim-port               | same, path taken from the clipboard           |
| nvim-port --help        | needs + gotchas                               |

| the plumbing      | fact                                                   |
|-------------------|--------------------------------------------------------|
| the address       | /tmp/nvim-`<session>`.sock            |
| who creates it    | the zshrc nvim() wrapper, first only  |
| who shows it      | the nvim statusline, right side       |
|                   | no badge = not addressable            |
| lifetime          | gone when that nvim exits             |
| raw form          | nvim --server `<socket>` --remote-tab `<path>`         |

from broot: `:pp` the path, then `nvim-port` — clipboard carries it over.

----
doc: docs/scripts/nvim-port.md

## Modes

| enter       | mode     | for                                        |
|-------------|----------|--------------------------------------------|
| (home base) | NORMAL   | moving + editing — where you should rest   |
| i  a  o     | INSERT   | typing: before / after cursor / line below |
| I  A  O     | INSERT   | typing: line start / line end / line above |
| v  V  C-v   | VISUAL   | selecting: chars / whole lines / block     |
| :           | COMMAND  | one-off commands — :w  :q  :s/…            |
| Esc  ·  jk  | → NORMAL | the way back — jk only from insert         |

which mode for what: read/navigate → NORMAL · type → INSERT ·
select or move text → VISUAL (V for lines) · save/quit → COMMAND

## Modes — traps

"a mode turned on and won't turn off" — recognize it, get out:

| statusline / symptom                     | you're in            | out                  |
|------------------------------------------|----------------------|----------------------|
| -- INSERT -- · keys type literally       | insert               | Esc or jk            |
| -- VISUAL -- · motions grow a highlight  | visual               | Esc                  |
| -- SELECT -- · typing REPLACES selection | select mode          | Esc                  |
| recording @q in the statusline           | macro recording      | q                    |
| selection keeps growing on C-Space       | treesitter select    | Esc (Bksp = shrink)  |
| a window full of old : commands          | command history (q:) | :q then Enter        |

## Insert mode

in: `i a o I A O` (see Modes) · out: `Esc` or `jk`

| keys        | does                                    |
|-------------|-----------------------------------------|
| C-w         | delete word BEFORE cursor               |
| C-u         | delete to line start                    |
| C-o {cmd}   | ONE normal command, back to insert      |
| Tab  S-Tab  | hop snippet fields (snippet active)     |
| C-Space     | completion menu (cmp)                   |
| C-j  C-k    | completion: next / prev suggestion      |
| Enter       | completion: accept — C-e closes         |
| C-b  C-f    | completion: scroll docs                 |
| C-s         | LSP signature help                      |

## Normal mode — moving

| keys       | does                                 |
|------------|--------------------------------------|
| h j k l    | ← ↓ ↑ →                              |
| w  b  e    | word forward / back / to word end    |
| 0  ^  $    | line start / first char / line end   |
| gg  G  5G  | file top / bottom / line 5           |
| f{c} t{c}  | jump to / till char — ; , repeat     |
| C-d  C-u   | half page down / up (centered)       |
| n  N       | next / prev search hit (centered)    |
| %          | matching bracket                     |
| s          | flash: 2 chars, hit the label        |
| C-h/j/k/l  | hop splits — and on into tmux panes  |

## Normal mode — editing

| keys              | does                                   |
|-------------------|----------------------------------------|
| d  c  y  + motion | delete / change / yank — dw  cw  y$    |
| dd  yy  cc        | whole line                             |
| D  C              | delete / change to line end            |
| ciw  daw  yiw     | inner word / word + space / yank word  |
| ci(  ci"  cit     | change inside ( )  " "  `<tag>`        |
| p  P              | paste after / before                   |
| u  C-r  .         | undo / redo / repeat last change       |
| J                 | join line below (cursor stays)         |
| >  <  =           | indent / dedent / auto-indent          |
| gcc  gc{motion}   | comment line / motion                  |
| ys  ds  cs        | surround add / delete / change         |
| `<leader>`r rr R  | substitute motion / line / to eol      |
| `<leader>`s       | replace cursor word in whole file      |
| `<leader>`+  -    | number up / down (C-a = tmux prefix)   |
| `<leader>`nh      | clear search highlight                 |
| x                 | delete char — skips the yank register  |

yanks also land in the mac clipboard (`clipboard = unnamedplus`)

## Visual mode

in: `v` chars · `V` lines · `C-v` block · out: `Esc`

| keys       | does                                  |
|------------|---------------------------------------|
| any motion | grows the selection (w  $  }  …)      |
| o          | jump to other end of selection        |
| y  d  c    | copy / delete / change selection      |
| p          | paste OVER selection — yank survives  |
| J  K       | MOVE selected lines down / up         |
| >  <       | indent — selection stays              |
| gc         | comment selection                     |
| S          | flash treesitter select               |
| C-Space    | grow by syntax node — Bksp shrinks    |

## Command mode — save · quit · the : line

`:` opens the command line at the bottom · Enter runs it · Esc abandons it

| type     | reads as       | does                                  |
|----------|----------------|---------------------------------------|
| :w       | write          | save the file                         |
| :q       | quit           | close — refuses if unsaved changes    |
| :q!      | quit, force    | close and DISCARD unsaved changes     |
| :wq  :x  | write-quit     | save, then close (:x = same, shorter) |
| :wqa     | write-quit-all | save + close everything               |
| :noh     | no-highlight   | clear leftover search highlight       |
| :redraw! | redraw         | repaint the screen (ghost cleanup)    |

the syntax composes: w write · q quit · a all · ! force —
:wqa = write-quit-all, :q! = quit-force. You read these, you don't memorise them.

## Mac muscle memory → the nvim way

| you reach for              | NORMAL mode          | INSERT mode               |
|----------------------------|----------------------|---------------------------|
| opt+← opt+→ · word jump    | b  /  w              | C-o b  /  C-o w  (or Esc) |
| cmd+← cmd+→ · line ends    | 0  /  $              | C-o 0  /  C-o $           |
| opt+delete · del word ←    | db  ·  daw           | C-w                       |
| opt+fn+delete · del word → | dw                   | C-o dw                    |
| cmd+delete · kill line ←   | d0                   | C-u                       |
| shift+arrows · select      | v + motions (V = ln) | Esc, then v               |
| cmd+c  cmd+v               | y  /  p              | (terminal paste works)    |
| cmd+z                      | u  (C-r = redo)      | Esc, then u               |

## Drill — what the fingers are training

| goal                   | do                                    |
|------------------------|---------------------------------------|
| jump words             | w  w  w · b back · e to word end      |
| line start / end       | 0  /  $                               |
| select + copy + paste  | v → motions → y → move → p            |
| grab lines + move them | V → j/k extends → J / K → Esc         |
| change a word          | ciw — from anywhere in the word       |
| delete a word          | daw                                   |
| get out of anything    | Esc (insert: jk)                      |

## Plugins — find & files

| plugin    | keys               | does                                  |
|-----------|--------------------|---------------------------------------|
| telescope | `<leader>`ff  fr   | find files · recent files             |
| telescope | `<leader>`fs  fc   | grep project · grep word at cursor    |
| telescope | `<leader>`fk  ft   | search every keymap · todo comments   |
| harpoon   | `<leader>`a   C-e  | bookmark file · the 4-slot menu       |
| harpoon   | C-y C-i C-n C-s    | jump slot 1 · 2 · 3 · 4               |
| harpoon   | C-S-p  C-S-n       | prev / next slot                      |
| nvim-tree | `<leader>`ee  ef   | file tree · tree at current file      |
| nvim-tree | `<leader>`ec  er   | collapse · refresh                    |
| oil       | -                  | folder as editable text — :w applies  |
| yazi      | `<leader>`fy       | yazi at current file                  |

## Plugins — git

| plugin   | keys             | does                      |
|----------|------------------|---------------------------|
| gitsigns | ]h  [h           | next / prev hunk          |
| gitsigns | `<leader>`hs hr  | stage / reset hunk        |
| gitsigns | `<leader>`hS hR  | stage / reset buffer      |
| gitsigns | `<leader>`hp hu  | preview hunk · undo stage |
| gitsigns | `<leader>`hb hB  | blame line · line blame   |
| gitsigns | `<leader>`hd hD  | diff · diff ~             |
| lazygit  | `<leader>`lg     | the whole git TUI         |

## Plugins — code intel

| plugin   | keys              | does                                |
|----------|-------------------|-------------------------------------|
| lsp      | gd  gD            | definition / declaration            |
| lsp      | grr  gri          | references / implementation         |
| lsp      | grn  gra          | rename · code action                |
| lsp      | grt  gO           | type definition · doc symbols       |
| lsp      | K                 | hover docs                          |
| lsp      | ]d  [d            | next / prev diagnostic              |
| trouble  | `<leader>`xw  xd  | workspace / document diagnostics    |
| trouble  | `<leader>`xq  xl  | quickfix / loclist                  |
| trouble  | `<leader>`xt      | todos — ]t [t jump todo comments    |
| conform  | `<leader>`mp      | format file or range (n + v)        |
| nvim-lint| `<leader>`l       | lint buffer                         |

these are nvim's default LSP keys — the old gd/gR/`<leader>`rn list is gone with the old config

## Markdown — md prose

Not a plugin — `after/ftplugin/markdown.lua`, 11 lines, buffer-local.
Every .md buffer gets these on open; nothing to enable.

| keys           | does                                          |
|----------------|-----------------------------------------------|
| `<leader>`mm   | markdown mode ON THIS BUFFER — scratch notes  |
| `<leader>`md   | toggle conceal — raw markup ⇄ concealed prose |
| `<leader>`mp   | format with prettier (conform, n + v)         |

| on open      | value                                            |
|--------------|--------------------------------------------------|
| conceallevel | 2 — tokens hidden (`<leader>`md flips) |
| wrap         | true — OVERRIDES the global wrap = false         |
| textwidth    | 80                                               |

the trigger is the FILETYPE, not the filename and not saving. A `:enew`
notepad has ft="" so it gets nothing — `<leader>`mm sets it and the whole
ftplugin fires at once, unsaved. Same trick $EDITOR handoffs use: they mint
a temp file WITH a .md extension so detection does it for them.

treesitter parses it (markdown + markdown_inline). No md LSP (no marksman
in mason) and no render/preview plugin — conceal is the whole prose view.

----
doc: nvim/after/ftplugin/markdown.lua

## Plugins — editing power-ups

cross-listed in the mode sections — collected here per plugin:

| plugin     | keys              | does                                 |
|------------|-------------------|--------------------------------------|
| surround   | ys  ds  cs        | add / delete / change surround       |
| substitute | `<leader>`r rr R  | substitute motion / line / to eol    |
| flash      | s  S              | jump by label · treesitter select    |
| flash      | r  R              | remote / search (operator mode)      |
| comment    | gcc  gc           | comment line / motion / selection    |
| treesitter | C-Space  Bksp     | grow / shrink selection by node      |
| treesitter | ]n [n · ]N [N     | next/prev node · sibling (visual)    |

## Plugins — workspace

| plugin         | keys                  | does                             |
|----------------|-----------------------|----------------------------------|
| splits         | `<leader>`sv  sh      | vertical / horizontal split      |
| splits         | `<leader>`se  sx      | equalize · close split           |
| maximizer      | `<leader>`sm          | maximize / restore split         |
| tabs           | `<leader>`to  tx      | tab open · close                 |
| tabs           | `<leader>`tn  tp  tf  | next · prev · buffer → tab       |
| auto-session   | `<leader>`wr  ws      | restore · save session (cwd)     |
| tmux-navigator | C-h/j/k/l · `C-\`     | splits + tmux panes · previous   |

tmux-navigator shadows nvim's redraw on C-l — use `:redraw!`

## Setup & admin

| task                | how                                                        |
|---------------------|------------------------------------------------------------|
| find any bind, live | `<leader>`fk — Telescope, every keymap |
| plugin manager      | :Lazy — status / install / update                          |
| LSP installer       | :Mason — language servers live here                        |
| health              | :checkhealth — run when something feels broken             |
| config location     | ~/.dotfiles/nvim → lua/grim/           |
| leader              | Space — `<leader>`x = Space, then x    |
| reload config       | quit + reopen — auto-session restores  |
| increment trap      | C-a is tmux — use `<leader>`+ / -      |

----
doc: docs/documentation/04-dev-languages/10-neovim-config.md
