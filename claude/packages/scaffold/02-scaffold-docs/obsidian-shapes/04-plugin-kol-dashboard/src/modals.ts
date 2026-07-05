import { App, Modal, Notice, SuggestModal, TFile, TFolder } from "obsidian";
import { Track, Project, ProjectStatus, createProject, discoverTracks, setProjectStatus } from "./tracks";
import { Social, logShare } from "./socials";
import { pinItem } from "./pinned";

export class TrackPickerModal extends SuggestModal<Track> {
  constructor(app: App, private tracks: Track[], private onPick: (t: Track) => void) {
    super(app);
    this.setPlaceholder("Pick a track…");
  }
  getSuggestions(query: string): Track[] {
    const q = query.toLowerCase();
    return this.tracks.filter((t) => t.name.toLowerCase().includes(q));
  }
  renderSuggestion(t: Track, el: HTMLElement): void {
    el.createDiv({ text: t.name });
    el.createDiv({
      text: `${t.projects.length} projects · ${t.todoCount}T ${t.doingCount}I ${t.doneCount}D`,
      cls: "kd-suggest-meta",
    });
  }
  onChooseSuggestion(t: Track): void {
    this.onPick(t);
  }
}

export class ProjectNameModal extends Modal {
  constructor(app: App, private track: Track, private onSubmit: (name: string) => void) {
    super(app);
  }
  onOpen(): void {
    const { contentEl } = this;
    contentEl.createEl("h3", { text: `New project in ${this.track.name}` });
    const input = contentEl.createEl("input", { type: "text" });
    input.placeholder = "project name (will be slugified)";
    input.style.width = "100%";
    input.style.padding = "6px 10px";
    input.style.marginTop = "8px";
    setTimeout(() => input.focus(), 0);

    const btnRow = contentEl.createDiv({ cls: "modal-button-container" });
    btnRow.style.marginTop = "12px";
    btnRow.style.display = "flex";
    btnRow.style.justifyContent = "flex-end";
    btnRow.style.gap = "8px";
    const cancel = btnRow.createEl("button", { text: "Cancel" });
    const create = btnRow.createEl("button", { cls: "mod-cta", text: "Create" });

    const submit = () => {
      const name = input.value.trim();
      if (!name) {
        new Notice("project name required");
        return;
      }
      this.onSubmit(name);
      this.close();
    };

    create.addEventListener("click", submit);
    cancel.addEventListener("click", () => this.close());
    input.addEventListener("keydown", (e) => {
      if (e.key === "Enter") submit();
      if (e.key === "Escape") this.close();
    });
  }
  onClose(): void {
    this.contentEl.empty();
  }
}

export class ManageModal extends Modal {
  constructor(app: App, private onClose_: () => void) {
    super(app);
  }
  async onOpen(): Promise<void> {
    const { contentEl } = this;
    contentEl.empty();
    contentEl.addClass("kd-manage-modal");

    const head = contentEl.createDiv({ cls: "kd-manage-head" });
    head.createEl("h3", { text: "Manage projects" });

    const newBtn = contentEl.createEl("button", { cls: "mod-cta kd-manage-new", text: "+ New project" });
    newBtn.addEventListener("click", async () => {
      const tracks = await discoverTracks(this.app);
      runNewProjectFlow(this.app, tracks, () => this.render());
    });

    await this.render();
  }
  async render(): Promise<void> {
    const wrap = this.contentEl.createDiv({ cls: "kd-manage-table-wrap" });
    const old = this.contentEl.querySelector(".kd-manage-table-wrap");
    if (old && old !== wrap) old.remove();

    const tracks = await discoverTracks(this.app);
    const flat: { project: Project; trackName: string }[] = [];
    for (const t of tracks) {
      for (const p of t.projects) flat.push({ project: p, trackName: t.name });
    }

    if (flat.length === 0) {
      wrap.createDiv({ cls: "kd-manage-empty", text: "no projects yet — use + New project above" });
      return;
    }

    const table = wrap.createEl("table", { cls: "kd-manage-table" });
    const thead = table.createEl("thead");
    const trh = thead.createEl("tr");
    ["Project", "Track", "Status", "Tasks"].forEach((h) => trh.createEl("th", { text: h }));

    const tbody = table.createEl("tbody");
    for (const { project, trackName } of flat) {
      const tr = tbody.createEl("tr");
      const nameCell = tr.createEl("td", { cls: "kd-manage-name" });
      const link = nameCell.createEl("a", { text: project.name, href: "#" });
      link.addEventListener("click", (e) => {
        e.preventDefault();
        this.app.workspace.openLinkText(project.path, "/", false);
        this.close();
      });
      tr.createEl("td", { text: trackName, cls: "kd-manage-track" });

      const statusCell = tr.createEl("td");
      const select = statusCell.createEl("select", { cls: "kd-manage-status" });
      (["active", "paused", "done"] as ProjectStatus[]).forEach((s) => {
        const opt = select.createEl("option", { text: s, value: s });
        if (s === project.status) opt.selected = true;
      });
      select.addEventListener("change", async () => {
        try {
          await setProjectStatus(this.app, project, select.value as ProjectStatus);
          new Notice(`${project.name} → ${select.value}`);
        } catch (err) {
          new Notice(`failed: ${(err as Error).message}`);
        }
      });

      tr.createEl("td", {
        text: `${project.todoCount}T ${project.doingCount}I ${project.doneCount}D`,
        cls: "kd-manage-tasks",
      });
    }
  }
  onClose(): void {
    this.contentEl.empty();
    this.onClose_();
  }
}

