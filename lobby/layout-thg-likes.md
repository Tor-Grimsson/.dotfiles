03/08/26


__________
__________


Dropbox — downloaded, task closed

Fixed the naming (dropped the underscore, 03-dropbox-tree.md with aliases: — underscore prefix is only for _assets/_files supporting attachments, this is a normal reference doc). Then pulled the full 7.8GB into the repo and closed out playbook item 1.

Path:    /dropbox at repo root, gitignored
Files:   543, 7.8GB — matches the tree doc exactly
Zip:     verified clean, extracted, then discarded

┌────────────────────────────────────────────────────────┬──────────────────────────────────┐
│                          File                          │              Change              │
├────────────────────────────────────────────────────────┼──────────────────────────────────┤
│                                                        │ Status row updated — pulled,     │
│ docs/documentation/05-platform-data/01-dropbox.md      │ supersedes the old               │
│                                                        │ Downloads/_s16 copy              │
├────────────────────────────────────────────────────────┼──────────────────────────────────┤
│ docs/documentation/05-platform-data/03-dropbox-tree.md │ Renamed from _dropbox-tree.md,   │
│                                                        │ reflects on-disk copy            │
├────────────────────────────────────────────────────────┼──────────────────────────────────┤
│ .gitignore                                             │ /dropbox/ added                  │
├────────────────────────────────────────────────────────┼──────────────────────────────────┤
│ .kol/llm-plan/02-playbook.md                           │ Item 1 → done; item 2 (drift     │
│                                                        │ check) → unblocked, not run      │
└────────────────────────────────────────────────────────┴──────────────────────────────────┘

Playbook item 2 is now runnable (diff -rq against Downloads/_s16) whenever you want it — not started.

Docs synced: (4) · Playbook items closed: (1)



---



CMS arc roadmap

Written to .kol/llm-plan/03-cms-arc-roadmap.md. Eight phases, three protocols, four open decisions.

The fix at the center of it — provenance keys on MD5 hash, not path. That's what makes cleaning the source safe: rename anything, the hash still ties a converted file to its original. Phase 0 builds cms/source-index.json and everything else hangs off it. Source being "read-only" is dead — the roadmap reverses that line and flags the doc that carries it.

Phases

0 index ──► 1 normalize ──► 2 map ──┬──► 3 reconcile CMS ──┐
                                    │                      ├──► 5 curate ──► 6 upload ──► 7 verify
                                    └──► 4 missing-29 ─────┘

┌─────┬─────────────────────────────────────────────────────────────────────┬──────┐
│  #  │                                Phase                                │ Gate │
├─────┼─────────────────────────────────────────────────────────────────────┼──────┤
│ 0   │ Index source by hash                                                │ —    │
├─────┼─────────────────────────────────────────────────────────────────────┼──────┤
│ 1   │ Prune + normalize filenames                                         │ 0    │
├─────┼─────────────────────────────────────────────────────────────────────┼──────┤
│ 2   │ Map source → 28 CMS slugs (owner falls out of ANNA_WORK/BRIET_WORK) │ 1    │
├─────┼─────────────────────────────────────────────────────────────────────┼──────┤
│ 3   │ Fix slugs + video field in Framer, re-dump                          │ 2    │
├─────┼─────────────────────────────────────────────────────────────────────┼──────┤
│ 4   │ Decide the 29 missing files                                         │ 2    │
├─────┼─────────────────────────────────────────────────────────────────────┼──────┤
│ 5   │ Curate, convert, fill manifests                                     │ 3, 4 │
├─────┼─────────────────────────────────────────────────────────────────────┼──────┤
│ 6   │ Upload                                                              │ 5    │
├─────┼─────────────────────────────────────────────────────────────────────┼──────┤
│ 7   │ Verify, archive to _tmp/                                            │ 6    │
└─────┴─────────────────────────────────────────────────────────────────────┴──────┘

Protocols: hash-keyed provenance · Framer-first for any CMS change (apply → re-dump → then mirror locally) · nothing deleted, everything to _tmp/.

Blocking decision for phase 1: the target slug format isn't defined — diacritic transliteration (ð→d, æ→ae), case, extension dedup. That's the first thing to settle before any renaming runs.
