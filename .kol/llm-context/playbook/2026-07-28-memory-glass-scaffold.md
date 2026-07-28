# Playbook — claude-glass shareable scaffold

> **Live work journal.** Append-only, newest at the bottom, real timestamps. One idea per line, no prose.
> Milestone logs: `session-log/`. Prior arc: `2026-07-28-kol-claude-memory-build.md` (sealed 🏁).

**Goal:** Ship the public template of the memory system — `sync.sh` + generic INDEX + README + bundled docs, zero KOL content — per `docs/kol-claude-memory/04-sharing.md`.

**Standing rules (non-negotiable):**
- ZERO private tokens in the template: no `/Users/biskup`, no client names, no repo roster, no memory content — grep-screened before handoff.
- The private kol-glass instance is never the template — separate folder, separate repo.
- No git — user inits/publishes; hand him the exact commands.

---
## Entries

[06:50 GMT · 2026-07-28] · setup · playbook + skeleton
  what → new playbook (new arc, prior one sealed at milestone) · ~/dev/projects/claude-glass/ created · sync.sh copied from kol-glass, EXCLUDE default neutralised to ()
  note → parked open calls decided: docs BUNDLED (private-repo links explain nothing) · name = claude-glass (neutral, rename-cheap)

[06:51] · template · authored + screened ✓
  what → README.md (pitch, quickstart, privacy, hard dependency) · docs/SYSTEM.md (problem/diagram/tiers/contract/failure-modes, generic paths) · INDEX.md (vault rules, no roster) · .gitignore (lens policy) · sync.sh (bash -n ok)
  verify → token screen CLEAN (biskup/client names/kol-* roster: 0 hits) · tree = 5 tracked files + docs/
  note → template NOT run (a sync.sh run would drop lens dirs into the clean tree) · publishing = user's git; handoff list printed in chat · side effect: the template has docs/ → next kol-glass sync.sh run will lens it into repos/ (correct, just expected)

[07:16] · rename · claude-glass → memory-glass ✓
  what → user ruled: not claude-specific (one seam = flatten()+wire()), name carries the subject not the category → memory-glass; dir mv'd, refs swept (template README/SYSTEM, dotfiles 04-sharing + parking lot, this playbook's filename), sync.sh spec comment repointed to docs/SYSTEM.md — greps: 0 leftovers
  note → ship-scope ruled: .kol/llm-context protocol + scaffold skills NOT bundled — different product, heavy KOL coupling; memory-glass's on-ramp stays one mkdir · looking-glass rejected for the KVM-project namespace collision

[07:20] · reframe · README de-Claude'd ✓ (user catch)
  what → rename had swept the name but not the positioning; README tagline → "for AI coding agents", Claude recast as reference harness/shipped adapter, new "Other harnesses" section (swap the flatten()+wire() seam, or skip the redirect and point the harness's rules/memory config at .kol/llm-memory directly), hard-dependency section scoped to the Claude adapter; SYSTEM.md framing line + INDEX de-Claude'd
  note → deliberate residue: concrete ~/.claude paths stay in quickstart/diagrams — they document the shipped adapter, not the system's identity
