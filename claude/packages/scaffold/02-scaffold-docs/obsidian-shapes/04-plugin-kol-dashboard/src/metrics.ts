import { requestUrl } from "obsidian";

export type StatFormat = "number" | "percent" | "duration";
export type StatStatus = "live" | "stale" | "offline";

export interface PlatformMetric {
  label: string;
  platform: "umami" | "youtube" | "instagram" | "tiktok" | "other";
  value: number;
  format: StatFormat;
  deltaPct?: number;
  status: StatStatus;
}

export interface LatestUpload {
  title: string;
  platform: string;
  url?: string;
  publishedAt?: string;
  views?: number;
  likes?: number;
  comments?: number;
  ageLabel?: string;
}

export interface MetricListItem {
  label: string;
  value: number;
}

export interface MetricsResult {
  generatedAt: string;
  platforms: PlatformMetric[];
  latest?: LatestUpload;
  topPages?: MetricListItem[];
  topReferrers?: MetricListItem[];
  source: "live" | "placeholder";
  error?: string;
}

export interface UmamiConfig {
  baseUrl: string;
  websiteId: string;
  username: string;
  password: string;
}

interface UmamiAuthCache {
  token: string;
  expiresAt: number;
}

let authCache: UmamiAuthCache | null = null;

function trimSlash(url: string): string {
  return url.replace(/\/$/, "");
}

async function umamiLogin(config: UmamiConfig): Promise<string> {
  const res = await requestUrl({
    url: `${trimSlash(config.baseUrl)}/api/auth/login`,
    method: "POST",
    contentType: "application/json",
    body: JSON.stringify({ username: config.username, password: config.password }),
    throw: false,
  });
  if (res.status < 200 || res.status >= 300) {
    throw new Error(`login http ${res.status}`);
  }
  const json = res.json as { token?: string };
  if (!json.token) throw new Error("login: no token in response");
  return json.token;
}

async function umamiToken(config: UmamiConfig): Promise<string> {
  const now = Date.now();
  if (authCache && authCache.expiresAt > now + 60_000) {
    return authCache.token;
  }
  const token = await umamiLogin(config);
  authCache = { token, expiresAt: now + 23 * 60 * 60 * 1000 };
  return token;
}

async function umamiGet<T>(
  config: UmamiConfig,
  path: string,
  params: Record<string, string | number>,
): Promise<T> {
  const query = new URLSearchParams(
    Object.entries(params).map(([k, v]) => [k, String(v)]),
  ).toString();
  const url = `${trimSlash(config.baseUrl)}${path}?${query}`;

  let token = await umamiToken(config);
  let res = await requestUrl({
    url,
    method: "GET",
    headers: { Authorization: `Bearer ${token}` },
    throw: false,
  });
  if (res.status === 401) {
    authCache = null;
    token = await umamiToken(config);
    res = await requestUrl({
      url,
      method: "GET",
      headers: { Authorization: `Bearer ${token}` },
      throw: false,
    });
  }
  if (res.status < 200 || res.status >= 300) {
    throw new Error(`${path} http ${res.status}`);
  }
  return res.json as T;
}

type UmamiStatsResponse = {
  pageviews: number;
  visitors: number;
  visits: number;
  bounces: number;
  totaltime: number;
  comparison?: {
    pageviews: number;
    visitors: number;
    visits: number;
    bounces: number;
    totaltime: number;
  };
};

type UmamiMetricRow = { x: string | null; y: number };

export async function fetchMetrics(config: UmamiConfig): Promise<MetricsResult> {
  if (!config.baseUrl || !config.websiteId || !config.username || !config.password) {
    return placeholder("umami not configured");
  }
  try {
    const endAt = Date.now();
    const startAt = endAt - 30 * 24 * 60 * 60 * 1000;
    const id = config.websiteId;
    const stats = await umamiGet<UmamiStatsResponse>(config, `/api/websites/${id}/stats`, { startAt, endAt });
    const result = parseUmamiStats(stats);

    // Best-effort enrichments — a failure on any of these must not blank the tiles.
    const [active, pages, referrers] = await Promise.all([
      umamiGet<unknown>(config, `/api/websites/${id}/active`, {}).catch(() => null),
      umamiGet<UmamiMetricRow[]>(config, `/api/websites/${id}/metrics`, { startAt, endAt, type: "url", limit: 5 }).catch(() => null),
      umamiGet<UmamiMetricRow[]>(config, `/api/websites/${id}/metrics`, { startAt, endAt, type: "referrer", limit: 5 }).catch(() => null),
    ]);

    const activeCount = parseActive(active);
    if (activeCount !== null) {
      result.platforms.push({
        label: "active now",
        platform: "umami",
        value: activeCount,
        status: "live",
        format: "number",
      });
    }
    result.topPages = parseMetricRows(pages);
    result.topReferrers = parseMetricRows(referrers);
    return result;
  } catch (e) {
    return placeholder((e as Error).message);
  }
}

