---
name: kol-press-research
description: Research a client/subject's public web presence — press, reviews, interviews, mentions, timeline facts — verify every hit by fetching it, and emit entries in the KOL brand-manifest shape (press[] / timeline[] / presence) ready for the client's brand package. Use when the user says "press research", "find mentions", "log <client> timeline", "presence scan", or wants a client's press/timeline compiled. This is the judgment half of scraping — the mechanical half is the kol-scrape CLI.
---

# kol-press-research — press & timeline research for a client

Durable form of the ad-hoc "public-web scrape" sessions (the 2026-05-27 enrichment
that produced `kolkrabbi-info/05-press.md` was one — done in chat, nothing survived
to reuse; this skill is the reusable version). Output conforms to the **brand
manifest schema** (`@kolkrabbi/kol-brand-template`) so results land directly in a
client's brand package.

## 0. Inputs (ask for what's missing)

- **Canonical name** + **aliases/pseudonyms** (e.g. Þórður Grímsson → Tór Grímsson, Biskup, Svartval, Konsulat) — search each.
- **Domains + social handles** (seed `presence`; also disambiguation anchors).
- **Language/region** — Icelandic subjects need native-language queries and the .is outlets: mbl.is / Morgunblaðið greinasafn, Vísir, RÚV, Fréttablaðið (archive), Reykjavík Grapevine (English). Native terms: *viðtal* (interview), *umfjöllun* (coverage), *dómur* (review), *sýning* (exhibition).
- **Scope**: studio/brand vs person — a founder's art/music press is *person-scoped*; record scope per entry, don't mix silently.
- **Date window** (default: all years).

## 1. Fan out searches

Per name/alias × per angle — separate queries, not one mega-query:

- `"<name>" interview` · `review` · `press` · `exhibition` · `profile`
- `"<name>" site:<outlet>` for each regional outlet above
- `"<name>" <project/release name>` for known works
- Native-language variants of all of the above
- Socials/platform sweeps: Discogs, Bandcamp, Behance, LinkedIn, Skemman (IS academic) — presence facts, not press

## 2. Verify every hit (mechanical — use the CLI)

Never log a search-result snippet unverified. Fetch each candidate:

- `npx @kolkrabbi/kol-scrape <url>` → structured record (title, og-meta, dates); until published: `node ~/dev/projects/kol-apparat/kol-design-system/packages/scrape/bin/kol-scrape.js <url>`
- Or WebFetch when a judgment question needs the prose ("is this about *our* subject?").
- Dead link → try `web.archive.org/web/*/<url>`; log the archive URL and note it.

Confirm: subject is actually the subject (name collisions are common), date, outlet, title.

## 3. Curate (the judgment half)

- **Subject vs author** — an op-ed *by* the subject is not coverage *of* them; keep it, flagged `(Author, not subject.)` (precedent: kolkrabbi-info `05-press.md`).
- **Uncertain facts stay uncertain** — year/URL unknown → `TBD`, never guessed.
- **Signal over noise** — aggregator reposts, listing pages, and store entries are presence, not press.
- **Confidentiality** — PII surfaced en route (kennitala, birthdate, home address) goes NOWHERE near a public package; per-client brand packages are local-only anyway, but flag anything sensitive explicitly.

## 4. Emit in the manifest shape

Two outputs, both sorted oldest→newest, ISO dates where known (year-only allowed):

```js
// → append into the client's brand package (local, NEVER public npm)
press: [
  { date: '2013-08-01', title: 'Fascinated by the Beauty in Darkness (interview, as Svartval)', outlet: 'Fréttablaðið', url: '…', note: 'On the Skyndreymi & táknvilla show.' },
],
timeline: [
  { date: '2019', title: 'Studio founded', note: '…' },
],
presence: { site: '…', profiles: { instagram: '…', discogs: '…' } },
```

No brand package yet? Emit the same data as a markdown table (`| Year | Item | Outlet | Notes |` — the `05-press.md` shape) into the client's docs, ready to convert later.

## 5. Verification pass

Before handing over: every entry has date + outlet + working (or archived) URL; scopes labeled; count stated ("N entries, M verified, K TBD"). What couldn't be verified is listed as open questions, not silently dropped.
