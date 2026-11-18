import { CalendarDays } from "lucide-react";
import { cn } from "@/lib/utils";
import { formatDateOnly } from "@/lib/dateOnly";
import { EVAL_STAGES, type EvalCycle } from "@/types/evaluations";

/** Períodos das etapas do ciclo, com a etapa atual destacada. */
export function CycleDates({ cycle }: { cycle: EvalCycle }) {
  const stages = EVAL_STAGES.filter(s => cycle[s.start] && cycle[s.end]);
  if (stages.length === 0) {
    return <p className="text-xs text-muted-foreground">Sem datas cadastradas. A etapa é trocada à mão.</p>;
  }
  return (
    <ul className="flex flex-wrap gap-2" aria-label="Datas das etapas">
      {stages.map(s => (
        <li
          key={s.status}
          className={cn(
            "flex items-center gap-1.5 rounded-md border px-2 py-1 text-xs",
            cycle.status === s.status ? "border-primary/40 bg-primary/10 text-foreground" : "text-muted-foreground",
          )}
        >
          <CalendarDays className="h-3.5 w-3.5" aria-hidden />
          <span className="font-medium">{s.label}</span>
          {formatDateOnly(cycle[s.start])} a {formatDateOnly(cycle[s.end])}
        </li>
      ))}
    </ul>
  );
}
