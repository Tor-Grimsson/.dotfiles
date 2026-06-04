---
title: Nmap
type: reference
status: active
updated: 2026-06-04
description: Port scanner and network mapper for discovering hosts, open ports, and services on a network.
aliases:
  - nmap
tags:
  - domain/network
  - domain/security
  - pattern/cli
  - integration/brew-formula
links:
  website: https://nmap.org/
  repo: https://github.com/nmap/nmap
  manual: https://nmap.org/book/man.html
  brew: https://formulae.brew.sh/formula/nmap
covers:
  - Host discovery and port/service scanning
  - Common scan flags for auditing a local network
related:
  - "[[02-arp-scan|arp-scan]]"
  - "[[06-iperf3|iperf3]]"
---

## Summary
Nmap is a network scanner that maps what is alive on a network and what each host exposes. It discovers live hosts, enumerates open TCP/UDP ports, fingerprints services and OS versions, and runs scripted probes through the Nmap Scripting Engine (NSE).

## Why installed
It is the go-to tool for answering "what is on this network and what is it running" — checking which devices are reachable, which ports a machine has open, and whether something unexpected is listening. It is the first thing reached for when a connection problem or a security question turns into "let me actually scan it".

## Most common use case
Scanning a host or a subnet to see which ports are open and which services answer — typically a quick `nmap <ip>` or a sweep of the local `/24` to inventory devices.

## Biggest win
Service and OS fingerprinting (`-sV`, `-O`) plus the scripting engine. Instead of just "port 22 is open", Nmap tells you it is OpenSSH 9.x and can run vulnerability or enumeration scripts against it — depth that a plain port check cannot match.

## How to use
```sh
# Quick scan of a single host (top 1000 ports)
nmap 192.168.1.10

# Discover live hosts on the local subnet (ping sweep, no port scan)
nmap -sn 192.168.1.0/24

# Service + version detection on common ports
nmap -sV 192.168.1.10

# Aggressive scan: OS detection, versions, scripts, traceroute
sudo nmap -A 192.168.1.10

# Scan specific ports across a range
nmap -p 22,80,443 192.168.1.0/24

# Fast scan of all 65535 TCP ports
nmap -p- -T4 192.168.1.10
```

## Future use
The Nmap Scripting Engine (`--script`) is largely untapped here — categories like `vuln`, `discovery`, and `safe` turn Nmap into a lightweight auditing platform. Scripted scans saved as reusable profiles, plus XML output (`-oX`) piped into other tooling, would be the natural next step.
