import { ItemView, MarkdownRenderer, Notice, TFile, WorkspaceLeaf, setIcon } from "obsidian";
import type KolDashboardPlugin from "./main";
import { fetchMetrics, MetricsResult, MetricListItem, PlatformMetric, formatNumber, formatValue } from "./metrics";
import { Task, TaskState, cycleTaskState } from "./tasks";
import { discoverTracks, ageLabel, Track, Project, ProjectStatus, nextStatus, setProjectStatus, addTaskToProject } from "./tracks";
import { runNewProjectFlow, ManageModal, LogShareModal, runPinFileFlow, LogPostModal, TextPromptModal } from "./modals";
import { Social, discoverSocials, logShare } from "./socials";
import { WeekDay, getCurrentWeek, attachReminders, attachManualEntries, countReminders, ShareReminder } from "./week";
import { PinnedItem, discoverPinned, unpinItem } from "./pinned";
import { KolLink, discoverLinks } from "./links";
import { readInbox, clearLines, INBOX_COLUMNS, promoteToNote, fileToGroup, replaceLine } from "./inbox";
import { fetchAgenda } from "./calendar";
import { KolFolderModal, KolFileModal } from "./modals";
import type { TabId } from "./settings";
import type { InboxColumn, InboxCard } from "./inbox";

export const VIEW_TYPE_DASHBOARD = "kol-dashboard-view";

const CB_GLYPH: Record<TaskState, string> = {
  todo: "☐",
  doing: "◐",
  done: "☒",
};

const STATUS_GLYPH: Record<ProjectStatus, string> = {
  active: "●",
  paused: "◐",
  done: "○",
};
const STATUS_LABEL: Record<ProjectStatus, string> = {
  active: "active",
  paused: "paused",
  done: "done",
};

interface CountRefs {
  todoEl: HTMLElement;
  doingEl: HTMLElement;
  doneEl: HTMLElement;
  todo: number;
  doing: number;
  done: number;
}

function formatDayLabel(iso: string): string {
  // Render "May 22" style — short month name + day.
  const d = new Date(iso + "T00:00:00");
  const month = d.toLocaleString("en-US", { month: "short" });
  return `${month} ${d.getDate()}`;
}

function adjustCounts(refs: CountRefs, from: TaskState, to: TaskState) {
  if (from === to) return;
  if (from === "todo") refs.todo--;
  else if (from === "doing") refs.doing--;
  else refs.done--;
  if (to === "todo") refs.todo++;
  else if (to === "doing") refs.doing++;
  else refs.done++;
  refs.todoEl.setText(`${refs.todo}T`);
  refs.doingEl.setText(`${refs.doing}I`);
  refs.doneEl.setText(`${refs.done}D`);
}

export class DashboardView extends ItemView {
  plugin: KolDashboardPlugin;
  private refreshTimer: number | null = null;
  private container!: HTMLElement;
  private expandedProjects = new Set<string>();
  private metricsRes: MetricsResult | null = null;
  private tracksContainer: HTMLElement | null = null;
  private socialsContainer: HTMLElement | null = null;
  private weekContainer: HTMLElement | null = null;
  private pinnedContainer: HTMLElement | null = null;

  constructor(leaf: WorkspaceLeaf, plugin: KolDashboardPlugin) {
    super(leaf);
    this.plugin = plugin;
  }

  getViewType(): string {
    return VIEW_TYPE_DASHBOARD;
  }

  getDisplayText(): string {
    return "KOL Dashboard";
  }

  getIcon(): string {
    return "activity";
  }

  async onOpen() {
    this.container = this.contentEl;
    this.container.empty();
    this.container.addClass("kol-dashboard");
    await this.render();
    this.scheduleAutoRefresh();
  }

  async onClose() {
    if (this.refreshTimer !== null) {
      window.clearInterval(this.refreshTimer);
      this.refreshTimer = null;
    }
  }

  scheduleAutoRefresh() {
    if (this.refreshTimer !== null) {
      window.clearInterval(this.refreshTimer);
      this.refreshTimer = null;
    }
    const min = this.plugin.settings.refreshIntervalMin;
    if (min <= 0) return;
    this.refreshTimer = window.setInterval(
      () => this.refresh(),
      min * 60 * 1000,
    );
  }

  /** Full refresh: refetch metrics + re-scan tracks. Used by button / interval. */
  async refresh() {
    this.metricsRes = null;
    await this.render();
  }

  /** Refresh only the tracks section. Used after task state changes. */
  async refreshTracks() {
    if (!this.tracksContainer) return;
    const tracks = await discoverTracks(this.app);
    this.tracksContainer.empty();
    this.renderTracks(this.tracksContainer, tracks);
  }

  /** Refresh only the socials section. Used after logging a share. */
  async refreshSocials() {
    if (!this.socialsContainer) return;
    const socials = await discoverSocials(this.app);
    this.socialsContainer.empty();
    this.renderSocials(this.socialsContainer, socials);
    await this.refreshWeek();
  }

  /** Refresh only the week section. Used after a share recomputes reminders. */
  async refreshWeek() {
    if (!this.weekContainer) return;
    const week = await this.buildWeek();
    this.weekContainer.empty();
    this.renderWeek(this.weekContainer, week);
  }

  /** Refresh only the pinned section. */
  async refreshPinned() {
    if (!this.pinnedContainer) return;
    const items = discoverPinned(this.app);
    this.pinnedContainer.empty();
    this.renderPinned(this.pinnedContainer, items);
  }

  private static TABS: { id: TabId; label: string }[] = [
    { id: "work", label: "WORK" },
    { id: "studio", label: "STUDIO" },
    { id: "growth", label: "GROWTH" },
    { id: "links", label: "LINKS" },
    { id: "pinned", label: "PINNED" },
    { id: "inbox", label: "INBOX" },
    { id: "calendar", label: "CALENDAR" },
  ];

  private activeTab(): TabId {
    const t = this.plugin.settings.activeTab;
    return DashboardView.TABS.some((x) => x.id === t) ? t : "work";
  }

