import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

export function SectionCard({ icon, iconColor, title, children }: { icon: React.ReactNode; iconColor: string; title: string; children: React.ReactNode }) {
  return (
    <Card className="border-border/60 bg-card shadow-card hover:shadow-card-hover transition-shadow">
      <CardHeader className="pb-2">
        <CardTitle className="flex items-center gap-2 text-lg text-card-foreground">
          <span className={`${iconColor} p-1.5 rounded-lg bg-muted/80`}>{icon}</span>
          {title}
        </CardTitle>
      </CardHeader>
      <CardContent>{children}</CardContent>
    </Card>
  );
}

export function ListSection({ icon, iconColor, title, items, itemIcon }: { icon: React.ReactNode; iconColor: string; title: string; items: string[]; itemIcon: React.ReactNode }) {
  return (
    <SectionCard icon={icon} iconColor={iconColor} title={title}>
      <ul className="space-y-2.5">
        {items.map((item, i) => (
          <li key={i} className="flex items-start gap-2.5">
            <span className={`mt-0.5 shrink-0 ${iconColor}`}>{itemIcon}</span>
            <span className="text-sm text-foreground/80">{item}</span>
          </li>
        ))}
      </ul>
    </SectionCard>
  );
}
