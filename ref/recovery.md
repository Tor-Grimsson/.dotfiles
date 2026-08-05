# recovery — quick reference

Filter: `ref-recovery <word …>` · what to do when nvim, tmux or yazi
crashes and takes work with it

## nvim — unsaved text after a crash

swapfile holds text you never saved · undofile holds the history of what you did

| keys / cmd | does                                 |
|------------|--------------------------------------|
| **## get it back** | |
| :Recovery  | pick from every swap with unsaved text |
| dashboard r | same — only shows when there are any |
| nvim -r    | the built-in list, outside nvim       |
| :recover   | recover the file already open        |
| :w ~/path  | keep it — the recovered buffer is UNSAVED |
| :e!        | throw it away, reload from disk      |
|            |                                       |
| **## undo, survives quitting** | |
| u · C-r    | undo · redo, still works days later  |
| :earlier 10m | rewind the buffer ten minutes      |
| :later 10m | roll it forward again                |
| :undolist  | every undo branch with timestamps    |

[e] — `nvim -r` prints one block per swap:

```
2.    %Users%kolkrabbi%.dotfiles.swo
          owned by: kolkrabbi   dated: Tue Aug 04 17:09:05 2026
         file name: [No Name]
          modified: YES
        process ID: 39480
```

Three lines decide whether it is worth anything:

```
modified:    YES = unsaved text is in it. NO = nothing to get.
file name:   a real path = that file. [No Name] = a scratch
             buffer that was never saved anywhere.
process ID:  "(still running)" = another nvim has it open NOW,
             do NOT recover. No such note = it crashed, take it.
```

Type the number. nvim opens the text in a buffer that is **still unsaved** —
`:w ~/somewhere.md` or you lose it again on quit.

nvim 0.10+ skips the ATTENTION prompt while the owning process is alive,
so seeing that prompt at all means a real crash.

----
doc: docs/operations/systems/terminality/12-nvim-from-scratch.md

## tmux — the session after the server dies

continuum autosaves every 15 min and replays the last save on the next start

| keys / cmd | does                                 |
|------------|--------------------------------------|
| **## keys** | |
| nothing    | restore is automatic on server start |
| prefix C-r | replay the last save by hand         |
| prefix S   | save now                             |
|            |                                       |
| **## comes back** | |
| layout     | windows, panes, sizes, cwd           |
| scrollback | pane contents, capture is on         |
| processes  | nvim · less · man · top, relaunched  |
|            |                                       |
| **## does NOT** | |
| buffer text | never stored — see the nvim section |
| a `[No Name]` nvim | relaunches empty              |
| the last 15 min | anything since the last autosave |

[e] — did it actually crash, and what did the save hold:

```sh
ps -o lstart,etime -p $(pgrep -o tmux)
ls -lt ~/.local/share/tmux/resurrect/
```

A server started minutes ago holding day-old work means it died and
continuum rebuilt it. Sessions all created within a few seconds of each
other is the same tell.

resurrect restores the COMMAND LINE, never what was in the buffer. A
restored nvim comes back empty — the text is in the swapfile, section above.

----
doc: docs/operations/systems/terminality/05-tmux-and-layout.md

## yazi — terminal response timeout

`[server exited unexpectedly]` is yazi's own server, not tmux's

| keys / cmd | does                                 |
|------------|--------------------------------------|
| yazi --debug | the check that error links to      |
| Emulator.detect | did the capability query answer  |
| Adapter.matches | which image protocol it settled on |

[e] — the two lines worth reading:

```sh
yazi --debug | sed -n '/Emulator/,/Dimension/p'
```

```
Emulator.detect: Left(Ghostty)      healthy — the query came back
Adapter.matches: Kgp                kitty graphics negotiated

Emulator.detect: Right(Unknown …)   the query got no answer
Adapter.matches: Chafa              fell back to ASCII images
```

Run it in a real pane. **Piping `yazi --debug` reports `Unknown` even when
the terminal is fine** — the query needs a TTY, so a redirected run lies.

yazi holds nothing unsaved. A crash costs you tabs and cwd, never a file.

----
doc: docs/documentation/02-file-management/02-yazi.md
