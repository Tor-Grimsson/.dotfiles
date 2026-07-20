# keybinds — quick reference

Filter with `keys <tag …>` (e.g. `keys tmux`, `keys tmux popover`, `keys bookmark`, `keys aerospace focus`).
tmux prefix = `C-a`, second prefix = `§` (either works everywhere "prefix" appears; `§ §` types a literal §).
Edit this file when you rebind — it's a hand-kept list, not generated.

## #tmux #popover
prefix C-t    scratch shell popup (cwd)
prefix C-y    yazi file-manager popup (cwd)
prefix C-g    lazygit popup — git TUI (cwd)
prefix C-p    clipboard image → ~/_inbox → yazi (clip-drop.sh)
prefix C-s    sesh session picker popup
prefix C-d    layout → WINDOW in current session (pane-layout.sh)
prefix C-o    layout → its OWN session (layout-picker.sh)
prefix C-b    bookmark picker (URL→browser, path→nvim)

## #tmux #bookmark
prefix C-b    open bookmark picker (fzf)
prefix B      quick-add the current directory
prefix A      add a bookmark (typed path/URL popup)

## #tmux #layout
prefix C-d               pick a layout → grafted as a WINDOW in the current session
prefix C-o               pick a layout → spawned as its OWN session
mux home/stats/torrent   dashboards: home=fastfetch+rmpc, stats=monitors, torrent
prefix space             cycle the built-in pane layouts
prefix Alt-1..5          preset layout: 1 even-columns · 2 even-rows · 3 big-top · 4 big-left · 5 grid

## #tmux #session
prefix C-n    new named session (switches in)
prefix C-s    switch session (sesh picker)
prefix O      sessionx picker (fzf session manager — TPM plugin)
prefix d      detach (session keeps running)
prefix $      rename session

## #tmux #window
prefix c      new window — always lands at the RIGHT end
prefix 1..9   jump to window N
prefix n / p  next / previous window
prefix N / P  move window right / left (swap with neighbour, follow it; repeatable)
prefix F / G  move window to the far start / end (leftmost / rightmost)
prefix ,      rename window
prefix &      kill window

## #tmux #pane
prefix |      split left/right (same dir)
prefix -      split top/bottom (same dir)
prefix h j k l   move between panes
prefix H J K L   resize pane
prefix z      zoom pane (toggle fullscreen)
prefix m / M  mark / unmark a pane
prefix x      kill pane

