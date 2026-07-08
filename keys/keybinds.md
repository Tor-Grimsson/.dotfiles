# keybinds — quick reference

Filter with `keys <tag …>` (e.g. `keys tmux`, `keys tmux popover`, `keys bookmark`, `keys aerospace focus`).
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
prefix M-1..M-5          even-h / even-v / main-h / main-v / tiled

## #tmux #session
prefix C-n    new named session (switches in)
prefix C-s    switch session (sesh picker)
prefix d      detach (session keeps running)
prefix $      rename session

## #tmux #window
prefix c      new window
prefix 1..9   jump to window N
prefix n / p  next / previous window
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

## #aerospace #focus
alt-h j k l       focus window left / down / up / right
alt-tab           previous workspace (back-and-forth)

## #aerospace #move
alt-shift-h j k l   move window left / down / up / right
alt-minus alt-equal resize -50 / +50
alt-shift-tab       move workspace to next monitor

## #aerospace #workspace
alt-1..9          go to workspace 1–9
alt-{letter}      go to workspace by letter (T term · B browser · P design · O obsidian · M music · S social · W finder · A bots)
alt-shift-{n/l}   move focused window to that workspace

## #aerospace #layout
alt-slash         tiles: toggle horizontal / vertical
alt-comma         accordion: toggle horizontal / vertical
cmd-alt-g         grid 2×2 (from a flat row of 4)
cmd-alt-s         main + stack (1 big left, rest stacked)
cmd-alt-shift-f   fullscreen

## #aerospace #mode
alt-shift-;       service mode (esc=reload · r=reset layout · f=float toggle · backspace=close others · alt-shift-hjkl=join)
cmd-alt-shift-r   resize mode (h/j/k/l resize · b balance · enter/esc exit)
cmd-alt-shift-d   DISABLE aerospace (app-native keys work) — re-enable via Raycast or `aerospace enable on`

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
