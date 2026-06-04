---
title: jdupes
type: reference
status: active
updated: 2026-06-04
description: Fast exact-match duplicate file finder, an enhanced fork of fdupes.
aliases:
  - jdupes
tags:
  - domain/cleanup/dedup
  - pattern/cli
  - integration/brew-formula
links:
  website: https://codeberg.org/jbruchon/jdupes
  repo: https://codeberg.org/jbruchon/jdupes
  manual: https://codeberg.org/jbruchon/jdupes
  brew: https://formulae.brew.sh/formula/jdupes
covers:
  - byte-for-byte exact duplicate detection
  - safe interactive deletion and hardlinking
  - scripting dedup into pipelines
related:
  - "[[02-rmlint|rmlint]]"
  - "[[03-czkawka|czkawka]]"
---

## Summary
jdupes is a command-line tool that finds files with identical content. It is an enhanced, faster fork of the classic `fdupes`, using progressively cheaper checks (size, partial hash, full hash, then a full byte-for-byte comparison) so it only declares a match when files are truly identical.

## Why installed
It is the fast, dependable first pass for reclaiming disk space — point it at a tree, get an exact-duplicate report, and act on it. No fuzzy heuristics, no false positives, so its output can be trusted for unattended or scripted deletion.

## Most common use case
Recursively scanning a directory for exact duplicates and reviewing or deleting them:

```sh
jdupes -r ~/Downloads
```

## Biggest win
It verifies matches with a full byte-for-byte comparison before ever reporting them, so a "duplicate" is guaranteed identical. Combined with size/hash short-circuiting it is dramatically faster than `fdupes` on large trees, which is why it is reached for over the original.

## How to use
```sh
# Recursive scan, print groups of duplicates
jdupes -r /path/to/dir

# Interactively choose which copies to keep/delete
jdupes -r -d /path/to/dir

# Auto-keep the first file in each set, delete the rest (no prompt)
jdupes -r -d -N /path/to/dir

# Replace duplicates with hardlinks instead of deleting
jdupes -r -L /path/to/dir

# Summarize space wasted by duplicates
jdupes -r -m /path/to/dir

# Machine-readable output for scripting (one set per line group)
jdupes -r /path/to/dir
```

## Future use
The hardlink mode (`-L`) is worth adopting for libraries where identical assets legitimately live in multiple folders — it collapses storage without changing the apparent file layout. The JSON/`-o` ordering options also make jdupes suitable as the detection stage of a custom cleanup script that then routes duplicates to a quarantine folder rather than deleting outright.