  async render() {
    this.container.empty();
    this.tracksContainer = null;
    this.socialsContainer = null;
    this.weekContainer = null;
    this.pinnedContainer = null;

    // ===== HEADER =====
    const header = this.container.createDiv({ cls: "kd-header" });
    const title = header.createDiv({ cls: "kd-title" });
    title.createSpan({ cls: "kd-title-icon", text: "▲" });
    title.createSpan({ cls: "kd-title-text", text: "KOL DASHBOARD" });

    const statusEl = header.createDiv({ cls: "kd-status" });
    const liveBadge = statusEl.createSpan({ cls: "kd-live-badge" });
    const liveDot = liveBadge.createSpan({ cls: "kd-live-dot" });
    const liveText = liveBadge.createSpan({ cls: "kd-live-text", text: "LIVE" });

    const refreshBtn = statusEl.createEl("button", { cls: "kd-refresh-btn", attr: { "aria-label": "Refresh" } });
    setIcon(refreshBtn, "refresh-cw");
    refreshBtn.addEventListener("click", () => {
      new Notice("Refreshing…");
      this.refresh();
    });

    // ===== TABS =====
    const active = this.activeTab();
    this.renderTabBar(active);

    // ===== TAB CONTENT =====
    const content = this.container.createDiv({ cls: "kd-tab-content" });
    if (active === "studio") await this.renderStudioTab(content);
    else if (active === "growth") await this.renderGrowthTab(content);
    else if (active === "links") await this.renderLinksTab(content);
    else if (active === "pinned") this.renderPinnedTab(content);
    else if (active === "inbox") await this.renderInboxTab(content);
    else if (active === "calendar") await this.renderCalendarTab(content);
    else await this.renderWorkTab(content);

    // Reflect actual data state in the header badge.
    const isLive = this.metricsRes?.source === "live";
    if (!isLive) {
      liveBadge.addClass("kd-live-badge-offline");
      liveDot.addClass("kd-live-dot-offline");
      liveText.setText(this.metricsRes ? "OFFLINE" : "—");
    }

    // ===== FOOTER =====
    const footer = this.container.createDiv({ cls: "kd-footer" });
    const ts = this.metricsRes ? new Date(this.metricsRes.generatedAt).toLocaleTimeString() : "—";
    const src = this.metricsRes
      ? this.metricsRes.source === "live"
        ? "live"
        : `placeholder (${this.metricsRes.error || "no endpoint"})`
      : "metrics not loaded";
    footer.createSpan({ text: `last pull: ${ts} · source: ${src}` });
  }

  private renderTabBar(active: TabId) {
    const bar = this.container.createDiv({ cls: "kd-tabbar" });
    for (const t of DashboardView.TABS) {
      const btn = bar.createEl("button", { cls: "kd-tab-btn", text: t.label });
      if (t.id === active) btn.addClass("kd-tab-active");
      btn.addEventListener("click", async () => {
        if (this.plugin.settings.activeTab === t.id) return;
        this.plugin.settings.activeTab = t.id;
        await this.plugin.saveSettings();
        await this.render();
      });
    }
  }

  /** STUDIO tab: metrics + socials. */
  private async renderStudioTab(parent: HTMLElement) {
    const { settings } = this.plugin;

    if (settings.showMetrics) {
      const metricsSection = parent.createDiv({ cls: "kd-section kd-metrics" });
      const metricsHead = metricsSection.createDiv({ cls: "kd-section-head" });
      metricsHead.createSpan({ cls: "kd-section-label", text: "KOL METRICS" });
      const metricsCount = metricsHead.createSpan({ cls: "kd-section-count" });

      if (this.metricsRes === null) {
        const metricsLoading = metricsSection.createDiv({ cls: "kd-loading", text: "loading metrics…" });
        this.metricsRes = await fetchMetrics({
          baseUrl: settings.umamiUrl,
          websiteId: settings.umamiWebsiteId,
          username: settings.umamiUsername,
          password: settings.umamiPassword,
        });
        metricsLoading.remove();
      }
      metricsCount.setText(`${this.metricsRes.platforms.length}`);
      this.renderMetrics(metricsSection, this.metricsRes);
      this.renderLatest(metricsSection, this.metricsRes);
      this.renderMetricLists(metricsSection, this.metricsRes);
    }

    const socialsSection = parent.createDiv({ cls: "kd-section kd-socials" });
    this.socialsContainer = socialsSection;
    const socials = await discoverSocials(this.app);
    this.renderSocials(socialsSection, socials);
  }

  /** WORK tab: tracks + week. */
  private async renderWorkTab(parent: HTMLElement) {
    const { settings } = this.plugin;

    // Inbox: triage list (first) + parked-cards mini-board.
    const inbox = await readInbox(this.app, settings.inboxPath, settings.inboxState);
    this.renderInboxList(parent, inbox.filter((c) => c.column === "triage"));
    const parked = inbox.filter((c) => c.column !== "triage");
    if (parked.length) {
      const mini = parent.createDiv({ cls: "kd-section kd-inbox-mini" });
      mini.createDiv({ cls: "kd-section-head" }).createSpan({ cls: "kd-section-title", text: "Board" });
      this.renderKanban(mini, parked, INBOX_COLUMNS.filter((c) => c.id !== "triage"));
    }

    if (settings.showProjects) {
      const tracksSection = parent.createDiv({ cls: "kd-section kd-tracks" });
      this.tracksContainer = tracksSection;
      const tracks = await discoverTracks(this.app);
      this.renderTracks(tracksSection, tracks);
    }

    const weekSection = parent.createDiv({ cls: "kd-section kd-week" });
    this.weekContainer = weekSection;
    const week = await this.buildWeek();
    this.renderWeek(weekSection, week);
  }

  /** PINNED tab. */
  private renderPinnedTab(parent: HTMLElement) {
    const pinnedSection = parent.createDiv({ cls: "kd-section kd-pinned" });
    this.pinnedContainer = pinnedSection;
    const pinned = discoverPinned(this.app);
    this.renderPinned(pinnedSection, pinned);
  }

  /** CALENDAR tab: live agenda from gcalcli (desktop only). */
  private async renderCalendarTab(parent: HTMLElement) {
    const days = this.plugin.settings.calendarDays;
    parent.createDiv({ cls: "kd-cal-head" }).createSpan({ cls: "kd-cal-title", text: `Next ${days} days` });
    const res = await fetchAgenda(days);
    if (res.error) {
      parent.createDiv({ cls: "kd-cal-error", text: `gcalcli: ${res.error}` });
      parent.createDiv({ cls: "kd-cal-hint", text: "Desktop only · gcalcli must be authed (gcalcli init)." });
      return;
    }
    if (!res.events.length) {
      parent.createDiv({ cls: "kd-cal-empty", text: "Nothing scheduled." });
      return;
    }
    const list = parent.createDiv({ cls: "kd-cal-list" });
    let lastDate = "";
    for (const ev of res.events) {
      if (ev.date !== lastDate) {
        list.createDiv({ cls: "kd-cal-day", text: ev.date });
        lastDate = ev.date;
      }
      const row = list.createDiv({ cls: "kd-cal-row" });
      row.createSpan({ cls: "kd-cal-time", text: ev.time || "all-day" });
      row.createSpan({ cls: "kd-cal-event", text: ev.title });
    }
  }

  /** INBOX tab: the full kanban (all columns) over the kol-capture inbox. */
  private async renderInboxTab(parent: HTMLElement) {
    const cards = await readInbox(this.app, this.plugin.settings.inboxPath, this.plugin.settings.inboxState);
    const head = parent.createDiv({ cls: "kd-inbox-head" });
    head.createSpan({ cls: "kd-inbox-title", text: `Inbox — ${cards.length} captured` });
    head.createSpan({ cls: "kd-inbox-path", text: this.plugin.settings.inboxPath });
    if (!cards.length) {
      parent.createDiv({ cls: "kd-inbox-empty", text: "Inbox empty. Text the bot  #kol-ob <thought>." });
      return;
    }
    this.renderKanban(parent, cards, INBOX_COLUMNS);
  }

