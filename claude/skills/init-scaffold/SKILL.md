---
name: init-scaffold
description: Scaffold a new Vite + React + Tailwind 4 project in the current directory, with the full KOL design system copied in (kol-loader icons, kol-theme CSS+fonts+favicon, kol-component atoms/molecules/organisms, kol-brand identity layer, kol-framework chrome + primitives + sections) and its documentation (kol-docs) dropped at docs/documentation/. React-router wired up around a BrandLayout (sidenav + theme toggle). Umami analytics injected commented-out (opt-in). No agent context — run /init-agent-context separately for that (also lands the kol-docs framework at docs/_framework/).
disable-model-invocation: true
allowed-tools: Bash, Edit, Write, Read, AskUserQuestion
---

# init-scaffold

Bootstrap a new web app in the current working directory using:
- pnpm
- Vite official React template (jsx)
- Tailwind CSS v4 via `@tailwindcss/vite`
- React Router (BrowserRouter wrapping a BrandLayout with sidenav + scroll-spy)
- Full KOL design system copied from `/Users/kolkrabbi/dev/projects/kol-system/packages/` (kol-loader/icons, kol-theme, kol-component, kol-brand, kol-framework)
- Design system documentation copied from `packages/kol-docs/src/` into `docs/documentation/`
- Umami analytics script in `index.html`, commented out — uncomment to opt in

The DS that lands here is **brand-included** — `kol-brand/src/kol-brand-color.css` ships Kolkrabbi's default hue ramps (`--brand-primary`, `--brand-secondary`, etc.). To reskin, `init-client` overwrites that one file plus `src/brand/config.js` (the `BRAND` name/slug used by `usePageTitle`). No layered-on additions — the brand layer is two files, replaceable in place.

Design system and docs are **copied**, not symlinked. Each scaffold gets its own independent snapshot.

---

## Prerequisites (sanity checks — run once at the top)

1. Run `which pnpm` — if not installed, stop and tell the user `brew install pnpm` or equivalent.
2. Run `ls /Users/kolkrabbi/dev/projects/kol-system/packages/` — if missing, stop and tell the user the design system repo isn't where the skill expects it.
3. Run `pwd` to get the current working directory. **The cwd IS the project root** — the skill scaffolds into `.`, it does NOT create a subfolder.
4. Run `ls -A` on cwd. If it contains anything other than `.git` (and `.DS_Store`, which is macOS noise — remove it silently and continue), stop and tell the user to `cd` into an empty directory first. Vite's interactive "directory not empty" prompt will break the skill.

---

## Steps

### 1. Derive project name

No prompt. Derive `PROJECT_NAME` from `basename "$(pwd)"` — used as the package.json name (set by vite), the `<h1>` text in `App.jsx`, and `BRAND.name` / `BRAND.nameSlug` in `src/brand/config.js`.

### 2. Show summary panel

Print exactly this (substituting `PROJECT_NAME` and `<pwd>`):

```
About to scaffold into current directory:

  Name:             <PROJECT_NAME>
  Root:             <pwd>
  Package manager:  pnpm
  Template:         vite react (jsx)
  Styles:           tailwind 4 (@tailwindcss/vite)
  Router:           react-router-dom (BrowserRouter → BrandLayout → /)
  Design system:    copied from kol-system/packages
                      - kol-loader/src/icons         → src/components/loaders/icons/
                      - kol-theme/src                → src/styles/  (9 CSS files)
                      - kol-theme/public             → public/ (fonts + favicon)
                      - kol-component/src/atoms      → src/components/atoms/      (12)
                      - kol-component/src/molecules  → src/components/molecules/  (17)
                      - kol-component/src/organisms  → src/components/organisms/  (Table.jsx)
                      - kol-brand/src                → src/brand/                 (kol-brand-color.css + config.js stub)
                      - kol-framework/src/chrome     → src/components/framework/  (5 verbatim; BrandLayout + sidebars.config authored locally)
                      - kol-framework/src/hooks      → src/components/hooks/      (3 hooks)
                      - kol-framework/src/primitives → src/components/primitives/ (7 files; Carousel ships dormant — install embla-carousel-react if used)
                      - kol-framework/src/sections   → src/components/sections/   (3 sections)
                      - kol-framework/src/kol-framework.css → src/components/framework/
  Chrome:           SideNav + ThemeToggle wired into BrandLayout (one-entry sidebars.config stub — extend NAV_TREE to add routes)
  Brand layer:      included — Kolkrabbi defaults; init-client overwrites src/brand/kol-brand-color.css + src/brand/config.js to reskin
  Documentation:    kol-docs/src → docs/documentation/
                      (tokens, components, cheat sheets, writing guidelines)
  Favicon:          /favicon/favicon.svg (linked in index.html)
  Analytics:        umami script in index.html (commented out — uncomment to opt in)
  Agent context:    none — run /init-repo separately if you want

proceed?
```

