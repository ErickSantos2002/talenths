import { Badge } from "@/components/ui/badge";
import type { ViewerStatus } from "@/lib/api";

const CONFIG: Record<ViewerStatus, { label: string; variant: "default" | "secondary" | "destructive" | "outline" }> = {
  concluido: { label: "Concluído", variant: "default" },
  atrasado: { label: "Atrasado", variant: "destructive" },
  em_andamento: { label: "Em andamento", variant: "secondary" },
  pendente: { label: "Pendente", variant: "outline" },
};

export function VideoStatusBadge({ status }: { status: ViewerStatus }) {
  const { label, variant } = CONFIG[status];
  return <Badge variant={variant}>{label}</Badge>;
}
