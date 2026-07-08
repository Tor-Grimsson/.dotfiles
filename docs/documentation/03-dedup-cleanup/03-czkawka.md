---
title: Czkawka
type: reference
status: active
updated: 2026-06-04
description: Multi-purpose cleaner that finds exact and similar (fuzzy) duplicate files, images, music, and videos.
aliases:
  - czkawka
  - czkawka_cli
tags:
  - domain/cleanup/dedup
  - pattern/cli
  - integration/brew-formula
links:
  website: https://github.com/qarmin/czkawka
  repo: https://github.com/qarmin/czkawka
  manual: https://github.com/qarmin/czkawka/blob/master/instructions/Instruction.md
  brew: https://formulae.brew.sh/formula/czkawka
covers:
  - similar-image and similar-video detection (perceptual hashing)
  - similar-music detection by tags and content
  - exact duplicates, empty files/folders, broken files
related:
  - "[[01-jdupes|jdupes]]"
  - "[[02-rmlint|rmlint]]"
---

## Summary
Czkawka is a fast Rust cleaner that goes beyond byte-for-byte matching: alongside exact duplicates it finds visually similar images, similar videos, and similar music using perceptual hashing and tag/content analysis. The Homebrew formula installs the command-line front end, `czkawka_cli` (a GTK GUI also exists under the project).

## Why installed
It is the fuzzy tier of the dedup stack — the tool that catches near-duplicates that jdupes and rmlint cannot, such as a resized JPEG, a re-encoded video, or the same track at a different bitrate. Essential when curating a media library where copies are not bit-identical.

## Most common use case
Finding visually similar images in a photo folder:

```sh
czkawka_cli image -d ~/Pictures
```

## Biggest win
Perceptual similarity matching. It reports images and videos that look the same to a human even when the files differ at the byte level, with a tunable similarity threshold — something exact-hash dedupers fundamentally cannot do.

## How to use
```sh
# Similar images, with adjustable strictness
czkawka_cli image -d ~/Pictures --similarity-preset High

# Similar videos
czkawka_cli video -d ~/Movies

# Similar music by tags / content
czkawka_cli music -d ~/Music

# Plain exact duplicate files
czkawka_cli dup -d /path/to/dir

# Empty folders and empty files
czkawka_cli empty-folders -d /path/to/dir
czkawka_cli empty-files -d /path/to/dir

# Save results to a file for later review
czkawka_cli image -d ~/Pictures -f results.txt
```

## Future use
The video and music similarity modes are the under-used capability worth leaning on — deduping re-encoded clips and variable-bitrate audio that the exact tools miss. Its results-export and reference-folder options also make it a candidate for a staged media-curation pass that flags near-duplicates into a review list before anything is removed.
