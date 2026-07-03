import { cn } from "@/lib/utils";

interface BingoCardProps {
  layout: (number | null)[][];
  marked?: number[];
  pending?: number[];
  numberPool?: number;
  name?: string;
  code?: string;
  showHeader?: boolean;
  variant?: "screen" | "print";
}

/** Cartela de bingo 10×3 (20 números + 10 vazios). Reusada em tela e impressão. */
export function BingoCard({
  layout, marked = [], pending = [], numberPool, name, code, showHeader, variant = "screen",
}: BingoCardProps) {
  const isPrint = variant === "print";
  const per = numberPool ? numberPool / 10 : 3;
  const markedSet = new Set(marked);
  const pendingSet = new Set(pending);

  const cellClass = (v: number | null) => {
    if (v === null) {
      return isPrint
        ? "bg-[#fafbfc] border border-dashed border-[#dfe4ec]"
        : "bg-[#0b1424] border border-dashed border-[#24334d]";
    }
    if (markedSet.has(v)) return "bg-blue-600 text-white border border-blue-600";
    if (pendingSet.has(v)) return "bg-transparent text-blue-300 border-[1.5px] border-blue-500";
    return isPrint
      ? "bg-blue-50 border border-blue-200 text-blue-800"
      : "bg-[#16233a] border border-[#2b3d5c] text-slate-100";
  };

  return (
    <div className={cn("rounded-lg", isPrint ? "p-2 border border-[#2d3646] bg-white" : "")}>
      {showHeader && (
        <div className={cn("flex items-center justify-between mb-1.5", isPrint ? "pb-1 border-b border-[#e4e8ef]" : "")}>
          <span className="flex items-center gap-1.5">
            <img src="/hs.ico" alt="HS" className="h-4 w-4 object-contain" />
            <span className={cn("font-bold text-sm", isPrint ? "text-[#17337a]" : "text-slate-100")}>{name}</span>
          </span>
          {code && <span className="font-mono text-[10px] text-muted-foreground">#{code}</span>}
        </div>
      )}
      {showHeader && numberPool && (
        <div className="grid grid-cols-10 gap-[3px] mb-[3px]">
          {Array.from({ length: 10 }, (_, c) => (
            <div key={c} className="text-center text-[8px] font-bold text-muted-foreground">
              {c * per + 1}-{c * per + per}
            </div>
          ))}
        </div>
      )}
      <div className="grid grid-cols-10 gap-[3px]">
        {layout.flat().map((v, i) => (
          <div key={i} className="relative aspect-square">
            <div
              className={cn(
                "absolute inset-0 flex items-center justify-center rounded-[5px] font-bold leading-none",
                isPrint ? "text-xl" : "text-[15px]",
                cellClass(v),
              )}
            >
              {v ?? ""}
            </div>
            {markedSet.has(v as number) && (
              <span className="absolute top-0 right-0.5 z-10 text-[8px] font-bold text-white opacity-90">✓</span>
            )}
          </div>
        ))}
      </div>
    </div>
  );
}
