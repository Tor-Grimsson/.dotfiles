import { App, TFile, TFolder } from "obsidian";

export interface Social {
  platform: string;          // e.g. "instagram"
  handle?: string;
  goalCadence?: string;      // raw frontmatter string, e.g. "3/week"
  intervalDays?: number;     // computed from goalCadence
  lastShared?: string;       // ISO date
  followers?: number;
  goalFollowers?: number;    // target follower count
  goalBy?: string;           // optional ISO target date
  path: string;              // .md file path
  daysSinceLastShare?: number;
  overdue: boolean;
}

const SOCIALS_FOLDER = "_system/_kol-config/socials";

export async function discoverSocials(app: App): Promise<Social[]> {
  const folder = app.vault.getAbstractFileByPath(SOCIALS_FOLDER);
  if (!(folder instanceof TFolder)) return [];

  const out: Social[] = [];
  for (const child of folder.children) {
    if (!(child instanceof TFile) || child.extension !== "md") continue;
    const fm = app.metadataCache.getFileCache(child)?.frontmatter;
    if (!fm) continue;
    const platform = typeof fm.platform === "string" ? fm.platform : child.basename;
    const handle = typeof fm.handle === "string" ? fm.handle : undefined;
    const goalCadence = typeof fm["goal-cadence"] === "string" ? fm["goal-cadence"] : undefined;
    const lastShared = typeof fm["last-shared"] === "string" ? fm["last-shared"] : undefined;
    const followers = typeof fm.followers === "number" ? fm.followers : undefined;
    const goalFollowers = typeof fm["goal-followers"] === "number" ? fm["goal-followers"] : undefined;
    const goalBy = typeof fm["goal-by"] === "string" ? fm["goal-by"] : undefined;

    const intervalDays = goalCadence ? parseCadence(goalCadence) : undefined;
    const daysSinceLastShare = lastShared ? daysSince(lastShared) : undefined;
    const overdue = intervalDays !== undefined && daysSinceLastShare !== undefined
      ? daysSinceLastShare > intervalDays
      : false;

    out.push({
      platform,
      handle,
      goalCadence,
      intervalDays,
      lastShared,
      followers,
      goalFollowers,
      goalBy,
      path: child.path,
      daysSinceLastShare,
      overdue,
    });
  }
  out.sort((a, b) => a.platform.localeCompare(b.platform));
  return out;
}

function parseCadence(raw: string): number | undefined {
  const s = raw.trim().toLowerCase();
  if (s === "daily") return 1;
  if (s === "weekly") return 7;
  if (s === "monthly") return 30;
  const m = s.match(/^(\d+)\s*\/\s*(day|week|month)$/);
  if (!m) return undefined;
  const n = parseInt(m[1], 10);
  if (!Number.isFinite(n) || n <= 0) return undefined;
  if (m[2] === "day") return Math.ceil(1 / n);
  if (m[2] === "week") return Math.ceil(7 / n);
  if (m[2] === "month") return Math.ceil(30 / n);
  return undefined;
}

function daysSince(iso: string): number | undefined {
  const t = Date.parse(iso);
  if (Number.isNaN(t)) return undefined;
  return Math.floor((Date.now() - t) / 86400000);
}

export async function logShare(
  app: App,
  social: Social,
  note: string,
): Promise<void> {
  const file = app.vault.getAbstractFileByPath(social.path);
  if (!(file instanceof TFile)) throw new Error(`socials file missing: ${social.path}`);
  const today = new Date().toISOString().slice(0, 10);
  await app.fileManager.processFrontMatter(file, (fm) => {
    fm["last-shared"] = today;
  });
  const line = note.trim()
    ? `- ${today} — ${note.trim()}`
    : `- ${today}`;
  await app.vault.process(file, (content) => {
    const lines = content.split("\n");
    let headerIdx = -1;
    let lastEntryIdx = -1;
    for (let i = 0; i < lines.length; i++) {
      if (/^##\s+(Log|Shares)\s*$/i.test(lines[i])) {
        headerIdx = i;
        continue;
      }
      if (headerIdx >= 0) {
        if (/^##\s+/.test(lines[i])) break;
        if (/^\s*-\s+\d{4}-\d{2}-\d{2}/.test(lines[i])) lastEntryIdx = i;
      }
    }
    if (lastEntryIdx >= 0) {
      lines.splice(lastEntryIdx, 0, line);
    } else if (headerIdx >= 0) {
      let insertAt = headerIdx + 1;
      while (insertAt < lines.length && lines[insertAt].trim() === "") insertAt++;
      lines.splice(insertAt, 0, line);
    } else {
      if (lines.length > 0 && lines[lines.length - 1].trim() !== "") lines.push("");
      lines.push("## Log", "", line);
    }
    return lines.join("\n");
  });
}
