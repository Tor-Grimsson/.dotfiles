---
title: iperf3
type: reference
status: active
updated: 2026-06-04
description: Active measurement tool for benchmarking maximum TCP, UDP, and SCTP throughput between two hosts.
aliases:
  - iperf3
tags:
  - domain/network
  - pattern/cli
  - integration/brew-formula
links:
  website: https://github.com/esnet/iperf
  repo: https://github.com/esnet/iperf
  manual: https://software.es.net/iperf/
  brew: https://formulae.brew.sh/formula/iperf3
covers:
  - Running a server/client throughput test
  - TCP and UDP bandwidth measurement
related:
  - "[[01-nmap|nmap]]"
  - "[[02-arp-scan|arp-scan]]"
  - "[[05-network-security|Network & remote card]]"
---

## Summary
iperf3 measures the real throughput between two machines. One host runs as a server, the other connects as a client, and iperf3 pushes traffic to report achievable bandwidth, jitter, and packet loss for TCP, UDP, or SCTP.

## Why installed
It answers "how fast is this link, really" with a hard number instead of guesswork. When a transfer feels slow or a new cable, switch, or Wi-Fi setup needs validating, iperf3 measures the actual end-to-end speed between two boxes on the network.

## Most common use case
Running `iperf3 -s` on one machine and `iperf3 -c <server-ip>` on another to get the sustained TCP throughput between them.

## Biggest win
It tests the link itself rather than a service. A file copy is bottlenecked by disks, protocols, and software; iperf3 generates pure synthetic traffic, so the number it reports is the network's real ceiling — the only honest way to tell a slow link from a slow application.

## How to use
```sh
# On the receiving host: start the server
iperf3 -s

# On the sending host: run a 10-second TCP test against it
iperf3 -c 192.168.1.10

# Reverse direction (server sends to client)
iperf3 -c 192.168.1.10 -R

# UDP test at a target bitrate, reporting jitter and loss
iperf3 -c 192.168.1.10 -u -b 100M

# Run parallel streams to saturate the link
iperf3 -c 192.168.1.10 -P 4
```

## Future use
JSON output (`-J`) makes results loggable for tracking link performance over time, and a persistent server (via launchd or `brew services`) would let any client benchmark against this machine on demand. UDP jitter/loss tests are useful for validating Wi-Fi or VPN quality.
