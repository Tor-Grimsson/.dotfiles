---
title: tmux help & cheat sheet
type: guide
status: active
updated: 2026-06-14
audience: internal
description: Practical tmux cheat sheet — the built-in help commands first, then the keys, shell commands, and workflows you actually use day to day with this repo's ~/.tmux.conf.
aliases:
  - tmux-help
  - tmux-cheatsheet
  - tmux-cheat-sheet
tags:
  - domain/shell
  - pattern/tui
related:
  - "[[01-cli-cheatsheet|CLI cheatsheet]]"
  - "[[02-tmux|tmux]]"
  - "[[09-tmux-tips|tmux tips & tricks]]"
---

# tmux help & cheat sheet

Quick-reference card for this repo's [[02-tmux|tmux]] config. **The prefix is `Ctrl-a`** — every binding below is `Ctrl-a` then a key, written `prefix`. Press `Ctrl-a`, release, then the key.

## Built-in help — find anything without leaving tmux

When you forget a key or a command, ask tmux directly. You never need to memorise the whole thing.

| Ask | Shows |
|---|---|
| `prefix ?` | **Every key binding**, live and scrollable — the built-in cheat sheet. `q` closes it. Start here. |
| `prefix :` | **Command prompt** — type any tmux command by name and run it (e.g. `kill-session`). |
| `man tmux` | The **full manual** — every command, option, and format. `/word` searches inside it. |
| `tmux list-keys` (`tmux lsk`) | Every binding, **from the shell** — greppable: `tmux lsk \| grep resize`. |
| `tmux list-commands` (`tmux lscm`) | Every command **with its syntax** — greppable the same way. |
| *any command, mistyped* | tmux prints the **usage line** — a fast way to recall a command's flags. |

**Find a binding fast:** `tmux lsk | grep copy` → shows every copy-mode key. **Find an option:** `man tmux`, then `/status-position`.

## The keys you actually use

### Sessions — the whole point (they outlive the terminal)

| Key / command | Does |
|---|---|
| `tmux new -s work` | start a named session `work` |
| `tmux ls` | list running sessions |
| `tmux a -t work` | reattach to `work` (`tmux a` = most recent) |
| `prefix d` | **detach** — leave it running in the background |
| `prefix s` | interactive session switcher (previews each session's windows) |
| `prefix $` | rename the current session |
| `tmux kill-session -t work` | end one session |

### Windows (like browser tabs)

| Key | Does |
|---|---|
| `prefix c` | new window (opens in the current folder) |
| `prefix 1`…`9` | jump to window by number |
| `prefix n` / `prefix p` | next / previous window |
| `prefix ,` | rename the current window |
| `prefix w` | pick a window from a list |
| `prefix &` | close the current window (confirms) |

### Panes (splits within a window)

| Key | Does |
|---|---|
| `prefix \|` | split **left/right**, in the current folder |
| `prefix -` | split **top/bottom**, in the current folder |
| `prefix h` `j` `k` `l` | move between panes (arrows also work) |
| `prefix H` `J` `K` `L` | resize (hold prefix, tap repeatedly) |
| `prefix z` | **zoom** the pane fullscreen — tap again to un-zoom |
| `prefix x` | close the current pane (confirms) |
| `prefix q` | flash pane numbers; tap one to jump |
| `prefix space` | cycle the built-in layouts |

### Copy / scroll mode (grab text from the scrollback)

`prefix [` enters it (or just scroll up with the mouse). Moves like vim because the config sets `mode-keys vi`. Full walk-through in [[09-tmux-tips|tmux tips & tricks]].

| Key | Does |
|---|---|
| `prefix [` | enter copy mode |
| `/` … / `?` … | search forward / backward; `n` `N` next / prev match |
| `g` / `G` | top / bottom of the buffer |
| `v` | start selecting |
| `y` | copy selection to the **macOS clipboard** (`pbcopy`) and exit |
| `q` | leave copy mode |
| `prefix ]` | paste tmux's own buffer back into a pane |

### One-offs worth knowing

| Key | Does |
|---|---|
| `prefix r` | reload `~/.tmux.conf` after editing it |
| `prefix t` | big clock |
| `prefix !` | break the current pane out into its own window |

## Common workflows

**Persistent work over SSH — survive a dropped connection**
```sh
tmux new -s deploy     # start, run your long task inside
# prefix d             → detach; the task keeps running on the server
# (connection drops, you go home, reconnect…)
tmux a -t deploy       # back exactly where you left it
```

**Edit + run side by side**
```text
prefix |     split left/right        → nvim on the left
prefix -     split the right pane     → server / logs bottom-right
prefix h/l   hop between them
prefix z     zoom the editor fullscreen, prefix z again to pop back
```

**Grab error text from 200 lines ago**
```text
prefix [     enter copy mode
?error       search backward for "error", Enter   (n / N for more matches)
v            select from there
y            copy to the macOS clipboard → ⌘V anywhere
```

**Run the same command across every pane** (e.g. several servers)
```text
prefix :  setw synchronize-panes on      # type once, hits all panes
prefix :  setw synchronize-panes off     # back to normal
```

**Reload after editing the config**
```text
prefix r    # flashes "tmux.conf reloaded" — tmux only re-reads on demand
```

## See also

- [[02-tmux|tmux]] — what it is, why it's installed, the config rundown.
- [[09-tmux-tips|tmux tips & tricks]] — copy mode explained in full, plus deeper pane/window/session tricks.
