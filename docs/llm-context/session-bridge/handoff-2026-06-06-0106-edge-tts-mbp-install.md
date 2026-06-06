# handoff — edge-tts: MBP half still pending

**Goal of the arc:** clipboard text-to-speech on *both* machines — edge-tts (Microsoft neural voices, not Apple) + `speak` alias, for reading long agent replies aloud.

**Done (iMac, 2026-06-06):** `pipx install edge-tts` (7.2.8, verified); `speak` alias in `shell/.zshrc`; doc `docs/06-media-av/06-edge-tts.md`; INDEX rows/counts; Brewfile breadcrumb under `brew "pipx"`. Detail: `../session-log/2026-06-06-edge-tts-speak-alias.md`.

**Current state:** repo changes land on the MBP via dot-sync once the user commits — but the pipx venv is machine-local, so the MBP has the `speak` alias *without the binary behind it*.

**Next action (first agent on the MBP):**
1. Run `pipx install edge-tts` (user has pre-approved this install on both machines).
2. Verify: `edge-tts --text "test" --write-media /tmp/t.mp3 && ls -la /tmp/t.mp3` (needs network; plays via mpv, already installed).
3. Confirm `speak` resolves in a fresh shell. Do **not** delete this handoff — per protocol it's superseded by the next session log, never auto-deleted.

**Not yet in AGENT-CONTEXT:** nothing — its status line already flags the pending MBP install.
