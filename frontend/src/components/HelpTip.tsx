import { HelpCircle } from "lucide-react";
import * as TooltipPrimitive from "@radix-ui/react-tooltip";
import { Tooltip, TooltipContent, TooltipTrigger } from "@/components/ui/tooltip";
import { cn } from "@/lib/utils";

interface HelpTipProps {
  children: React.ReactNode;
  className?: string;
  side?: "top" | "right" | "bottom" | "left";
}

/** Ícone de ajuda (?) com tooltip explicativo. */
export function HelpTip({ children, className, side = "top" }: HelpTipProps) {
  return (
    <Tooltip>
      <TooltipTrigger asChild>
        <button
          type="button"
          aria-label="Ajuda"
          onClick={(e) => e.preventDefault()}
          className={cn(
            "inline-flex items-center text-muted-foreground/50 hover:text-muted-foreground transition-colors align-middle",
            className,
          )}
        >
          <HelpCircle className="h-3.5 w-3.5" />
        </button>
      </TooltipTrigger>
      <TooltipPrimitive.Portal>
        <TooltipContent side={side} collisionPadding={12} className="max-w-xs text-xs leading-relaxed font-normal">
          {children}
        </TooltipContent>
      </TooltipPrimitive.Portal>
    </Tooltip>
  );
}
