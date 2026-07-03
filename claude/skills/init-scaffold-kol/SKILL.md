---
name: init-scaffold-kol
description: Scaffold a new Vite + React + Tailwind 4 project in the current directory on the PUBLISHED KOL design system — installs @kolkrabbi/kol-{theme,loader,component,framework} from npm, wires the 4-point consumer contract (CSS cascade order, @source, react dedupe, /fonts), and an AppShell + SideNav router shell. No source copying — packages update via npm. For a headless base (this same stack, no design system) use /init-scaffold. No agent context — run /init-agent-context separately.
disable-model-invocation: true
allowed-tools: Bash, Edit, Write, Read, AskUserQuestion
---

# init-scaffold-kol

> Sibling: `/init-scaffold` scaffolds this same Vite + React + Tailwind 4 stack **without** a design system. Use this one only when you want KOL wired in.

Bootstrap a new web app in the current working directory on the **published** KOL design system:

- pnpm · Vite (react jsx template) · Tailwind CSS v4 (`@tailwindcss/vite`) · react-router-dom
- `@kolkrabbi/kol-{theme,loader,component,framework}` **installed from npm** — no source copying; `pnpm up` gets new versions
- The **4-point consumer contract** wired in (this is what makes KOL render correctly):
  1. CSS cascade order: `tailwindcss` → `kol-theme` → `kol-brand-color.css` → `kol-framework.css`
  2. `@source` the package sources (Tailwind skips `node_modules`)
  3. one React copy (dedupe)
  4. fonts served by the app at `/fonts/`
- `AppShell` + `SideNav` from kol-framework wired around the router
- Umami analytics in `index.html`, commented out — uncomment to opt in

> Superseded model: this skill used to copy DS source from a local repo. Since 2026-07-01 the packages are live on npm (`kol-design-system` is the maintenance home) — consumers install, never vendor.

---

## Prerequisites

1. `which pnpm` — if missing, stop: `brew install pnpm`.
2. `pwd` — **the cwd IS the project root**; the skill scaffolds into `.`, never a subfolder.
3. `ls -A` — if anything besides `.git`/`.DS_Store` exists, stop and tell the user to `cd` into an empty directory.

## Steps

### 1. Derive project name + confirm

`PROJECT_NAME` = `basename "$(pwd)"`. Show a short summary (name, root, pnpm, vite react, tailwind 4, router, `@kolkrabbi/kol-* from npm`, umami commented out) and confirm via `AskUserQuestion` before touching anything.

### 2. Scaffold + deps

```sh
pnpm create vite . --template react
pnpm install
pnpm add tailwindcss @tailwindcss/vite react-router-dom
pnpm add @kolkrabbi/kol-theme @kolkrabbi/kol-loader @kolkrabbi/kol-component @kolkrabbi/kol-framework
```

(`@floating-ui/react`, `embla-carousel-react` etc. are the packages' own deps/peers — add only if `pnpm install` reports an unmet peer.)

### 3. vite.config.js

Add the Tailwind plugin (read the file, apply the equivalent edit if the template drifted):

```js
import tailwindcss from '@tailwindcss/vite'
// plugins: [react(), tailwindcss()]
```

### 4. src/index.css — the contract, points 1 + 2

Overwrite entirely:

```css
@import "tailwindcss";

/* KOL packages ship raw JSX — Tailwind must scan them or their utilities
   never generate (contract point 2). */
@source "../node_modules/@kolkrabbi/kol-loader/src";
@source "../node_modules/@kolkrabbi/kol-component/src";
@source "../node_modules/@kolkrabbi/kol-framework/src";

/* Cascade order is load-bearing (contract point 1) — never reorder. */
@import "@kolkrabbi/kol-theme";
@import "@kolkrabbi/kol-framework/kol-brand-color.css";
@import "@kolkrabbi/kol-framework/kol-framework.css";
```

If an import specifier 404s, check the installed package's `exports`/files and use the real path (e.g. `@kolkrabbi/kol-theme/kol-theme.css`) — the contract order is the invariant, not the exact specifier.

### 5. Fonts — contract point 4

The theme references brand fonts at absolute `/fonts/…`; packages don't bundle them. If `~/dev/projects/kol-apparat/kol-design-system/showcase/public/fonts/` exists locally, copy it to `public/fonts/`. Otherwise leave `public/fonts/` empty and tell the user the app falls back to system fonts until fonts land there.

### 6. Shell + router

- `src/nav.config.js` — a one-entry `NAV_TREE` (`{ id: 'home', label: PROJECT_NAME, to: '/', icon: 'book-open' }`) + `getActivePage` helper; extend to add routes.
- `src/main.jsx` — `BrowserRouter` → route element `<AppShell navTree={NAV_TREE} getActivePage={getActivePage} />` (from `@kolkrabbi/kol-framework`) → index route `<App />`.
- `src/App.jsx` — minimal: a `PageSection` (kol-framework) with an `<h1>` of `PROJECT_NAME` and one KOL `Button` so the render proves the packages work.
- Delete `src/App.css`.

### 7. index.html

- `<title>` = PROJECT_NAME.
- Umami snippet commented out with a `<!-- uncomment to opt in -->` note.

### 8. Verify — actually run it

`pnpm dev`, load the page, confirm: KOL button renders styled (contract point 2 working), sidenav chrome present, no console errors, only ONE react copy (`pnpm why react` — contract point 3). Report what works and anything left for the user (fonts, umami).

## Docs

The design-system documentation is NOT copied — it lives with the system (`kol-design-system/docs/documentation/`, and each package's README covers install/use). For per-repo agent context + doc framework, run `/init-agent-context` (lands `LLM_RULES.md` + `.kol/`).
