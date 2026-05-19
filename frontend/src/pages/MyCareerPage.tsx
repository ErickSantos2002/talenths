import { useQuery } from "@tanstack/react-query";
import { GitBranch, CheckCircle2, Clock, Star, ChevronRight } from "lucide-react";
import { AdminLayout } from "@/components/AdminLayout";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import { career as careerApi } from "@/lib/api";
import { cn } from "@/lib/utils";

export default function MyCareerPage() {
  const { data: myCareer, isLoading } = useQuery({
    queryKey: ["my-career"],
    queryFn: careerApi.my,
  });

  return (
    <AdminLayout>
      <div className="space-y-6 max-w-2xl">
        {/* Header */}
        <div className="flex items-center gap-3">
          <GitBranch className="h-6 w-6 text-primary" />
          <h1 className="text-2xl font-bold tracking-tight">Minha Trilha de Carreira</h1>
        </div>

        {isLoading ? (
          <div className="space-y-4">
            {[1, 2, 3].map(i => <Skeleton key={i} className="h-24 w-full rounded-xl" />)}
          </div>
        ) : !myCareer ? (
          <div className="rounded-xl border border-dashed p-16 text-center">
            <GitBranch className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
            <p className="text-muted-foreground">Sua trilha de carreira ainda não foi definida.</p>
            <p className="text-sm text-muted-foreground mt-1">Entre em contato com o RH para configurar sua trilha.</p>
          </div>
        ) : (
          <div className="space-y-4">
            {/* Trilha atual */}
            <div className="rounded-xl border bg-card p-5 space-y-4">
              <div className="flex items-start justify-between gap-3">
                <div>
                  <p className="text-xs text-muted-foreground uppercase tracking-wide mb-1">{myCareer.track_name}</p>
                  <h2 className="text-xl font-bold">{myCareer.level_name}</h2>
                  {myCareer.level_description && (
                    <p className="text-sm text-muted-foreground mt-1">{myCareer.level_description}</p>
                  )}
                </div>
                {myCareer.eligible_for_next && (
                  <div className="flex items-center gap-1.5 rounded-full bg-emerald-500/10 border border-emerald-500/20 px-3 py-1.5 text-emerald-600 dark:text-emerald-400 text-xs font-medium shrink-0">
                    <Star className="h-3.5 w-3.5 fill-current" />
                    Elegível para promoção
                  </div>
                )}
              </div>

              <div className="flex flex-wrap gap-4 text-sm">
                {myCareer.started_at && (
                  <div>
                    <p className="text-xs text-muted-foreground">Neste nível desde</p>
                    <p className="font-medium">{new Date(myCareer.started_at).toLocaleDateString("pt-BR", { month: "long", year: "numeric" })}</p>
                  </div>
                )}
                {myCareer.months_in_level !== undefined && (
                  <div>
                    <p className="text-xs text-muted-foreground">Tempo no nível</p>
                    <p className="font-medium">{myCareer.months_in_level} {myCareer.months_in_level === 1 ? "mês" : "meses"}</p>
                  </div>
                )}
                {myCareer.score_final !== null && myCareer.score_final !== undefined && (
                  <div>
                    <p className="text-xs text-muted-foreground">Última nota</p>
                    <p className={cn("font-semibold", myCareer.score_final >= 4.6 ? "text-emerald-500" : myCareer.score_final >= 3 ? "text-amber-500" : "text-red-500")}>
                      {myCareer.score_final.toFixed(2)}
                    </p>
                  </div>
                )}
                {myCareer.nine_box_quadrant && (
                  <div>
                    <p className="text-xs text-muted-foreground">Quadrante 9Box</p>
                    <Badge variant="outline" className="text-xs mt-0.5">{myCareer.nine_box_quadrant}</Badge>
                  </div>
                )}
              </div>
            </div>

            {/* Próximo nível */}
            {myCareer.next_level ? (
              <div className="rounded-xl border p-5 space-y-3">
                <div className="flex items-center gap-2 text-sm font-medium text-muted-foreground">
                  <ChevronRight className="h-4 w-4" />
                  Próximo nível: <span className="text-foreground font-semibold">{myCareer.next_level.name}</span>
                </div>
                {myCareer.next_level.description && (
                  <p className="text-sm text-muted-foreground">{myCareer.next_level.description}</p>
                )}
                <div className="space-y-2">
                  <p className="text-xs font-medium text-muted-foreground uppercase tracking-wide">Critérios para promoção</p>
                  <div className="space-y-2">
                    {myCareer.next_level.min_score_final && (
                      <CriterionRow
                        label={`Nota de avaliação ≥ ${myCareer.next_level.min_score_final}`}
                        met={myCareer.score_final !== null && myCareer.score_final !== undefined && myCareer.score_final >= myCareer.next_level.min_score_final}
                        current={myCareer.score_final !== null && myCareer.score_final !== undefined ? `Atual: ${myCareer.score_final.toFixed(2)}` : "Sem nota"}
                      />
                    )}
                    {myCareer.next_level.min_months_in_level && (
                      <CriterionRow
                        label={`Mínimo ${myCareer.next_level.min_months_in_level} meses no nível atual`}
                        met={(myCareer.months_in_level ?? 0) >= myCareer.next_level.min_months_in_level}
                        current={`Atual: ${myCareer.months_in_level ?? 0} meses`}
                      />
                    )}
                    {(myCareer.next_level.required_9box_quadrants?.length ?? 0) > 0 && (
                      <CriterionRow
                        label={`Quadrante 9Box: ${myCareer.next_level.required_9box_quadrants!.join(" ou ")}`}
                        met={!!myCareer.nine_box_quadrant && myCareer.next_level.required_9box_quadrants!.includes(myCareer.nine_box_quadrant)}
                        current={myCareer.nine_box_quadrant ? `Atual: ${myCareer.nine_box_quadrant}` : "Sem quadrante"}
                      />
                    )}
                    {!myCareer.next_level.min_score_final && !myCareer.next_level.min_months_in_level && (myCareer.next_level.required_9box_quadrants?.length ?? 0) === 0 && (
                      <p className="text-sm text-muted-foreground">Sem critérios definidos — promoção a critério do gestor.</p>
                    )}
                  </div>
                </div>
              </div>
            ) : (
              <div className="rounded-xl border border-dashed p-6 text-center">
                <Star className="mx-auto h-8 w-8 text-amber-400 fill-amber-400 mb-2" />
                <p className="font-medium">Você está no nível máximo desta trilha!</p>
                <p className="text-sm text-muted-foreground mt-1">Converse com o RH sobre novas possibilidades.</p>
              </div>
            )}
          </div>
        )}
      </div>
    </AdminLayout>
  );
}

function CriterionRow({ label, met, current }: { label: string; met: boolean; current?: string }) {
  return (
    <div className="flex items-center justify-between rounded-lg border px-3 py-2 text-sm">
      <div className="flex items-center gap-2">
        {met
          ? <CheckCircle2 className="h-4 w-4 text-emerald-500 shrink-0" />
          : <Clock className="h-4 w-4 text-muted-foreground/40 shrink-0" />}
        <span className={met ? "text-foreground" : "text-muted-foreground"}>{label}</span>
      </div>
      {current && <span className="text-xs text-muted-foreground">{current}</span>}
    </div>
  );
}
