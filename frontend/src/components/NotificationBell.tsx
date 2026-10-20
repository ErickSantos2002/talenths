import { Bell, Video } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { notifications as notificationsApi } from "@/lib/api";
import { useAuth } from "@/contexts/AuthContext";
import { Button } from "@/components/ui/button";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { formatDistanceToNow } from "date-fns";
import { ptBR } from "date-fns/locale";
import {
  countUnread,
  formatBadge,
  sortNewestFirst,
  unreadIds,
  notificationRoute,
  type AppNotification,
} from "@/lib/notifications";

const VISIBLE_LIMIT = 5;

export function NotificationBell() {
  const { user } = useAuth();
  const navigate = useNavigate();
  const queryClient = useQueryClient();

  const queryKey = ["notifications", user?.id];

  const { data: items = [] } = useQuery({
    queryKey,
    queryFn: async () => sortNewestFirst((await notificationsApi.list()) as unknown as AppNotification[]),
    enabled: !!user,
    refetchInterval: 60_000,
  });

  const markRead = useMutation({
    mutationFn: (ids: string[]) => Promise.all(ids.map((id) => notificationsApi.markRead(id))),
    onSettled: () => queryClient.invalidateQueries({ queryKey }),
  });

  if (!user) return null;

  const unreadCount = countUnread(items);

  const handleClick = (n: AppNotification) => {
    if (!n.read) markRead.mutate([n.id]);
    const route = notificationRoute(n.type);
    if (route) navigate(route);
  };

  const markAllAsRead = () => {
    const ids = unreadIds(items);
    if (ids.length > 0) markRead.mutate(ids);
  };

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <Button
          data-tour="notifications"
          variant="ghost"
          size="icon"
          className="relative h-9 w-9"
          aria-label={unreadCount > 0 ? `Notificações (${unreadCount} não lidas)` : "Notificações"}
        >
          <Bell className="h-5 w-5 text-muted-foreground" />
          {unreadCount > 0 && (
            <span className="absolute -right-0.5 -top-0.5 flex h-4 min-w-4 items-center justify-center rounded-full px-0.5 bg-destructive text-[10px] font-bold text-destructive-foreground">
              {formatBadge(unreadCount)}
            </span>
          )}
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end" className="w-72 max-w-[calc(100vw-1.5rem)]">
        <div className="flex items-center justify-between px-3 py-2 border-b border-border">
          <span className="text-sm font-semibold">Notificações</span>
          {unreadCount > 0 && (
            <button
              onClick={markAllAsRead}
              className="text-xs text-primary hover:underline"
            >
              Marcar todas como lidas
            </button>
          )}
        </div>
        {items.length === 0 ? (
          <div className="px-3 py-4 text-center text-sm text-muted-foreground">
            Nenhuma notificação
          </div>
        ) : (
          items.slice(0, VISIBLE_LIMIT).map((n) => (
            <DropdownMenuItem
              key={n.id}
              onSelect={() => handleClick(n)}
              className={`flex items-start gap-2 px-3 py-2 cursor-pointer ${!n.read ? "bg-primary/5" : ""}`}
            >
              {n.type === "video" && (
                <Video className="mt-0.5 h-4 w-4 shrink-0 text-primary" aria-hidden="true" />
              )}
              <div className="flex min-w-0 flex-col gap-0.5">
                <span className="text-sm font-medium">{n.title}</span>
                {n.message && (
                  <span className="text-xs text-muted-foreground line-clamp-1">
                    {n.message}
                  </span>
                )}
                <span className="text-xs text-muted-foreground">
                  {formatDistanceToNow(new Date(n.created_at), {
                    addSuffix: true,
                    locale: ptBR,
                  })}
                </span>
              </div>
            </DropdownMenuItem>
          ))
        )}
      </DropdownMenuContent>
    </DropdownMenu>
  );
}