Ask via `AskUserQuestion`: "Proceed with these settings?" — Yes / Cancel.

If Cancel: stop, confirm nothing changed.

### 3. Run the Vite generator

From the cwd (which is the project root):
```sh
pnpm create vite . --template react
```

The `.` scaffolds into the current directory. All subsequent Bash commands run from cwd — no `cd` needed.

### 4. Install deps

```sh
pnpm install
```

### 5. Add Tailwind 4 + KOL component runtime deps

```sh
pnpm add tailwindcss @tailwindcss/vite
pnpm add @floating-ui/react
pnpm add react-router-dom
```

`@floating-ui/react` is required by `kol-component` molecules `Popover.jsx`
and `MenuItem.jsx` (and any consumer that opens a popover/dropdown). Adding
it here means the DS scaffold renders cleanly without a "module not found"
error the first time a popover mounts.

`react-router-dom` is required by everything in `kol-framework/src/chrome/`
(SideNav, BrandLayout, Layout, ScrollToTop) plus `sections/` and a couple
of primitives. The default `main.jsx` rewrite wraps `<App />` in
`<BrowserRouter>` so `useLocation`, `<Link>`, `<NavLink>`, `<Outlet />`
resolve cleanly out of the box.

**Skipped on purpose:** `embla-carousel-react` is *not* installed. It's
only used by `primitives/Carousel.jsx`, which ships dormant — Vite won't
bundle it unless something in the live render path imports it. If a
consumer mounts `<Carousel />`, the import will throw a clean "module not
found" pointing at exactly what to add: `pnpm add embla-carousel-react`.

### 6. Wire Tailwind into vite.config.js

The default template's `vite.config.js` looks like:
```js
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
})
```

Use `Edit` to change it to:
```js
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [react(), tailwindcss()],
})
```

If the template changes in the future and the exact string doesn't match, read the file first and apply the equivalent insertion (import + plugin entry).

### 7. Copy design system into the new project

Run these in order:

```sh
mkdir -p src/components/atoms src/components/molecules src/components/organisms src/components/loaders/icons src/components/framework src/components/hooks src/components/primitives src/components/sections src/styles src/brand public/fonts public/favicon docs/documentation

cp -R /Users/kolkrabbi/dev/projects/kol-system/packages/kol-loader/src/icons/. src/components/loaders/icons/

cp -R /Users/kolkrabbi/dev/projects/kol-system/packages/kol-theme/src/. src/styles/

cp -R /Users/kolkrabbi/dev/projects/kol-system/packages/kol-component/src/atoms/. src/components/atoms/

cp -R /Users/kolkrabbi/dev/projects/kol-system/packages/kol-component/src/molecules/. src/components/molecules/

cp -R /Users/kolkrabbi/dev/projects/kol-system/packages/kol-component/src/organisms/. src/components/organisms/

cp -R /Users/kolkrabbi/dev/projects/kol-system/packages/kol-brand/src/. src/brand/

# kol-framework: copy chrome files SELECTIVELY (BrandLayout + sidebars.config are authored locally in step 9 — package versions reference consumer-app paths that don't exist in a fresh scaffold)
cp /Users/kolkrabbi/dev/projects/kol-system/packages/kol-framework/src/chrome/Layout.jsx        src/components/framework/Layout.jsx
cp /Users/kolkrabbi/dev/projects/kol-system/packages/kol-framework/src/chrome/PortalFooter.jsx  src/components/framework/PortalFooter.jsx
cp /Users/kolkrabbi/dev/projects/kol-system/packages/kol-framework/src/chrome/ScrollToTop.jsx   src/components/framework/ScrollToTop.jsx
cp /Users/kolkrabbi/dev/projects/kol-system/packages/kol-framework/src/chrome/SideNav.jsx       src/components/framework/SideNav.jsx
cp /Users/kolkrabbi/dev/projects/kol-system/packages/kol-framework/src/chrome/ThemeToggle.jsx   src/components/framework/ThemeToggle.jsx
cp /Users/kolkrabbi/dev/projects/kol-system/packages/kol-framework/src/kol-framework.css        src/components/framework/kol-framework.css

cp -R /Users/kolkrabbi/dev/projects/kol-system/packages/kol-framework/src/hooks/.      src/components/hooks/
cp -R /Users/kolkrabbi/dev/projects/kol-system/packages/kol-framework/src/primitives/. src/components/primitives/
cp -R /Users/kolkrabbi/dev/projects/kol-system/packages/kol-framework/src/sections/.   src/components/sections/

cp -R /Users/kolkrabbi/dev/projects/kol-system/packages/kol-theme/public/fonts/. public/fonts/

cp -R /Users/kolkrabbi/dev/projects/kol-system/packages/kol-theme/public/favicon/. public/favicon/

cp -R /Users/kolkrabbi/dev/projects/kol-system/packages/kol-docs/src/. docs/documentation/
rm -rf docs/documentation/_framework
```

