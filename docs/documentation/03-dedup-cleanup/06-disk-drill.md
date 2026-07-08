---
title: Disk Drill
type: reference
status: active
updated: 2026-06-04
description: macOS data-recovery app for restoring deleted files from disks, partitions, and external media.
aliases:
  - Disk Drill
tags:
  - domain/cleanup
  - pattern/gui
  - integration/brew-cask
  - provider/cleverfiles
links:
  website: https://www.cleverfiles.com/
  brew: https://formulae.brew.sh/cask/disk-drill
covers:
  - recovery of deleted files and lost partitions
  - scanning internal disks, external drives, and memory cards
  - preventive recovery (Recovery Vault) and disk health
related:
  - "[[04-appcleaner|AppCleaner]]"
---

## Summary
Disk Drill is a data-recovery application from CleverFiles. It scans disks, partitions, and external media for deleted or lost files and reconstructs them, supporting a wide range of file types and storage devices. It also bundles preventive tools that make future recovery more reliable.

## Why installed
It is the safety net of the cleanup stack: aggressive deduping and uninstalling carry the risk of removing something that turns out to be needed, and Disk Drill is the tool that gets it back. Having a known recovery option installed makes the rest of the cleanup tooling safer to use.

## Most common use case
Running a scan on a drive (or a memory card / external disk) after accidental deletion or a wipe, then previewing and recovering the wanted files to a separate destination.

## Biggest win
Broad recovery coverage with file preview before restore — it scans many filesystems and device types and lets you confirm a file is intact before recovering, instead of restoring blindly. Its Recovery Vault adds a preventive layer that improves the odds of a clean recovery later.

## How to use
- Launch Disk Drill and grant it Full Disk Access when macOS prompts (required to read raw disks).
- Select the disk, partition, or external device to scan and start the scan.
- Browse or filter the found files, preview them to confirm contents, then **Recover** to a *different* drive than the one being scanned.
- Enable **Recovery Vault** / guaranteed-recovery features beforehand on disks you want extra protection on.
- Use the extra disk tools (S.M.A.R.T. health, free-space cleanup) for routine drive maintenance.

## Future use
The preventive side — Recovery Vault and byte-to-byte disk backups — is worth enabling proactively on the primary drive so that a future accidental deletion is recoverable by design rather than by luck. The drive-health monitoring can also fold into a periodic maintenance routine alongside the dedup passes.
