---
title: Media & A/V
type: index
status: active
updated: 2026-06-10
description: Command-line tools for playing, transcoding, downloading, transcribing, speaking, and transferring audio and video.
tags:
  - domain/media
---

Command-line media stack — the FFmpeg engine plus a player, a preset transcoder, a multi-site downloader, a local speech-to-text engine, a neural text-to-speech CLI, and a headless torrent client.

| Tool | Description |
| --- | --- |
| [FFmpeg](01-ffmpeg.md) | Universal CLI engine for decoding, encoding, transcoding, filtering, and probing audio/video. |
| [mpv](02-mpv.md) | Minimal, scriptable, high-quality media player driven from the command line and config files. |
| [HandBrake](03-handbrake.md) | Open-source video transcoder with tuned presets, exposed as HandBrakeCLI. |
| [whisper.cpp](04-whisper-cpp.md) | Local offline speech-to-text via OpenAI's Whisper model, run with whisper-cli. |
| [Transmission (CLI)](05-transmission-cli.md) | Lightweight headless BitTorrent client — daemon plus remote control utilities. |
| [edge-tts](06-edge-tts.md) | Neural text-to-speech via Microsoft Edge's free voices — `speak` reads the clipboard aloud through mpv. |
| [yt-dlp](07-yt-dlp.md) | Download video/audio from YouTube, TikTok + ~1800 sites; `-x` rips audio for whisper transcription. |