The trailing `/.` copies folder *contents* (not the folder itself nested). Fonts and favicon go to `public/` because CSS references them via absolute URLs (`/fonts/...`, `/favicon/...`). Docs land at `docs/documentation/` — see `packages/kol-docs/src/00-system/02-imports.md` for the full source → destination manifest. Only the `kol-loader/src/icons/` subfolder is copied (Icon + KOL ~366-icon registry, with the canonical `00-kol/` stroke set overlaying older fill-style buckets via the two-pass resolver in `Icon.jsx`); `logos/` / `marks/` / `graphics/` stay in kol-loader for `init-client` to pull through.

**Why the `rm -rf` after the docs copy:** `kol-docs/src/` ships both the DS reference content AND the docs framework (`_framework/`). The framework is the property of `/init-agent-context`, not init-scaffold — it belongs at `docs/_framework/` in the consumer, not nested at `docs/documentation/_framework/`. Stripping it here keeps init-scaffold's surface clean; the user runs `/init-agent-context` separately when they want the framework.

**About the kol-framework folder layout.** The package's `chrome/` files use relative paths like `'../loaders/icons/Icon'`, `'../hooks/useScrollSpy'`, `'../primitives/ExitPreview'`, `'../atoms/Divider'` that assume their destination has sibling folders one level up. That destination layout is `src/components/{framework,hooks,primitives,sections,atoms,molecules,organisms,loaders/icons}/` — chrome lives flat at `framework/` (not nested in a `chrome/` subdir), and hooks/primitives/sections sit as peers. The cp commands above honor that exactly. Do NOT vendor to `src/framework/` or `src/components/framework/chrome/` — every relative import will break.

