import { App, TFile } from "obsidian";

export interface PinnedItem {
  title: string;
  description?: string;
  path: string;
  basename: string;
  tags: string[];
}

export function discoverPinned(app: App): PinnedItem[] {
  const files = app.vault.getMarkdownFiles();
  const out: PinnedItem[] = [];
  for (const f of files) {
    const fm = app.metadataCache.getFileCache(f)?.frontmatter;
    if (!fm || fm.pinned !== true) continue;
    out.push({
      title: typeof fm.title === "string" ? fm.title : f.basename,
      description: typeof fm.description === "string" ? fm.description : undefined,
      path: f.path,
      basename: f.basename,
      tags: extractTags(fm.tags),
    });
  }
  out.sort((a, b) => a.title.localeCompare(b.title));
  return out;
}

export async function pinItem(app: App, file: TFile): Promise<void> {
  await app.fileManager.processFrontMatter(file, (fm) => {
    fm.pinned = true;
  });
}

export async function unpinItem(app: App, item: PinnedItem): Promise<void> {
  const file = app.vault.getAbstractFileByPath(item.path);
  if (!(file instanceof TFile)) throw new Error(`pinned file missing: ${item.path}`);
  await app.fileManager.processFrontMatter(file, (fm) => {
    delete fm.pinned;
  });
}

function extractTags(raw: unknown): string[] {
  if (Array.isArray(raw)) return raw.filter((t): t is string => typeof t === "string");
  if (typeof raw === "string") return [raw];
  return [];
}
