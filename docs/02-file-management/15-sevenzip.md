---
title: 7-Zip (sevenzip)
type: reference
status: active
updated: 2026-06-14
description: High-ratio file archiver. Command is `7zz`. Installed as yazi's backend for browsing/extracting inside archives.
aliases:
  - sevenzip
  - 7zz
  - 7-Zip
tags:
  - domain/files
  - pattern/cli
  - integration/brew-formula
links:
  website: https://www.7-zip.org/
  repo: https://github.com/ip7z/7zip
  manual: https://www.7-zip.org/
  brew: https://formulae.brew.sh/formula/sevenzip
covers:
  - 7zz create / extract / list
  - Why it's here (yazi archive preview backend)
related:
  - "[[02-yazi|Yazi]]"
  - "[[06-keka|Keka]]"
---

## Summary
The 7-Zip CLI — strong compression across many formats (7z, zip, tar, gz, xz, rar-read, …). The binary is **`7zz`** (brew's `sevenzip`, not the older `p7zip`'s `7z`).

## Use

```sh
7zz a out.7z file1 dir2     # create (add) an archive
7zz x archive.7z            # extract, keeping full paths
7zz e archive.7z            # extract flat (no dir structure)
7zz l archive.7z            # list contents without extracting
7zz t archive.7z            # test integrity
```

## Why installed
yazi's backend for **previewing and extracting inside archives** — hover a `.7z`/`.zip` in [Yazi](02-yazi.md) and it lists the contents in the preview pane; the `extract` opener uses it too. Not part of daily CLI use, but yazi expects a `7z`/`7zz` on PATH. The GUI counterpart for interactive archiving is [Keka](06-keka.md).
