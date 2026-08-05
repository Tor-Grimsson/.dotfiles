# shell — quick reference

Filter: `ref-shell <word …>` · `[e]` = example · zsh line editor + history + ssh

## ssh

| keys                 | does                          |
|----------------------|-------------------------------|
| ssh HOST             | connect (~/.ssh/config alias) |
| ssh -t HOST tmux a   | connect + attach tmux         |
| mosh HOST            | roaming/latency-tolerant      |

host IPs + connect syntax (biskup, acyr, vnc, smb): `ref-remote`

## history

| keys    | does                                     |
|---------|------------------------------------------|
| Up      | prev command · typed prefix = prefix-walk |
| Down    | same, forward                            |
| S-Up    | atuin, seeded with typed prefix          |
| M-Up    | plain chronological prev                 |

## atuin

| keys      | does                              |
|-----------|-----------------------------------|
| C-p       | search · press again = cycle scope |
| C-s       | cycle mode (fuzzy/prefix/full)    |
| Enter     | run the selected command          |
| Tab       | paste it to the prompt instead    |
| C-o       | inspector (exit code, cwd, host)  |
| C-a d / D | delete entry / all matching       |

----
doc: docs/documentation/01-shell-terminal/25-atuin.md

## vimode

| keys        | does                                  |
|-------------|---------------------------------------|
| Esc · C-[   | normal mode — i a I A o O back in     |
| w b e       | word motions                          |
| 0 $ ^       | line start / end / first non-blank    |
| dw dd d$    | delete word / line / to end           |
| cw ciw      | change word / inner word              |
| ci" di( dt/ | change in quotes · del in parens · del to / |
| u · C-r · . | undo · redo · repeat                  |
| ysiw" cs"'  | surround: wrap · change               |
| vv          | edit the command line in nvim         |
| gx          | open URL/path under cursor            |

the full modal picture — nvim vs zsh vs claude vs tmux vs yazi: `ref-vim`

## paths — copy the cwd

| keys        | does                                  |
|-------------|---------------------------------------|
| cwd         | print the current directory           |
| cwd -c      | copy it to the clipboard              |
| cwd -e      | open it in nvim                       |
| cwd -f      | copy it AND reveal it in Finder       |

| keys        | does                                  |
|-------------|---------------------------------------|
| zshrc       | print the .zshrc path                 |
| zshrc -e    | edit it in nvim                       |
| zshrc -s    | source ~/.zshrc                       |
| zshrc -c    | copy the path                         |

jump to a saved path — tmux bookmarks: `ref-tmux bookmark`

[e] where they live · `~/.dotfiles/shell/functions/paths.zsh`

----
doc: docs/documentation/01-shell-terminal/28-zsh-vi-mode.md