export class PinFileModal extends SuggestModal<TFile> {
  constructor(
    app: App,
    private excludePaths: Set<string>,
    private onPicked: (file: TFile) => void,
  ) {
    super(app);
    this.setPlaceholder("Search files to pin…");
  }
  getSuggestions(query: string): TFile[] {
    const q = query.toLowerCase().trim();
    const all = this.app.vault
      .getMarkdownFiles()
      .filter((f) => !this.excludePaths.has(f.path));
    if (!q) return all.slice(0, 50);
    return all
      .filter((f) =>
        f.basename.toLowerCase().includes(q) ||
        f.path.toLowerCase().includes(q),
      )
      .slice(0, 50);
  }
  renderSuggestion(file: TFile, el: HTMLElement): void {
    el.createDiv({ text: file.basename });
    el.createDiv({ text: file.parent?.path || "/", cls: "kd-suggest-meta" });
  }
  onChooseSuggestion(file: TFile): void {
    this.onPicked(file);
  }
}

export async function runPinFileFlow(
  app: App,
  excludePaths: Set<string>,
  onPinned: () => void,
): Promise<void> {
  new PinFileModal(app, excludePaths, async (file) => {
    try {
      await pinItem(app, file);
      new Notice(`pinned ${file.basename}`);
      onPinned();
    } catch (err) {
      new Notice(`failed: ${(err as Error).message}`);
    }
  }).open();
}

/** Pick a folder under `root` — inbox "→ New note" destination. */
export class KolFolderModal extends SuggestModal<TFolder> {
  constructor(app: App, private root: string, private onPicked: (f: TFolder) => void) {
    super(app);
    this.setPlaceholder(`Pick a folder under ${root}/ …`);
  }
  getSuggestions(q: string): TFolder[] {
    const ql = q.toLowerCase().trim();
    const all = this.app.vault
      .getAllLoadedFiles()
      .filter((f): f is TFolder => f instanceof TFolder && f.path.startsWith(this.root + "/"));
    return (ql ? all.filter((f) => f.path.toLowerCase().includes(ql)) : all).slice(0, 50);
  }
  renderSuggestion(f: TFolder, el: HTMLElement): void {
    el.createDiv({ text: f.path });
  }
  onChooseSuggestion(f: TFolder): void {
    this.onPicked(f);
  }
}

/** Pick a note under `root` — inbox "→ File to group" append target. */
export class KolFileModal extends SuggestModal<TFile> {
  constructor(app: App, private root: string, private onPicked: (f: TFile) => void) {
    super(app);
    this.setPlaceholder(`Pick a note under ${root}/ to file into…`);
  }
  getSuggestions(q: string): TFile[] {
    const ql = q.toLowerCase().trim();
    const all = this.app.vault.getMarkdownFiles().filter((f) => f.path.startsWith(this.root + "/"));
    return (ql
      ? all.filter((f) => f.basename.toLowerCase().includes(ql) || f.path.toLowerCase().includes(ql))
      : all
    ).slice(0, 50);
  }
  renderSuggestion(f: TFile, el: HTMLElement): void {
    el.createDiv({ text: f.basename });
    el.createDiv({ text: f.parent?.path || "/", cls: "kd-suggest-meta" });
  }
  onChooseSuggestion(f: TFile): void {
    this.onPicked(f);
  }
}

export class LogShareModal extends Modal {
  constructor(app: App, private social: Social, private onSubmit: (note: string) => void) {
    super(app);
  }
  onOpen(): void {
    const { contentEl } = this;
    contentEl.empty();
    contentEl.createEl("h3", { text: `Log share — ${this.social.platform}` });
    contentEl.createEl("p", {
      text: `Records today as last-shared. Optional note/url appended to the log.`,
      cls: "setting-item-description",
    });

    const input = contentEl.createEl("input", { type: "text" });
    input.placeholder = "note or url (optional)";
    input.style.width = "100%";
    input.style.padding = "6px 10px";
    input.style.marginTop = "8px";
    setTimeout(() => input.focus(), 0);

    const btnRow = contentEl.createDiv();
    btnRow.style.marginTop = "12px";
    btnRow.style.display = "flex";
    btnRow.style.justifyContent = "flex-end";
    btnRow.style.gap = "8px";
    const cancel = btnRow.createEl("button", { text: "Cancel" });
    const log = btnRow.createEl("button", { cls: "mod-cta", text: "Log share" });

    const submit = () => {
      this.onSubmit(input.value);
      this.close();
    };
    log.addEventListener("click", submit);
    cancel.addEventListener("click", () => this.close());
    input.addEventListener("keydown", (e) => {
      if (e.key === "Enter") submit();
      if (e.key === "Escape") this.close();
    });
  }
  onClose(): void {
    this.contentEl.empty();
  }
}

