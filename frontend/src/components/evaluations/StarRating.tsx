import { Star } from "lucide-react";
import { SCORE_LABELS } from "@/types/evaluations";
import { cn } from "@/lib/utils";

interface StarRatingProps {
  value: number;
  onChange?: (value: number) => void;
  disabled?: boolean;
  size?: "sm" | "md";
}

export function StarRating({ value, onChange, disabled, size = "md" }: StarRatingProps) {
  const starSize = size === "sm" ? "h-5 w-5" : "h-7 w-7";

  return (
    <div className="flex items-center gap-1.5">
      <div className="flex gap-0.5">
        {[1, 2, 3, 4, 5].map((star) => (
          <button
            key={star}
            type="button"
            disabled={disabled}
            onClick={() => onChange?.(star)}
            className={cn(
              starSize,
              "transition-colors",
              star <= value ? "text-amber-400" : "text-muted-foreground/20",
              !disabled && "hover:text-amber-300 cursor-pointer",
              disabled && "cursor-default"
            )}
          >
            <Star className="h-full w-full fill-current" />
          </button>
        ))}
      </div>
      {value > 0 && (
        <span className="text-xs text-muted-foreground">{SCORE_LABELS[value]}</span>
      )}
    </div>
  );
}
