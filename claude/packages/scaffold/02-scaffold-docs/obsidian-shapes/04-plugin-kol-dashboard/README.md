# KOL Dashboard

Custom Obsidian plugin: live metrics card grid + vault project/task tracker.

Built 2026-05-22 for the kol-vault. Lives at `.obsidian/plugins/kol-dashboard/`.

---

## Opening the dashboard

- Ribbon icon (activity wave): click to open
- Command palette: `Open KOL Dashboard`
- Refresh command: `Refresh KOL Dashboard`

The view opens in the main tab area.

---

## Sections

### 1. Metrics

Polls a JSON endpoint and renders one card per platform. Status dot per card:

- **green pulse** — live
- **yellow** — stale
- **red dim** — offline / endpoint unreachable

If no endpoint is configured (or fetch fails), four placeholder cards render in offline state — the dashboard still works, just no live data.

### 2. Projects

Scans the configured project folder (default `kol-project`). Each direct subfolder = one project. Per row:

- Project name
- File count
- Open-task count (cross-reference from task scan)
- Age since most recent file modification

Click a project row to open its `INDEX.md` or `<folder-name>.md`.

### 3. Open tasks

Scans markdown files under the configured root (default: whole vault) for `- [ ]` open-task syntax. Per task:

- Task text
- Due date (parses `📅 YYYY-MM-DD` or `(due: YYYY-MM-DD)`)
- Project (if file lives under the project folder)
- Source file (click to jump)

Overdue dates highlighted red. Sorted by due date first, then alphabetical. Truncated to 30 rows.

---

## Settings

| Setting | Default | Notes |
|---|---|---|
| Metrics endpoint URL | (empty) | Full JSON endpoint URL, e.g. `https://kolkrabbi.io/api/metrics` |
| Refresh interval (min) | 5 | Set to 0 to disable auto-refresh |
| Project folder | `kol-project` | Vault-relative path |
| Task scan root | (empty) | Empty = whole vault |
| Show metrics / projects / tasks | all on | Per-section toggles |

---

## Expected metrics endpoint JSON shape

```json
{
  "generated_at": "2026-05-22T18:30:00Z",
  "platforms": {
    "youtube": {
      "subs": 125000,
      "views": 9836543,
      "delta": { "subs_pct": 0.0, "views_pct": 0.7 }
    },
    "instagram": {
      "followers": 196000,
      "delta": { "followers_pct": 0.5 }
    },
    "tiktok": {
      "followers": 124800,
      "delta": { "followers_pct": 0.1 }
    }
  },
  "latest_content": {
    "title": "My Secret Content Claude Code Skill",
    "platform": "youtube",
    "url": "https://...",
    "published_at": "2026-05-21T08:00:00Z",
    "views": 1500,
    "likes": 78,
    "comments": 1
  }
}
```

All keys are optional. The parser skips missing platforms. The plugin sends a normal GET, expects `Content-Type: application/json`, follows CORS via Obsidian's `requestUrl` (so cross-origin is fine; no CORS hassle).

If the endpoint returns HTML (like `kolkrabbi.io/metrics` does right now — it's the React SPA route), the plugin shows placeholder cards and logs `endpoint returned non-JSON` in the footer.

---

## Development

Source: `src/*.ts`. Build: `npm run build`.

```bash
cd .obsidian/plugins/kol-dashboard
npm install          # one-time
npm run dev          # watch mode, rebuilds on save
npm run build        # production minified bundle
```

The `.hotreload` marker file is present, so the Hot Reload plugin (already installed) picks up changes automatically — no Obsidian restart needed.

### File tour

- `src/main.ts` — plugin entry, view registration, commands, ribbon, settings tab
- `src/view.ts` — `ItemView` subclass; renders header / metrics / projects / tasks / footer; auto-refresh timer
- `src/metrics.ts` — `fetchMetrics()` via `requestUrl()`; parses the JSON shape above; falls back to placeholder if endpoint missing/broken
- `src/tasks.ts` — `scanTasks()` walks markdown files, regex for `- [ ]`, parses due dates, attributes to projects
- `src/projects.ts` — `scanProjects()` reads project subfolders, computes file counts + last-modified age + open-task counts
- `src/settings.ts` — settings interface + settings tab UI
- `styles.css` — all styles scoped under `.kol-dashboard`; uses Obsidian CSS vars for theme integration; platform-themed accent strips (YT red, IG pink, TT magenta); pulsing LIVE dot

### Adding a card

Two-step:

1. In `src/metrics.ts` extend `RawResponse` + `parse()` to recognize the new platform's JSON keys, pushing to the `platforms` array.
2. In `styles.css` add `.kd-card-<platform>::before { background: ... }` for the accent strip color.

That's it — the view auto-renders any platform the parser emits.

### Adding action buttons (later)

The screenshot reference dashboard has a button grid (Plan Today, Pull Metrics, etc.). Not in v1. Hook point: in `view.ts`'s `render()`, between the metrics section and projects section, add a button grid that calls registered Obsidian commands via `app.commands.executeCommandById('plugin-id:command-id')`.

---

## Known limitations

- No persistent metrics history yet — deltas come from the endpoint, not computed locally. (Adding local history = adding a JSON file in plugin data + ring buffer.)
- Tasks scan does a full re-read on every refresh. Fine up to ~5000 markdown files; consider caching via Obsidian's metadata cache if it slows down.
- No drag-to-reorder for projects or tasks (just sort-by-recent-activity / sort-by-due).
- Single workspace view; doesn't persist scroll position across reloads.
