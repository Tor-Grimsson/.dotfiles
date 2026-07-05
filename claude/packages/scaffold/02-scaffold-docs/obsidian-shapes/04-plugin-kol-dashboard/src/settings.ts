import { App, PluginSettingTab, Setting } from "obsidian";
import type KolDashboardPlugin from "./main";
import type { InboxColumn } from "./inbox";

export type TrackLayout = "list" | "grid";
export type WeekLayout = "horizontal" | "vertical";
export type TabId = "work" | "studio" | "growth" | "links" | "pinned" | "inbox" | "calendar";

/** Manual entries the user pins to a specific day in the week view. */
export interface WeekEntry {
  reminders: string[];
  notes: string[];
}

export interface KolDashboardSettings {
  umamiUrl: string;
  umamiWebsiteId: string;
  umamiUsername: string;
  umamiPassword: string;
  refreshIntervalMin: number;
  showMetrics: boolean;
  showProjects: boolean;
  trackLayout: TrackLayout;
  weekLayout: WeekLayout;
  activeTab: TabId;
  /** Keyed by ISO date (YYYY-MM-DD). */
  weekEntries: Record<string, WeekEntry>;
  /** Vault-relative path to the kol-capture inbox the INBOX tab triages. */
  inboxPath: string;
  /** Kanban column per inbox card, keyed by the card's raw markdown line. */
  inboxState: Record<string, InboxColumn>;
  /** Days ahead the CALENDAR tab pulls from gcalcli. */
  calendarDays: number;
}

export const DEFAULT_SETTINGS: KolDashboardSettings = {
  umamiUrl: "https://kol-umami.vercel.app",
  umamiWebsiteId: "fcd04534-5dcd-44a3-b7b1-256cbdf49ab9",
  umamiUsername: "",
  umamiPassword: "",
  refreshIntervalMin: 30,
  showMetrics: true,
  showProjects: true,
  trackLayout: "list",
  weekLayout: "horizontal",
  activeTab: "work",
  weekEntries: {},
  inboxPath: "kol-inbox/inbox.md",
  inboxState: {},
  calendarDays: 30,
};

export class KolDashboardSettingsTab extends PluginSettingTab {
  plugin: KolDashboardPlugin;

  constructor(app: App, plugin: KolDashboardPlugin) {
    super(app, plugin);
    this.plugin = plugin;
  }

  display(): void {
    const { containerEl } = this;
    containerEl.empty();

    containerEl.createEl("h2", { text: "KOL Dashboard" });

    containerEl.createEl("h3", { text: "Umami metrics" });
    containerEl.createEl("p", {
      text: "Self-hosted Umami v3 has no API token UI. The plugin logs in with your account, caches the bearer token locally, and refreshes on 401. Credentials stay in this device's plugin data — never in the vault.",
      cls: "setting-item-description",
    });

    new Setting(containerEl)
      .setName("Umami URL")
      .setDesc("Base URL of your Umami instance (no trailing slash).")
      .addText((text) =>
        text
          .setPlaceholder("https://kol-umami.vercel.app")
          .setValue(this.plugin.settings.umamiUrl)
          .onChange(async (value) => {
            this.plugin.settings.umamiUrl = value.trim();
            await this.plugin.saveSettings();
          }),
      );

    new Setting(containerEl)
      .setName("Website ID")
      .setDesc("Umami website ID (UUID).")
      .addText((text) =>
        text
          .setPlaceholder("fcd04534-5dcd-44a3-b7b1-256cbdf49ab9")
          .setValue(this.plugin.settings.umamiWebsiteId)
          .onChange(async (value) => {
            this.plugin.settings.umamiWebsiteId = value.trim();
            await this.plugin.saveSettings();
          }),
      );

    new Setting(containerEl)
      .setName("Username")
      .addText((text) =>
        text
          .setValue(this.plugin.settings.umamiUsername)
          .onChange(async (value) => {
            this.plugin.settings.umamiUsername = value.trim();
            await this.plugin.saveSettings();
          }),
      );

    new Setting(containerEl)
      .setName("Password")
      .setDesc("Stored locally in plugin data; never written to the vault.")
      .addText((text) => {
        text.inputEl.type = "password";
        text.inputEl.autocomplete = "new-password";
        text
          .setValue(this.plugin.settings.umamiPassword)
          .onChange(async (value) => {
            this.plugin.settings.umamiPassword = value;
            await this.plugin.saveSettings();
          });
      });

    containerEl.createEl("h3", { text: "Vault" });

    new Setting(containerEl)
      .setName("Refresh interval (minutes)")
      .setDesc("How often to refetch metrics. Set to 0 to disable auto-refresh.")
      .addText((text) =>
        text
          .setPlaceholder("30")
          .setValue(String(this.plugin.settings.refreshIntervalMin))
          .onChange(async (value) => {
            const n = parseInt(value, 10);
            this.plugin.settings.refreshIntervalMin = Number.isFinite(n) && n >= 0 ? n : 30;
            await this.plugin.saveSettings();
          }),
      );

    containerEl.createEl("p", {
      text: "Projects are discovered by frontmatter — add `dashboard: true` to a folder's INDEX.md (or matching folder-note) to surface it. Tasks come from `- [ ]` checkboxes inside active project folders only.",
      cls: "setting-item-description",
    });

    containerEl.createEl("h3", { text: "Sections" });

    new Setting(containerEl)
      .setName("Show metrics")
      .addToggle((t) =>
        t.setValue(this.plugin.settings.showMetrics).onChange(async (v) => {
          this.plugin.settings.showMetrics = v;
          await this.plugin.saveSettings();
        }),
      );

    new Setting(containerEl)
      .setName("Show tracks")
      .addToggle((t) =>
        t.setValue(this.plugin.settings.showProjects).onChange(async (v) => {
          this.plugin.settings.showProjects = v;
          await this.plugin.saveSettings();
        }),
      );
  }
}
