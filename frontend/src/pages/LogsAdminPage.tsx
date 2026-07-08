import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { logs as logsApi, type AuditLog } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Shield, Search } from "lucide-react";
import { TablePagination } from "@/components/TablePagination";
import { usePageSize } from "@/hooks/use-page-size";
import { cn } from "@/lib/utils";

// ── Helpers ───────────────────────────────────────────────────────────────────

function MethodBadge({ method }: { method: string }) {
  const colors: Record<string, string> = {
    POST: "bg-emerald-500/15 text-emerald-400",
    PUT: "bg-blue-500/15 text-blue-400",
    PATCH: "bg-blue-500/15 text-blue-400",
    DELETE: "bg-red-500/15 text-red-400",
    GET: "bg-muted text-muted-foreground",
  };
  return (
    <Badge className={cn("text-[10px] border-0 font-mono font-bold px-1.5", colors[method] ?? "bg-muted text-muted-foreground")}>
      {method}
    </Badge>
  );
}

function StatusBadge({ code }: { code?: number }) {
  if (!code) return <span className="text-muted-foreground text-xs">—</span>;
  const ok = code < 400;
  return (
    <Badge className={cn("text-[10px] border-0 font-mono", ok ? "bg-emerald-500/15 text-emerald-400" : "bg-red-500/15 text-red-400")}>
      {code}
    </Badge>
  );
}

function formatDate(iso: string): string {
  const d = new Date(iso);
  return d.toLocaleString("pt-BR", {
    day: "2-digit", month: "2-digit", year: "numeric",
    hour: "2-digit", minute: "2-digit", second: "2-digit",
  });
}

// ── Filters ───────────────────────────────────────────────────────────────────

interface Filters {
  q: string;
  method: string;
  status: string;
}

function FiltersBar({ filters, onChange }: { filters: Filters; onChange: (f: Filters) => void }) {
  const [draft, setDraft] = useState(filters.q);

  const submit = () => onChange({ ...filters, q: draft });

  return (
    <div className="flex flex-wrap gap-3 items-center">
      <div className="flex gap-2 flex-1 min-w-[200px]">
        <Input
          placeholder="Buscar usuário, ação ou rota..."
          value={draft}
          onChange={(e) => setDraft(e.target.value)}
          onKeyDown={(e) => e.key === "Enter" && submit()}
        />
        <Button variant="outline" size="icon" onClick={submit}>
          <Search className="h-4 w-4" />
        </Button>
      </div>

      <Select value={filters.method || "all"} onValueChange={(v) => onChange({ ...filters, method: v === "all" ? "" : v })}>
        <SelectTrigger className="w-36">
          <SelectValue placeholder="Método" />
        </SelectTrigger>
        <SelectContent>
          <SelectItem value="all">Todos os métodos</SelectItem>
          <SelectItem value="POST">POST</SelectItem>
          <SelectItem value="PUT">PUT</SelectItem>
          <SelectItem value="PATCH">PATCH</SelectItem>
          <SelectItem value="DELETE">DELETE</SelectItem>
        </SelectContent>
      </Select>

      <Select value={filters.status || "all"} onValueChange={(v) => onChange({ ...filters, status: v === "all" ? "" : v })}>
        <SelectTrigger className="w-36">
          <SelectValue placeholder="Status" />
        </SelectTrigger>
        <SelectContent>
          <SelectItem value="all">Todos os status</SelectItem>
          <SelectItem value="success">Sucesso (2xx/3xx)</SelectItem>
          <SelectItem value="error">Erro (4xx/5xx)</SelectItem>
        </SelectContent>
      </Select>

      {(filters.q || filters.method || filters.status) && (
        <Button variant="ghost" size="sm" onClick={() => { setDraft(""); onChange({ q: "", method: "", status: "" }); }}>
          Limpar filtros
        </Button>
      )}
    </div>
  );
}

// ── Table ─────────────────────────────────────────────────────────────────────