  /** Reusable kanban over `cards`, limited to `columns`. Drag + ←/→ to move. */
  private renderKanban(parent: HTMLElement, cards: InboxCard[], columns: { id: InboxColumn; label: string }[]) {
    const state = this.plugin.settings.inboxState;
    const board = parent.createDiv({ cls: "kd-kanban" });
    for (const col of columns) {
      const colCards = cards.filter((c) => c.column === col.id);
      const colEl = board.createDiv({ cls: `kd-kanban-col kd-kanban-${col.id}` });
      colEl.addEventListener("dragover", (e) => { e.preventDefault(); colEl.addClass("kd-drop-target"); });
      colEl.addEventListener("dragleave", () => colEl.removeClass("kd-drop-target"));
      colEl.addEventListener("drop", (e) => {
        e.preventDefault();
        colEl.removeClass("kd-drop-target");
        const line = (e as DragEvent).dataTransfer?.getData("text/plain");
        if (line) this.moveCard(line, col.id);
      });
      const ch = colEl.createDiv({ cls: "kd-kanban-head" });
      ch.createSpan({ cls: "kd-kanban-label", text: col.label });
      ch.createSpan({ cls: "kd-kanban-count", text: String(colCards.length) });
      if (col.id === "done" && colCards.length) {
        const clr = ch.createEl("button", { cls: "kd-kanban-clear", text: "clear" });
        clr.onclick = async () => {
          await clearLines(this.app, this.plugin.settings.inboxPath, new Set(colCards.map((c) => c.line)));
          for (const c of colCards) delete state[c.line];
          await this.plugin.saveSettings();
          await this.render();
        };
      }
      for (const card of colCards) {
        const cardEl = colEl.createDiv({ cls: "kd-kanban-card" });
        cardEl.draggable = true;
        cardEl.addEventListener("dragstart", (e) => {
          (e as DragEvent).dataTransfer?.setData("text/plain", card.line);
          cardEl.addClass("kd-dragging");
        });
        cardEl.addEventListener("dragend", () => cardEl.removeClass("kd-dragging"));
        cardEl.createDiv({ cls: "kd-kanban-card-text", text: card.text });
        cardEl.createDiv({ cls: "kd-kanban-card-ts", text: card.ts });
        const ctrls = cardEl.createDiv({ cls: "kd-kanban-ctrls" });
        const idx = columns.findIndex((c) => c.id === col.id);
        if (idx > 0) {
          const b = ctrls.createEl("button", { cls: "kd-kanban-move", text: "←" });
          b.onclick = () => this.moveCard(card.line, columns[idx - 1].id);
        }
        if (idx < columns.length - 1) {
          const b = ctrls.createEl("button", { cls: "kd-kanban-move", text: "→" });
          b.onclick = () => this.moveCard(card.line, columns[idx + 1].id);
        }
      }
    }
  }

  /** WORK: the triage list (incoming items) with the per-item action menu. */
  private renderInboxList(parent: HTMLElement, cards: InboxCard[]) {
    const section = parent.createDiv({ cls: "kd-section kd-inbox-list" });
    const head = section.createDiv({ cls: "kd-section-head" });
    head.createSpan({ cls: "kd-section-title", text: "Inbox" });
    head.createSpan({ cls: "kd-section-count", text: String(cards.length) });
    if (!cards.length) {
      section.createDiv({ cls: "kd-inbox-empty", text: "Nothing to triage." });
      return;
    }
    for (const card of cards) {
      const row = section.createDiv({ cls: "kd-inbox-row" });
      const txt = row.createDiv({ cls: "kd-inbox-row-text" });
      txt.createSpan({ cls: "kd-inbox-row-msg", text: card.text });
      txt.createSpan({ cls: "kd-inbox-row-ts", text: card.ts });
      const menu = row.createDiv({ cls: "kd-inbox-menu" });
      this.actionBtn(menu, "Note", "Promote to its own note in kol-library", () => this.actNote(card));
      this.actionBtn(menu, "Group", "File into an existing kol-library note", () => this.actGroup(card));
      this.actionBtn(menu, "Board", "Park as a kanban card", () => this.moveCard(card.line, "todo"));
      this.actionBtn(menu, "✕", "Delete", () => this.actDelete(card));
    }
  }

  private actionBtn(host: HTMLElement, label: string, tip: string, fn: () => void) {
    const b = host.createEl("button", { cls: "kd-inbox-act", text: label, attr: { title: tip, "aria-label": tip } });
    b.onclick = fn;
  }

  /** → New note: pick a kol-library folder, spin up a draft, backlink the inbox line. */
  private actNote(card: InboxCard) {
    new KolFolderModal(this.app, "kol-library", async (folder) => {
      const file = await promoteToNote(this.app, card, folder);
      await replaceLine(this.app, this.plugin.settings.inboxPath, card.line, `- ${card.ts} → [[${file.basename}]]`);
      delete this.plugin.settings.inboxState[card.line];
      await this.plugin.saveSettings();
      new Notice(`note: ${file.basename}`);
      await this.render();
    }).open();
  }

  /** → File to group: pick an existing kol-library note, append, backlink the inbox line. */
  private actGroup(card: InboxCard) {
    new KolFileModal(this.app, "kol-library", async (file) => {
      await fileToGroup(this.app, card, file);
      await replaceLine(this.app, this.plugin.settings.inboxPath, card.line, `- ${card.ts} → [[${file.basename}]]`);
      delete this.plugin.settings.inboxState[card.line];
      await this.plugin.saveSettings();
      new Notice(`filed → ${file.basename}`);
      await this.render();
    }).open();
  }

  private async actDelete(card: InboxCard) {
    await clearLines(this.app, this.plugin.settings.inboxPath, new Set([card.line]));
    delete this.plugin.settings.inboxState[card.line];
    await this.plugin.saveSettings();
    await this.render();
  }

  private async moveCard(line: string, col: InboxColumn) {
    this.plugin.settings.inboxState[line] = col;
    await this.plugin.saveSettings();
    await this.render();
  }

  /** Build the week with both cadence-derived and user-added entries attached. */
  private async buildWeek(): Promise<WeekDay[]> {
    const socials = await discoverSocials(this.app);
    const week = getCurrentWeek();
    attachReminders(week, socials);
    attachManualEntries(week, this.plugin.settings.weekEntries);
    return week;
  }

