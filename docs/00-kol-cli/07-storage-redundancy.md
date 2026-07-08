---
title: Storage redundancy & backup
type: guide
status: active
updated: 2026-06-26
audience: internal
description: Two drives holding the same data — what RAID/mirroring actually is, why it is NOT a backup, the CLI/GUI/cloud tools (rsync, rclone, Disk Utility, Time Machine, CCC, Backblaze), how sync really works, and an A→Z demo of taking two 8 TB drives from the box to mirrored, off-sited storage.
aliases:
  - storage-redundancy
  - backup
  - raid
  - mirror
tags:
  - domain/storage
  - domain/backup
  - pattern/cli
  - provider/backblaze
related:
  - "[[01-rclone|rclone (reference)]]"
  - "[[05-network-security|Network & remote card]]"
  - "[[01-cli-cheatsheet|CLI cheatsheet]]"
---

# Storage redundancy & backup

Two drives with the same data can mean two very different things, and confusing them is how people lose data while feeling safe. Read §0 before anything else.

---

## 0. The one idea that matters — redundancy ≠ backup

| | **Redundancy** (RAID / mirror) | **Backup** (a copy you can roll back to) |
|---|---|---|
| Protects against | a **drive dying** (keep working, no downtime) | **deletion, corruption, ransomware, theft, "oops"** |
| Does NOT protect against | deletion/corruption — the bad write hits both halves **instantly** | a drive dying *between* backups (you lose the gap) |
| Copy is | live, real-time, automatic | periodic, and ideally **versioned** (keeps old states) |

**"RAID is not a backup."** A mirror copies *everything* the instant it happens — including the `rm -rf` you didn't mean. Redundancy buys *uptime*; backup buys *undo*. You want both, and they're different mechanisms.

**The rule everyone uses — 3-2-1:** **3** copies of the data, on **2** different media, with **1** off-site. Two drives in the same room is 2 copies, 1 medium, 0 off-site — better than nothing, not enough.

---

## 1. The two ways "two drives hold the same data"

| | RAID 1 (mirror) | Scheduled copy (rsync/rclone/CCC) |
|---|---|---|
| Written | both disks at once, by the controller/OS | on a timer (hourly/nightly) |
| Looks like | **one** volume (you never see two) | **two** separate volumes |
| A deleted file | gone on both immediately | still on the copy **until the next sync** (your undo window) |
| If one disk dies | keep working, replace + rebuild | swap to the copy manually |
| Best for | uptime on an always-on box | actual backup with a rollback window |

For two drives the practical RAID choices are **RAID 1** (mirror — same data twice, half the capacity) or **RAID 0** (stripe — one big fast volume, **zero** redundancy, *double* the failure risk). For *"backup the same data,"* you want RAID 1 — or, better on a Mac, a scheduled copy (§6).

---

## 2. RAID, briefly

**Levels:** `0` stripe (speed, no safety) · `1` mirror (2 copies) · `5`/`6` parity (3+ disks, survive 1–2 failures) · `10` mirror+stripe. Two disks → `1` or `0`.

**How it's implemented:**
- **Hardware** — a 2-bay enclosure/DAS with a RAID switch, or a **NAS** (Synology/QNAP). The box presents one volume; the OS sees a single disk.
- **Software** — the OS does it: macOS **Disk Utility → RAID Assistant** (or `diskutil appleRAID`); Linux **`mdadm`**; or **ZFS/Btrfs** mirror (the modern best — checksums catch silent corruption, plus snapshots).
- **macOS reality check:** AppleRAID mirroring works but formats as **Mac OS Extended (JHFS+)**, *not* APFS (APFS has no supported software mirror). USB RAID sets drop offline easily, and rebuilding an 8 TB mirror takes hours. On a Mac, a scheduled copy + cloud usually beats RAID for this goal.

---

## 3. The tools

### CLI
| Tool | Role | Key flags |
|---|---|---|
| **rsync** | local or over-SSH mirror; only sends changed bytes | `-a` archive · `-H` hardlinks · `--delete` mirror deletes · `--backup-dir` keep replaced files · `--dry-run` · `--progress` |
| **rclone** | cloud **and** local; the multi-backend one | `copy` (never deletes) · `sync` (mirrors, deletes) · `bisync` (two-way) · `--backup-dir` · `crypt` remote (client-side encryption) · `mount` |
| **diskutil** | format / partition / RAID on macOS | `list` · `eraseDisk` · `appleRAID` |

> ⚠️ **Your macOS rsync is `openrsync` (protocol 29)** — Apple's stripped BSD replacement. It covers basics but lacks some GNU features (progress, `--backup-dir` edge cases). For backup scripting, **`brew install rsync`** (GNU 3.x) and call it explicitly. Your `kolkrabbi:` rclone remote (Backblaze B2) is already configured.

