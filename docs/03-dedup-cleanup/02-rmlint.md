---
title: rmlint
type: reference
status: active
updated: 2026-06-04
description: Fast tool that finds duplicates plus other filesystem lint and emits a reviewable cleanup script.
aliases:
  - rmlint
tags:
  - domain/cleanup/dedup
  - pattern/cli
  - integration/brew-formula
links:
  website: https://rmlint.readthedocs.io/en/master/
  repo: https://github.com/sahib/rmlint
  manual: https://rmlint.readthedocs.io/en/master/
  brew: https://formulae.brew.sh/formula/rmlint
covers:
  - duplicate files and duplicate directory detection
  - empty files/dirs, broken symlinks, and other lint
  - generated shell script for reviewable, deferred cleanup
related:
  - "[[01-jdupes|jdupes]]"
  - "[[03-czkawka|czkawka]]"
---

## Summary
rmlint scans a filesystem for "lint": duplicate files, entire duplicate directories, empty files and folders, broken symlinks, and non-stripped binaries. Rather than deleting anything itself, it writes out a `rmlint.sh` script describing every action, which you read and then run when satisfied.

## Why installed
It is the heavier, more thorough counterpart to jdupes — it catches not just file duplicates but duplicate directory trees and assorted cruft, and its review-before-execute model makes large cleanups safe. When a quick exact-dedup pass is not enough, rmlint does the full sweep.

## Most common use case
Scanning a tree and generating the cleanup script, then inspecting it before running:

```sh
rmlint /path/to/dir
# review the generated rmlint.sh, then:
./rmlint.sh
```

## Biggest win
The generated, human-readable `rmlint.sh` is the killer feature: nothing is destroyed at scan time, you get a complete diff of intended actions, and you can edit the script before executing. Its duplicate-directory detection (reporting a whole redundant folder as one finding instead of hundreds of individual file matches) makes real-world cleanups far less tedious than per-file dedupers.

## How to use
```sh
# Scan current directory for all lint types, write rmlint.sh
rmlint

# Scan a specific path
rmlint /path/to/dir

# Treat one tree as the "original" to preserve, dedupe a second against it
rmlint /path/to/keep // /path/to/scan

# Only look for duplicates, skip other lint types
rmlint -T df /path/to/dir

# Replace duplicates with reflinks/hardlinks via the generated script
rmlint -c sh:link /path/to/dir

# Review, then execute
./rmlint.sh
```

## Future use
The `// ` two-tree syntax (a "tagged" original set vs. a set to clean) is ideal for reconciling a working folder against an archive without risking the master copy. The handler config (`-c sh:link`, paranoid hashing, JSON output via `-o json`) opens the door to wiring rmlint into a scripted library-maintenance routine that links rather than deletes and logs every action.