  /** GROWTH tab: followers vs goal per account, plus a total roll-up. */
  private async renderGrowthTab(parent: HTMLElement) {
    const socials = await discoverSocials(this.app);
    const section = parent.createDiv({ cls: "kd-section kd-growth" });
    const head = section.createDiv({ cls: "kd-section-head" });
    head.createSpan({ cls: "kd-section-label", text: "KOL GROWTH" });
    head.createSpan({ cls: "kd-section-count", text: `${socials.length}` });

    if (socials.length === 0) {
      const empty = section.createDiv({ cls: "kd-empty" });
      empty.createSpan({ text: "no platforms configured. add .md files to " });
      empty.createEl("code", { text: "_system/_kol-config/socials/" });
      empty.createSpan({ text: " with followers + goal-followers." });
      return;
    }

    const totalFollowers = socials.reduce((n, s) => n + (s.followers ?? 0), 0);
    const totalGoal = socials.reduce((n, s) => n + (s.goalFollowers ?? 0), 0);
    const roll = section.createDiv({ cls: "kd-growth-rollup" });
    const totalCard = (label: string, value: string) => {
      const c = roll.createDiv({ cls: "kd-growth-total" });
      c.createSpan({ cls: "kd-growth-total-value", text: value });
      c.createSpan({ cls: "kd-growth-total-label", text: label });
    };
    totalCard("total followers", formatNumber(totalFollowers));
    totalCard("total goal", totalGoal > 0 ? formatNumber(totalGoal) : "—");
    totalCard(
      "to goal",
      totalGoal > totalFollowers ? formatNumber(totalGoal - totalFollowers) : "reached",
    );

    const list = section.createDiv({ cls: "kd-growth-list" });
    for (const s of socials) this.renderGrowthRow(list, s);
  }

  private renderGrowthRow(parent: HTMLElement, s: Social) {
    const row = parent.createDiv({ cls: "kd-growth-row" });

    const head = row.createDiv({ cls: "kd-growth-row-head" });
    const name = head.createDiv({ cls: "kd-growth-name" });
    const platformEl = name.createSpan({ cls: "kd-growth-platform", text: s.platform.toUpperCase() });
    platformEl.addEventListener("click", () => this.app.workspace.openLinkText(s.path, "/", false));
    if (s.handle) name.createSpan({ cls: "kd-growth-handle", text: s.handle });

    const nums = head.createDiv({ cls: "kd-growth-nums" });
    const cur = s.followers ?? 0;
    if (s.followers === undefined) {
      nums.createSpan({ cls: "kd-growth-current kd-growth-missing", text: "no followers set" });
    } else {
      nums.createSpan({ cls: "kd-growth-current", text: formatNumber(cur) });
    }
    if (s.goalFollowers !== undefined) {
      nums.createSpan({ cls: "kd-growth-goal", text: `/ ${formatNumber(s.goalFollowers)}` });
    }

    if (s.goalFollowers !== undefined && s.goalFollowers > 0) {
      const pct = Math.max(0, Math.min(100, (cur / s.goalFollowers) * 100));
      const bar = row.createDiv({ cls: "kd-growth-bar" });
      const fill = bar.createDiv({ cls: "kd-growth-bar-fill" });
      fill.style.width = `${pct}%`;
      if (pct >= 100) fill.addClass("kd-growth-bar-done");
      const meta = row.createDiv({ cls: "kd-growth-meta" });
      meta.createSpan({ text: `${pct.toFixed(0)}%` });
      if (s.goalBy) meta.createSpan({ text: `by ${s.goalBy}` });
    } else {
      row.createDiv({
        cls: "kd-growth-meta kd-growth-no-goal",
        text: "set goal-followers to track progress",
      });
    }
  }

  /** LINKS tab: curated pillars + repos. */
  private async renderLinksTab(parent: HTMLElement) {
    const links = await discoverLinks(this.app);
    const section = parent.createDiv({ cls: "kd-section kd-links" });
    const head = section.createDiv({ cls: "kd-section-head" });
    head.createSpan({ cls: "kd-section-label", text: "KOL LINKS" });
    head.createSpan({ cls: "kd-section-count", text: `${links.length}` });

    if (links.length === 0) {
      const empty = section.createDiv({ cls: "kd-empty" });
      empty.createSpan({ text: "no links yet. add .md files to " });
      empty.createEl("code", { text: "_system/_kol-config/links/" });
      empty.createSpan({ text: " with frontmatter (url, group: pillar|repo, label, note)." });
      return;
    }

    this.renderLinkGroup(section, "PILLARS", links.filter((l) => l.group === "pillar"));
    this.renderLinkGroup(section, "REPOS", links.filter((l) => l.group === "repo"));
  }

  private renderLinkGroup(parent: HTMLElement, title: string, links: KolLink[]) {
    if (links.length === 0) return;
    const group = parent.createDiv({ cls: "kd-link-group" });
    group.createDiv({ cls: "kd-link-group-title", text: title });
    const grid = group.createDiv({ cls: "kd-link-grid" });
    for (const l of links) this.renderLinkCard(grid, l);
  }

  private renderLinkCard(parent: HTMLElement, l: KolLink) {
    const card = parent.createEl("a", { cls: "kd-link-card", href: l.url });
    card.setAttr("target", "_blank");
    card.setAttr("rel", "noopener");

    const cardHead = card.createDiv({ cls: "kd-link-card-head" });
    cardHead.createSpan({ cls: "kd-link-label", text: l.label });
    let host = l.url;
    try {
      host = new URL(l.url).hostname.replace(/^www\./, "");
    } catch {
      /* non-URL string — show as-is */
    }
    cardHead.createSpan({ cls: "kd-link-host", text: host });
    if (l.note) card.createDiv({ cls: "kd-link-note", text: l.note });
  }

  private renderMetrics(parent: HTMLElement, res: MetricsResult) {
    const grid = parent.createDiv({ cls: "kd-card-grid" });
    if (res.platforms.length === 0) {
      grid.createDiv({ cls: "kd-empty", text: "no platforms configured" });
      return;
    }
    for (const m of res.platforms) {
      this.renderMetricCard(grid, m);
    }
  }

  private renderMetricCard(parent: HTMLElement, m: PlatformMetric) {
    const card = parent.createDiv({ cls: `kd-card kd-card-${m.platform}` });

    const head = card.createDiv({ cls: "kd-card-head" });
    head.createSpan({ cls: "kd-card-label", text: m.label.toUpperCase() });
    const statusDot = head.createSpan({ cls: `kd-card-status kd-status-${m.status}` });
    statusDot.setAttr("aria-label", m.status);

    card.createDiv({ cls: "kd-card-value", text: formatValue(m.value, m.format, m.status) });

    const delta = card.createDiv({ cls: "kd-card-delta" });
    if (m.deltaPct !== undefined && m.status !== "offline") {
      const sign = m.deltaPct > 0 ? "▲" : m.deltaPct < 0 ? "▼" : "·";
      const cls = m.deltaPct > 0 ? "up" : m.deltaPct < 0 ? "down" : "flat";
      delta.addClass(`kd-delta-${cls}`);
      delta.setText(`${sign} ${Math.abs(m.deltaPct).toFixed(1)}%`);
    } else {
      delta.addClass("kd-delta-none");
      delta.setText(m.status === "offline" ? "offline" : "—");
    }
  }

