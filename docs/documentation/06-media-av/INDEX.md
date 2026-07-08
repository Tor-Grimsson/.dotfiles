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
| [[01-ffmpeg|FFmpeg]] | Universal CLI engine for decoding, encoding, transcoding, filtering, and probing audio/video. |
| [[02-mpv|mpv]] | Minimal, scriptable, high-quality media player driven from the command line and config files. |
| [[03-handbrake|HandBrake]] | Open-source video transcoder with tuned presets, exposed as HandBrakeCLI. |
| [[04-whisper-cpp|whisper.cpp]] | Local offline speech-to-text via OpenAI's Whisper model, run with whisper-cli. |
| [[05-transmission-cli|Transmission (CLI)]] | Lightweight headless BitTorrent client — daemon plus remote control utilities. |
| [[06-edge-tts|edge-tts]] | Neural text-to-speech via Microsoft Edge's free voices — `speak` reads the clipboard aloud through mpv. |
| [[07-yt-dlp|yt-dlp]] | Download video/audio from YouTube, TikTok + ~1800 sites; `-x` rips audio for whisper transcription. |
| [[08-terminal-music|mpd + rmpc]] | Terminal music for the local library — mpd daemon + rmpc TUI client, mount-guarded to the external drive. |
