import { App, TFile, TFolder, normalizePath } from "obsidian";

/** Kanban columns for triaging captures out of the kol-capture inbox. */
export type InboxColumn = "triage" | "todo" | "doing" | "done";

export const INBOX_COLUMNS: { id: InboxColumn; label: string }[] = [
  { id: "triage", label: "Triage" },
  { id: "todo", label: "Todo" },
  { id: "doing", label: "Doing" },
  { id: "done", label: "Done" },
];

export interface InboxCard {
  /** the raw markdown line — stable id, used as the state key */
  line: string;
  ts: string;
  text: string;
  column: InboxColumn;
}

// matches the bot's append format: "- YYYY-MM-DD HH:MM <text>"
const LINE_RE = /^-\s+(\d{4}-\d{2}-\d{2} \d{2}:\d{2})\s+(.*\S)\s*$/;

/** Read inbox.md and parse its bullet lines into cards. Column comes from
 *  persisted state (new captures default to "triage"). */
export async function readInbox(
  app: App,
  path: string,
  state: Record<string, InboxColumn>,
): Promise<InboxCard[]> {
  const file = app.vault.getAbstractFileByPath(path);
  if (!(file instanceof TFile)) return [];
  const body = await app.vault.read(file);
  const out: InboxCard[] = [];
  for (const raw of body.split("\n")) {
    const m = raw.match(LINE_RE);
    if (!m) continue;
    out.push({ line: raw, ts: m[1], text: m[2], column: state[raw] ?? "triage" });
  }
  return out;
}

function slugify(text: string): string {
  return text.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-+|-+$/g, "").slice(0, 50) || "note";
}

/** Replace one raw line in inbox.md (newLine = null drops it). */
export async function replaceLine(app: App, path: string, oldLine: string, newLine: string | null): Promise<void> {
  const file = app.vault.getAbstractFileByPath(path);
  if (!(file instanceof TFile)) return;
  const body = await app.vault.read(file);
  const out: string[] = [];
  for (const l of body.split("\n")) {
    if (l === oldLine) { if (newLine !== null) out.push(newLine); }
    else out.push(l);
  }
  await app.vault.modify(file, out.join("\n"));
}

/** Promote a capture to its own .md in `folder` (kol-docs draft). Returns the new file. */
export async function promoteToNote(app: App, card: InboxCard, folder: TFolder): Promise<TFile> {
  const slug = slugify(card.text);
  let target = normalizePath(`${folder.path}/${slug}.md`);
  for (let n = 2; app.vault.getAbstractFileByPath(target); n++) target = normalizePath(`${folder.path}/${slug}-${n}.md`);
  const day = card.ts.slice(0, 10);
  const body = `---\ntitle: ${card.text}\ntype: reference\nstatus: draft\nupdated: ${day}\ntags:\n  - pattern/capture\n---\n\n# ${card.text}\n\nCaptured ${card.ts} via kol-capture.\n`;
  return app.vault.create(target, body);
}

/** File a capture into an existing note — append a timestamped bullet (librarian "log"). */
export async function fileToGroup(app: App, card: InboxCard, target: TFile): Promise<void> {
  const body = await app.vault.read(target);
  const sep = body.length && !body.endsWith("\n") ? "\n" : "";
  await app.vault.modify(target, `${body}${sep}- ${card.ts} ${card.text}\n`);
}

/** Remove the given raw lines from inbox.md — the "cleared / triaged out" gesture.
 *  ponytail: full rewrite. The bot appends every ~2 min so a clobber is possible
 *  but improbable; this is a deliberate batch-clear, not a per-keystroke write. */
export async function clearLines(app: App, path: string, lines: Set<string>): Promise<void> {
  const file = app.vault.getAbstractFileByPath(path);
  if (!(file instanceof TFile)) return;
  const body = await app.vault.read(file);
  const kept = body.split("\n").filter((l) => !lines.has(l));
  await app.vault.modify(file, kept.join("\n"));
}
