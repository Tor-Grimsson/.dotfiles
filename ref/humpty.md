# humpty — quick reference

Filter: `ref-humpty <word …>` · the muzzle plugin — source: `~/dev/projects/kol-dumpty/humpty`
complain here about: word soup · buried leads · ignored laws · gates misfiring

## dial

one setting instead of per-incident corrections · persists across sessions

| keys       | does                                    |
|------------|-----------------------------------------|
| $humpty    | show the dial                           |
| $humpty 1  | loose                                   |
| $humpty 2  | standard (the default)                  |
| $humpty 3  | strict                                  |
| $humpty 4  | muzzle                                  |
| $humpty off| plugin inert, text stays plain          |

[e] — as typed:

```sh
$humpty 3
```

## clamp

escalating word floors — decay back to normal on clean turns

| keys   | does                          |
|--------|-------------------------------|
| /st    | tap on the glass — 160 words  |
| /stf   | warning shot — 80 words       |
| /stfu  | 40 words · substance only     |

`tmpl-wl-*` is the standing version of the same idea — a budget that does NOT decay.

## laws

| # | law                                          |
|---|----------------------------------------------|
| 1 | use what we have — find it before building it |
| 2 | don't improvise — reference a precedent      |
| 3 | high reference = canon — promote it          |
| 4 | read it twice — unclear means ask            |
| 5 | check means check — read-verbs only report   |

fuck-up protocol (always on): one line of ownership, then one question line — memory? severity? scope?

## gate

| keys                | does                                       |
|---------------------|--------------------------------------------|
| prefix g            | agent-grant 15m read-only window           |
| agent-grant [min]   | same from the shell · `off` · `status`     |
| humpty-grant git    | open a git-write window                    |

## lobby

| keys   | does                                              |
|--------|---------------------------------------------------|
| /lobby | read `humpty/lobby/` — queued behaviour |
| staged | research-dump · text-overload (family folder)     |
| file   | clip-drop.sh --humpty NAME                        |

----
doc: docs/operations/systems/agent-system/INDEX.md
