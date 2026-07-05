import { execFile } from "child_process";

export interface CalEvent {
  date: string;   // YYYY-MM-DD
  time: string;   // HH:MM or "" for all-day
  title: string;
}

export interface CalResult {
  events: CalEvent[];
  error?: string;
}

/** Run gcalcli through a login shell so it gets the brew PATH + its OAuth config.
 *  Desktop only — child_process is unavailable on Obsidian mobile. */
function gcalcli(argline: string): Promise<string> {
  return new Promise((resolve, reject) => {
    execFile(
      "zsh",
      ["-lc", `gcalcli ${argline}`],
      { timeout: 15000, maxBuffer: 4 * 1024 * 1024 },
      (err, stdout, stderr) => {
        if (err) reject(new Error((stderr || "").trim() || (err as Error).message));
        else resolve(stdout);
      },
    );
  });
}

/** Agenda for `days` ahead, parsed from gcalcli's `--tsv` (header + tab rows). */
export async function fetchAgenda(days: number): Promise<CalResult> {
  try {
    const out = await gcalcli(`agenda today "+${days} days" --tsv --military`);
    const lines = out.split("\n").filter((l) => l.includes("\t"));
    const events: CalEvent[] = [];
    for (const line of lines) {
      const c = line.split("\t");
      if (c[0] === "start_date") continue; // header
      if (!c[0]) continue;
      events.push({ date: c[0], time: c[1] || "", title: (c[4] ?? "").trim() });
    }
    return { events };
  } catch (e) {
    return { events: [], error: (e as Error).message };
  }
}

/** Quick-add an event via natural language (`gcalcli quick "…"`). */
export async function quickAdd(text: string): Promise<void> {
  // single-quote-safe: gcalcli quick '<text>' with internal quotes escaped
  const safe = text.replace(/'/g, `'\\''`);
  await gcalcli(`quick '${safe}'`);
}