  private renderLatest(parent: HTMLElement, res: MetricsResult) {
    if (!res.latest) return;
    const l = res.latest;
    const wrap = parent.createDiv({ cls: "kd-latest" });
    const head = wrap.createDiv({ cls: "kd-latest-head" });
    head.createSpan({ cls: "kd-latest-label", text: "LATEST UPLOAD" });
    if (l.ageLabel) head.createSpan({ cls: "kd-latest-age", text: l.ageLabel });

    const titleRow = wrap.createDiv({ cls: "kd-latest-title-row" });
    if (l.url) {
      const a = titleRow.createEl("a", { cls: "kd-latest-title", text: l.title, href: l.url });
      a.setAttr("target", "_blank");
    } else {
      titleRow.createSpan({ cls: "kd-latest-title", text: l.title });
    }

    const stats = wrap.createDiv({ cls: "kd-latest-stats" });
    if (l.views !== undefined) stats.createSpan({ text: `${formatNumber(l.views)} views` });
    if (l.likes !== undefined) stats.createSpan({ text: `${formatNumber(l.likes)} likes` });
    if (l.comments !== undefined) stats.createSpan({ text: `${formatNumber(l.comments)} comments` });
  }

  /** Top pages + top referrers, side by side, under the metric tiles. */
  private renderMetricLists(parent: HTMLElement, res: MetricsResult) {
    const pages = res.topPages ?? [];
    const refs = res.topReferrers ?? [];
    if (pages.length === 0 && refs.length === 0) return;

    const wrap = parent.createDiv({ cls: "kd-metric-lists" });
    const list = (title: string, items: MetricListItem[]) => {
      if (items.length === 0) return;
      const col = wrap.createDiv({ cls: "kd-metric-list" });
      col.createDiv({ cls: "kd-metric-list-title", text: title });
      for (const it of items) {
        const row = col.createDiv({ cls: "kd-metric-list-row" });
        row.createSpan({ cls: "kd-metric-list-label", text: it.label, attr: { title: it.label } });
        row.createSpan({ cls: "kd-metric-list-value", text: formatNumber(it.value) });
      }
    };
    list("TOP PAGES", pages);
    list("TOP REFERRERS", refs);
  }

  private renderTracks(parent: HTMLElement, tracks: Track[]) {
    const head = parent.createDiv({ cls: "kd-section-head" });
    head.createSpan({ cls: "kd-section-label", text: "KOL TRACKS" });
    head.createSpan({ cls: "kd-section-count", text: `${tracks.length}` });

    const tools = head.createDiv({ cls: "kd-toolbar" });
    this.renderNewProjectBtn(tools, tracks);
    this.renderManageBtn(tools);
    this.renderLayoutToggle(tools);

    if (tracks.length === 0) {
      const empty = parent.createDiv({ cls: "kd-empty" });
      empty.createSpan({ text: "no tracks marked. add " });
      empty.createEl("code", { text: "dashboard: true" });
      empty.createSpan({ text: " to a folder's INDEX.md frontmatter." });
      return;
    }

    const grid = parent.createDiv({ cls: `kd-track-grid kd-track-grid-${this.plugin.settings.trackLayout}` });
    for (const t of tracks) {
      this.renderTrack(grid, t);
    }
  }

  private renderNewProjectBtn(parent: HTMLElement, tracks: Track[]) {
    const btn = parent.createEl("button", { cls: "kd-toolbar-btn kd-new-project-btn" });
    setIcon(btn, "plus");
    btn.createSpan({ text: "NEW PROJECT", cls: "kd-toolbar-btn-label" });
    btn.addEventListener("click", () => {
      runNewProjectFlow(this.app, tracks, () => this.refreshTracks());
    });
  }

  private renderManageBtn(parent: HTMLElement) {
    const btn = parent.createEl("button", { cls: "kd-toolbar-btn" });
    setIcon(btn, "settings-2");
    btn.createSpan({ text: "MANAGE", cls: "kd-toolbar-btn-label" });
    btn.addEventListener("click", () => {
      new ManageModal(this.app, () => this.refreshTracks()).open();
    });
  }

  private renderLayoutToggle(parent: HTMLElement) {
    const toggle = parent.createDiv({ cls: "kd-layout-toggle" });
    const make = (mode: "list" | "grid", icon: string, label: string) => {
      const btn = toggle.createEl("button", {
        cls: "kd-layout-btn",
        attr: { "aria-label": label, "data-mode": mode },
      });
      setIcon(btn, icon);
      if (this.plugin.settings.trackLayout === mode) btn.addClass("kd-layout-active");
      btn.addEventListener("click", async () => {
        if (this.plugin.settings.trackLayout === mode) return;
        this.plugin.settings.trackLayout = mode;
        await this.plugin.saveSettings();
        // Class swap only — no re-render needed.
        const grid = this.tracksContainer?.querySelector(".kd-track-grid");
        if (grid) {
          grid.classList.remove("kd-track-grid-list", "kd-track-grid-grid");
          grid.classList.add(`kd-track-grid-${mode}`);
        }
        toggle.querySelectorAll(".kd-layout-btn").forEach((b) => b.removeClass("kd-layout-active"));
        btn.addClass("kd-layout-active");
      });
    };
    make("list", "list", "List view");
    make("grid", "layout-grid", "Grid view");
  }

  private renderTrack(parent: HTMLElement, t: Track) {
    const block = parent.createDiv({ cls: "kd-track" });

    const header = block.createDiv({ cls: "kd-track-head" });
    const nameEl = header.createSpan({ cls: "kd-track-name", text: t.name });
    nameEl.addEventListener("click", () => {
      this.app.workspace.openLinkText(t.markerFile, "/", false);
    });

    const flipBtn = header.createEl("button", { cls: "kd-track-flip", attr: { "aria-label": `Flip ${t.name} card` } });
    setIcon(flipBtn, "info");
    flipBtn.addEventListener("click", (e) => {
      e.stopPropagation();
      this.flipTrack(block, t);
    });
    const counts = header.createDiv({ cls: "kd-track-counts" });
    counts.createSpan({ cls: "kd-count-projects", text: `${t.projects.length} projects` });
    const trackTodoEl = counts.createSpan({ cls: "kd-count-todo", text: `${t.todoCount}T` });
    const trackDoingEl = counts.createSpan({ cls: "kd-count-doing", text: `${t.doingCount}I` });
    const trackDoneEl = counts.createSpan({ cls: "kd-count-done", text: `${t.doneCount}D` });
    counts.createSpan({ cls: "kd-track-age", text: ageLabel(t.lastModified) });

    const trackRefs: CountRefs = {
      todoEl: trackTodoEl,
      doingEl: trackDoingEl,
      doneEl: trackDoneEl,
      todo: t.todoCount,
      doing: t.doingCount,
      done: t.doneCount,
    };

    const addBtn = header.createEl("button", { cls: "kd-track-add", attr: { "aria-label": `New project in ${t.name}` } });
    setIcon(addBtn, "plus");
    addBtn.addEventListener("click", (e) => {
      e.stopPropagation();
      this.promptNewProjectInTrack(t);
    });

    const visible = t.projects.filter((p) => p.status !== "done");
    const front = block.createDiv({ cls: "kd-track-front" });

    if (visible.length === 0) {
      const hint = t.projects.length === 0
        ? `no projects in ${t.name}/projects/`
        : `all ${t.projects.length} projects done — see MANAGE to view`;
      front.createDiv({ cls: "kd-empty kd-track-empty", text: hint });
      return;
    }

    const list = front.createDiv({ cls: "kd-project-list" });
    for (const p of visible) {
      this.renderProject(list, p, trackRefs);
    }
  }

