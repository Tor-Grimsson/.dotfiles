// kol-bookmarks.widget — v1 (Übersicht)
// The sticky-widget idea, first cut: BOOKMARKS ONLY (notes live in the sibling
// kol-notes.widget). Reads the SAME file as the tmux `prefix C-b` picker —
// ~/.dotfiles/tmux/bookmarks.txt, one path or URL per line — so the desk
// widget and the tmux popup never drift.
// Click a URL → browser. Click a path → COPY to clipboard (~-form, ready to
// paste into a shell — reveal-in-Finder was v1, user call 2026-07-15).
//
// Anatomy (the whole Übersicht contract in one file):
//   command          — shell that produces this widget's data (stdout → render's `output`)
//   refreshFrequency — how often Übersicht re-runs `command` (ms); keep honest, not hot
//   className        — emotion CSS template: POSITIONS the widget on the desktop
//   render           — pure JSX over `output`; `run()` fires shell on interaction
//
// Themed by kol-theme: `command` prepends the active theme's colors.json;
// render parses it, falling back to kol-dark when the selector has never run.
// Style doctrine: flat. Hairlines, block hover, radius at the window level only (4px).

import { run } from "uebersicht";

export const command =
  'cat "$HOME/.config/kol-theme/current/colors.json" 2>/dev/null; echo "__KOLTHEME__"; cat ~/.dotfiles/tmux/bookmarks.txt 2>/dev/null';

export const refreshFrequency = 30000; // 30s — it's a text file, not a stock ticker

// position + type only — every COLOR comes from the theme in render
export const className = `
  top: 48px;
  right: 12px;
  width: 280px;
  font-family: "JetBrains Mono", Menlo, monospace;
  font-size: 12px;
  line-height: 17px;
`;

const KOL_DARK = {
  bgRgb: "18,18,21",
  fg: "#F5EBD8",
  muted: "#A39A78",
  accent: "#FFCF33",
  hairline: "rgba(245,235,216,.10)",
  hover: "rgba(255,207,51,.14)",
  empty: "rgba(245,235,216,.3)",
};

const styles = (t) => ({
  // near-solid: Übersicht's WebView doesn't run backdrop blur, so real
  // translucency just double-exposes whatever sits behind on the desktop
  root:  { background: `rgba(${t.bgRgb},0.96)`, color: t.fg,
           borderRadius: "4px",                 /* window-level radius — the only one */
           padding: "10px 12px 8px" },
  top:   { display: "flex", justifyContent: "space-between", fontSize: "11px",
           lineHeight: "1", color: t.muted, paddingBottom: "7px" },
  head:  { fontSize: "11px", lineHeight: "1", letterSpacing: ".08em", color: t.accent,
           borderBottom: `1px solid ${t.hairline}`,                  /* hairline, not a box */
           padding: "8px 0 4px", marginBottom: "2px" },
  row:   { display: "block", width: "100%", textAlign: "left", cursor: "pointer",
           border: 0, background: "transparent", font: "inherit", color: t.muted,
           padding: "2px 4px", whiteSpace: "nowrap", overflow: "hidden",
           textOverflow: "ellipsis" },
  empty: { color: t.empty, fontSize: "10.5px", paddingTop: "4px" },
});

const isUrl = (l) => /^https?:\/\//.test(l);
const label = (l) => (isUrl(l) ? l.replace(/^https?:\/\/(www\.)?/, "") : l.replace(/^\/Users\/[^/]+/, "~"));
const openIt = (l) =>
  // paths copy AS LISTED (the ~ form) — pasteable into any shell
  run(isUrl(l) ? `open "${l}"` : `printf '%s' '${l}' | pbcopy`);

export const render = ({ output, error }) => {
  const [themeRaw, data] = (output || "").split("__KOLTHEME__");
  let theme = KOL_DARK;
  try {
    theme = { ...KOL_DARK, ...JSON.parse(themeRaw) };
  } catch (e) {} // selector never run → kol-dark
  const S = styles(theme);

  if (error) return <div style={{ ...S.root, ...S.empty }}>bookmarks: {String(error)}</div>;
  const lines = (data || "").split("\n").map((l) => l.trim()).filter(Boolean);
  const urls = lines.filter(isUrl);
  const paths = lines.filter((l) => !isUrl(l));
  const Row = (l) => (
    <button key={l} style={S.row} title={l} onClick={() => openIt(l)}
      onMouseOver={(e) => { e.currentTarget.style.background = theme.hover; e.currentTarget.style.color = theme.fg; }}
      onMouseOut={(e)  => { e.currentTarget.style.background = "transparent"; e.currentTarget.style.color = theme.muted; }}>
      {label(l)}
    </button>
  );
  return (
    <div style={S.root}>
      <div style={S.top}><span>bookmarks</span><span>tmux ⌃a C-b</span></div>
      {paths.length > 0 && <div style={S.head}>paths</div>}
      {paths.map(Row)}
      {urls.length > 0 && <div style={S.head}>links</div>}
      {urls.map(Row)}
      {lines.length === 0 && <div style={S.empty}>empty — add with prefix B / A</div>}
    </div>
  );
};
