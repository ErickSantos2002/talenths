import { Badge } from "@/components/ui/badge";
import { CATEGORY_LABEL, type RequestCategory } from "@/types/requests";

const STYLE: Record<RequestCategory, string> = {
  saida: "bg-violet-500/15 text-violet-600 dark:text-violet-400 border-violet-500/20 hover:bg-violet-500/15",
  pagar_hora: "bg-emerald-500/15 text-emerald-600 dark:text-emerald-400 border-emerald-500/20 hover:bg-emerald-500/15",
};

export function RequestCategoryBadge({ category }: { category: RequestCategory }) {
  return (
    <Badge variant="outline" className={STYLE[category]}>
      {CATEGORY_LABEL[category]}
    </Badge>
  );
}