/**
 * Log a social post from the week view: pick a platform from the list, paste a
 * link, optionally add a note. Composes the link + note into one log line.
 */
export class LogPostModal extends Modal {
  constructor(
    app: App,
    private socials: Social[],
    private dateLabel: string,
    private onSubmit: (social: Social, note: string) => void,
  ) {
    super(app);
  }
  onOpen(): void {
    const { contentEl } = this;
    contentEl.empty();
    contentEl.createEl("h3", { text: "Log social post" });
    contentEl.createEl("p", {
      text: `Records ${this.dateLabel} as last-shared on the chosen platform and appends the link to its log.`,
      cls: "setting-item-description",
    });

    if (this.socials.length === 0) {
      contentEl.createEl("p", {
        text: "No platforms found in _system/_kol-config/socials.",
        cls: "setting-item-description",
      });
      return;
    }

    const fieldStyle = (el: HTMLElement) => {
      el.style.width = "100%";
      el.style.padding = "6px 10px";
      el.style.marginTop = "8px";
    };

    const select = contentEl.createEl("select", { cls: "dropdown" });
    fieldStyle(select);
    for (const s of this.socials) {
      select.createEl("option", {
        text: s.handle ? `${s.platform} — ${s.handle}` : s.platform,
        value: s.path,
      });
    }

    const linkInput = contentEl.createEl("input", { type: "text" });
    linkInput.placeholder = "link to the post (url)";
    fieldStyle(linkInput);
    setTimeout(() => linkInput.focus(), 0);

    const noteInput = contentEl.createEl("input", { type: "text" });
    noteInput.placeholder = "note (optional)";
    fieldStyle(noteInput);

    const btnRow = contentEl.createDiv();
    btnRow.style.marginTop = "12px";
    btnRow.style.display = "flex";
    btnRow.style.justifyContent = "flex-end";
    btnRow.style.gap = "8px";
    const cancel = btnRow.createEl("button", { text: "Cancel" });
    const log = btnRow.createEl("button", { cls: "mod-cta", text: "Log post" });

    const submit = () => {
      const social = this.socials.find((s) => s.path === select.value);
      if (!social) {
        new Notice("pick a platform");
        return;
      }
      const link = linkInput.value.trim();
      const note = noteInput.value.trim();
      const composed = link && note ? `${link} — ${note}` : link || note;
      this.onSubmit(social, composed);
      this.close();
    };
    log.addEventListener("click", submit);
    cancel.addEventListener("click", () => this.close());
    const onKey = (e: KeyboardEvent) => {
      if (e.key === "Enter") submit();
      if (e.key === "Escape") this.close();
    };
    linkInput.addEventListener("keydown", onKey);
    noteInput.addEventListener("keydown", onKey);
  }
  onClose(): void {
    this.contentEl.empty();
  }
}

/** Generic single-line text prompt — used for week reminders and notes. */
export class TextPromptModal extends Modal {
  constructor(
    app: App,
    private title: string,
    private placeholder: string,
    private onSubmit: (text: string) => void,
  ) {
    super(app);
  }
  onOpen(): void {
    const { contentEl } = this;
    contentEl.empty();
    contentEl.createEl("h3", { text: this.title });

    const input = contentEl.createEl("input", { type: "text" });
    input.placeholder = this.placeholder;
    input.style.width = "100%";
    input.style.padding = "6px 10px";
    input.style.marginTop = "8px";
    setTimeout(() => input.focus(), 0);

    const btnRow = contentEl.createDiv();
    btnRow.style.marginTop = "12px";
    btnRow.style.display = "flex";
    btnRow.style.justifyContent = "flex-end";
    btnRow.style.gap = "8px";
    const cancel = btnRow.createEl("button", { text: "Cancel" });
    const add = btnRow.createEl("button", { cls: "mod-cta", text: "Add" });

    const submit = () => {
      const text = input.value.trim();
      if (!text) {
        new Notice("nothing to add");
        return;
      }
      this.onSubmit(text);
      this.close();
    };
    add.addEventListener("click", submit);
    cancel.addEventListener("click", () => this.close());
    input.addEventListener("keydown", (e) => {
      if (e.key === "Enter") submit();
      if (e.key === "Escape") this.close();
    });
  }
  onClose(): void {
    this.contentEl.empty();
  }
}

export async function runNewProjectFlow(
  app: App,
  tracks: Track[],
  onCreated: () => void,
): Promise<void> {
  if (tracks.length === 0) {
    new Notice("no tracks marked yet — add dashboard: true to an INDEX.md");
    return;
  }
  new TrackPickerModal(app, tracks, (track) => {
    new ProjectNameModal(app, track, async (name) => {
      try {
        const file = await createProject(app, track, name);
        new Notice(`created ${file.path}`);
        onCreated();
      } catch (err) {
        new Notice(`failed: ${(err as Error).message}`);
      }
    }).open();
  }).open();
}
