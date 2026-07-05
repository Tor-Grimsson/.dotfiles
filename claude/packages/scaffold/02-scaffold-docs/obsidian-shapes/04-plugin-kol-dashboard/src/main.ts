import { Plugin, WorkspaceLeaf } from "obsidian";
import { DashboardView, VIEW_TYPE_DASHBOARD } from "./view";
import { DEFAULT_SETTINGS, KolDashboardSettings, KolDashboardSettingsTab } from "./settings";
import { discoverTracks } from "./tracks";
import { runNewProjectFlow } from "./modals";

export default class KolDashboardPlugin extends Plugin {
  settings!: KolDashboardSettings;

  async onload() {
    await this.loadSettings();

    this.registerView(
      VIEW_TYPE_DASHBOARD,
      (leaf) => new DashboardView(leaf, this),
    );

    this.addRibbonIcon("activity", "Open KOL Dashboard", () => {
      this.activateView();
    });

    this.addCommand({
      id: "open-kol-dashboard",
      name: "Open KOL Dashboard",
      callback: () => this.activateView(),
    });

    this.addCommand({
      id: "refresh-kol-dashboard",
      name: "Refresh KOL Dashboard",
      callback: () => this.refreshAllDashboards(),
    });

    this.addCommand({
      id: "new-project",
      name: "New project",
      callback: async () => {
        const tracks = await discoverTracks(this.app);
        runNewProjectFlow(this.app, tracks, () => this.refreshAllDashboards());
      },
    });

    this.addSettingTab(new KolDashboardSettingsTab(this.app, this));
  }

  onunload() {
    // Obsidian docs: don't manually detach leaves on unload.
  }

  async loadSettings() {
    this.settings = Object.assign({}, DEFAULT_SETTINGS, await this.loadData());
  }

  async saveSettings() {
    await this.saveData(this.settings);
  }

  refreshAllDashboards() {
    this.app.workspace.getLeavesOfType(VIEW_TYPE_DASHBOARD).forEach((leaf) => {
      const view = leaf.view as DashboardView;
      view.refresh();
    });
  }

  async activateView() {
    const { workspace } = this.app;
    let leaf: WorkspaceLeaf | null = null;
    const leaves = workspace.getLeavesOfType(VIEW_TYPE_DASHBOARD);
    if (leaves.length > 0) {
      leaf = leaves[0];
    } else {
      leaf = workspace.getLeaf("tab");
      await leaf.setViewState({ type: VIEW_TYPE_DASHBOARD, active: true });
    }
    workspace.revealLeaf(leaf);
  }
}
