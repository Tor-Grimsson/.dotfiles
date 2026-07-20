# nvim — the daily config (~/.dotfiles/nvim/, lua/grim). leader = space. (nmix merged in 2026-07-20)

## #setup
sibling       ref-nnow (the from-scratch build)
<leader>fk    search every keymap live

## #modes
i a o         insert: before / after / line below
I A O         insert: line start / end / line above
v V ctrl-v    visual: char / line / block
:             command · Esc or jk → normal

## #normal #move
h j k l · w b e · 0 ^ $    the usual
gg G · 5G · %              top / bottom / line / bracket
f{c} t{c}     to / till char (; , repeat)
ctrl-d/u n N  scroll + matches stay centered
J             join, cursor stays

## #normal #edit
d c y · ciw ci( ci" cit    verbs + inner things
dd yy D C · . u ctrl-r     lines · repeat · undo/redo
gc gcc        comment motion / line
<leader>s     replace word under cursor globally
<leader>nh    clear highlights
<leader>+ -   increment / decrement
x             skips the yank register
<leader>X     chmod +x · <leader>fp copy path

## #visual
J K           move selection (reindents)
< >           reindent keeps selection
p             paste keeps yank
gc            comment

## #save #quit
:w :wq :x · :q :q! · :wqa

## #files #explorer #tree
<leader>ee    toggle nvim-tree
<leader>ef    tree on current file
<leader>ec er collapse · refresh
<leader>fy    yazi at current file
-             Oil: dir as editable buffer · Enter open · - up · q close
:w in Oil     applies renames/deletes/creates to disk (:Oil --float for float; no key — <leader>- is decrement)
ctrl-h/j/k/l  splits AND tmux panes

## #find #telescope
<leader>ff fr    files · recent
<leader>fs fc    grep cwd · grep word
<leader>ft fk    todos · keymaps

## #jump #flash
s S           flash jump · treesitter select
r R           remote · treesitter search (operator/visual)
ctrl-s        toggle flash in search

## #edit #substitute #surround #treesitter
<leader>r rr R   substitute: motion · line · to eol (x: selection)
ys ds cs      surround: add · delete · change
ctrl-space    incremental select (grow) · backspace shrink

## #tabs #splits
<leader>to tx tn tp   open · close · next · prev
<leader>tf            buffer → new tab
<leader>sv sh se sx   vsplit · hsplit · equal · close
<leader>sm            maximize toggle (nnow: mx)

## #harpoon
harpoon =     per-project FILE BOOKMARKS, 4 jump slots (not tmux bookmarks)
<leader>a     bookmark current file
ctrl-e        quick menu
ctrl-y/i/n/s  file 1 · 2 · 3 · 4
ctrl-shift-p/n   prev · next

## #session
<leader>wr ws    restore · save session (cwd)

## #git
<leader>lg    lazygit
<leader>hs hr hS hR   stage/reset hunk · buffer
<leader>hu hp         undo stage · preview
<leader>hb hB hd hD   blame · line-blame · diff · diff~
]h [h         hunks

## #lsp
gd gD gR gi gt   defs · decl · refs · impl · types
K             hover
<leader>rn rs    rename · restart LSP
<leader>d D      line float · buffer diagnostics
]d [d            diagnostics

## #diagnostics #trouble
<leader>xw xd xq xl xt   trouble: workspace · doc · qf · loc · todos
]t [t            todo comments

## #format #lint
<leader>mp    format
<leader>l     lint
