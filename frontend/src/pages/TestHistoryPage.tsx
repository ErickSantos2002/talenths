import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { tests as testsApi } from "@/lib/api";
import { useAuth } from "@/contexts/AuthContext";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { ClipboardList, Eye, Loader2 } from "lucide-react";
import { Skeleton } from "@/components/ui/skeleton";
import { format } from "date-fns";
import { ptBR } from "date-fns/locale";

interface HistoryItem {
  id: string;
  completed_at: string;
  disc_natural: { D: number; I: number; S: number; C: number };
}

import { dniaDimensions, discToDisplayKey } from "@/data/dniaLabels";
const discLabels = dniaDimensions;

function getDominantProfile(disc: { D: number; I: number; S: number; C: number }): string {
  const entries = Object.entries(disc) as [string, number][];
  entries.sort((a, b) => b[1] - a[1]);
  return `${discToDisplayKey[entries[0][0]]} - ${discLabels[entries[0][0]]}`;
}

export default function TestHistoryPage() {
  const { user } = useAuth();
  const navigate = useNavigate();
  const [items, setItems] = useState<HistoryItem[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!user) return;
    const fetchHistory = async () => {
      try {
        const data = await testsApi.results();
        const sorted = (data as unknown as HistoryItem[]).sort(
          (a, b) => new Date(b.completed_at).getTime() - new Date(a.completed_at).getTime()
        );
        setItems(sorted);
      } catch {
        setItems([]);
      }
      setLoading(false);
    };
    fetchHistory();
  }, [user]);

  return (
    <AdminLayout>
      <div className="animate-fade-in space-y-6">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10">
              <ClipboardList className="h-5 w-5 text-primary" />
            </div>
            <div>
              <h1 className="text-2xl font-bold text-foreground">Meu Histórico</h1>
              <p className="text-sm text-muted-foreground">Todos os testes realizados</p>
            </div>
          </div>
          <Button onClick={() => navigate("/teste")} className="gap-2">
            <ClipboardList className="h-4 w-4" />
            Realizar Teste
          </Button>
        </div>

        {loading ? (
          <div className="space-y-4">{[1, 2, 3].map((i) => <Skeleton key={i} className="h-20 w-full" />)}</div>
        ) : items.length === 0 ? (
          <Card>
            <CardContent className="py-12 text-center">
              <ClipboardList className="mx-auto h-10 w-10 text-muted-foreground" />
              <p className="mt-3 text-muted-foreground">Nenhum teste realizado ainda.</p>
              <Button className="mt-4" onClick={() => navigate("/teste")}>Fazer Teste</Button>
            </CardContent>
          </Card>
        ) : (
          <div className="space-y-3">
            {items.map((item) => (
              <Card key={item.id} className="shadow-card hover:shadow-card-hover transition-shadow">
                <CardContent className="flex items-center justify-between p-4">
                  <div>
                    <p className="font-medium text-foreground">
                      {format(new Date(item.completed_at), "dd 'de' MMMM 'de' yyyy", { locale: ptBR })}
                    </p>
                    <p className="text-sm text-muted-foreground">
                      Perfil dominante: <span className="font-semibold text-primary">{getDominantProfile(item.disc_natural)}</span>
                    </p>
                    <div className="mt-1 flex gap-3 text-xs text-muted-foreground">
                      {Object.entries(item.disc_natural).map(([k, v]) => (
                        <span key={k}>{discToDisplayKey[k] || k}: {v}</span>
                      ))}
                    </div>
                  </div>
                  <Button size="sm" variant="outline" onClick={() => navigate(`/resultado?testId=${item.id}`)} className="gap-1">
                    <Eye className="h-3 w-3" />
                    Ver
                  </Button>
                </CardContent>
              </Card>
            ))}
          </div>
        )}
      </div>
    </AdminLayout>
  );
}
