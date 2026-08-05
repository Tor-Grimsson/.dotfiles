# tmux — quick reference

Filter: `ref-tmux <word …>` · `[e]` = example · pfx = `C-a` (second prefix `§` · `§ §` types a literal §)

## popover llm

the prefix is `C-a` · esc backs out of an fzf picker · q leaves a pager ·
a raw shell or REPL needs `exit` or Ctrl-D · two = picker first, then pager

| keys    | does                                    | close     |
|---------|-----------------------------------------|-----------|
| pfx C-t | scratch shell popup (cwd)               | type exit |
| pfx C-y | yazi popup (cwd)                        | q         |
| pfx C-g | lazygit popup — see ref-git             | q         |
| pfx C-p | capture menu (clip-drop)                | esc       |
| pfx C-s | sesh session picker                     | esc       |
| pfx C-d | layout → window in current session      | esc       |
| pfx C-o | layout → its own session                | esc       |
| pfx C-b | bookmark picker                         | esc       |
| pfx C-w | app rule (aero-add) — see ref-desk      | esc       |
| pfx C-f | ref-card picker (ref-pick)              | esc · q   |
| pfx C-k | lobby queue (lobby) — see ref-lobby     | esc · q   |
| pfx C-l | ask llm (llm-pick) — see ref-llm        | esc · q   |

## bookmark

| keys    | does                             |
|---------|----------------------------------|
| pfx C-b | bookmark picker (fzf)            |
| pfx B   | quick-add the current directory  |
| pfx A   | add a typed path/URL             |

## layout

| keys        | does                                        |
|-------------|---------------------------------------------|
| pfx C-d     | layout → window in current session          |
| pfx C-o     | layout → its own session                    |
| mux NAME    | dashboards: home · stats · torrent          |
| pfx space   | cycle built-in pane layouts                 |
| pfx Alt-1–5 | preset: columns · rows · big-top · grid |

## session

| keys    | does                            |
|---------|---------------------------------|
| pfx C-n | new named session               |
| pfx C-s | switch session (sesh)           |
| pfx O   | sessionx picker (fzf)           |
| pfx d   | detach (keeps running)          |
| pfx $   | rename session                  |

## window

| keys      | does                                  |
|-----------|---------------------------------------|
| pfx c     | new window (lands at the right end)   |
| pfx 1–9   | jump to window N                      |
| pfx n / p | next / previous                       |
| pfx N / P | move right / left (repeatable)        |
| pfx F / G | move to far start / end               |
| pfx ,     | rename                                |
| pfx &     | kill window                           |

## pane

| keys        | does                                 |
|-------------|--------------------------------------|
| pfx \|      | split left/right (same dir)          |
| pfx -       | split top/bottom (same dir)          |
| pfx h j k l | move between panes                   |
| pfx H J K L | resize                               |
| pfx z       | zoom toggle                          |
| pfx m / M   | tint / untint pane bg (marker)       |
| pfx < / >   | join: pull window in / send pane out |
| pfx !       | break pane out to its own window     |
| pfx { / }   | swap with previous / next            |
| pfx q       | flash pane numbers — press to jump   |
| pfx x       | kill pane                            |

## copy

| keys  | does                             |
|-------|----------------------------------|
| pfx [ | copy/scroll mode (q exits)       |
| v     | begin selection (in copy mode)   |
| y     | copy to system clipboard         |

## reload

| keys  | does                                  |
|-------|---------------------------------------|
| pfx r | reload tmux.conf — new binds go live  |
| pfx y | restart yazi in place — see ref-yazi  |
| pfx v | cycle md-preview mode — see ref-yazi  |

## harpoon

| keys  | does                            |
|-------|---------------------------------|
| pfx a | harpoon prefix, then…           |
| a     | add current session             |
| e     | edit the list                   |
| 1–4   | jump to bookmarked session N    |

## resurrect

| keys    | does                                |
|---------|-------------------------------------|
| pfx S   | save all sessions (resurrect)       |
| pfx C-r | restore last save (continuum 15min) |

## claude

| keys  | does                                    |
|-------|-----------------------------------------|
| pfx g | humpty-grant 15m window (again=revoke)  |
| shell | humpty-grant [min] / off / status       |

## clipdrop

| keys    | does                                     |
|---------|------------------------------------------|
| pfx C-p | capture menu: file · drop · note · review |
| r x p   | (in yazi) rename · cut · paste           |
| q       | quit — file stays in ~/_inbox            |
| shell   | clip-drop.sh · --note · --review · --lobby |

----
doc: docs/documentation/01-shell-terminal/02-tmux.md