**Two files SKIPPED from `kol-framework/src/chrome/`:** `BrandLayout.jsx` (imports `GeneratorLibraryProvider` from a consumer-app path that doesn't exist outside kol-client-kolkrabbi) and `sidebars.config.js` (full Kolkrabbi NAV_TREE with phantom routes). Both are authored locally in step 9.

### 8. Replace src/index.css

Overwrite the template's `src/index.css` entirely with:
```css
@import "tailwindcss";
@import "./styles/kol-theme.css";
@import "./brand/kol-brand-color.css";
@import "./components/framework/kol-framework.css";
```

`kol-theme.css` is the umbrella — it internally imports `kol-color.css`, `kol-opacity.css`, `kol-typography.css`, `kol-typography-mono.css`, `kol-utilities.css`, `kol-components-atoms.css`, `kol-components-molecules.css`, `kol-components-organisms.css` in cascade order. `kol-brand-color.css` defines `:root` brand vars (Kolkrabbi defaults). `kol-framework.css` defines chrome rules (sidenav grid, page scaffold, primitives, sections). Order matters — brand layer must load before framework (the `::selection` rule in kol-framework.css reads `--brand-primary`).

### 9. Clean up Vite template boilerplate + author chrome locals + wire the router

#### 9a. Delete unused template assets

- Delete `src/App.css` (Tailwind + design system handle styling).

#### 9b. Overwrite `src/App.jsx` with a minimal shell

```jsx
function App() {
  return (
    <div>
      <h1>{/* PROJECT_NAME */}</h1>
    </div>
  )
}

export default App
```
Substitute `<PROJECT_NAME>` for the actual project name.

#### 9c. Write `src/main.jsx` with router + BrandLayout wired around App

Overwrite the template's `src/main.jsx`:
```jsx
import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { BrowserRouter, Routes, Route } from 'react-router-dom'
import './index.css'
import BrandLayout from './components/framework/BrandLayout.jsx'
import App from './App.jsx'

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <BrowserRouter>
      <Routes>
        <Route element={<BrandLayout />}>
          <Route path="/" element={<App />} />
        </Route>
      </Routes>
    </BrowserRouter>
  </StrictMode>,
)
```

#### 9d. Write `src/components/framework/BrandLayout.jsx` (local — NOT copied from package)

The package version imports `GeneratorLibraryProvider` + `ModalProvider` from consumer-app paths. Author a trimmed version:

```jsx
import { useEffect, useState } from 'react'
import { Outlet, useLocation } from 'react-router-dom'
import SideNav from './SideNav'
import Icon from '../loaders/icons/Icon'

export default function BrandLayout() {
  const [drawerOpen, setDrawerOpen] = useState(false)
  const { pathname } = useLocation()

  useEffect(() => { setDrawerOpen(false) }, [pathname])

  useEffect(() => {
    if (!drawerOpen) return
    const onKey = (e) => { if (e.key === 'Escape') setDrawerOpen(false) }
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [drawerOpen])

  return (
    <div className="kol-brand-layout" data-drawer-open={drawerOpen ? 'true' : undefined}>
      <button
        type="button"
        className="kol-sidenav-hamburger md:hidden fixed top-3 left-3 z-30 w-10 h-10 inline-flex items-center justify-center rounded-full bg-surface-primary border border-fg-08 text-emphasis"
        aria-label={drawerOpen ? 'Close menu' : 'Open menu'}
        aria-expanded={drawerOpen}
        onClick={() => setDrawerOpen((v) => !v)}
      >
        <Icon name={drawerOpen ? 'x' : 'menu'} size={18} />
      </button>

      <div
        className="kol-sidenav-backdrop fixed inset-0 z-20 bg-black/50 opacity-0 pointer-events-none transition-opacity duration-200 md:hidden"
        onClick={() => setDrawerOpen(false)}
        aria-hidden="true"
      />

      <SideNav drawerOpen={drawerOpen} onCloseDrawer={() => setDrawerOpen(false)} />
      <div className="min-w-0">
        <Outlet />
      </div>
    </div>
  )
}
```

#### 9e. Write `src/components/framework/sidebars.config.js` (local stub)

```js
/**
 * Single navigation tree.
 *
 * Each top-level entry is a page (icon + label + route). Pages may have
 * `children`. Children may have `children` (grandchildren) for further grouping.
 *
 * Leaf shape:
 *   { id: 'about',  label: 'About' }          — page section anchor (#about)
 *   { to: '/about', label: 'About' }          — sub-route link
 *
 * Group shape (no id, no to):
 *   { label: 'Color', children: [...] }       — group node
 */

export const NAV_TREE = [
  { id: 'home', label: 'Home', to: '/', icon: 'terminal' },
]

/* Find the active top-level page given a pathname. */
export function getActivePage(pathname) {
  if (pathname === '/') return NAV_TREE.find((n) => n.to === '/')
  return NAV_TREE.find((n) => n.to !== '/' && pathname.startsWith(n.to))
}
```

The `terminal` icon resolves via `loaders/icons/svg/11-system-tools/terminal.svg` — exists in the brand-neutral icon set.

#### 9f. Write `src/brand/config.js` stub

`kol-brand/src/` only ships `kol-brand-color.css`. The framework hook `usePageTitle` imports `BRAND` from `'../../brand/config'` — we ship a stub alongside the color file so init-client has both rebrandable files in one place:

```js
/**
 * Brand identity config — the single source of truth for client-brand naming.
 *
 * All user-facing references to the client brand name (page titles, aria labels,
 * portal labels, carousel captions, palette ids/labels) and asset-path fragments
 * (`/brand/<slug>/…`) resolve through this file.
 */

export const BRAND = {
  name:     '<PROJECT_NAME>',
  nameSlug: '<PROJECT_NAME>',
}
```

Substitute `<PROJECT_NAME>` for the derived project name.

### 10. Wire favicon + inject umami analytics into index.html

Two edits to `index.html`, both in the `<head>`:

1. Replace the default Vite favicon link (`<link rel="icon" type="image/svg+xml" href="/vite.svg" />` or `/favicon.svg`, depending on the template version) with:
   ```html
       <link rel="icon" type="image/svg+xml" href="/favicon/favicon.svg" />
   ```

2. Insert **before** `</head>`, **commented out** (the user opts in by uncommenting when ready to track):
   ```html
       <!-- <script defer src="https://kol-umami.vercel.app/script.js" data-website-id="fcd04534-5dcd-44a3-b7b1-256cbdf49ab9"></script> -->
   ```

Also delete the template's root favicon (either `public/vite.svg` or `public/favicon.svg`, depending on Vite version) — replaced by the design system's favicon.

Preserve existing indentation.

### 11. Gitignore agent-context & local-only docs

Append a block to `.gitignore` (Vite already created it) so `LLM_RULES.md`, `/docs/`, and `.claude/` are ignored. These are the artifacts produced by `/init-scaffold` + `/init-repo` — design system docs, agent context, private skills — none of which belong in the deployable repo.

Idempotent — a sentinel comment keeps re-runs from duplicating the block:

```sh
if ! grep -qxF '# Agent context & local-only docs (init-scaffold / init-repo)' .gitignore 2>/dev/null; then
  [ -s .gitignore ] && printf '\n' >> .gitignore
  cat >> .gitignore <<'EOF'
# Agent context & local-only docs (init-scaffold / init-repo)
LLM_RULES.md
/docs/
.claude/
EOF
fi
```

### 12. Report

Say:
```
Scaffolded <PROJECT_NAME> into <pwd>.

Next:
  pnpm dev

The scaffold mounts a BrandLayout (sidenav + theme toggle) wrapping App at `/`. To add routes:
  1. Add a top-level entry to NAV_TREE in src/components/framework/sidebars.config.js
  2. Add a matching <Route> inside main.jsx

To reskin (Kolkrabbi defaults → your brand):
  - Overwrite src/brand/kol-brand-color.css (hue ramps + role assignments)
  - Overwrite src/brand/config.js (BRAND.name + nameSlug)
  - Or run /init-client which automates that.

Design system docs are at docs/documentation/
  - 00-system/00-index.md      overview
  - 01-colors/, 02-typography/, 03-breakpoints/  token systems + cheat sheets
  - 04-components/, 05-icons/  component and icon reference

If you want agent context (LLM_RULES.md, architecture.md, session logs), run /init-repo.
```

---

## Notes

- **Design system + docs are copied, not symlinked.** Updates to `kol-system/packages/` do not propagate to already-scaffolded projects. Intentional — projects are independent after scaffold. Re-run the skill into a scratch folder and diff if you need to pull newer upstream changes.
- **Source path is hardcoded** to `/Users/kolkrabbi/dev/projects/kol-system/packages/`. If the master design system moves, update the step-7 paths. The `kol-docs` imports manifest (`packages/kol-docs/src/00-system/02-imports.md`) is the source of truth for what this skill copies — keep it in sync with any step-7 changes.
- **Brand layer is included.** Kolkrabbi defaults from `kol-brand/src/kol-brand-color.css` land at `src/brand/kol-brand-color.css`, plus a `src/brand/config.js` stub keyed off `PROJECT_NAME`. To reskin, `init-client` overwrites both files in place — no layered-on additions, the brand layer is exactly two files.
- **kol-framework folder layout is load-bearing.** The package's chrome files use relative imports (`'../hooks/...'`, `'../loaders/icons/...'`, `'../primitives/...'`) that only resolve when chrome lives flat at `src/components/framework/` with siblings at `src/components/{hooks,primitives,sections,atoms,molecules,organisms,loaders/icons}/`. Do NOT mirror the package's nested `chrome/` subdir — every import breaks.
- **Two chrome files are authored locally, not vendored.** `BrandLayout.jsx` (package version imports consumer-app providers) and `sidebars.config.js` (package version has Kolkrabbi-specific NAV_TREE with phantom routes). Step 9d/9e ships replacements.
- **`embla-carousel-react` is skipped.** Only `primitives/Carousel.jsx` uses it; ships dormant. Vite tree-shakes it out unless something in the live render path imports it. If consumed: `pnpm add embla-carousel-react`.
- **`kol-loader/src/{logos,marks,graphics}/` are NOT copied** — only the `icons/` subfolder. Logos / marks / graphics are branded SVG sets, owned by `init-client`.
- **`disable-model-invocation: true`** means Claude won't autonomously invoke this — only on explicit `/init-scaffold`.
- **Cwd IS the project root.** The skill scaffolds into `.`; no subfolder is created. Cwd must be empty (`.git` tolerated, `.DS_Store` removed silently) — refuse otherwise (prereq 4).
- **No agent context included.** `/init-repo` is a separate skill; user runs it inside the scaffolded project if they want `LLM_RULES.md` + `docs/llm-context/`.
