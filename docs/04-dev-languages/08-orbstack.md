---
title: OrbStack
type: reference
status: active
updated: 2026-06-04
description: Fast, light replacement for Docker Desktop on macOS that also runs full Linux VMs with minimal resource overhead.
aliases:
  - orb
  - orbctl
tags:
  - domain/dev/containers
  - pattern/gui
  - integration/brew-cask
links:
  website: https://orbstack.dev/
  manual: https://docs.orbstack.dev/
  brew: https://formulae.brew.sh/cask/orbstack
covers:
  - First-run setup and the Docker-compatible CLI
  - Running containers and lightweight Linux VMs
related:
  - "[[02-visual-studio-code|VS Code]]"
---

## Summary
OrbStack is a native macOS app that provides a Docker engine and lightweight Linux virtual machines. It is a drop-in replacement for Docker Desktop — the standard `docker` CLI works unchanged — but starts faster, uses far less CPU, memory, and disk, and adds an `orb`/`orbctl` command for managing full Linux distros alongside containers.

## Why installed
It is the container and Linux runtime for this Mac. Docker Desktop is heavy and battery-hungry; OrbStack runs the same workflows with a fraction of the overhead and near-instant startup, so containers and a throwaway Linux environment are always available without bogging the machine down.

## Most common use case
Running Docker containers locally — `docker run`, `docker compose up` — backed by the OrbStack engine instead of Docker Desktop, with the menu-bar app managing the engine lifecycle.

## Biggest win
Speed and efficiency without changing tooling. The Docker CLI and Compose work exactly as before, but startup is near-instant and resource use is dramatically lower, while the `orb` command adds frictionless Linux VMs that integrate with the host filesystem and network.

## How to use
- First run: open the OrbStack app once to finish setup; it installs the Docker engine and the `docker` CLI integration automatically.
- Use Docker normally: `docker run`, `docker ps`, `docker compose up` — no daemon to start manually.
- Create a Linux machine: `orb create ubuntu` then `orb` to drop into a shell in it.
- List and manage machines: `orbctl list`, `orbctl start <name>`, `orbctl stop <name>`.
- The menu-bar app shows running containers and machines and controls the engine.

## Future use
Lean on the Linux VM side (`orb`) for distro-specific testing and builds with host-mounted files, and pair it with VS Code Dev Containers / Remote-SSH to edit code running inside an OrbStack machine directly from the editor.
