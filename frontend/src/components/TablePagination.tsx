function getVisiblePages(current: number, total: number): number[] {
  const half = 2;
  let start = Math.max(1, current - half);
  let end = Math.min(total, start + 4);
  if (end - start < 4) start = Math.max(1, end - 4);
  return Array.from({ length: end - start + 1 }, (_, i) => start + i);
}

interface TablePaginationProps {
  currentPage: number;
  totalPages: number;
  totalItems: number;
  startIdx: number;
  endIdx: number;
  itemLabel?: string;
  onPage: (p: number) => void;
  onPrev: () => void;
  onNext: () => void;
}

export function TablePagination({
  currentPage, totalPages, totalItems, startIdx, endIdx,
  itemLabel = "itens",
  onPage, onPrev, onNext,
}: TablePaginationProps) {
  if (totalPages <= 1) return null;
  const pages = getVisiblePages(currentPage, totalPages);
  const btnBase = "rounded-lg border border-border bg-background px-3 py-1.5 text-sm text-foreground transition-colors hover:bg-muted disabled:cursor-not-allowed disabled:opacity-40";
  return (
    <div className="flex flex-col items-center gap-3 border-t border-border px-4 py-3 sm:flex-row sm:justify-between">
      <span className="text-xs text-muted-foreground">
        Mostrando {startIdx + 1}–{endIdx} de {totalItems} {itemLabel}
      </span>
      <div className="flex items-center gap-1.5">
        <button className={btnBase} disabled={currentPage === 1} onClick={onPrev}>‹ Anterior</button>
        {pages.map((p) => (
          <button
            key={p}
            onClick={() => onPage(p)}
            className={`min-w-[2rem] rounded-lg border px-2.5 py-1.5 text-sm transition-colors ${
              p === currentPage
                ? "border-primary bg-primary text-primary-foreground"
                : "border-border bg-background text-foreground hover:bg-muted"
            }`}
          >{p}</button>
        ))}
        <button className={btnBase} disabled={currentPage === totalPages} onClick={onNext}>Próxima ›</button>
      </div>
    </div>
  );
}
