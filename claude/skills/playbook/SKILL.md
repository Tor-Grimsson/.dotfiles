---
name: playbook
description: Short alias for /log-work-playbook — append an entry to the live work-journal playbook in <ctx>/playbook/ (or scaffold a new one). Terse, append-only, real timestamps, one idea per line. Use when the user invokes /playbook or asks to journal work-in-progress without the log-work prefix.
---

# playbook (alias)

This is a short-name alias. Follow the `log-work-playbook` skill verbatim:
read `~/.claude/skills/log-work-playbook/SKILL.md` and execute its steps —
locate the context dir, get the real time via `date`, append at the BOTTOM of
the newest `<ctx>/playbook/*.md` (or scaffold a new playbook when asked),
match the file's own entry format, never touch AGENT-CONTEXT, and report one
line: `Playbook entry appended to <file> at HH:MM`.
