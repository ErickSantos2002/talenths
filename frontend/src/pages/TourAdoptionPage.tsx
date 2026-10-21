import { useMemo, useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { Download, UserCheck } from "lucide-react";
import { tour as tourApi } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Skeleton } from "@/components/ui/skeleton";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import {
  AUDIENCE_LABEL, NO_DEPARTMENT_LABEL, STATUS_LABEL, type AdoptionStatus,
  departmentOptions, filterRows, formatDate, stepLabel, toCsv, totals,
} from "@/help/tourAdoption";

const STATUS_VARIANT: Record<AdoptionStatus, "default" | "secondary" | "outline"> = {
  completed: "default",
  in_progress: "secondary",
  not_started: "outline",
};

const TOTAL_CARDS: { key: AdoptionStatus | "total"; label: string }[] = [
  { key: "total", label: "Total" },
  { key: "completed", label: STATUS_LABEL.completed },
  { key: "in_progress", label: STATUS_LABEL.in_progress },
  { key: "not_started", label: STATUS_LABEL.not_started },
];

export default function TourAdoptionPage() {
  const [department, setDepartment] = useState("all");
  const [status, setStatus] = useState<AdoptionStatus | "all">("all");
  const { data: rows = [], isLoading, isError, refetch } = useQuery({
    queryKey: ["tour-adoption"],
    queryFn: tourApi.adoption,
  });

  const departments = useMemo(() => departmentOptions(rows), [rows]);
  const counts = useMemo(() => totals(rows, department), [rows, department]);
  const visible = useMemo(() => filterRows(rows, { department, status }), [rows, department, status]);

  const exportCsv = () => {
    const blob = new Blob([toCsv(visible)], { type: "text/csv;charset=utf-8" });
    const a = document.createElement("a");
    a.href = URL.createObjectURL(blob);
    a.download = "adocao-do-tour.csv";
    a.click();
    URL.revokeObjectURL(a.href);
  };

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div className="flex flex-wrap items-center justify-between gap-3">
          <div className="flex items-center gap-3" data-tour="admin-tour-adoption">
            <UserCheck className="h-6 w-6 text-primary" />
            <div>
              <h1 className="text-2xl font-bold tracking-tight">Adoção do tour</h1>
              <p className="text-sm text-muted-foreground">
                Veja quem já fez o tour de boas-vindas do papel atual de cada pessoa: colaborador ou gestor.
              </p>
            </div>
          </div>
          <Button variant="outline" size="sm" onClick={exportCsv} disabled={isLoading || isError}>
            <Download className="h-4 w-4 mr-2" />
            Exportar CSV
          </Button>
        </div>

        <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
          {TOTAL_CARDS.map((c) => (
            <Card key={c.key} data-testid={`total-${c.key}`}>
              <CardContent className="p-4">
                <p className="text-xs text-muted-foreground">{c.label}</p>
                {isLoading ? (
                  <Skeleton className="h-8 w-12 mt-1" />
                ) : (
                  <p className="text-2xl font-bold">{counts[c.key]}</p>
                )}
              </CardContent>
            </Card>
          ))}
        </div>

        <div className="flex flex-wrap gap-3">
          <Select value={department} onValueChange={setDepartment}>
            <SelectTrigger className="w-full sm:w-60" aria-label="Departamento">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all">Todos os departamentos</SelectItem>
              {departments.map((d) => (
                <SelectItem key={d.value} value={d.value}>{d.label}</SelectItem>
              ))}
            </SelectContent>
          </Select>
          <Select value={status} onValueChange={(v) => setStatus(v as AdoptionStatus | "all")}>
            <SelectTrigger className="w-full sm:w-52" aria-label="Situação">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all">Todas as situações</SelectItem>
              {(Object.keys(STATUS_LABEL) as AdoptionStatus[]).map((s) => (
                <SelectItem key={s} value={s}>{STATUS_LABEL[s]}</SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>

        {isLoading ? (
          <div className="space-y-2">
            {[0, 1, 2, 3].map((i) => <Skeleton key={i} className="h-10 w-full" />)}
          </div>
        ) : isError ? (
          <Card>
            <CardContent className="p-6 flex flex-col items-center gap-3 text-center">
              <p className="text-sm text-muted-foreground">Não foi possível carregar a adoção do tour.</p>
              <Button variant="outline" size="sm" onClick={() => refetch()}>Tentar de novo</Button>
            </CardContent>
          </Card>
        ) : visible.length === 0 ? (
          <p className="text-sm text-muted-foreground py-8 text-center">Ninguém nesta seleção.</p>
        ) : (
          <Card>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Nome</TableHead>
                  <TableHead>Departamento</TableHead>
                  <TableHead>Tour</TableHead>
                  <TableHead>Situação</TableHead>
                  <TableHead>Passo</TableHead>
                  <TableHead>Concluído em</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {visible.map((r) => (
                  <TableRow key={r.user_id}>
                    <TableCell>
                      <p className="font-medium">{r.name}</p>
                      {r.email && <p className="text-xs text-muted-foreground">{r.email}</p>}
                    </TableCell>
                    <TableCell>{r.department ?? NO_DEPARTMENT_LABEL}</TableCell>
                    <TableCell>{AUDIENCE_LABEL[r.audience]}</TableCell>
                    <TableCell>
                      <Badge variant={STATUS_VARIANT[r.status]}>{STATUS_LABEL[r.status]}</Badge>
                    </TableCell>
                    <TableCell>{stepLabel(r)}</TableCell>
                    <TableCell>{formatDate(r.completed_at)}</TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </Card>
        )}
      </div>
    </AdminLayout>
  );
}
