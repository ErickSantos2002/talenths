import { Badge } from "@/components/ui/badge";

function formatDate(value: string): string {
  const [y, m, d] = value.slice(0, 10).split("-");
  return `${d}/${m}/${y}`;
}

export function InactiveBadge({ since }: { since?: string | null }) {
  return (
    <Badge variant="outline" className="border-border bg-muted font-normal text-muted-foreground">
      {since ? `Desligado(a) em ${formatDate(since)}` : "Desligado(a)"}
    </Badge>
  );
}
