import { useState } from "react";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { useNavigate } from "react-router-dom";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/contexts/AuthContext";
import { AdminLayout } from "@/components/AdminLayout";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Skeleton } from "@/components/ui/skeleton";
import { Search, Eye, ClipboardList, RefreshCw, Trash2 } from "lucide-react";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from "@/components/ui/alert-dialog";
import { format } from "date-fns";
import { ptBR } from "date-fns/locale";
import { toast } from "sonner";

interface DiscScores {
  D?: number;
  I?: number;
  S?: number;
  C?: number;
}

interface BigFiveScores {
  O?: number;
  C?: number;
  E?: number;
  A?: number;
  N?: number;
}

function formatDisc(data: unknown): string {
  const scores = data as DiscScores;
  if (!scores) return "—";
  return `D:${scores.D ?? 0} I:${scores.I ?? 0} S:${scores.S ?? 0} C:${scores.C ?? 0}`;
}

function formatBigFive(data: unknown): string {
  const scores = data as BigFiveScores;
  if (!scores) return "—";
  return `O:${scores.O ?? 0} C:${scores.C ?? 0} E:${scores.E ?? 0} A:${scores.A ?? 0} N:${scores.N ?? 0}`;
}

export default function AdminTestsPage() {
  const [search, setSearch] = useState("");
  const [reprocessingId, setReprocessingId] = useState<string | null>(null);
  const [deletingId, setDeletingId] = useState<string | null>(null);
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const { selectedCompanyId, hasRole, profile } = useAuth();
  const isMasterAdmin = hasRole("master_admin");

  const handleReprocess = async (testId: string, userId: string) => {
    setReprocessingId(testId);
    try {
      const { data, error } = await supabase.functions.invoke("reprocess-results", {
        body: { userId, testId },
      });
      if (error) throw error;
      toast.success("Teste reprocessado com sucesso!");
      queryClient.invalidateQueries({ queryKey: ["admin-tests"] });
    } catch (err: any) {
      toast.error("Erro ao reprocessar: " + (err.message || "Erro desconhecido"));
    } finally {
      setReprocessingId(null);
    }
  };

  const handleDelete = async (testId: string, userId: string) => {
    setDeletingId(testId);
    try {
      await supabase.from("test_responses").delete().eq("user_id", userId);
      const { error } = await supabase.from("test_results").delete().eq("id", testId);
      if (error) throw error;
      toast.success("Teste excluído com sucesso!");
      queryClient.invalidateQueries({ queryKey: ["admin-tests"] });
    } catch (err: any) {
      toast.error("Erro ao excluir: " + (err.message || "Erro desconhecido"));
    } finally {
      setDeletingId(null);
    }
  };

  const effectiveCompanyId = isMasterAdmin ? selectedCompanyId : profile?.company_id;

  // Fetch profiles separately since there's no FK between test_results and profiles
  const { data: profiles } = useQuery({
    queryKey: ["all-profiles"],
    queryFn: async () => {
      const { data, error } = await supabase.from("profiles").select("user_id, name, email, company_id");
      if (error) throw error;
      return data;
    },
  });

  const profileMap = new Map(profiles?.map((p) => [p.user_id, p]) ?? []);

  const { data: tests, isLoading } = useQuery({
    queryKey: ["admin-tests"],
    queryFn: async () => {
      const { data, error } = await supabase
        .from("test_results")
        .select("id, user_id, completed_at, disc_natural, disc_adapted, big_five")
        .order("completed_at", { ascending: false });
      if (error) throw error;
      return data;
    },
  });

  const filtered = tests?.filter((t) => {
    const p = profileMap.get(t.user_id);
    if (!p) return false;
    if (effectiveCompanyId && p.company_id !== effectiveCompanyId) return false;
    if (!search) return true;
    const q = search.toLowerCase();
    return p.name.toLowerCase().includes(q) || p.email.toLowerCase().includes(q);
  });

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-2xl font-bold text-foreground">Testes</h1>
            <p className="text-muted-foreground">Resultados dos testes realizados pelos colaboradores</p>
          </div>
        </div>

        <div className="relative max-w-sm">
          <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
          <Input
            placeholder="Buscar por nome ou email..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="pl-9"
          />
        </div>

        <div className="rounded-lg border bg-card">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Usuário</TableHead>
                <TableHead>Email</TableHead>
                <TableHead>Data</TableHead>
                <TableHead>DISC Natural</TableHead>
                <TableHead>DISC Adaptado</TableHead>
                <TableHead>Big Five</TableHead>
                <TableHead className="text-right">Ações</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {isLoading ? (
                Array.from({ length: 5 }).map((_, i) => (
                  <TableRow key={i}>
                    {Array.from({ length: 7 }).map((_, j) => (
                      <TableCell key={j}>
                        <Skeleton className="h-4 w-20" />
                      </TableCell>
                    ))}
                  </TableRow>
                ))
              ) : filtered && filtered.length > 0 ? (
                filtered.map((test) => {
                  const p = profileMap.get(test.user_id);
                  return (
                    <TableRow key={test.id}>
                      <TableCell className="font-medium">{p?.name ?? "—"}</TableCell>
                      <TableCell className="text-muted-foreground">{p?.email ?? "—"}</TableCell>
                      <TableCell>
                        {format(new Date(test.completed_at), "dd/MM/yyyy HH:mm", { locale: ptBR })}
                      </TableCell>
                      <TableCell className="font-mono text-xs">{formatDisc(test.disc_natural)}</TableCell>
                      <TableCell className="font-mono text-xs">{formatDisc(test.disc_adapted)}</TableCell>
                      <TableCell className="font-mono text-xs">{formatBigFive(test.big_five)}</TableCell>
                      <TableCell className="text-right space-x-1">
                        {isMasterAdmin && (
                          <>
                            <Button
                              variant="ghost"
                              size="sm"
                              onClick={() => handleReprocess(test.id, test.user_id)}
                              disabled={reprocessingId === test.id}
                              title="Reprocessar resultado"
                            >
                              <RefreshCw className={`h-4 w-4 ${reprocessingId === test.id ? "animate-spin" : ""}`} />
                            </Button>
                            <AlertDialog>
                              <AlertDialogTrigger asChild>
                                <Button
                                  variant="ghost"
                                  size="sm"
                                  disabled={deletingId === test.id}
                                  title="Excluir teste"
                                  className="text-destructive hover:text-destructive"
                                >
                                  <Trash2 className="h-4 w-4" />
                                </Button>
                              </AlertDialogTrigger>
                              <AlertDialogContent>
                                <AlertDialogHeader>
                                  <AlertDialogTitle>Excluir teste?</AlertDialogTitle>
                                  <AlertDialogDescription>
                                    Esta ação é irreversível. O resultado e todas as respostas deste teste serão permanentemente excluídos.
                                  </AlertDialogDescription>
                                </AlertDialogHeader>
                                <AlertDialogFooter>
                                  <AlertDialogCancel>Cancelar</AlertDialogCancel>
                                  <AlertDialogAction
                                    onClick={() => handleDelete(test.id, test.user_id)}
                                    className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
                                  >
                                    Excluir
                                  </AlertDialogAction>
                                </AlertDialogFooter>
                              </AlertDialogContent>
                            </AlertDialog>
                          </>
                        )}
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => navigate(`/resultado?userId=${test.user_id}&testId=${test.id}`)}
                        >
                          <Eye className="mr-1 h-4 w-4" />
                          Ver Relatório
                        </Button>
                      </TableCell>
                    </TableRow>
                  );
                })
              ) : (
                <TableRow>
                  <TableCell colSpan={7} className="h-32 text-center">
                    <div className="flex flex-col items-center gap-2 text-muted-foreground">
                      <ClipboardList className="h-8 w-8" />
                      <p>Nenhum teste encontrado</p>
                    </div>
                  </TableCell>
                </TableRow>
              )}
            </TableBody>
          </Table>
        </div>
      </div>
    </AdminLayout>
  );
}
