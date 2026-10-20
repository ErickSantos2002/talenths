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

export function latestNotifications(list: AppNotification[], limit = 5): AppNotification[] {
  return [...list]
    .sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime())
    .slice(0, limit);
}

export function countUnread(list: AppNotification[]): number {
  return list.filter((n) => !n.read).length;
}
