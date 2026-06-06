# 2026-06-06 — edge-tts + `speak` clipboard alias (iMac)

Added text-to-speech for reading long agent replies aloud: edge-tts (Microsoft's free neural voices, explicitly not Apple's) installed via pipx, wired to a `speak` alias that reads the clipboard through mpv. Install was run by the agent with explicit user approval — a deliberate exception to the no-provisioning rule (pipx, not brew/bootstrap).

- `pipx install edge-tts` (7.2.8, iMac) — gives `edge-tts` + `edge-playback`. Synthesis smoke-tested to `/tmp/edge-tts-test.mp3`.
- `shell/.zshrc` — `alias speak='edge-playback --text "$(pbpaste)"'` under Aliases.
- `docs/06-media-av/06-edge-tts.md` — new reference doc (purpose, voice/rate/file examples, Icelandic voice). Category INDEX row added; `related:` backlinks added in `02-mpv.md` + `04-whisper-cpp.md`. New tag leaf `integration/pipx`.
- `docs/INDEX.md` — headline counts were drifting (frontmatter 56/12, body 54/12, actual table 13 categories); recounted from disk → **57 tools, 13 categories**, and 05-network-security row corrected 7→8.
- `Brewfile` — breadcrumb comment under `brew "pipx"` listing edge-tts as pipx-managed (per-machine install, not brew-bundled).

## Next steps
- MBP: run `pipx install edge-tts` (alias arrives via the synced `.zshrc`).
- iMac: `source ~/.zshrc` or new shell to pick up `speak`.
- If the manual habit sticks, candidates in the doc's Future use: `speak-file`, pipe-through, Stop-hook auto-speak.
