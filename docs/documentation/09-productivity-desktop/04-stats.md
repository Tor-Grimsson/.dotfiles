---
title: Stats
type: reference
status: active
updated: 2026-06-04
description: Open-source macOS menu-bar system monitor.
aliases:
  - stats
tags:
  - domain/productivity
  - pattern/gui
  - integration/brew-cask
links:
  website: https://github.com/exelban/stats
  repo: https://github.com/exelban/stats
  brew: https://formulae.brew.sh/cask/stats
covers:
  - Menu-bar CPU, memory, network, disk, battery readouts
  - Per-module configuration
  - First-run setup
related:
  - "[[01-raycast|Raycast]]"
  - "[[11-htop|htop]]"
---

## Summary
Stats is an open-source macOS application that displays live system metrics in the menu bar. It covers CPU, GPU, memory, disk, network, battery, and sensor readings through individual toggleable modules. Each module shows a compact menu-bar widget and expands to a detailed popover.

## Why installed
It is the always-on system gauge — CPU load, memory pressure, and network throughput visible at a glance without opening Activity Monitor. For a development machine that runs heavy builds and syncs, a passive menu-bar readout catches runaway processes early.

## Most common use case
Glance at the menu bar to read current CPU and network activity, then click the widget for a per-core / per-process breakdown when something spikes.

## Biggest win
Free and open-source with granular, per-module control. It replaces several paid menu-bar utilities at once and lets you enable only the metrics you care about, each with its own display style and refresh rate.

## How to use
- Launch Stats once and grant the permissions it requests for sensor/network access.
- Open Settings to enable the modules you want (CPU, Memory, Network, etc.) and hide the rest.
- Configure each module's menu-bar widget style and update interval independently.
- Click any menu-bar widget for the detailed popover.

## Future use
Stats can run shell scripts on threshold events; those hooks could trigger dotfiles maintenance — for example kicking off a cleanup or alerting when disk space crosses a limit.
