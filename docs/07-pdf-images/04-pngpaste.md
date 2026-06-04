---
title: pngpaste
type: reference
status: active
updated: 2026-06-04
description: Pastes an image from the macOS clipboard straight to a file or stdout from the command line.
aliases:
  - pngpaste
tags:
  - domain/images
  - pattern/cli
  - integration/brew-formula
links:
  website: https://github.com/jcsalterego/pngpaste
  repo: https://github.com/jcsalterego/pngpaste
  manual: https://github.com/jcsalterego/pngpaste/blob/master/README.md
  brew: https://formulae.brew.sh/formula/pngpaste
covers:
  - Saving clipboard images to a file
  - Piping clipboard image data to stdout
  - Bridging screenshots into shell scripts
related:
  - "[[01-imagemagick|ImageMagick]]"
  - "[[02-img2pdf|img2pdf]]"
---

## Summary
pngpaste reads an image off the macOS clipboard (the `NSPasteboard`) and writes it to a file or to stdout. It is the missing command-line counterpart to Cmd-V for images — the equivalent of `pbpaste`, but for pixels instead of text.

## Why installed
macOS has no built-in way to dump a copied image to a file from the shell. pngpaste closes that gap, letting screenshots and copied images flow directly into scripts, editors, and the rest of the image toolchain without a manual save-as.

## Most common use case
Taking a screenshot to the clipboard (Cmd-Ctrl-Shift-4), then saving it to a file in one command to drop into notes, a repo, or a markdown doc.

## Biggest win
It turns the clipboard into a scriptable source. Combined with a quick capture shortcut, an image goes from screen to named file — and onward into ImageMagick or img2pdf — without ever opening an application.

## How to use
```sh
pngpaste shot.png            # save clipboard image to shot.png
pngpaste ~/Desktop/x.jpg     # extension picks the output format
pngpaste -                   # write image to stdout (pipe it onward)
pngpaste - | magick - -resize 50% small.png   # paste and resize in one go
```

## Future use
Capture helpers in the shell config — a function that timestamps a pasted screenshot into a notes folder, or one that pastes, optimizes via ImageMagick, and copies the result back, making clipboard-to-asset a single keystroke.
