import { Lightbulb } from "lucide-react";

interface PracticalInsightBoxProps {
  variant: "disc" | "bigfive";
  children: React.ReactNode;
}

export function PracticalInsightBox({ variant, children }: PracticalInsightBoxProps) {
  const styles = variant === "disc"
    ? "bg-accent/10 border-accent/30"
    : "bg-secondary/10 border-secondary/30";
  const iconColor = variant === "disc" ? "text-accent" : "text-secondary";

  return (
    <div className={`rounded-lg border p-4 ${styles}`}>
      <div className="flex items-start gap-2">
        <Lightbulb className={`h-5 w-5 mt-0.5 shrink-0 ${iconColor}`} />
        <div className="text-sm leading-relaxed text-foreground">{children}</div>
      </div>
    </div>
  );
}