  private renderAddTaskFooter(parent: HTMLElement, p: Project) {
    const footer = parent.createDiv({ cls: "kd-add-task-footer" });
    const trigger = footer.createDiv({ cls: "kd-add-task-trigger" });
    const triggerLabel = p.tasks.length === 0 ? "+ Add the first task" : "+ Add task";
    trigger.createSpan({ text: triggerLabel });

    const editor = footer.createDiv({ cls: "kd-add-task-editor" });
    const input = editor.createEl("input", { type: "text", cls: "kd-add-task-input" });
    input.placeholder = "task text (optional: 📅 YYYY-MM-DD or (due: YYYY-MM-DD))";

    const open = () => {
      footer.addClass("kd-add-task-open");
      input.value = "";
      window.setTimeout(() => input.focus(), 0);
    };
    const close = () => {
      footer.removeClass("kd-add-task-open");
      input.value = "";
    };
    const submit = async () => {
      const text = input.value.trim();
      if (!text) {
        close();
        return;
      }
      try {
        await addTaskToProject(this.app, p, text);
        await this.refreshTracks();
      } catch (err) {
        new Notice(`failed: ${(err as Error).message}`);
      }
    };

    trigger.addEventListener("click", (e) => {
      e.stopPropagation();
      open();
    });
    input.addEventListener("keydown", (e) => {
      if (e.key === "Enter") {
        e.preventDefault();
        submit();
      } else if (e.key === "Escape") {
        e.preventDefault();
        close();
      }
    });
    input.addEventListener("blur", () => {
      // Close empty input on blur; non-empty stays open in case of accidental click-away.
      if (!input.value.trim()) close();
    });
  }

  private renderSocials(parent: HTMLElement, socials: Social[]) {
    const head = parent.createDiv({ cls: "kd-section-head" });
    head.createSpan({ cls: "kd-section-label", text: "KOL SOCIALS" });
    head.createSpan({ cls: "kd-section-count", text: `${socials.length}` });

    if (socials.length === 0) {
      const empty = parent.createDiv({ cls: "kd-empty" });
      empty.createSpan({ text: "no platforms configured. add .md files to " });
      empty.createEl("code", { text: "_system/_kol-config/socials/" });
      empty.createSpan({ text: " with frontmatter (platform, handle, goal-cadence, last-shared, followers)." });
      return;
    }

    const grid = parent.createDiv({ cls: "kd-social-grid" });
    for (const s of socials) {
      this.renderSocialCard(grid, s);
    }
  }

  private renderSocialCard(parent: HTMLElement, s: Social) {
    const card = parent.createDiv({ cls: `kd-social-card${s.overdue ? " kd-social-overdue" : ""}` });

    const head = card.createDiv({ cls: "kd-social-head" });
    const platformEl = head.createSpan({ cls: "kd-social-platform", text: s.platform.toUpperCase() });
    platformEl.addEventListener("click", () => {
      this.app.workspace.openLinkText(s.path, "/", false);
    });
    if (s.handle) head.createSpan({ cls: "kd-social-handle", text: s.handle });

    const stats = card.createDiv({ cls: "kd-social-stats" });
    if (s.followers !== undefined) {
      const f = stats.createDiv({ cls: "kd-social-followers" });
      f.createSpan({ cls: "kd-social-followers-value", text: formatNumber(s.followers) });
      f.createSpan({ cls: "kd-social-followers-label", text: "followers" });
    }

    const cadenceRow = card.createDiv({ cls: "kd-social-cadence" });
    if (s.goalCadence) {
      cadenceRow.createSpan({ cls: "kd-social-target", text: `target ${s.goalCadence}` });
    } else {
      cadenceRow.createSpan({ cls: "kd-social-target kd-social-no-target", text: "no cadence set" });
    }
    if (s.daysSinceLastShare !== undefined) {
      const sinceText = s.daysSinceLastShare === 0
        ? "shared today"
        : `${s.daysSinceLastShare}d since last share`;
      cadenceRow.createSpan({ cls: "kd-social-since", text: sinceText });
    } else {
      cadenceRow.createSpan({ cls: "kd-social-since kd-social-never", text: "never logged" });
    }

    const actions = card.createDiv({ cls: "kd-social-actions" });
    const logBtn = actions.createEl("button", { cls: "kd-social-log-btn", text: "+ log share" });
    logBtn.addEventListener("click", (e) => {
      e.stopPropagation();
      new LogShareModal(this.app, s, async (note) => {
        try {
          await logShare(this.app, s, note);
          new Notice(`logged share to ${s.platform}`);
          await this.refreshSocials();
        } catch (err) {
          new Notice(`failed: ${(err as Error).message}`);
        }
      }).open();
    });
  }

  private renderWeek(parent: HTMLElement, week: WeekDay[]) {
    const head = parent.createDiv({ cls: "kd-section-head" });
    head.createSpan({ cls: "kd-section-label", text: "KOL WEEK" });
    head.createSpan({ cls: "kd-section-count", text: `${countReminders(week)}` });
    const range = week.length > 0
      ? `${formatDayLabel(week[0].date)} → ${formatDayLabel(week[6].date)}`
      : "";
    if (range) head.createSpan({ cls: "kd-week-range", text: range });

    const tools = head.createDiv({ cls: "kd-toolbar" });
    this.renderWeekLayoutToggle(tools, week);

    const list = parent.createDiv({ cls: `kd-week-list kd-week-${this.plugin.settings.weekLayout}` });
    for (const day of week) {
      this.renderWeekDay(list, day);
    }
  }

  private renderWeekLayoutToggle(parent: HTMLElement, week: WeekDay[]) {
    const toggle = parent.createDiv({ cls: "kd-layout-toggle" });
    const make = (mode: "horizontal" | "vertical", icon: string, label: string) => {
      const btn = toggle.createEl("button", {
        cls: "kd-layout-btn",
        attr: { "aria-label": label, "data-mode": mode },
      });
      setIcon(btn, icon);
      if (this.plugin.settings.weekLayout === mode) btn.addClass("kd-layout-active");
      btn.addEventListener("click", async () => {
        if (this.plugin.settings.weekLayout === mode) return;
        this.plugin.settings.weekLayout = mode;
        await this.plugin.saveSettings();
        const list = this.weekContainer?.querySelector(".kd-week-list");
        if (list) {
          list.classList.remove("kd-week-horizontal", "kd-week-vertical");
          list.classList.add(`kd-week-${mode}`);
        }
        toggle.querySelectorAll(".kd-layout-btn").forEach((b) => b.removeClass("kd-layout-active"));
        btn.addClass("kd-layout-active");
        void week;
      });
    };
    make("horizontal", "columns-3", "Horizontal week");
    make("vertical", "list", "Vertical week");
  }

