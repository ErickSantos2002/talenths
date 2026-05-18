import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { comparisons, profiles } from "@/lib/api";
import { useAuth } from "@/contexts/AuthContext";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { GitCompareArrows, Eye, Users } from "lucide-react";
import { Skeleton } from "@/components/ui/skeleton";
import { format } from "date-fns";
import { ptBR } from "date-fns/locale";

interface Comparison {
  id: string;
  user1_id: string;
  user2_id: string;
  compatibility_score: number | null;
  created_at: string;
  otherName: string;
}

export default function LeaderCompatibilityPage() {
  const { user } = useAuth();
  const navigate = useNavigate();
  const [items, setItems] = useState<Comparison[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!user) return;
    const fetchComparisons = async () => {
      try {
        const data = (await comparisons.list()) as any[];

        if (data && data.length > 0) {
          // Filter to only comparisons involving the current user
          const userComparisons = data.filter(
            (c) => c.user1_id === user.id || c.user2_id === user.id
          );

          const otherIds = userComparisons.map((c) =>
            c.user1_id === user.id ? c.user2_id : c.user1_id
          );
          const uniqueOtherIds = [...new Set(otherIds)];

          // Fetch profiles for the other users
          const allProfiles = (await profiles.list()) as any[];
          const nameMap = new Map(
            allProfiles
              .filter((p: any) => uniqueOtherIds.includes(p.user_id))
              .map((p: any) => [p.user_id, p.name])
          );

          // Deduplicate: keep only the latest comparison per pair
          const seen = new Map<string, any>();
          for (const c of userComparisons) {
            const pairKey = [c.user1_id, c.user2_id].sort().join("-");
            const existing = seen.get(pairKey);
            if (!existing || new Date(c.created_at) > new Date(existing.created_at)) {
              seen.set(pairKey, c);
            }
          }
          const unique = Array.from(seen.values());

          setItems(
            unique.map((c) => {
              const otherId = c.user1_id === user.id ? c.user2_id : c.user1_id;
              return { ...c, otherName: nameMap.get(otherId) ?? "Usuário" };
            })
          );
        }
      } catch { /* silently fail */ } finally {
        setLoading(false);
      }
    };
    fetchComparisons();
  }, [user]);

  return (
    <AdminLayout>
      <div className="animate-fade-in space-y-6">
        <div className="flex items-center gap-3">
          <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10">
            <GitCompareArrows className="h-5 w-5 text-primary" />
          </div>
          <div>
            <h1 className="text-2xl font-bold text-foreground">Compatibilidade</h1>
            <p className="text-sm text-muted-foreground">Comparações de perfil envolvendo você</p>
          </div>
        </div>

        {loading ? (
          <div className="space-y-3">{[1, 2, 3].map((i) => <Skeleton key={i} className="h-16 w-full" />)}</div>
        ) : items.length === 0 ? (
          <Card>
            <CardContent className="py-12 text-center">
              <Users className="mx-auto h-10 w-10 text-muted-foreground" />
              <p className="mt-3 text-muted-foreground">Nenhuma comparação encontrada.</p>
            </CardContent>
          </Card>
        ) : (
          <div className="space-y-3">
            {items.map((item) => (
              <Card key={item.id} className="shadow-card hover:shadow-card-hover transition-shadow">
                <CardContent className="flex items-center justify-between p-4">
                  <div>
                    <p className="font-medium text-foreground">{item.otherName}</p>
                    <div className="mt-1 flex items-center gap-3 text-sm text-muted-foreground">
                      {item.compatibility_score !== null && (
                        <span className="font-semibold text-primary">{item.compatibility_score}% compatível</span>
                      )}
                      <span>{format(new Date(item.created_at), "dd MMM yyyy", { locale: ptBR })}</span>
                    </div>
                  </div>
                  <Button size="sm" variant="outline" onClick={() => navigate(`/comparar-perfis`)} className="gap-1">
                    <Eye className="h-3 w-3" />
                    Detalhes
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
