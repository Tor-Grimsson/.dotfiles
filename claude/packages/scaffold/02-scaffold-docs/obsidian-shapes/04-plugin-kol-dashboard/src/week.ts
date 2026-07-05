import { Social } from "./socials";
import { WeekEntry } from "./settings";

export interface ShareReminder {
  platform: string;
  handle?: string;
  overdue: boolean;
  socialPath: string;
}

export interface WeekDay {
  date: string;     // ISO YYYY-MM-DD
  dayName: string;  // "Mon" … "Sun"
  isToday: boolean;
  isPast: boolean;
  reminders: ShareReminder[];   // cadence-derived "due" chips
  manualReminders: string[];    // user-added reminders for this day
  notes: string[];              // user-added notes for this day
}

const DAY_NAMES = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

export function getCurrentWeek(now: Date = new Date()): WeekDay[] {
  const today = startOfDay(now);
  const dow = today.getDay(); // 0=Sun .. 6=Sat
  const offsetToMonday = dow === 0 ? -6 : 1 - dow;
  const monday = new Date(today);
  monday.setDate(today.getDate() + offsetToMonday);

  const todayIso = isoDate(today);
  const days: WeekDay[] = [];
  for (let i = 0; i < 7; i++) {
    const d = new Date(monday);
    d.setDate(monday.getDate() + i);
    const iso = isoDate(d);
    days.push({
      date: iso,
      dayName: DAY_NAMES[i],
      isToday: iso === todayIso,
      isPast: iso < todayIso,
      reminders: [],
      manualReminders: [],
      notes: [],
    });
  }
  return days;
}

/** Layer user-added reminders/notes (from plugin data) onto the week. */
export function attachManualEntries(
  days: WeekDay[],
  entries: Record<string, WeekEntry>,
): void {
  for (const day of days) {
    const e = entries[day.date];
    if (!e) continue;
    if (Array.isArray(e.reminders)) day.manualReminders = [...e.reminders];
    if (Array.isArray(e.notes)) day.notes = [...e.notes];
  }
}

export function attachReminders(days: WeekDay[], socials: Social[]): void {
  if (days.length === 0) return;
  const weekStart = days[0].date;
  const weekEnd = days[6].date;
  const todayDay = days.find((d) => d.isToday);

  for (const s of socials) {
    if (!s.intervalDays) continue;

    // Never logged a share → due today as overdue.
    if (!s.lastShared) {
      if (todayDay) addReminder(todayDay, s, true);
      continue;
    }

    let due = addDays(s.lastShared, s.intervalDays);

    // Catch up: if next due is before this week starts, it's overdue → pin to today.
    if (due < weekStart) {
      if (todayDay) addReminder(todayDay, s, true);
      while (due < weekStart) due = addDays(due, s.intervalDays);
    }

    // Walk forward across the week, dropping reminders on each due date.
    while (due <= weekEnd) {
      const day = days.find((d) => d.date === due);
      if (day) addReminder(day, s, day.isPast && !day.isToday);
      due = addDays(due, s.intervalDays);
    }
  }
}

function addReminder(day: WeekDay, s: Social, overdue: boolean): void {
  // Avoid duplicate reminders for the same account on the same day (keyed by
  // file path, so two accounts on one platform — e.g. two Instagrams — both show).
  if (day.reminders.some((r) => r.socialPath === s.path && r.overdue === overdue)) return;
  day.reminders.push({
    platform: s.platform,
    handle: s.handle,
    overdue,
    socialPath: s.path,
  });
}

function startOfDay(d: Date): Date {
  const out = new Date(d);
  out.setHours(0, 0, 0, 0);
  return out;
}

function isoDate(d: Date): string {
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, "0");
  const day = String(d.getDate()).padStart(2, "0");
  return `${y}-${m}-${day}`;
}

function addDays(iso: string, n: number): string {
  const d = new Date(iso + "T00:00:00");
  d.setDate(d.getDate() + n);
  return isoDate(d);
}

export function countReminders(days: WeekDay[]): number {
  return days.reduce(
    (n, d) => n + d.reminders.length + d.manualReminders.length + d.notes.length,
    0,
  );
}
