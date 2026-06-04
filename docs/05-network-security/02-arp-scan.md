---
title: arp-scan
type: reference
status: active
updated: 2026-06-04
description: Layer-2 scanner that discovers and fingerprints every device on the local network via ARP requests.
aliases:
  - arp-scan
tags:
  - domain/network
  - domain/security
  - pattern/cli
  - integration/brew-formula
links:
  website: https://github.com/royhills/arp-scan
  repo: https://github.com/royhills/arp-scan
  manual: https://github.com/royhills/arp-scan/wiki
  brew: https://formulae.brew.sh/formula/arp-scan
covers:
  - Enumerating local-network devices by IP and MAC
  - Identifying hardware vendors from MAC OUI
related:
  - "[[01-nmap|nmap]]"
---

## Summary
arp-scan sends ARP requests across the local link and lists every device that replies, with its IP address, MAC address, and the hardware vendor inferred from the MAC OUI prefix. Because it works at layer 2, it finds hosts that ignore ICMP pings and never appear in a higher-level scan.

## Why installed
It is the fastest way to get an honest device inventory of the local network. Where Nmap's ping sweep can miss hosts that drop pings, arp-scan catches everything on the same broadcast domain — useful for spotting an unknown device, finding a headless box's IP, or confirming what is actually plugged in.

## Most common use case
Listing every device on the local segment with `arp-scan --localnet` to see IPs, MACs, and vendor names in one shot.

## Biggest win
Layer-2 discovery is essentially unspoofable on the local link — a device must answer ARP to use the network at all, so arp-scan sees it regardless of firewall rules. The automatic vendor lookup (Apple, Espressif, Ubiquiti, etc.) makes an unfamiliar MAC immediately identifiable.

## How to use
```sh
# Scan the whole local network (auto-detects interface and subnet)
sudo arp-scan --localnet

# Scan a specific interface
sudo arp-scan --interface=en0 --localnet

# Scan an explicit range
sudo arp-scan 192.168.1.0/24

# Show the detected interface and timing details
sudo arp-scan --localnet --verbose
```

## Future use
Periodic scans diffed against a known-good device list would turn arp-scan into a simple rogue-device detector — anything new on the segment shows up immediately. Pairing it with Nmap (arp-scan to find hosts, Nmap to fingerprint them) is the natural escalation path.
