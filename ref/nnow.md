# nnow — the from-scratch build (NVIM_APPNAME=nvim-now). leader = space.

## #setup #now
nnow          alias → ~/.dotfiles/nvim-now/ · sibling: ref-nvim (daily — nmix merged into it 2026-07-20)
<leader>fk    search every keymap live

## #modes
i a o         insert: before / after / line below
I A O         insert: line start / end / line above
v V ctrl-v    visual: char / line / block
:             command · Esc or jk → normal

## #insert
jk            → normal
ctrl-h        signature help
ctrl-space ctrl-n/p ctrl-y ctrl-e   completion: menu · select · accept · close

## #normal #move
h j k l · w b e · 0 ^ $    the usual
gg G · 5G · %              top / bottom / line / bracket
f{c} t{c}     to / till char (; , repeat)
ctrl-d/u n N  scroll + matches stay centered
J             join, cursor stays

## #normal #edit
d c y · ciw ci( ci" cit    verbs + inner things
dd yy D C · . u ctrl-r     lines · repeat · undo/redo
<leader>s     replace word under cursor globally
<leader>d     delete to black hole · x skips register
<leader>+ -   increment / decrement
gcc gc        comment line / motion
<leader>nh    clear highlights
<leader>X     chmod +x · <leader>fp copy path

## #visual
J K           move selection (reindents)
< >           reindent keeps selection
p             paste keeps yank
gc            comment · <leader>gs/gr hunks

## #save #quit
:w :wq :x · :q :q! · :wqa

## #files #explorer
-             Oil: dir as editable buffer · Enter open · - up · q close
:w in Oil     applies renames/deletes/creates to disk
<leader>-     Oil float
yazi          tmux: prefix ctrl-y (`keys yazi`)
ctrl-h/j/k/l  splits AND tmux panes

## #find #telescope
<leader>ff fr    files · recent
<leader>fs fc    grep cwd · grep word
<leader>ft fk    todos · keymaps
<leader>ths      theme switcher

## #tabs
<leader>to tx tn tp   open · close · next · prev
<leader>tf            buffer → new tab

## #splits #windows
<leader>sv sh se sx   vsplit · hsplit · equal · close
<leader>mx            maximize toggle
ctrl-h/j/k/l          navigate

## #harpoon
harpoon =     per-project FILE BOOKMARKS, 4 jump slots (not tmux bookmarks)
<leader>a     bookmark current file
ctrl-e        quick menu
ctrl-y/i/n/s  file 1 · 2 · 3 · 4
ctrl-shift-p/n   prev · next

## #git
<leader>lg    lazygit
<leader>gs gr gS gR   stage/reset hunk · buffer
<leader>gu gp         undo stage · preview
<leader>gbl gB gd gD  blame · line-blame · diff · diff~
]h [h         hunks

## #lsp
gd gD gR gi gt   defs · decl · refs · impl · types
K · i: ctrl-h    hover · signature
<leader>vca rn   code action · rename
<leader>lx       toggle virtual text

## #diagnostics #trouble
df · <leader>D   line float · buffer list
<leader>xw xd xq xl xt   trouble: workspace · doc · qf · loc · todos
]t [t            todo comments

## #format #lint
<leader>mp    format
<leader>l     lint
