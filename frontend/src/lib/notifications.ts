export interface AppNotification {
  id: string;
  title: string;
  message: string | null;
  read: boolean;
  created_at: string;
  type: string;
}

const ROUTE_BY_TYPE: Record<string, string> = {
  video: "/meus-videos",
};

export function notificationRoute(type: string): string | null {
  return ROUTE_BY_TYPE[type] ?? null;
}

export function sortNewestFirst(list: AppNotification[]): AppNotification[] {
  return [...list].sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime());
}

export function countUnread(list: AppNotification[]): number {
  return list.filter((n) => !n.read).length;
}

export function formatBadge(count: number): string {
  return count > 99 ? "99+" : String(count);
}

export function unreadIds(list: AppNotification[]): string[] {
  return list.filter((n) => !n.read).map((n) => n.id);
}
