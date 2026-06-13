# 2026-06-13 (4, MBP) — nvim 0.12.2 handoff verified + oh-my-posh/vi-mode MBP cleanup

First MBP session since the iMac's nvim 0.12.2 fixes. Confirmed the handoff traveled and finished the machine-local half of the 2026-06-12 oh-my-posh/vi-mode reversion.

## Done
- **Machine confirmed:** MBP (arm64, `/opt/homebrew`, nvim **0.12.2** — same version the iMac fixes targeted).
- **nvim handoff verified:** first `nvim` launch compiled all **20 treesitter parsers on `master`**, nvim-tree + treesitter load clean on 0.12.2. The iMac's `branch="master"` + updated `lazy-lock.json` fix carried through dot-sync exactly as intended. (The `-- More --` pager flood during install reads as a hang but isn't — Space/`q` pages through.)
- **oh-my-posh / vi-mode (MBP-local cleanup):** repo side was already reverted 2026-06-12; verified the MBP `.zshrc` symlink is clean of omp/vi-mode (only hit was an unrelated `y()` comment), and **p10k 1.20.0** is installed and is what the prompt actually sources (line 25) — so removing omp won't touch the prompt. Deleted the local cache `~/.cache/oh-my-posh-theme`.

## Handed off (provisioning — user runs)
- `brew uninstall oh-my-posh` — binary **29.15.1** still installed on the MBP; Brewfile already dropped it 2026-06-12, so this just reconciles installed state. Closes the omp/vi-mode arc on the MBP.

## Next / still open on the MBP
- **iTerm not on the shared custom-folder plist** → Option-arrows / word-jump keys dead. GUI fix: point iTerm at `~/.dotfiles/iterm`, save = Manually, ⌘Q, relaunch. (Unchanged from prior sessions.)
- Optional: kill the nvim `-- More --` pager flood on first-launch parser installs with a one-line config tweak, if it keeps being annoying.
