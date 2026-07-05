import { App, TFile } from "obsidian";

export type TaskState = "todo" | "doing" | "done";

export interface Task {
  text: string;
  state: TaskState;
  filePath: string;
  line: number;
  due?: string;
}

const TASK_RE = /^(\s*[-*+]\s+\[)([ /xX])(\]\s+)(.+?)\s*$/;
const DUE_RE = /(?:📅\s*|\(due:\s*)(\d{4}-\d{2}-\d{2})\)?/;

export function parseTasks(filePath: string, content: string): Task[] {
  const out: Task[] = [];
  const lines = content.split("\n");
  for (let i = 0; i < lines.length; i++) {
    const m = lines[i].match(TASK_RE);
    if (!m) continue;
    const state = charToState(m[2]);
    const rawText = m[4].trim();
    const due = (rawText.match(DUE_RE) || [])[1];
    out.push({
      text: rawText.replace(DUE_RE, "").trim(),
      state,
      filePath,
      line: i,
      due,
    });
  }
  return out;
}

function charToState(c: string): TaskState {
  if (c === "x" || c === "X") return "done";
  if (c === "/") return "doing";
  return "todo";
}

function stateToChar(s: TaskState): string {
  if (s === "done") return "x";
  if (s === "doing") return "/";
  return " ";
}

export function nextState(s: TaskState): TaskState {
  if (s === "todo") return "doing";
  if (s === "doing") return "done";
  return "todo";
}

export async function cycleTaskState(app: App, task: Task): Promise<TaskState> {
  const file = app.vault.getAbstractFileByPath(task.filePath);
  if (!(file instanceof TFile)) throw new Error(`task file missing: ${task.filePath}`);
  const target = nextState(task.state);
  await app.vault.process(file, (content) => {
    const lines = content.split("\n");
    const line = lines[task.line];
    if (line === undefined) return content;
    const replaced = line.replace(TASK_RE, (_m, p1, _box, p3, body) => {
      return `${p1}${stateToChar(target)}${p3}${body}`;
    });
    lines[task.line] = replaced;
    return lines.join("\n");
  });
  return target;
}

export function sortByDue(tasks: Task[]): Task[] {
  return [...tasks].sort((a, b) => {
    if (a.due && b.due) return a.due.localeCompare(b.due);
    if (a.due) return -1;
    if (b.due) return 1;
    return a.text.localeCompare(b.text);
  });
}
