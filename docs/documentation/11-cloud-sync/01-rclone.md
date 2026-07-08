---
title: rclone
type: reference
status: active
updated: 2026-06-04
description: Command-line program to sync files and directories to and from cloud storage.
aliases:
  - rclone
tags:
  - domain/cloud
  - pattern/cli
  - integration/brew-formula
links:
  website: https://rclone.org/
  repo: https://github.com/rclone/rclone
  manual: https://rclone.org/docs/
  brew: https://formulae.brew.sh/formula/rclone
covers:
  - Configuring remotes
  - copy / sync / move between local and cloud
  - macOS mount caveat (use nfsmount)
related:
  - "[[07-storage-redundancy|Storage redundancy & backup]]"
---

## Summary
rclone is a command-line tool that syncs, copies, and moves files between the local filesystem and a long list of cloud storage providers. It treats each configured backend as a named "remote" and exposes rsync-like commands across all of them. It supports encryption, checksums, and bandwidth control on every transfer.

## Why installed
It is the cloud-sync workhorse for this setup — a single CLI that pushes and pulls files to whatever object store or cloud drive is in use, scriptable into backup and mirror routines. One tool covers every provider instead of a separate sync app per service.

## Most common use case
`rclone sync` a local directory up to (or down from) a configured remote, mirroring the source so the destination matches exactly.

## Biggest win
Provider-agnostic, scriptable transfers with verification. The same command set works across dozens of backends, with checksum-based integrity checking and a `--dry-run` flag that makes destructive syncs safe to rehearse.

## How to use
```sh
# Interactively define a remote (S3, B2, Drive, etc.)
rclone config

# List remotes and browse a remote's contents
rclone listremotes
rclone ls remote:bucket

# Copy local -> remote (adds/updates, never deletes)
rclone copy ~/dir remote:bucket/dir -P

# Mirror local -> remote (makes destination match source; deletes extras)
rclone sync ~/dir remote:bucket/dir --dry-run    # rehearse first
rclone sync ~/dir remote:bucket/dir -P

# Mount a remote as a filesystem on macOS (FUSE 'mount' is unavailable)
rclone nfsmount remote:bucket /mnt/point
```

## Future use
rclone could back the dotfiles' off-machine backups end to end — crypt-wrapped remotes for sensitive data, scheduled `sync` jobs, and `bisync` for two-way mirroring of a working directory across machines.
