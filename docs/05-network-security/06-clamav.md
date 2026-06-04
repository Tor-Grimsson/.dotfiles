---
title: ClamAV
type: reference
status: active
updated: 2026-06-04
description: Open-source antivirus engine used to scan files and quarantine threats from the command line.
aliases:
  - clamscan
tags:
  - domain/security
  - pattern/cli
  - integration/brew-formula
links:
  website: https://www.clamav.net/
  repo: https://github.com/Cisco-Talos/clamav
  manual: https://docs.clamav.net/
  brew: https://formulae.brew.sh/formula/clamav
covers:
  - Updating signatures and scanning files
  - How it powers the Transmission download quarantine script
related:
  - "[[01-nmap|nmap]]"
---

## Summary
ClamAV is an open-source antivirus engine. Its `clamscan` command scans files and directories against a signature database, detects known malware, and can move infected files into quarantine. Signatures are refreshed with `freshclam`.

## Why installed
It powers the Transmission download quarantine script in this repo (`scripts/transmission_scan.sh`). Transmission runs that script when a torrent finishes; the script calls `clamscan -r` on the completed download, moves anything flagged into a `_Quarantine` folder, strips junk files, and fires a macOS notification — so every completed download is scanned before it is touched.

## Most common use case
Recursively scanning a directory and moving any detected threats out of the way — exactly what the post-download hook does with `clamscan -r --move=<quarantine>`.

## Biggest win
A free, scriptable scanner with a `--move` flag, so detection and quarantine happen in a single non-interactive command — which is what makes the unattended Transmission hook possible. No GUI antivirus or paid license sits in the path.

## How to use
```sh
# Update the virus signature database first
freshclam

# Scan a single file
clamscan suspicious.zip

# Scan a directory recursively, only print infected files
clamscan -r --infected ~/Downloads

# Scan and move any detections into a quarantine folder (as the hook does)
clamscan -r --move="$HOME/_Quarantine" --log=scan.log --no-summary --quiet ~/Downloads
```

The Transmission hook (`scripts/transmission_scan.sh`) wires this into the download pipeline automatically.

## Future use
Running `clamd` as a resident daemon (with `clamdscan`) keeps signatures loaded in memory for faster repeat scans. A scheduled `freshclam` via launchd or `brew services` would keep the database current without manual updates — worth adding so the Transmission scans always run against fresh signatures.