  private renderWeekDay(parent: HTMLElement, day: WeekDay) {
    const row = parent.createDiv({
      cls: `kd-week-day${day.isToday ? " kd-week-today" : ""}${day.isPast && !day.isToday ? " kd-week-past" : ""}`,
    });
    const label = row.createDiv({ cls: "kd-week-label" });
    label.createSpan({ cls: "kd-week-name", text: day.dayName });
    label.createSpan({ cls: "kd-week-date", text: formatDayLabel(day.date) });
    this.renderDayActions(label, day);

    const items = row.createDiv({ cls: "kd-week-reminders" });
    const total = day.reminders.length + day.manualReminders.length + day.notes.length;
    if (total === 0) {
      items.createSpan({ cls: "kd-week-empty", text: day.isToday ? "— nothing planned" : "—" });
      return;
    }
    for (const r of day.reminders) this.renderReminderPill(items, r);
    day.manualReminders.forEach((text, i) =>
      this.renderManualPill(items, day.date, "reminders", i, text),
    );
    day.notes.forEach((text, i) =>
      this.renderManualPill(items, day.date, "notes", i, text),
    );
  }

  /** Hover-revealed per-day action bar: log post · reminder · note. */
  private renderDayActions(parent: HTMLElement, day: WeekDay) {
    const bar = parent.createDiv({ cls: "kd-week-actions" });
    const mk = (icon: string, label: string, onClick: () => void) => {
      const b = bar.createEl("button", {
        cls: "kd-week-action-btn",
        attr: { "aria-label": label, title: label },
      });
      setIcon(b, icon);
      b.addEventListener("click", (e) => {
        e.stopPropagation();
        onClick();
      });
    };
    mk("send", "Log social post", () => void this.openLogPost(day));
    mk("bell", "Add reminder", () => {
      new TextPromptModal(
        this.app,
        `Reminder — ${formatDayLabel(day.date)}`,
        "reminder text",
        (text) => void this.addWeekEntry(day.date, "reminders", text),
      ).open();
    });
    mk("pencil", "Add note", () => {
      new TextPromptModal(
        this.app,
        `Note — ${formatDayLabel(day.date)}`,
        "note text",
        (text) => void this.addWeekEntry(day.date, "notes", text),
      ).open();
    });
  }

  private async openLogPost(day: WeekDay) {
    const socials = await discoverSocials(this.app);
    new LogPostModal(this.app, socials, formatDayLabel(day.date), async (social, note) => {
      try {
        await logShare(this.app, social, note);
        new Notice(`logged post to ${social.platform}`);
        await this.refreshWeek();
        await this.refreshSocials();
      } catch (err) {
        new Notice(`failed: ${(err as Error).message}`);
      }
    }).open();
  }

  private async addWeekEntry(date: string, kind: "reminders" | "notes", text: string) {
    const entries = this.plugin.settings.weekEntries;
    const e = (entries[date] ||= { reminders: [], notes: [] });
    if (!Array.isArray(e.reminders)) e.reminders = [];
    if (!Array.isArray(e.notes)) e.notes = [];
    e[kind].push(text);
    await this.plugin.saveSettings();
    await this.refreshWeek();
  }

  private async removeWeekEntry(date: string, kind: "reminders" | "notes", index: number) {
    const e = this.plugin.settings.weekEntries[date];
    if (!e || !Array.isArray(e[kind])) return;
    e[kind].splice(index, 1);
    if ((e.reminders?.length ?? 0) === 0 && (e.notes?.length ?? 0) === 0) {
      delete this.plugin.settings.weekEntries[date];
    }
    await this.plugin.saveSettings();
    await this.refreshWeek();
  }

  private renderManualPill(
    parent: HTMLElement,
    date: string,
    kind: "reminders" | "notes",
    index: number,
    text: string,
  ) {
    const pill = parent.createDiv({
      cls: `kd-reminder kd-week-${kind === "notes" ? "note" : "reminder-manual"}`,
      attr: { title: text },
    });
    pill.createSpan({ cls: "kd-reminder-dot" });
    pill.createSpan({ cls: "kd-week-entry-text", text });
    const del = pill.createSpan({ cls: "kd-week-entry-del", attr: { "aria-label": "remove" } });
    setIcon(del, "x");
    del.addEventListener("click", (e) => {
      e.stopPropagation();
      void this.removeWeekEntry(date, kind, index);
    });
  }

  private renderReminderPill(parent: HTMLElement, r: ShareReminder) {
    const pill = parent.createDiv({
      cls: "kd-reminder kd-reminder-due",
      attr: { title: `${r.platform}${r.handle ? ` (${r.handle})` : ""} — due · click to log` },
    });
    pill.createSpan({ cls: "kd-reminder-dot" });
    pill.createSpan({ cls: "kd-reminder-platform", text: r.platform });

    pill.addEventListener("click", async () => {
      const socials = await discoverSocials(this.app);
      const social = socials.find((s) => s.path === r.socialPath);
      if (!social) {
        new Notice(`platform file missing: ${r.platform}`);
        return;
      }
      new LogShareModal(this.app, social, async (note) => {
        try {
          await logShare(this.app, social, note);
          new Notice(`logged share to ${social.platform}`);
          await this.refreshWeek();
          await this.refreshSocials();
        } catch (err) {
          new Notice(`failed: ${(err as Error).message}`);
        }
      }).open();
    });
  }

  private renderPinned(parent: HTMLElement, items: PinnedItem[]) {
    const head = parent.createDiv({ cls: "kd-section-head" });
    head.createSpan({ cls: "kd-section-label", text: "KOL PINNED" });
    head.createSpan({ cls: "kd-section-count", text: `${items.length}` });

    const tools = head.createDiv({ cls: "kd-toolbar" });
    const pinBtn = tools.createEl("button", { cls: "kd-toolbar-btn" });
    setIcon(pinBtn, "plus");
    pinBtn.createSpan({ text: "PIN FILE", cls: "kd-toolbar-btn-label" });
    pinBtn.addEventListener("click", () => {
      const excluded = new Set(items.map((i) => i.path));
      runPinFileFlow(this.app, excluded, () => this.refreshPinned());
    });

    if (items.length === 0) {
      const empty = parent.createDiv({ cls: "kd-empty" });
      empty.createSpan({ text: "no pinned files. click " });
      empty.createEl("code", { text: "+ PIN FILE" });
      empty.createSpan({ text: " to pick one, or add " });
      empty.createEl("code", { text: "pinned: true" });
      empty.createSpan({ text: " to any file's frontmatter directly." });
      return;
    }

    const grid = parent.createDiv({ cls: "kd-pinned-grid" });
    for (const item of items) {
      this.renderPinnedCard(grid, item);
    }
  }

