# system — quick reference

Filter: `ref-system <word …>` · `[e]` = example · pfx = tmux prefix

## theme — kol-theme terminals

| keys          | does                     |
|---------------|--------------------------|
| kol-theme     | --help · list themes     |
| `<leader>`ths | nvim theme switcher      |

[e] — as typed:

```sh
kol-theme gruvbox
```

----
doc: docs/documentation/09-productivity-desktop/08-kol-theme.md

## clipboard capture — screenshots

| keys    | does                       |
|---------|----------------------------|
| pfx C-p | capture menu (tmux)        |
| save    | ss-save.sh NAME DIR        |
| inbox   | clip-drop.sh               |
| file it | clip-drop.sh --yazi        |
| note    | clip-drop.sh --note kolx   |
| review  | clip-drop.sh --review kolx |
| folder  | clip-drop.sh bingo          |
| lobby   | clip-drop.sh --humpty NAME |

[e] — as typed:

```sh
ss-save.sh bingo ~/dev
clip-drop.sh bingo --note
clip-drop.sh --kol-ds-ui topnav --desc "hairline 1px low at 1440"
clip-drop.sh --lobby
```

----
doc: docs/scripts/08-system.md

## agent-drop — headless triage

drop a file, get a report beside it · creates only, edits nothing

| keys                 | does                                    |
|----------------------|-----------------------------------------|
| ~/_inbox/agent/      | drop files here                         |
| agent-drop           | process the queue now                   |
| agent-drop --dry-run | list what would run, move nothing       |
| agent-drop --init    | create the queue folders                |
| .result.md           | the report, beside the original         |
| done/                | inputs land here after                  |
| .log                 | every run, appended                     |

[e] arm the watcher · `cp ~/.dotfiles/macos/launchd/com.kolkrabbi.agent-drop.plist ~/Library/LaunchAgents/`
[e] then · `launchctl bootstrap "gui/$(id -u)" ~/Library/LaunchAgents/com.kolkrabbi.agent-drop.plist`
[e] NOT armed by default — headless runs cost money

----
doc: docs/operations/systems/headless-agents/INDEX.md

## emoji — pick and render

two vocabularies, do not mix them

| type      | does                                       |
|-----------|--------------------------------------------|
| emo       | pick a glyph -> clipboard has the emoji    |
| emo -n    | pick -> clipboard has :shortcode:          |
| emojify   | filter — :shortcode: in text becomes emoji |
| emojify --list `<word>` | find a shortcode by name     |

| gotcha    | fact                                       |
|-----------|--------------------------------------------|
| the vocab | emojify 2562 github names · emoji-fzf 4440 |
|           | unicode names — :astronaut: is ONLY in the |
|           | second, emojify leaves it as literal text  |
| so        | emo -n reads emojify's list, not emoji-fzf |
| the file  | holds :rocket: · the terminal shows it     |

----
doc: docs/documentation/01-shell-terminal/30-emojify.md

## theme gotchas

| thing   | fact                                         |
|---------|----------------------------------------------|
| ghostty | theme switch → quit + relaunch               |
| btop    | rewrites conf on exit — kol-theme re-asserts |
| glyphs  | powerline PUA — inject by codepoint          |
| nvim    | kol-dark / linkarzu halves = stand-ins       |

----
doc: docs/documentation/09-productivity-desktop/08-kol-theme.md
