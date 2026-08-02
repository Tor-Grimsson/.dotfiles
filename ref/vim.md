# vim — which vim am I in?

Filter: `ref-vim <word …>` · seven surfaces, four dialects. Stops you
trying nvim keys somewhere that only speaks four of them.

## nvim — true vim

the only full implementation · everything else here is a subset

| fact       | value                                 |
|------------|---------------------------------------|
| config     | ~/.dotfiles/nvim → lua/grim           |
| leader     | Space                                 |
| the card   | ref-nvim                              |
| alt-arrows | ← b · → w — both hop to NORMAL first  |

## zsh — modes

zsh-vi-mode 0.12.0, live — the prompt is modal, cursor shape tells you which

| keys      | does                                       |
|-----------|--------------------------------------------|
| esc       | insert -> NORMAL · ctrl-[ is the same      |
| i a       | insert before cursor · after cursor        |
| I A       | insert at line start · at line end         |
| o O       | open line below · above                    |
| v V       | visual charwise · linewise                 |
| the beam  | cursor is a beam in INSERT                 |
| the block | cursor is a block in NORMAL                |
| each prompt | starts in INSERT — type, esc to edit     |

## zsh — move

| keys      | does                                       |
|-----------|--------------------------------------------|
| h l       | left · right                               |
| w b       | next word · previous word · e end of word  |
| W B       | same, WHITESPACE-delimited                 |
| 0 ^ $     | line start · first non-blank · line end    |
| f`<c>`    | jump to next `<c>` · F back · ; , repeat   |
| t`<c>`    | jump before next `<c>` · T back            |
| j k       | walk history — there is only one line here |

## zsh — edit

| keys      | does                                       |
|-----------|--------------------------------------------|
| x  X      | delete char under · before cursor          |
| dd  D     | delete line · delete to line end           |
| dw de db  | delete word · to end · back                |
| cc  C     | change line · change to line end           |
| cw ciw    | change word · change INNER word            |
| daw  diw  | delete around · inside word                |
| ci" ci'   | change inside quotes · ci( ci{ ci[ too     |
| yy  p P   | yank line · paste after · before           |
| r`<c>`    | replace one char · R overtype              |
| ~         | toggle case of the char under the cursor   |
| u         | undo · ctrl-r redo                         |
| .         | repeat the last change                     |

## zsh — surround

vim-surround built in — works on the command line

| keys      | does                                       |
|-----------|--------------------------------------------|
| ysiw"     | wrap the word in double quotes             |
| cs"'      | change surrounding " to '                  |
| ds"       | delete the surrounding quotes              |
| S"        | in VISUAL, wrap the selection              |

## zsh — the editor handoff

| keys      | does                                       |
|-----------|--------------------------------------------|
| vv        | open the command line in nvim              |
| :wq       | save and the line RUNS                     |
| :q!       | quit without running                       |

## zsh — kept from emacs

these still work IN INSERT MODE, on purpose — you are never stuck

| keys      | does                                       |
|-----------|--------------------------------------------|
| ctrl-a    | beginning of line · ctrl-e end of line     |
| ctrl-k    | kill to end of line                        |
| alt-b     | back a word · alt-f forward a word         |
| alt-del   | delete the word before the cursor          |
| opt-arrow | opt-left / opt-right are word jumps        |

## zsh — kept bindings

the plugin re-inits zle at the FIRST PROMPT and wipes earlier bindkeys ·
.zshrc re-applies these in zvm_after_init, so nothing is lost

| keys      | does                                       |
|-----------|--------------------------------------------|
| ctrl-r    | fzf history · ctrl-t files · alt-c cd      |
| ctrl-p    | atuin search · shift-up atuin too          |
| up down   | prefix search of history                   |
| opt-up    | plain history, no prefix                   |

## zsh — vim setup

| fact                | value                                    |
|---------------------|------------------------------------------|
| the off switch      | VI_MODE=false in .zshrc, then exec zsh   |
| ZVM_LINE_INIT_MODE  | $ZVM_MODE_INSERT — prompts start typing  |
| ZVM_NORMAL_MODE_CURSOR | $ZVM_CURSOR_BLOCK                     |
| ZVM_INSERT_MODE_CURSOR | $ZVM_CURSOR_BEAM                      |
| ZVM_TERM            | xterm-256color — cursor shapes in tmux   |
| jk as esc           | ZVM_VI_INSERT_ESCAPE_BINDKEY — COMMENTED |
| do NOT set          | zsh's KEYTIMEOUT — the plugin owns it    |
| normal-mode binds   | go in zvm_after_lazy_keybindings, not    |
|                     | zvm_after_init — those keymaps lazy-load |

----
doc: docs/documentation/01-shell-terminal/28-zsh-vi-mode.md

## tmux — copy-mode vi

`mode-keys vi` · the scrollback is a vim buffer you cannot edit

| keys    | does                                      |
|---------|-------------------------------------------|
| pfx [   | enter copy-mode                           |
| h j k l | move · C-u C-d half pages · g G top/bottom |
| v       | begin selection                           |
| y       | copy selection and exit                   |
| q  esc  | leave copy-mode                           |

## yazi — vim-ish g-keys

a file manager wearing vim motions · no modes, every key is normal-mode

| keys    | does                                     |
|---------|------------------------------------------|
| j k     | down / up · h l out / in                 |
| gg  G   | first / last entry                       |
| g`<key>`| jump to a bookmarked location            |
| /  n N  | filter · next / prev hit                 |
| y  x  p | yank · cut · paste (NOT vim's registers) |

## broot — its own verbs

NOT vim · type to fuzzy-filter, keys are verbs not motions

| keys   | does                                     |
|--------|------------------------------------------|
| type   | filters the tree — there is no normal mode |
| ↑ ↓    | move — j/k TYPE, they do not move        |
| enter  | open / cd                                |
| :verb  | run a verb (`:pp` copy path, `:e` edit)  |
| esc    | clear the filter                         |

## claude — modes

vim mode is ON — "editorMode": "vim" in claude/settings.json (2026-08-01)

| keys      | does                                       |
|-----------|--------------------------------------------|
| esc       | insert or visual -> NORMAL                 |
| i I       | insert before cursor · at line start       |
| a A       | insert after cursor · at line end          |
| o O       | open line below · above                    |
| v V       | visual charwise · linewise                 |

## claude — stop

esc does NOT interrupt in vim mode — vim eats it as insert -> NORMAL

| keys        | does                                     |
|-------------|------------------------------------------|
| `Ctrl+C`    | interrupt — ONE press, draft survives    |
| `Ctrl+C`    | 2nd press, idle: clears the input        |
| `Ctrl+C`    | 3rd press, empty: EXITS claude code      |
| `Ctrl+X` `Ctrl+K` | stop background subagents · 2x in 3s |
| `Ctrl+X` `Ctrl+B` | background the task — chord dodges  |
|             | the tmux prefix on plain `Ctrl+B`        |
| the rebind  | IMPOSSIBLE — reserved, hardcoded         |

## claude — move

| keys      | does                                       |
|-----------|--------------------------------------------|
| h j k l   | left down up right · space also moves right |
| w e b     | next word · end of word · previous word    |
| 0 ^ $     | line start · first non-blank · line end    |
| gg G      | start of input · end of input              |
| f F t T   | jump to char · back · before · after       |
| ; ,       | repeat last f/F/t/T · reversed             |
| /         | reverse history search (same as ctrl-R)    |

at the first or last character, j/k walk COMMAND HISTORY instead

## claude — edit

| keys      | does                                       |
|-----------|--------------------------------------------|
| x  dd  D  | del char · del line · del to line end      |
| dw de db  | delete word · to end · back                |
| cc C      | change line · change to line end           |
| cw ce cb  | change word · to end · back                |
| s S       | substitute char · substitute line          |
| yy Y      | yank line                                  |
| yw ye yb  | yank word · to end · back                  |
| p P       | paste after · before                       |
| >> <<     | indent · dedent                            |
| J  u  .   | join lines · undo · repeat last change     |

## claude — text objects

pair with d c y — diw ciw yi" and so on

| keys      | does                                       |
|-----------|--------------------------------------------|
| iw aw     | inner · around word                        |
| iW aW     | inner · around WORD (whitespace-delimited) |
| i" a"     | inner · around double quotes               |
| i' a'     | inner · around single quotes               |
| i( a(     | inner · around parens                      |
| i[ a[     | inner · around brackets                    |
| i{ a{     | inner · around braces                      |

## claude — visual

| keys      | does                                       |
|-----------|--------------------------------------------|
| d x       | delete selection                           |
| y  c s    | yank · change selection                    |
| p         | replace selection with register            |
| r`<char>` | replace every selected char                |
| ~ u U     | toggle case · lowercase · uppercase        |
| > <       | indent · dedent selected lines             |
| J  o      | join selected · swap cursor and anchor     |
| v V       | toggle charwise/linewise, or exit          |

ctrl-V blockwise visual is NOT supported

## claude — vim setup

| fact                | value                                    |
|---------------------|------------------------------------------|
| /config             | Editor mode -> vim (the supported route) |
| "editorMode"        | "vim" — claude/settings.json:102         |
| vimInsertModeRemaps | {"jj": "`<Esc>`"} — two printable chars  |
| the target          | "`<Esc>`" is the ONLY legal target       |
| the window          | 2nd char within 1s, else both stay text  |
| where it is read    | USER settings only — a repo's own        |
|                     | .claude/settings.json is IGNORED         |
| not read            | no ~/.vimrc, no vim plugins — built-ins  |

"/vim" is NOT a command (tested, "Unknown command") — use /config

----
doc: https://code.claude.com/docs/en/interactive-mode

## ghostty kitty — no vim at all

| fact     | value                                       |
|----------|---------------------------------------------|
| mode     | plain readline — whatever the shell gives   |
| so       | inside a terminal, vi-ness comes from zsh   |
| opt keys | macos-option-as-alt = true eats opt-symbols |

----
doc: ref-terminal · ref-explorer
