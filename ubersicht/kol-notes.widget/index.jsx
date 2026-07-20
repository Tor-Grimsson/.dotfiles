// kol-notes.widget — v1 (Übersicht)
// The sticky-widget idea, second cut: DISPLAY the note on the desk.
// Reads the SAME file the cmd-alt-n sticky edits — ~/dev/projects/kol-vault/
// desk-notes.md (bin/notes-toggle) — so the desk view and the editor never
// drift. Read-only: writing happens in nvim, this just shows it. Files are
// the API — no daemon, cat + refresh. Sibling: kol-bookmarks.widget (above).
//
// Themed by kol-theme: `command` prepends the active theme's colors.json;
// render parses it, falling back to kol-dark when the selector has never run.
// Style doctrine: flat. Hairlines, radius at the window level only (4px).

// ponytail: note path literal (no `process` in the WebView, KOL_NOTES_FILE
// can't reach here) — repoint by hand if the vault moves.
export const command =
  'cat "$HOME/.config/kol-theme/current/colors.json" 2>/dev/null; echo "__KOLTHEME__"; cat ~/dev/projects/kol-vault/desk-notes.md 2>/dev/null; echo "__KOLBM__"; cat ~/.dotfiles/tmux/bookmarks.txt 2>/dev/null';

export const refreshFrequency = 10000; // 10s — edits in the sticky show up fast

// position + type only — every COLOR comes from the theme in render
export const className = `
  top: 48px;                           /* same origin as kol-bookmarks — render margin-tops below it */
  right: 12px;
  width: 280px;
  font-family: "JetBrains Mono", Menlo, monospace;
  font-size: 12px;
  line-height: 17px;
  pointer-events: none;                /* wrapper overlays bookmarks — clicks fall through; root re-enables */
`;

const KOL_DARK = {
  bgRgb: "18,18,21",
  fg: "#F5EBD8",
  muted: "#A39A78",
  accent: "#FFCF33",
  hairline: "rgba(245,235,216,.10)",
  empty: "rgba(245,235,216,.3)",
};

const styles = (t) => ({
  root:  { background: `rgba(${t.bgRgb},0.96)`, color: t.fg, /* near-solid — no backdrop blur in this WebView */
           borderRadius: "4px",                 /* window-level radius — the only one */
           padding: "10px 12px 8px", maxHeight: "420px", overflow: "hidden" },
  top:   { display: "flex", justifyContent: "space-between", fontSize: "11px",
           lineHeight: "1", color: t.muted, paddingBottom: "7px" },
  head:  { fontSize: "11px", lineHeight: "1", letterSpacing: ".08em", color: t.accent,
           borderBottom: `1px solid ${t.hairline}`,                  /* hairline, not a box */
           padding: "8px 0 4px", marginBottom: "2px" },
  line:  { padding: "1px 4px", whiteSpace: "pre-wrap", overflowWrap: "break-word" },
  done:  { color: t.muted },                                         /* checked = muted */
  gap:   { height: "8px" },
  empty: { color: t.empty, fontSize: "10.5px", paddingTop: "4px" },
});

// linked spacing: both widgets read bookmarks.txt, so notes computes
// kol-bookmarks' rendered height and sits GAP px below it — constant gap
// however long the list grows. Mirrors its metrics (root pad 18, top row 18,
// head 26, row 21 at 12px/17px type) — update together with kol-bookmarks.
const GAP = 12;
const bmOffset = (raw) => {
  const lines = (raw || "").split("\n").map((l) => l.trim()).filter(Boolean);
  if (!lines.length) return 18 + 18 + 21 + GAP; // its empty state
  const urls = lines.filter((l) => /^https?:\/\//.test(l)).length;
  const heads = (urls ? 1 : 0) + (urls < lines.length ? 1 : 0);
  return 18 + 18 + 26 * heads + 21 * lines.length + GAP;
};

export const render = ({ output, error }) => {
  const [themeRaw, rest] = (output || "").split("__KOLTHEME__");
  const [data, bmRaw] = (rest || "").split("__KOLBM__");
  let theme = KOL_DARK;
  try {
    theme = { ...KOL_DARK, ...JSON.parse(themeRaw) };
  } catch (e) {} // selector never run → kol-dark
  const S = styles(theme);

  const Line = (l, i) => {
    const head = l.match(/^#{1,6} (.*)/);
    if (head) return <div key={i} style={S.head}>{head[1]}</div>;
    if (!l.trim()) return <div key={i} style={S.gap} />;
    const todo = l.match(/^(\s*)- \[( |x)\] (.*)/);
    if (todo)
      return (
        <div key={i} style={{ ...S.line, ...(todo[2] === "x" ? S.done : {}) }}>
          {todo[1]}{todo[2] === "x" ? "■" : "□"} {todo[3]}
        </div>
      );
    return <div key={i} style={S.line}>{l}</div>;
  };

  const offset = { marginTop: `${bmOffset(bmRaw)}px`, pointerEvents: "auto" };
  if (error) return <div style={{ ...S.root, ...S.empty, ...offset }}>notes: {String(error)}</div>;
  const body = (data || "").replace(/\s+$/, "").replace(/^\n+/, "");
  const isEmpty = !body || body === "# desk notes"; // untouched seed = empty
  return (
    <div style={{ ...S.root, ...offset }}>
      <div style={S.top}><span>notes</span><span>⌘⌥n edit</span></div>
      {isEmpty
        ? <div style={S.empty}>empty — ⌘⌥n to write</div>
        : body.split("\n").map(Line)}
    </div>
  );
};
