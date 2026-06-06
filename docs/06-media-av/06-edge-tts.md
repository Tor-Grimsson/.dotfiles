---
title: edge-tts
type: reference
status: active
updated: 2026-06-06
description: Neural text-to-speech CLI (Microsoft Edge voices, free, no API key). `speak` reads the clipboard aloud via mpv.
aliases:
  - edge-tts
  - edge-playback
  - speak
tags:
  - domain/media/speech
  - pattern/cli
  - integration/pipx
  - provider/microsoft
links:
  website: https://github.com/rany2/edge-tts
  repo: https://github.com/rany2/edge-tts
  manual: https://github.com/rany2/edge-tts/blob/master/README.md
  pypi: https://pypi.org/project/edge-tts/
covers:
  - speak alias (clipboard → audio)
  - edge-tts / edge-playback commands
  - voice, rate, pitch, volume flags
related:
  - "[[02-mpv|mpv]]"
  - "[[04-whisper-cpp|whisper.cpp]]"
---

## Summary
Text-to-speech from the command line. Microsoft's online neural voices — free, no key, needs network.

**One install** (`pipx install edge-tts`) **ships two commands.** The alias builds on one of them:

| Command | Does | Needs |
|---|---|---|
| `edge-tts` | text → audio file | network only |
| `edge-playback` | text → speakers, immediately | network + [[02-mpv\|mpv]] (brew, already installed) |
| `speak` (alias) | clipboard → speakers | `edge-playback` + `pbpaste` (built into macOS) |

## Setup

1. Install: `pipx install edge-tts`
2. Alias (already in `shell/.zshrc`): `alias speak='edge-playback --text "$(pbpaste)"'`
3. New shell or `source ~/.zshrc`
4. Test: copy any text → `speak`

## Use

```sh
speak                                                  # read clipboard aloud
edge-playback --text "hello"                           # read a string aloud
edge-playback --rate=+30% --text "$(pbpaste)"          # faster
edge-playback --voice en-GB-SoniaNeural --text "hi"    # other voice
edge-tts --text "$(pbpaste)" --write-media out.mp3     # clipboard → mp3
edge-tts --file notes.md --write-media notes.mp3       # file → mp3
edge-tts --list-voices                                 # all ~300 voices
edge-tts --list-voices | grep ^is-                     # Icelandic: is-IS-GudrunNeural, is-IS-GunnarNeural
```

## Flags

| Flag | Does | Example |
|---|---|---|
| `--text` | text to speak | `--text "hello"` |
| `--file` | read text from file | `--file notes.md` |
| `--voice` | pick voice | `--voice is-IS-GudrunNeural` |
| `--rate` | speed | `--rate=+30%` / `--rate=-20%` |
| `--volume` | loudness | `--volume=+50%` |
| `--pitch` | pitch | `--pitch=-10Hz` |
| `--write-media` | output audio file (edge-tts only) | `--write-media out.mp3` |
| `--write-subtitles` | output srt alongside | `--write-subtitles out.srt` |
| `--list-voices` | list all voices | — |

Same flags work on both commands except `--write-media`/`--write-subtitles` (`edge-tts` only).

## Why installed
Agent replies in Claude Code got too long to read on screen. Copy the wall of text → `speak` → listen while doing something else. Deliberately not Apple's `say`/Siri stack. The inverse of [[04-whisper-cpp|whisper.cpp]]: that turns speech into text, this turns text back into speech.

## Biggest win
The clipboard is the universal hand-off — text from Claude Code, a browser, or a man page all reads aloud the same way, with zero per-use ceremony and voices that don't sound like 1998.

## Future use
A `speak-file <path>` helper if reading docs aloud becomes routine; piping agent output straight in (`… | edge-playback --text "$(cat -)"`); a Claude Code Stop-hook that auto-speaks reply summaries — not built until the manual habit proves itself.
