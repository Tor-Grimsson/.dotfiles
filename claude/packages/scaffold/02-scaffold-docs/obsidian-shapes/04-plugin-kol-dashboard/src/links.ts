import { App, TFile, TFolder } from "obsidian";

export type LinkGroup = "pillar" | "repo";

export interface KolLink {
  label: string;
  url: string;
  group: LinkGroup;
  note?: string;
  path: string;   // .md file path
}

const LINKS_FOLDER = "_system/_kol-config/links";

/**
 * Discover curated links from _system/_kol-config/links/*.md.
 * Frontmatter: url (required), group (pillar|repo), label, note.
 */
export async function discoverLinks(app: App): Promise<KolLink[]> {
  const folder = app.vault.getAbstractFileByPath(LINKS_FOLDER);
  if (!(folder instanceof TFolder)) return [];

  const out: KolLink[] = [];
  for (const child of folder.children) {
    if (!(child instanceof TFile) || child.extension !== "md") continue;
    const fm = app.metadataCache.getFileCache(child)?.frontmatter;
    if (!fm || typeof fm.url !== "string") continue;
    const group: LinkGroup = fm.group === "repo" ? "repo" : "pillar";
    const label = typeof fm.label === "string" ? fm.label : child.basename;
    const note = typeof fm.note === "string" ? fm.note : undefined;
    out.push({ label, url: fm.url, group, note, path: child.path });
  }
  out.sort((a, b) => a.label.localeCompare(b.label));
  return out;
}
