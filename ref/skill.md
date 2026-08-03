# skills — quick reference

Filter: `ref-skill <word …>` · slash commands are **user-invoked** · `tmpl-` = output contract
`## keys` is the chat keybindings — not slash commands

## tmpl

how the reply is SHAPED — invoke one, it governs the next reply

| keys              | does                                            |
|-------------------|-------------------------------------------------|
| /tmpl-present     | present understanding + steps, then STOP        |
| /tmpl-ask         | ask · state · blocker · need — four lines       |
| /tmpl-human       | write for a tired human — scannable, no walls   |
| /tmpl-uncanny     | no apology, sympathy, or performed feeling      |
| /tmpl-hl          | high level only, then step through together     |
| /tmpl-bullet      | reformat the last reply into lists/tables       |
| /tmpl-clear       | restate the last reply with far fewer words     |
| /tmpl-stfu        | human-coded noise — substance only, ≤5 lines    |
| /tmpl-yn  /yn     | one word — yes/no · 2+ = `1 no 2 yes` |
| /tmpl-done        | settled items collapse to `N done`              |
| /tmpl-path        | prior art → convention → done → the steps       |
| /tmpl-proposal    | stage a visual side-by-side for approval        |
| /dump             | research puked unparsed — verdict first         |

----
doc: docs/operations/systems/claude-harness/INDEX.md

## wl

word budget — **standing** until another is set · overflow folds into the footer

| keys           | budget          |
|----------------|-----------------|
| /tmpl-wl-100   | ~250 words      |
| /tmpl-wl-80    | ~200 words      |
| /tmpl-wl-60    | ~150 words      |
| /tmpl-wl-40    | ~100 words      |
| /tmpl-wl-10    | ~25 — verdict + footer |

## mode — goal · jana · rosa

what the agent may DO this turn

| keys        | does                                     |
|-------------|------------------------------------------|
| /jana       | answer only — zero tool calls            |
| /yana       | same as jana                             |
| /rosa       | research WITH tools, change NOTHING      |
| /kol-goal   | goal the Stop hook won't let you abandon |
|             | `- [ ]` items — `done` refused till all ticked |
| /kol-goal-force | + refuses the ask-shaped exit — YOU decide |

## kolds

| keys        | does                                        |
|-------------|---------------------------------------------|
| /kolds      | "the design system" — repo, 15 packages |
| /kolds-ref  | cite a token/component before new       |

## lobby

| keys        | does                                          |
|-------------|-----------------------------------------------|
| /lobby      | the router — file · read · audit              |
| /lobby-list | READ this repo's queue, start nothing         |
| the family  | 4 writers · icon · hygiene — see `ref-lobby`  |

the whole system — states, where things go, the law: `ref-lobby`

## maintain

| keys          | does                                      |
|---------------|-------------------------------------------|
| /ref-admin    | add an entry to any ref card              |
| /log-work     | session log (retrospective)               |
| /playbook     | live work journal entry                   |
| /log-work-handoff | forward-looking state, mid-arc        |

## keys

| keys   | does                                     |
|--------|------------------------------------------|
| ctrl+- | UNDO the input buffer — recovers a draft |
| cmd+z  | same undo, mac reflex                    |
| ctrl+s | stash the draft                          |
| cmd+s  | same stash                               |
| ctrl+g | open the draft in $EDITOR                |
| ctrl+l | clear input                              |
| ctrl+c | interrupt — CANNOT be rebound            |

cmd+z · cmd+s added 2026-08-01 after a ctrl+c ate a long draft
config `claude/keybindings.json` → `~/.claude/keybindings.json`

----
doc: docs/operations/systems/claude-harness/INDEX.md