  private renderPinnedCard(parent: HTMLElement, item: PinnedItem) {
    const card = parent.createDiv({ cls: "kd-pinned-card" });

    const head = card.createDiv({ cls: "kd-pinned-head" });
    const titleEl = head.createSpan({ cls: "kd-pinned-title", text: item.title });
    titleEl.addEventListener("click", () => {
      this.app.workspace.openLinkText(item.path, "/", false);
    });

    const unpinBtn = head.createEl("button", {
      cls: "kd-pinned-unpin",
      attr: { "aria-label": "Unpin", title: "Unpin" },
    });
    setIcon(unpinBtn, "pin-off");
    unpinBtn.addEventListener("click", async (e) => {
      e.stopPropagation();
      try {
        await unpinItem(this.app, item);
        new Notice(`unpinned ${item.title}`);
        await this.refreshPinned();
      } catch (err) {
        new Notice(`failed: ${(err as Error).message}`);
      }
    });

    if (item.description) {
      card.createDiv({ cls: "kd-pinned-desc", text: item.description });
    }

    if (item.tags.length > 0) {
      const tags = card.createDiv({ cls: "kd-pinned-tags" });
      for (const t of item.tags.slice(0, 3)) {
        tags.createSpan({ cls: "kd-pinned-tag", text: `#${t}` });
      }
    }
  }

  private async flipTrack(block: HTMLElement, t: Track) {
    const flipped = block.hasClass("kd-track-flipped");
    if (flipped) {
      block.removeClass("kd-track-flipped");
      return;
    }

    // Build the back face once on first flip.
    let back = block.querySelector(".kd-track-back") as HTMLElement | null;
    if (!back) {
      back = block.createDiv({ cls: "kd-track-back" });
      const file = this.app.vault.getAbstractFileByPath(t.markerFile);
      if (file instanceof TFile) {
        try {
          const content = await this.app.vault.cachedRead(file);
          const body = content.replace(/^---\n[\s\S]*?\n---\n?/, "").trim();
          if (body) {
            await MarkdownRenderer.render(this.app, body, back, t.markerFile, this);
          } else {
            back.createDiv({ cls: "kd-empty", text: `no description in ${t.name}/INDEX.md` });
          }
        } catch (err) {
          back.createDiv({ cls: "kd-empty", text: `failed to read INDEX: ${(err as Error).message}` });
        }
      } else {
        back.createDiv({ cls: "kd-empty", text: "marker file not found" });
      }
    }
    block.addClass("kd-track-flipped");
  }

  private async promptNewProjectInTrack(track: Track) {
    const { ProjectNameModal } = await import("./modals");
    new ProjectNameModal(this.app, track, async (name) => {
      const { createProject } = await import("./tracks");
      try {
        await createProject(this.app, track, name);
        await this.refreshTracks();
      } catch (err) {
        new Notice(`failed: ${(err as Error).message}`);
      }
    }).open();
  }

  private renderProject(parent: HTMLElement, p: Project, trackRefs: CountRefs) {
    const wrap = parent.createDiv({ cls: `kd-project kd-project-status-${p.status}` });
    const expanded = this.expandedProjects.has(p.path);
    if (expanded) wrap.addClass("kd-project-expanded");

    const row = wrap.createDiv({ cls: "kd-project-row" });
    const chev = row.createSpan({ cls: "kd-project-chev", text: expanded ? "▾" : "▸" });

    const statusBadge = row.createSpan({
      cls: `kd-project-status kd-project-status-${p.status}`,
      text: STATUS_GLYPH[p.status],
      attr: { "aria-label": `status: ${STATUS_LABEL[p.status]} (click to cycle)`, title: STATUS_LABEL[p.status] },
    });
    statusBadge.addEventListener("click", async (e) => {
      e.stopPropagation();
      try {
        const next = nextStatus(p.status);
        await setProjectStatus(this.app, p, next);
        // Status change DOES alter sort group — full refresh is the right call here.
        await this.refreshTracks();
      } catch (err) {
        new Notice(`Status cycle failed: ${(err as Error).message}`);
      }
    });

    const name = row.createSpan({ cls: "kd-project-name", text: p.name });
    const meta = row.createDiv({ cls: "kd-project-meta" });
    const projTodoEl = meta.createSpan({ cls: "kd-count-todo", text: `${p.todoCount}T` });
    const projDoingEl = meta.createSpan({ cls: "kd-count-doing", text: `${p.doingCount}I` });
    const projDoneEl = meta.createSpan({ cls: "kd-count-done", text: `${p.doneCount}D` });

    const projectRefs: CountRefs = {
      todoEl: projTodoEl,
      doingEl: projDoingEl,
      doneEl: projDoneEl,
      todo: p.todoCount,
      doing: p.doingCount,
      done: p.doneCount,
    };

    // Always render the task list, hidden via class when collapsed.
    const taskList = wrap.createDiv({ cls: "kd-task-list" });
    for (const task of p.tasks) {
      this.renderTaskRow(taskList, task, projectRefs, trackRefs);
    }
    this.renderAddTaskFooter(taskList, p);

    row.addEventListener("click", (e) => {
      const target = e.target as HTMLElement;
      if (target === name) {
        this.app.workspace.openLinkText(p.path, "/", false);
        return;
      }
      const nowExpanded = !wrap.hasClass("kd-project-expanded");
      wrap.toggleClass("kd-project-expanded", nowExpanded);
      chev.setText(nowExpanded ? "▾" : "▸");
      if (nowExpanded) this.expandedProjects.add(p.path);
      else this.expandedProjects.delete(p.path);
    });
  }

  private renderTaskRow(parent: HTMLElement, task: Task, projectRefs: CountRefs, trackRefs: CountRefs) {
    const row = parent.createDiv({ cls: `kd-task-row kd-task-${task.state}` });
    const cb = row.createSpan({ cls: "kd-task-cb", text: CB_GLYPH[task.state] });

    row.createSpan({ cls: "kd-task-text", text: task.text });

    const meta = row.createDiv({ cls: "kd-task-meta" });
    let dueEl: HTMLElement | null = null;
    if (task.due) {
      dueEl = meta.createSpan({ cls: "kd-task-due", text: task.due });
      if (task.state !== "done" && task.due < new Date().toISOString().slice(0, 10)) {
        dueEl.addClass("kd-task-overdue");
      }
    }

    cb.addEventListener("click", async (e) => {
      e.stopPropagation();
      try {
        const newState = await cycleTaskState(this.app, task);
        // Update DOM in place — no full re-render, no flicker, no movement.
        row.removeClass(`kd-task-${task.state}`);
        row.addClass(`kd-task-${newState}`);
        cb.setText(CB_GLYPH[newState]);
        adjustCounts(projectRefs, task.state, newState);
        adjustCounts(trackRefs, task.state, newState);
        if (dueEl) {
          const overdue = newState !== "done" && task.due! < new Date().toISOString().slice(0, 10);
          dueEl.toggleClass("kd-task-overdue", overdue);
        }
        task.state = newState;
      } catch (err) {
        new Notice(`Cycle failed: ${(err as Error).message}`);
      }
    });
  }
}