### GUI
- **Time Machine** (native) — versioned, set-and-forget, to a **dedicated** drive. Hourly→daily→weekly snapshots. The easiest real backup on a Mac.
- **Carbon Copy Cloner** / **SuperDuper!** — scheduled clones with a *SafetyNet* (keeps changed/deleted files). CCC is the Mac power-user standard. *(Neither installed here — worth CCC if you want GUI scheduling.)*
- **Disk Utility** — format, **RAID Assistant**, and **Restore** (one-shot clone of a volume).
- **NAS GUI** (Synology DSM / QNAP) if you go the appliance route.

### Cloud (the off-site "1")
- **Backblaze Personal Backup** — unlimited, ~flat fee per computer, GUI, backs up internal + attached drives. Gotcha: an external drive not reconnected for **30 days gets purged** from the backup.
- **Backblaze B2** — object storage, pay-per-GB, driven by **rclone** — *you already use this* (`kolkrabbi:`). Best paired with rclone **crypt** so the cloud copy is encrypted before it leaves the Mac.
- rclone also speaks **S3, Google Drive, Dropbox** (you have Dropbox), etc. **iCloud is sync, not backup** — don't count it.

---

## 4. How the sync actually works

- **"Same file?"** — default check is **size + modification-time** (fast). `--checksum`/`-c` hashes contents instead (slow, certain). Use checksum when mtimes lie (after a restore, across filesystems).
- **Direction:**
  - **One-way mirror** — dest becomes identical to source; **deletes propagate** (`rsync --delete`, `rclone sync`). Powerful and dangerous.
  - **Additive copy** — `rclone copy` / `rsync` without `--delete`: only adds/updates, never removes. Safe, but the copy bloats with old files.
  - **Two-way** — `rclone bisync`: changes flow both directions (laptop ↔ desktop). More moving parts.
- **Incremental + delta:** only changed *files* are touched; rsync's delta algorithm sends only the changed *blocks* of a big file over a link. First run is slow (everything), later runs are quick (the diff).
- **Versioning / soft-delete — your undo:** `--backup-dir=<dated path>` moves replaced/deleted files aside instead of destroying them; CCC SafetyNet, B2 file-versions + lifecycle, Time Machine hourlies, and APFS/ZFS **snapshots** all do the same job. Without one of these, a mirror faithfully reproduces your mistakes.
- **The deletion trap:** `rsync --delete` and `rclone sync` will happily delete the only other copy of a file you removed by accident. Mitigate with a `--backup-dir`, with `copy` instead of `sync`, or with cloud versioning.

---

## 5. Accessing the files

- **RAID mirror** → one mounted volume, transparent; you use it like any disk and never see the second drive.
- **Scheduled copy** → two volumes; you work on the primary, the mirror sits cold until you need it.
- **Cloud** → the service's app, the web UI, or **`rclone mount kolkrabbi: ~/cloud`** to use the bucket as a normal folder. `rclone ncdu kolkrabbi:` browses sizes; `rclone serve` exposes it over HTTP/WebDAV.

---

## 6. A→Z demo — two 8 TB drives, box to mirrored storage

**My call (§7 explains why):** *don't* RAID them. Drive 1 = working vault, drive 2 = nightly **versioned** mirror, Backblaze B2 = off-site. That's 3-2-1, and an accidental delete on drive 1 doesn't instantly vaporise drive 2. The real RAID-1 path is in §6.6 if you specifically want one auto-volume.

### 6.1 Unbox & connect
8 TB drives are almost always **3.5" desktop** units → they need their **own power brick** plus USB-C/USB-A (or a dock/enclosure if they're bare internal drives). Plug power, then data, power on. Give them air — they run warm, don't stack them touching.

### 6.2 See them
```sh
diskutil list          # find the new externals, e.g. /dev/disk6 and /dev/disk7
```
A fresh drive shows as `external, physical` with a `GUID_partition_scheme`. (Your current externals show as `kol-ssd-4000`, `kol-ssd-480` — the new ones will appear the same way once named.)

### 6.3 Format each — APFS, GUID
**GUI:** Disk Utility → View → **Show All Devices** → select the **physical disk** (the top-level 8 TB line, not a volume) → **Erase** → Format **APFS**, Scheme **GUID Partition Map** → name them per your convention: **`kol-hdd-8000-a`** and **`kol-hdd-8000-b`**.

