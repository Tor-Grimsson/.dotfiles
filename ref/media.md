# media — quick reference

Filter: `ref-media <word …>` · `[e]` = example · rmpc = music TUI (mpd client)

## rmpc — transport

| keys    | does                                    |
|---------|-----------------------------------------|
| p · s   | play/pause · stop                       |
| Enter   | play the selected track                 |
| > · <   | next / previous track                   |
| f · b   | seek forward / back                     |
| . · ,   | volume up / down                        |
| z x c v | repeat · random · consume · single      |
| C-u     | update library (C-U full rescan)        |
| q       | quit                                    |

## rmpc — nav

| keys        | does                                        |
|-------------|---------------------------------------------|
| 1–7         | tabs: Queue·Dirs·Artists·Albums·Search |
| Tab · S-Tab | next / previous tab                         |
| ? · :       | help / command mode                         |

----
doc: docs/documentation/06-media-av/08-terminal-music.md

## torrent

| keys       | does                                    |
|------------|-----------------------------------------|
| tor-search | search via jackett (script)             |
| mux torrent| the torrent dashboard (tmux layout)     |
| daemon     | transmission-cli — see the doc          |

----
doc: docs/documentation/06-media-av/05-transmission-cli.md

## scripts

| keys | does                                     |
|------|------------------------------------------|
| au-  | audio family — docs/scripts/01-audio.md  |
| vid- | video family — docs/scripts/02-video.md  |
| dl-  | yt-dlp fetch — docs/scripts/12-download.md |

----
doc: docs/scripts/07-torrent.md
