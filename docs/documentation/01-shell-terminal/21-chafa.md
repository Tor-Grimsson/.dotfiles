---
title: chafa
type: reference
status: active
updated: 2026-07-08
description: Terminal image-to-graphics renderer that turns images, GIFs, and video into Unicode blocks, braille/sextant dots, sixels, or inline kitty/iTerm2 graphics.
aliases:
  - chafa
tags:
  - domain/shell
  - pattern/cli
  - integration/brew-formula
links:
  website: https://hpjansson.org/chafa/
  repo: https://github.com/hpjansson/chafa
  manual: https://hpjansson.org/chafa/man/
  brew: https://formulae.brew.sh/formula/chafa
related:
  - "[[02-yazi|yazi (uses chafa as preview fallback)]]"
  - "[[07-fastfetch|fastfetch (chafa logo)]]"
---

## Summary
chafa converts images (and GIFs/video) into terminal-renderable output — colored Unicode blocks, braille/sextant dots, sixels, or the kitty/iTerm2 inline-image protocols. It picks the best mode for the current terminal automatically but exposes every knob for a specific look.

Installed version: **chafa 1.18.2**, via Homebrew (`brew "chafa"` in `brewfile-cli`).

## Why installed
Two concrete roles in this setup:

- **yazi preview fallback** — when yazi can't detect a native image protocol (e.g. over SSH inside tmux), it shells out to chafa to render the preview as Unicode/sixel. Over iTerm2 directly this never fires. See [[02-yazi|yazi]].
- **fastfetch portrait logo** — the ASCII portrait shown next to the system banner is a chafa render of a source image, baked to a text file. See [[07-fastfetch|fastfetch]] and [[01-fastfetch-home|the shell-home doc]].

## How to use
```sh
chafa image.png                              # auto-detect terminal, render inline

# Bake ANSI art to a file (fixed box, aspect preserved):
chafa image.png --size 42x26 > logo.txt

cat logo.txt                                 # replay the saved art anytime
```

The saved file keeps its ANSI escape codes, so `cat` reproduces the colors exactly.

## Flags that matter
Run `chafa --help` for the complete list; these are the ones that shape the output.

| Flag | What it does | Example |
| --- | --- | --- |
| `--size WxH` | Fit inside a `WxH` character box, aspect preserved | `chafa img.png --size 80x40` |
| `--format` | Output mode: `symbols` \| `sixels` \| `kitty` \| `iterm` | `chafa img.png --format iterm` |
| `--symbols` | Glyph set — the "dot vs block vs ascii" look: `block`, `ascii`, `braille`, `sextant`, `half`, `all` (combinable, e.g. `block+border`) | `chafa img.png --symbols braille` |
| `--fill` | Symbols allowed for solid fill when detail is scarce | `chafa img.png --fill block` |
| `--colors` | Color depth: `2`, `8`, `16`, `256`, `full` (truecolor), `none` | `chafa img.png --colors 256` |
| `--dither` | Dithering: `none`, `ordered`, `diffusion` — the grainy/dithered look | `chafa img.png --dither diffusion` |
| `--align` | Position within the box, e.g. `center`, `top`, `left` | `chafa img.png --align center` |
| `--stretch` | Ignore aspect ratio, fill the whole box | `chafa img.png --size 42x26 --stretch` |
| `--clear` | Clear the screen before drawing | `chafa img.png --clear` |
| `--fg` / `--bg` | Foreground/background color for 2-color output | `chafa img.png --colors 2 --fg white --bg black` |
| `--animate` | Play GIFs/video frames (on by default for animations); `off` to freeze | `chafa clip.gif --animate on` |
| `--duration` | Seconds to play an animation before exiting | `chafa clip.gif --duration 3` |

## Getting a specific look
```sh
# Dithered colored-dots portrait (the soft, grainy look):
chafa img.png --symbols sextant --dither diffusion --colors full --size 42x26

# Pure ASCII, no color — copy-paste-safe text art:
chafa img.png --symbols ascii --colors none --size 60x30

# Sharp, real-pixel render on iTerm2 (uses the inline-image protocol):
chafa img.png --format iterm --size 60x40
```

- **Dots vs blocks vs ascii** is entirely `--symbols`: `sextant`/`braille` give fine dot detail, `block`/`half` give chunky color fields, `ascii` gives portable text.
- **`--dither diffusion`** trades hard color banding for a stippled gradient — the classic "dithered portrait" feel.
- **`--format iterm`** (or `kitty`/`sixels`) bypasses glyphs entirely for a true-pixel image where the terminal supports it.

## In this setup
Regenerate the fastfetch portrait logo (source lives beside the fastfetch config):

```sh
chafa ~/.dotfiles/fastfetch/logo-source.jpeg -f symbols --size 42x26 --align left > ~/.dotfiles/fastfetch/logo.txt
# -f symbols: auto-detect may emit kitty-graphics escapes; --align left: center bakes a left gutter of spaces
```

yazi calls chafa automatically as a preview fallback — no config action needed; it only engages when no native image protocol is available.

## Biggest win
One binary that renders images in *any* terminal — from a truecolor iTerm2 tab down to a plain SSH session inside tmux — auto-selecting the best available mode. That is exactly why it works both as yazi's universal preview fallback and as a repeatable logo baker.

## Future use
Quick image previews from the shell without leaving the terminal, thumbnailing over SSH, dropping a rendered banner into scripts or MOTDs, and regenerating the fastfetch logo whenever the source portrait changes — just rerun the command above with a new `--size` or `--symbols` to retune the look.