**CLI equivalent:**
```sh
diskutil eraseDisk APFS kol-hdd-8000-a GPT /dev/disk6
diskutil eraseDisk APFS kol-hdd-8000-b GPT /dev/disk7
```
- **APFS** = Mac-only (best). Use **exFAT** instead only if a Windows box must also mount it (no journaling/permissions — weaker).
- Encryption: skip unless you'll manage the key — APFS (Encrypted) / FileVault-on-external prompts for a password and is unrecoverable if lost.

### 6.4 Drive 1 → drive 2, nightly & versioned
Put your data on `kol-hdd-8000-a`. Mirror to `-b` with replaced/deleted files archived into a dated folder (your undo window). Use **brew GNU rsync**:

```sh
# dry-run first — ALWAYS, especially with --delete
rsync -aH --delete --dry-run \
  --backup-dir="/Volumes/kol-hdd-8000-b/_versions/$(date +%F)" \
  /Volumes/kol-hdd-8000-a/  /Volumes/kol-hdd-8000-b/

# real run: drop --dry-run
```
What the flags do: `-a` preserve everything (perms/times/symlinks), `-H` keep hardlinks, `--delete` make `-b` match `-a` (mirror), `--backup-dir=…/$(date +%F)` move anything it would delete/overwrite into today's dated folder instead of destroying it. Trailing slash on the source = "contents of", not the folder itself — get this right or you nest.

Automate it daily with a launchd plist (same pattern as your `dot-sync` daemon), or skip the script entirely and let **Carbon Copy Cloner** schedule it with SafetyNet.

### 6.5 Off-site → Backblaze B2 (encrypted)
One-time: make an encrypted view of your bucket so the cloud copy is unreadable without your key —
```sh
rclone config        # n) new remote → type: crypt → wrap "kolkrabbi:bucket/vault" → set passwords
```
Then, weekly:
```sh
rclone sync /Volumes/kol-hdd-8000-a/ kolkrabbi-crypt:vault \
  --backup-dir "kolkrabbi-crypt:vault-versions/$(date +%F)" -P
```
(`-P` shows progress; `--backup-dir` keeps cloud-side versions.) Alternatively, enable **B2 object versioning + a lifecycle rule** and skip the per-run backup-dir.

### 6.6 Alternative — an actual RAID 1 volume
If you truly want **one auto-mirrored volume** instead of two drives:
```sh
# Disk Utility → File → RAID Assistant → Mirror (RAID 1) → add both disks → name → format
# CLI equivalent (ERASES both disks):
diskutil appleRAID create mirror kol-vault "Journaled HFS+" disk6 disk7
```
Format is **Mac OS Extended (Journaled)** — AppleRAID doesn't do APFS. Result: a single `kol-vault` volume that writes to both disks live. Caveats: **erases both disks**, **is not a backup**, USB RAID sets drop offline easily, and a rebuild after a failure runs for hours. If you do this, **still** add the B2 off-site leg.

### 6.7 Verify & eject
```sh
diskutil list                               # see the new volumes (or the AppleRAID set)
du -sh /Volumes/kol-hdd-8000-a /Volumes/kol-hdd-8000-b   # sizes should track after a sync
diskutil eject /dev/disk6                    # unmount safely before unplugging
```

---

## 7. What I'd actually run (the verdict)

- **`kol-hdd-8000-a`** — working vault (where you put files).
- **`kol-hdd-8000-b`** — nightly `rsync -aH --delete` mirror with a dated `--backup-dir` (versioned, so deletes are recoverable).
- **`kolkrabbi-crypt:` on B2** — weekly off-site, client-side encrypted.

= 3 copies, 2 local media + cloud, 1 off-site, with a rollback window. **RAID only if you need zero-downtime** on an always-on box — and never as *the* backup. Two spinning drives + your existing B2 is a genuinely solid setup; the only thing missing today is the second drive and the schedule.

---

## 8. Quick reference

| Task | Command |
|---|---|
| List disks | `diskutil list` |
| Format a drive (APFS) | `diskutil eraseDisk APFS <name> GPT /dev/diskN` |
| Local mirror (versioned) | `rsync -aH --delete --backup-dir=".../$(date +%F)" SRC/ DST/` |
| Preview any rsync | add `--dry-run` |
| Off-site to cloud | `rclone sync SRC/ kolkrabbi-crypt:vault -P` |
| Cloud as a folder | `rclone mount kolkrabbi: ~/cloud` |
| Make a RAID 1 mirror | `diskutil appleRAID create mirror <name> "Journaled HFS+" diskN diskM` |
| Eject safely | `diskutil eject /dev/diskN` |

---

*Living doc. Tool depth: [[01-rclone|rclone]]. The golden rule stays §0 — redundancy keeps you running, backup lets you undo; you want both. Symlinked into the kol-vault for print.*
