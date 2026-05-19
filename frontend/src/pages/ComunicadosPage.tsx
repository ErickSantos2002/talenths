import { useQuery } from "@tanstack/react-query";
import { communications as commsApi } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Badge } from "@/components/ui/badge";
import { AnnouncementCard } from "./CommunicationsAdminPage";
import { Megaphone, Cake, Award } from "lucide-react";
import { cn } from "@/lib/utils";

const MONTH_NAMES = ["Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"];

export default function ComunicadosPage() {
  const { data: announcements = [], isLoading } = useQuery({
    queryKey: ["announcements"],
    queryFn: commsApi.listAnnouncements,
  });
  const { data: birthdays = [] } = useQuery({
    queryKey: ["birthdays"],
    queryFn: commsApi.birthdays,
  });
  const { data: milestones = [] } = useQuery({
    queryKey: ["milestones"],
    queryFn: commsApi.milestones,
  });

  const currentMonth = MONTH_NAMES[new Date().getMonth()];
  const todayBirthdays = birthdays.filter(b => b.is_today);
  const todayMilestones = milestones.filter(m => m.is_today);

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div className="flex items-center gap-3">
          <Megaphone className="h-6 w-6 text-primary" />
          <h1 className="text-2xl font-bold tracking-tight">Comunicados</h1>
        </div>

        {/* Today highlights */}
        {(todayBirthdays.length > 0 || todayMilestones.length > 0) && (
          <div className="rounded-xl border bg-gradient-to-r from-primary/5 to-primary/10 p-4 space-y-2">
            <p className="text-sm font-semibold text-primary">Acontece hoje 🎉</p>
            <div className="flex flex-wrap gap-2">
              {todayBirthdays.map(b => (
                <div key={b.user_id} className="flex items-center gap-1.5 rounded-full bg-pink-100 text-pink-700 px-3 py-1 text-xs font-medium">
                  <Cake className="h-3 w-3" /> {b.name}
                </div>
              ))}
              {todayMilestones.map(m => (
                <div key={m.user_id} className="flex items-center gap-1.5 rounded-full bg-amber-100 text-amber-700 px-3 py-1 text-xs font-medium">
                  <Award className="h-3 w-3" /> {m.name} — {m.years} {m.years === 1 ? "ano" : "anos"} de empresa
                </div>
              ))}
            </div>
          </div>
        )}

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Feed */}
          <div className="lg:col-span-2 space-y-3">
            {isLoading ? (
              <p className="text-sm text-muted-foreground">Carregando...</p>
            ) : announcements.length === 0 ? (
              <div className="rounded-xl border border-dashed p-12 text-center">
                <Megaphone className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
                <p className="text-muted-foreground">Nenhum comunicado publicado ainda.</p>
              </div>
            ) : (
              announcements.map(a => <AnnouncementCard key={a.id} announcement={a} />)
            )}
          </div>

          {/* Sidebar */}
          <div className="space-y-4">
            {/* Birthdays */}
            <div className="rounded-xl border bg-card p-4 space-y-3">
              <h3 className="flex items-center gap-2 text-sm font-semibold">
                <Cake className="h-4 w-4 text-pink-500" /> Aniversariantes — {currentMonth}
              </h3>
              {birthdays.length === 0 ? (
                <p className="text-xs text-muted-foreground">Nenhum este mês.</p>
              ) : (
                <div className="space-y-2">
                  {birthdays.map(b => (
                    <div key={b.user_id} className={cn(
                      "flex items-center gap-2 text-sm",
                      b.is_today && "font-semibold text-pink-600"
                    )}>
                      <span className="text-xs w-5 text-right text-muted-foreground shrink-0">{b.day}</span>
                      <span className="truncate">{b.name}</span>
                      {b.is_today && <Badge className="bg-pink-100 text-pink-700 border-0 text-[10px] h-4 px-1">hoje</Badge>}
                    </div>
                  ))}
                </div>
              )}
            </div>

            {/* Milestones */}
            {milestones.length > 0 && (
              <div className="rounded-xl border bg-card p-4 space-y-3">
                <h3 className="flex items-center gap-2 text-sm font-semibold">
                  <Award className="h-4 w-4 text-amber-500" /> Tempo de Casa — {currentMonth}
                </h3>
                <div className="space-y-2">
                  {milestones.map(m => (
                    <div key={m.user_id} className={cn(
                      "flex items-center gap-2 text-sm",
                      m.is_today && "font-semibold text-amber-600"
                    )}>
                      <span className="text-xs font-medium text-amber-600 shrink-0">{m.years}a</span>
                      <span className="truncate flex-1">{m.name}</span>
                      {m.is_today && <Badge className="bg-amber-100 text-amber-700 border-0 text-[10px] h-4 px-1">hoje</Badge>}
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </AdminLayout>
  );
}