## #tmux #copy
prefix [      enter copy/scroll mode (q exits)
v             begin selection (copy mode)
y             copy to system clipboard (copy mode)
prefix r      reload the config

## #tmux #harpoon
prefix a      harpoon prefix, then…
a             add current session to the list
e            edit the harpoon list
1..4          jump to bookmarked session N

## #tmux #resurrect
prefix S      save all sessions now (tmux-resurrect; C-s is sesh's)
prefix C-r    restore last save (post-reboot; continuum autosaves every 15 min)

## #tmux #lazygit
prefix C-g    open the lazygit popup (cwd)
a             stage ALL changes  (the `git add .`)
c             commit → type message → Enter to confirm
A             amend: fold staged changes into the last commit (keep msg)
r             reword last commit's message  (in the Commits panel)
P             push   ·   p = pull
q             quit the popup

## #tmux #clipdrop
prefix C-p    capture: clipboard image → ~/_inbox → yazi opens on it
r             rename the file        (in yazi)
x             cut it                 (in yazi)
h/l j/k       navigate to the destination folder
p             paste → moves it there
q             quit (skip r/x/p to just leave it in ~/_inbox)

## #rmpc #transport
p             play / pause toggle
s             stop
<CR>          play the selected track
> / <         next / previous track
f / b         seek forward / back
. / ,         volume up / down
z x c v       toggle repeat / random / consume / single
C-u / C-U     update library / full rescan
q             quit rmpc

## #rmpc #nav
1..7          tab: Queue·Dirs·Artists·AlbumArtists·Albums·Playlists·Search
Tab / S-Tab   next / previous tab
j / k         down / up (arrows work too)
? / :         help / command mode

## #nvim #modes
i a o         insert: before / after cursor · new line below
I A O         insert: line start / end · new line above
v V C-v       visual: char / line / block
:             command mode · Esc or jk → normal
leader = Space   <leader>fk searches every keymap (Telescope)

## #nvim #save
:w            save
:wq  :x       save + quit
:q   :q!      quit / discard
:wqa          save + quit all

## #nvim #move
h j k l       ← ↓ ↑ →
w b e         word forward / back / end
0 ^ $         line start / first word / end
gg G          file top / bottom · 5G = line 5
f{c} t{c}     to / till char c  (; , repeat)
C-d C-u       half-page down / up
%             matching bracket

## #nvim #edit
d c y         delete / change / yank (+ a target)
ciw daw yiw   change / delete+space / yank inner word
ci( ci" cit   change inside ()  " "  <tag>
dd yy         delete / yank line   ·   D C = to end of line
> <  =        indent / dedent · auto-indent
.             repeat last change  ·  u = undo · C-r = redo

## #yazi #ops
o                 open selected (system default app)
O  ·  S-Enter     open with… — pick app interactively
Enter             smart-enter: enter dir / open file
y                 yank = COPY (mark files to paste)
x                 yank cut = MOVE (mark files to cut)
p  ·  P           paste here  ·  P overwrites existing
y then p          DUPLICATE — no native cmd: paste in same dir
Y  ·  X           cancel the yank/cut mark
d  ·  D           trash (Trash)  /  delete permanently
a                 create file (end name with / for a folder)
A                 bulk create (edit a list)
r                 rename (cursor before extension)
-  ·  _           symlink yanked: absolute / relative path
C--               hardlink yanked files

## #yazi #select
Space             toggle selection of the current file
C-a  ·  C-r       select all  /  invert selection
v  ·  V           visual mode: add to / remove from selection
Esc               clear selection / exit visual / cancel search

## #yazi #nav
h  ·  l           parent dir  /  enter dir
H  ·  L           history back  /  forward
gg  ·  G          jump to top  /  bottom
C-u  ·  C-d       half-page up / down (C-b/C-f = full page)
z  ·  Z           jump via fzf  /  via zoxide
g Space           jump to a dir interactively
gh gd gc          go: home / Downloads / .config
gD g. gt gp       go: Desktop / dotfiles / _temp / dev-projects
gf                follow the hovered symlink

## #yazi #copy
cc                copy full path
cd                copy directory path
cf                copy filename
cn                copy filename without extension

## #yazi #find
f                 filter list (live, as you type)
/  ·  ?           find next / previous by name
n  ·  N           jump to next / previous match
s  ·  S           search by name (fd) / by content (rg)
C-s               cancel the running search

## #yazi #sort
,m  ·  ,M         sort mtime  /  reverse
,s  ·  ,S         sort size  /  reverse
,a  ·  ,A         sort alphabetical  /  reverse
,n  ·  ,N         sort natural  /  reverse
,e  ·  ,E         sort extension  /  reverse
,d                reset sort + linemode to default

## #yazi #view
.                 toggle hidden files
Tab               spot — metadata / preview popup
C-y               Quick Look (macOS qlmanage)
M                 render markdown fullscreen (mdcat)
T                 maximize / restore the preview pane
K  ·  J           scroll preview up / down
m s/p/b/m/o/n     linemode: size perms btime mtime owner none

## #yazi #tabs
tt                new tab in current dir
tr                rename current tab
1 … 9             switch to tab N
[  ·  ]           previous / next tab
{  ·  }           swap tab with prev / next

## #yazi #shell
;                 run a shell command
:                 run a shell command (block until done)
w                 task manager (show running jobs)
~  ·  F1          open help (full keymap)
q  ·  Q           quit  /  quit without cwd-file
C-c               close current tab (quit if last)

# NOTE: modifier is ctrl-alt (not bare alt) — alt is left free for the terminal (fzf Alt-C, word-nav Alt-b/f, tmux prefix Alt-1..5). Reload: aerospace service mode → esc.
## #aerospace #focus
ctrl-alt-h j k l       focus window left / down / up / right
ctrl-alt-tab           previous workspace (back-and-forth)

## #aerospace #move
ctrl-alt-shift-h j k l   move window left / down / up / right
ctrl-alt-minus / =       resize -50 / +50
ctrl-alt-shift-tab       move workspace to next monitor

## #aerospace #workspace
ctrl-alt-1..9          go to workspace 1–9
ctrl-alt-{letter}      go to workspace by letter (T term · B browser · P design · O obsidian · M music · S social · W finder · A bots)
ctrl-alt-shift-{n/l}   move focused window to that workspace

## #aerospace #layout
ctrl-alt-slash         tiles: toggle horizontal / vertical
ctrl-alt-comma         accordion: toggle horizontal / vertical
cmd-alt-g              grid 2×2 (from a flat row of 4)
cmd-alt-s              main + stack (1 big left, rest stacked)
cmd-alt-shift-f        fullscreen

## #aerospace #mode
ctrl-alt-shift-;       service mode (esc=reload · r=reset layout · f=float toggle · backspace=close others · alt-shift-hjkl=join)
cmd-alt-shift-r        resize mode (h/j/k/l resize · b balance · enter/esc exit)
cmd-alt-shift-d        DISABLE aerospace (app-native keys work) — re-enable via Raycast or `aerospace enable on`

## #aerospace #macos
cmd-alt-m              toggle native macOS menubar (bin/menubar-toggle)
cmd-alt-d              toggle macOS dock (bin/dock-toggle)
cmd-alt-u              open/close Übersicht + simple-bar (bin/ubersicht-toggle)
cmd-alt-r              refresh all Übersicht widgets, double-pass (bin/ubersicht-refresh)
cmd-alt-n              summon/dismiss kol-notes sticky — nvim in Kitty (bin/notes-toggle)
cmd-alt-b              summon/dismiss kol-bookmarks sticky — edit bookmarks.txt in nvim (bin/bookmarks-toggle)

## #kitty #claude
shift+enter   newline in Claude Code — kitty.conf maps it to ESC+CR (meta-enter)
ctrl+shift+f5 reload kitty config in a running window

## #git #lazygit
prefix C-g    lazygit popup (tmux)
space         stage / unstage file · Enter = stage hunk
c  A          commit · amend
P  p          push · pull
s  r  d  e    (commits) squash · reword · drop · edit (rebase)
q             quit

## #gh
gh pr create / checkout / merge     pull requests
gh run watch / view --log-failed    CI
gh issue create / list              issues
gh api … --jq                       raw GitHub API

## #ssh
ssh <host>            connect (see ~/.ssh/config aliases)
ssh -t <host> tmux a  connect + attach tmux
mosh <host>           roaming/latency-tolerant session

## #fzf
C-r    fuzzy shell-history search (reverse-i-search)
C-t    insert a file path into the command line (fd-fed picker)
M-c    cd into a directory (fd-fed picker, tree preview)
Tab    fzf-powered Tab completion (fzf-tab plugin)
fe     fuzzy-pick a file (fd → fzf → bat preview) and open it in nvim
fzv    fzf with image preview — renders svg/png/jpg… via chafa; plain fzf stays text

## #history
Up          type nothing → previous command; type a prefix (e.g. `git`) → Up walks only commands starting with it
Down        same, forward through the matches
S-Up        open atuin seeded with the typed prefix (full fuzzy history)
S-Down      open atuin
M-Up        plain chronological previous command — prefix ignored ("normal" up)
M-Down      plain chronological history, forward

## #atuin
C-p          open search — fuzzy shell history (global scope); press again to cycle scope (global/host/session/dir)
S-Up         open atuin scoped to this directory, seeded with the typed prefix (plain Up is zsh prefix search now)
C-s          cycle search mode (fuzzy/prefix/fulltext/skim)
Enter        run the selected command
Tab          paste it into the prompt instead of running
C-o          open the inspector (exit code, duration, cwd, host)
Esc / C-c    cancel, restore what you were typing
C-a d        prefix: delete the selected history entry
C-a D        prefix: delete ALL entries matching the selected command

## #vimode
Esc / C-[       enter normal mode (motions); i/a/I/A/o/O → back to insert
v / V           visual select — char / whole line
w / b / e       next word / prev word / end of word
0 / $ / ^        line start / end / first non-blank
f<c> / t<c>     jump onto / just-before next <c>   (; repeats, , reverses)
x               delete the char under the cursor
dw / dd / d$    delete word / whole line / to end of line
cw / cc / ciw   change word / line / inner word (text object)
ci" di( dt/     change inside quotes / delete inside parens / delete up-to /
u / C-r         undo / redo
.               repeat the last change
yy / p / P      yank line / paste after / paste before
ysiw" cs"' ds"  surround: wrap word in " / change "→' / delete the surround
vv              edit the command line in nvim, save to run it
gx              open the URL or file path under the cursor