function LogsTable({ items }: { items: AuditLog[] }) {
  if (items.length === 0) {
    return (
      <div className="rounded-xl border border-dashed p-16 text-center">
        <Shield className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
        <p className="text-muted-foreground">Nenhum log encontrado para os filtros aplicados.</p>
      </div>
    );
  }

  return (
    <div className="rounded-lg border overflow-hidden">
      <div className="overflow-x-auto">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b bg-muted/40">
              <th className="px-4 py-2.5 text-left text-xs font-semibold text-muted-foreground whitespace-nowrap">Data / Hora</th>
              <th className="px-4 py-2.5 text-left text-xs font-semibold text-muted-foreground">Usuário</th>
              <th className="px-4 py-2.5 text-left text-xs font-semibold text-muted-foreground">Ação</th>
              <th className="px-4 py-2.5 text-left text-xs font-semibold text-muted-foreground">Método</th>
              <th className="px-4 py-2.5 text-left text-xs font-semibold text-muted-foreground">Rota</th>
              <th className="px-4 py-2.5 text-left text-xs font-semibold text-muted-foreground">Status</th>
              <th className="px-4 py-2.5 text-left text-xs font-semibold text-muted-foreground">IP</th>
            </tr>
          </thead>
          <tbody className="divide-y">
            {items.map((log) => (
              <tr key={log.id} className="hover:bg-muted/20 transition-colors">
                <td className="px-4 py-2.5 text-xs text-muted-foreground whitespace-nowrap font-mono">
                  {formatDate(log.created_at)}
                </td>
                <td className="px-4 py-2.5 text-xs">
                  {log.user_name ? (
                    <span className="font-medium">{log.user_name}</span>
                  ) : (
                    <span className="text-muted-foreground italic">Anônimo</span>
                  )}
                </td>
                <td className="px-4 py-2.5 text-xs max-w-[220px]">
                  <span className="truncate block" title={log.action ?? log.path}>
                    {log.action ?? "—"}
                  </span>
                </td>
                <td className="px-4 py-2.5">
                  <MethodBadge method={log.method} />
                </td>
                <td className="px-4 py-2.5 text-xs font-mono text-muted-foreground max-w-[200px]">
                  <span className="truncate block" title={log.path}>{log.path}</span>
                </td>
                <td className="px-4 py-2.5">
                  <StatusBadge code={log.status_code} />
                </td>
                <td className="px-4 py-2.5 text-xs font-mono text-muted-foreground whitespace-nowrap">
                  {log.ip_address ?? "—"}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

// ── Page ──────────────────────────────────────────────────────────────────────

export default function LogsAdminPage() {
  const [page, setPage] = useState(1);
  const [limit, setLimit] = usePageSize("audit-logs", 50);
  const [filters, setFilters] = useState<Filters>({ q: "", method: "", status: "" });

  const handleFilterChange = (f: Filters) => {
    setFilters(f);
    setPage(1);
  };

  const { data, isLoading } = useQuery({
    queryKey: ["audit-logs", page, limit, filters],
    queryFn: () => logsApi.list({ page, limit, ...filters }),
    placeholderData: (prev) => prev,
  });

  return (
    <AdminLayout>
      <div className="space-y-5">
        <div className="flex items-center gap-3">
          <Shield className="h-6 w-6 text-primary" />
          <div>
            <h1 className="text-2xl font-bold tracking-tight">Logs de Auditoria</h1>
            <p className="text-sm text-muted-foreground">
              Registro de todas as ações realizadas no sistema.
            </p>
          </div>
        </div>

        <FiltersBar filters={filters} onChange={handleFilterChange} />

        {isLoading ? (
          <p className="text-sm text-muted-foreground">Carregando...</p>
        ) : data ? (
          <div className="space-y-4">
            <LogsTable items={data.items} />
            <TablePagination
              currentPage={data.page}
              totalPages={data.pages}
              totalItems={data.total}
              startIdx={(data.page - 1) * data.limit}
              endIdx={Math.min(data.page * data.limit, data.total)}
              itemLabel="registros"
              onPage={setPage}
              onPrev={() => setPage((p) => Math.max(1, p - 1))}
              onNext={() => setPage((p) => Math.min(data.pages, p + 1))}
              pageSize={limit}
              onPageSizeChange={(size) => { setLimit(size); setPage(1); }}
            />
          </div>
        ) : null}
      </div>
    </AdminLayout>
  );
}
