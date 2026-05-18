import { Info } from "lucide-react";
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from "@/components/ui/tooltip";
import { dniaAcronym } from "@/data/dniaLabels";
import { cn } from "@/lib/utils";

interface DniaInfoIconProps {
  letter: "D" | "N" | "I" | "A";
  className?: string;
}

export function DniaInfoIcon({ letter, className }: DniaInfoIconProps) {
  const info = dniaAcronym[letter];
  if (!info) return null;

  return (
    <TooltipProvider delayDuration={200}>
      <Tooltip>
        <TooltipTrigger asChild>
          <button
            type="button"
            className={cn(
              "inline-flex items-center justify-center rounded-full text-muted-foreground hover:text-primary transition-colors focus:outline-none focus-visible:ring-2 focus-visible:ring-primary",
              "h-5 w-5 min-w-[20px] min-h-[20px]",
              className
            )}
            aria-label={`${info.letter} - ${info.meaning}`}
          >
            <Info className="h-3.5 w-3.5" />
          </button>
        </TooltipTrigger>
        <TooltipContent side="top" className="max-w-[220px]">
          <p className="font-semibold text-sm">
            {info.letter} — {info.meaning}
          </p>
          <p className="text-xs text-muted-foreground mt-0.5">
            {info.description}
          </p>
        </TooltipContent>
      </Tooltip>
    </TooltipProvider>
  );
}

/** Shows all 4 DNIA letters with info icons inline */
export function DniaFullAcronym({ className }: { className?: string }) {
  return (
    <TooltipProvider delayDuration={200}>
      <div className={cn("inline-flex items-center gap-3", className)}>
        {(["D", "N", "I", "A"] as const).map((letter) => {
          const info = dniaAcronym[letter];
          return (
            <Tooltip key={letter}>
              <TooltipTrigger asChild>
                <button
                  type="button"
                  className="inline-flex items-center gap-1 text-muted-foreground hover:text-primary transition-colors focus:outline-none focus-visible:ring-2 focus-visible:ring-primary rounded"
                  aria-label={`${info.letter} - ${info.meaning}`}
                >
                  <span className="text-xs font-bold text-foreground">{letter}</span>
                  <Info className="h-3 w-3" />
                </button>
              </TooltipTrigger>
              <TooltipContent side="top" className="max-w-[220px]">
                <p className="font-semibold text-sm">
                  {info.letter} — {info.meaning}
                </p>
                <p className="text-xs text-muted-foreground mt-0.5">
                  {info.description}
                </p>
              </TooltipContent>
            </Tooltip>
          );
        })}
      </div>
    </TooltipProvider>
  );
}
