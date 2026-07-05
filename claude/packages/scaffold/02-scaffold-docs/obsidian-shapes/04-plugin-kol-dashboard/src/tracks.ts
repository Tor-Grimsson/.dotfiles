import { App, TFile, TFolder } from "obsidian";
import { Task, parseTasks } from "./tasks";

export type ProjectStatus = "active" | "paused" | "done";

export interface Project {
  name: string;
  path: string;            // .md file path
  trackName: string;
  status: ProjectStatus;
  tasks: Task[];
  lastModified: number;
  todoCount: number;
  doingCount: number;
  doneCount: number;
}

export interface Track {
  name: string;
  path: string;            // folder path
  markerFile: string;      // INDEX.md path
  projects: Project[];
  todoCount: number;
  doingCount: number;
  doneCount: number;
  lastModified: number;
  sharePlatform?: string;
  shareCadence?: string;
  lastShared?: string;
}

const PROJECTS_SUBFOLDER = "projects";

export async function discoverTracks(app: App): Promise<Track[]> {
  const files = app.vault.getMarkdownFiles();
  const tracks: Track[] = [];

  for (const f of files) {
    const cache = app.metadataCache.getFileCache(f);
    const fm = cache?.frontmatter;
    if (!fm || fm.dashboard !== true) continue;

    const parent = f.parent;
    if (!parent) continue;

    const projects = await loadProjects(app, parent);

    let todo = 0, doing = 0, done = 0, lastModified = 0;
    for (const p of projects) {
      todo += p.todoCount;
      doing += p.doingCount;
      done += p.doneCount;
      if (p.lastModified > lastModified) lastModified = p.lastModified;
    }
    if (lastModified === 0) lastModified = f.stat.mtime;

    tracks.push({
      name: parent.name,
      path: parent.path,
      markerFile: f.path,
      projects,
      todoCount: todo,
      doingCount: doing,
      doneCount: done,
      lastModified,
      sharePlatform: typeof fm["share-platform"] === "string" ? fm["share-platform"] : undefined,
      shareCadence: typeof fm["share-cadence"] === "string" ? fm["share-cadence"] : undefined,
      lastShared: typeof fm["last-shared"] === "string" ? fm["last-shared"] : undefined,
    });
  }

  tracks.sort((a, b) => a.name.localeCompare(b.name));
  return tracks;
}

const STATUS_ORDER: Record<ProjectStatus, number> = { active: 0, paused: 1, done: 2 };

async function loadProjects(app: App, trackFolder: TFolder): Promise<Project[]> {
  const projectsFolder = trackFolder.children.find(
    (c) => c instanceof TFolder && c.name === PROJECTS_SUBFOLDER,
  );
  if (!(projectsFolder instanceof TFolder)) return [];

  const projects: Project[] = [];
  for (const child of projectsFolder.children) {
    if (!(child instanceof TFile)) continue;
    if (child.extension !== "md") continue;
    const content = await app.vault.cachedRead(child);
    const tasks = parseTasks(child.path, content);
    let todo = 0, doing = 0, done = 0;
    for (const t of tasks) {
      if (t.state === "todo") todo++;
      else if (t.state === "doing") doing++;
      else done++;
    }
    const fm = app.metadataCache.getFileCache(child)?.frontmatter;
    const status = normalizeStatus(fm?.status);
    projects.push({
      name: child.basename,
      path: child.path,
      trackName: trackFolder.name,
      status,
      tasks,
      lastModified: child.stat.mtime,
      todoCount: todo,
      doingCount: doing,
      doneCount: done,
    });
  }
  projects.sort((a, b) => {
    const sd = STATUS_ORDER[a.status] - STATUS_ORDER[b.status];
    if (sd !== 0) return sd;
    return a.name.localeCompare(b.name);
  });
  return projects;
}

function normalizeStatus(raw: unknown): ProjectStatus {
  if (raw === "paused") return "paused";
  if (raw === "done") return "done";
  return "active";
}

export function nextStatus(s: ProjectStatus): ProjectStatus {
  if (s === "active") return "paused";
  if (s === "paused") return "done";
  return "active";
}

export async function addTaskToProject(
  app: App,
  project: Project,
  text: string,
): Promise<void> {
  const file = app.vault.getAbstractFileByPath(project.path);
  if (!(file instanceof TFile)) throw new Error(`project file missing: ${project.path}`);
  const trimmed = text.trim();
  if (!trimmed) throw new Error("task text required");
  const newLine = `- [ ] ${trimmed}`;

  await app.vault.process(file, (content) => {
    const lines = content.split("\n");
    let headerIdx = -1;
    let lastTaskIdx = -1;
    for (let i = 0; i < lines.length; i++) {
      if (/^##\s+Tasks\s*$/i.test(lines[i])) {
        headerIdx = i;
        continue;
      }
      if (headerIdx >= 0) {
        if (/^##\s+/.test(lines[i])) break; // next section ends the Tasks block
        if (/^\s*[-*+]\s+\[[ /xX-]\]/.test(lines[i])) lastTaskIdx = i;
      }
    }

    if (lastTaskIdx >= 0) {
      lines.splice(lastTaskIdx + 1, 0, newLine);
    } else if (headerIdx >= 0) {
      let insertAt = headerIdx + 1;
      while (insertAt < lines.length && lines[insertAt].trim() === "") insertAt++;
      lines.splice(insertAt, 0, newLine);
    } else {
      if (lines.length > 0 && lines[lines.length - 1].trim() !== "") lines.push("");
      lines.push("## Tasks", "", newLine);
    }
    return lines.join("\n");
  });
}

export async function setProjectStatus(
  app: App,
  project: Project,
  status: ProjectStatus,
): Promise<void> {
  const file = app.vault.getAbstractFileByPath(project.path);
  if (!(file instanceof TFile)) throw new Error(`project file missing: ${project.path}`);
  await app.fileManager.processFrontMatter(file, (fm) => {
    fm.status = status;
  });
}

export async function createProject(
  app: App,
  track: Track,
  projectName: string,
): Promise<TFile> {
  const slug = projectName.trim().toLowerCase().replace(/\s+/g, "-").replace(/[^a-z0-9-]/g, "");
  if (!slug) throw new Error("project name empty after slugify");

  const projectsPath = `${track.path}/${PROJECTS_SUBFOLDER}`;
  const folder = app.vault.getAbstractFileByPath(projectsPath);
  if (!folder) {
    await app.vault.createFolder(projectsPath);
  }
  const targetPath = `${projectsPath}/${slug}.md`;
  if (app.vault.getAbstractFileByPath(targetPath)) {
    throw new Error(`project already exists: ${targetPath}`);
  }
  const today = new Date().toISOString().slice(0, 10);
  const body = `---
title: ${projectName}
track: ${track.name}
status: active
created: ${today}
tags:
  - kol-dashboard
  - kol-dashboard/${track.name}
---

# ${projectName}

## Tasks

- [ ]
`;
  return await app.vault.create(targetPath, body);
}

export function ageLabel(ms: number): string {
  if (ms === 0) return "—";
  const diff = Date.now() - ms;
  const min = Math.round(diff / 60000);
  if (min < 60) return `${min}m`;
  const hr = Math.round(min / 60);
  if (hr < 48) return `${hr}h`;
  const day = Math.round(hr / 24);
  if (day < 14) return `${day}d`;
  const wk = Math.round(day / 7);
  return `${wk}w`;
}