/** Umami's /active shape varies by version: number, {visitors}, or [{x}]. */
function parseActive(data: unknown): number | null {
  if (data == null) return null;
  if (typeof data === "number") return data;
  if (Array.isArray(data)) {
    const first = data[0] as { x?: number; visitors?: number } | undefined;
    return first ? first.x ?? first.visitors ?? 0 : 0;
  }
  const o = data as { visitors?: number; x?: number };
  if (typeof o.visitors === "number") return o.visitors;
  if (typeof o.x === "number") return o.x;
  return null;
}

function parseMetricRows(rows: UmamiMetricRow[] | null): MetricListItem[] | undefined {
  if (!Array.isArray(rows)) return undefined;
  return rows.slice(0, 5).map((r) => ({ label: r.x || "(direct)", value: r.y ?? 0 }));
}

function deltaPct(curr: number, prev: number): number | undefined {
  if (!Number.isFinite(prev) || prev === 0) return undefined;
  return ((curr - prev) / prev) * 100;
}

function parseUmamiStats(s: UmamiStatsResponse): MetricsResult {
  const c = s.comparison ?? { pageviews: 0, visitors: 0, visits: 0, bounces: 0, totaltime: 0 };
  const visits = s.visits ?? 0;
  const prevVisits = c.visits ?? 0;
  const bouncesRaw = s.bounces ?? 0;
  const prevBouncesRaw = c.bounces ?? 0;
  const bounceRate = visits > 0 ? (bouncesRaw / visits) * 100 : 0;
  const prevBounceRate = prevVisits > 0 ? (prevBouncesRaw / prevVisits) * 100 : 0;
  const totalTime = s.totaltime ?? 0;
  const prevTotalTime = c.totaltime ?? 0;
  const avgSession = visits > 0 ? totalTime / visits : 0;
  const prevAvgSession = prevVisits > 0 ? prevTotalTime / prevVisits : 0;

  const visitors = s.visitors ?? 0;
  const prevVisitors = c.visitors ?? 0;
  const pageviews = s.pageviews ?? 0;
  const prevPageviews = c.pageviews ?? 0;

  const platforms: PlatformMetric[] = [
    {
      label: "visitors (30d)",
      platform: "umami",
      value: visitors,
      deltaPct: deltaPct(visitors, prevVisitors),
      status: "live",
      format: "number",
    },
    {
      label: "pageviews",
      platform: "umami",
      value: pageviews,
      deltaPct: deltaPct(pageviews, prevPageviews),
      status: "live",
      format: "number",
    },
    {
      label: "visits",
      platform: "umami",
      value: visits,
      deltaPct: deltaPct(visits, prevVisits),
      status: "live",
      format: "number",
    },
    {
      label: "bounce rate",
      platform: "umami",
      value: bounceRate,
      deltaPct: deltaPct(bounceRate, prevBounceRate),
      status: "live",
      format: "percent",
    },
    {
      label: "avg session",
      platform: "umami",
      value: avgSession,
      deltaPct: deltaPct(avgSession, prevAvgSession),
      status: "live",
      format: "duration",
    },
  ];

  return {
    generatedAt: new Date().toISOString(),
    platforms,
    source: "live",
  };
}

function placeholder(reason: string): MetricsResult {
  return {
    generatedAt: new Date().toISOString(),
    platforms: [
      { label: "visitors (30d)", platform: "umami", value: 0, status: "offline", format: "number" },
      { label: "pageviews", platform: "umami", value: 0, status: "offline", format: "number" },
      { label: "visits", platform: "umami", value: 0, status: "offline", format: "number" },
      { label: "bounce rate", platform: "umami", value: 0, status: "offline", format: "percent" },
      { label: "avg session", platform: "umami", value: 0, status: "offline", format: "duration" },
    ],
    source: "placeholder",
    error: reason,
  };
}

export function formatNumber(n: number): string {
  return n.toLocaleString("en-US");
}

export function formatValue(value: number, format: StatFormat, status: StatStatus): string {
  if (status === "offline") return "—";
  switch (format) {
    case "number":
      return formatNumber(Math.round(value));
    case "percent":
      return `${value.toFixed(1)}%`;
    case "duration": {
      const sec = Math.max(0, Math.round(value));
      const m = Math.floor(sec / 60);
      const s = sec % 60;
      if (m === 0) return `${s}s`;
      return `${m}m ${s.toString().padStart(2, "0")}s`;
    }
  }
}
