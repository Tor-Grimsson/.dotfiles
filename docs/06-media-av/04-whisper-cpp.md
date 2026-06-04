---
title: whisper.cpp
type: reference
status: active
updated: 2026-06-04
description: Fast C/C++ port of OpenAI's Whisper speech-to-text model, run locally via the whisper-cli binary.
aliases:
  - whisper-cli
  - whisper-cpp
tags:
  - domain/media/speech
  - pattern/cli
  - integration/brew-formula
  - provider/openai
links:
  website: https://github.com/ggml-org/whisper.cpp
  repo: https://github.com/ggml-org/whisper.cpp
  manual: https://github.com/ggml-org/whisper.cpp/blob/master/README.md
  brew: https://formulae.brew.sh/formula/whisper-cpp
covers:
  - Local offline speech-to-text transcription
  - Loading GGML model files (.bin)
  - Output to text, SRT, and VTT
  - Transcribing audio extracted from video
related:
  - "[[01-ffmpeg|FFmpeg]]"
---

## Summary
whisper.cpp is a dependency-light C/C++ reimplementation of OpenAI's Whisper automatic-speech-recognition model, running entirely on-device with no API calls. The brew formula installs the inference engine as `whisper-cli`; the actual model weights are separate GGML `.bin` files you download once. It turns spoken audio into text, with optional subtitle-format output.

## Why installed
It brings local, offline transcription to the toolchain — captions, interview transcripts, and searchable text from audio without uploading anything to a cloud service. Combined with `ffmpeg` to extract or convert audio first, it closes the loop from any media file to a usable transcript on the same machine.

## Most common use case
Transcribing an audio file to plain text or to an SRT subtitle file for a video.

## Biggest win
Private, local Whisper-quality transcription. You get the accuracy of OpenAI's Whisper model with zero network dependency, no per-minute cost, and no data leaving the machine — and it is fast enough on Apple Silicon to be practical for real workloads.

## How to use
whisper.cpp needs a model file before it can run. Download one (e.g. `base.en` or `large-v3`) from Hugging Face — the formula's caveats point to `https://huggingface.co/ggerganov/whisper.cpp/tree/main`.

```sh
# Whisper expects 16 kHz mono WAV — convert first with ffmpeg
ffmpeg -i input.mp4 -ar 16000 -ac 1 -c:a pcm_s16le audio.wav

# Transcribe to stdout
whisper-cli -m models/ggml-base.en.bin -f audio.wav

# Write an SRT subtitle file alongside the audio
whisper-cli -m models/ggml-base.en.bin -f audio.wav --output-srt

# Write a WebVTT file instead
whisper-cli -m models/ggml-base.en.bin -f audio.wav --output-vtt

# Force a language (otherwise auto-detected)
whisper-cli -m models/ggml-large-v3.bin -f audio.wav -l is
```

## Future use
Worth adopting: a standing `~/whisper-models/` with a couple of model sizes plus a wrapper script that runs the `ffmpeg` extract and `whisper-cli` transcribe in one step, and the larger multilingual models (`large-v3`) for non-English source audio.
