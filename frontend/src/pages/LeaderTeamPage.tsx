import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { profiles as profilesApi, tests as testsApi } from "@/lib/api";
import { useAuth } from "@/contexts/AuthContext";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Users, User, BookOpen } from "lucide-react";
import { SkeletonCard } from "@/components/SkeletonCard";

interface TeamMember {
  user_id: string;
  name: string;
  email: string;
  hasTest: boolean;
}

export default function LeaderTeamPage() {
  const { profile } = useAuth();
  const navigate = useNavigate();
  const [members, setMembers] = useState<TeamMember[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    if (!profile) {
      setIsLoading(false);
      return;
    }

    const fetchTeam = async () => {
      try {
        // Fetch all profiles and test results in parallel
        const [allProfiles, allResults] = await Promise.all([
          profilesApi.list(profile.company_id as string | undefined),
          testsApi.results(),
        ]);

        // Build a set of user_ids that have at least one test result
        const testedUserIds = new Set(
          (allResults as any[]).map((r: any) => r.user_id)
        );

        // Filter to department members (excluding the current leader)
        const departmentMembers = (allProfiles as any[]).filter(
          (p: any) =>
            p.user_id !== profile.user_id &&
            profile.department_id &&
            p.department_id === profile.department_id
        );

        const membersWithTests: TeamMember[] = departmentMembers.map((p: any) => ({
          user_id: p.user_id,
          name: p.name,
          email: p.email,
          hasTest: testedUserIds.has(p.user_id),
        }));

        setMembers(membersWithTests);
      } catch {
        // leave members empty on error
      }
      setIsLoading(false);
    };
    fetchTeam();
  }, [profile]);

  return (
    <AdminLayout>
      <div className="animate-fade-in space-y-6">
        <div className="flex items-center gap-3">
          <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10">
            <Users className="h-5 w-5 text-primary" />
          </div>
          <div>
            <h1 className="text-2xl font-bold text-foreground">Minha Equipe</h1>
            <p className="text-sm text-muted-foreground">Gerencie e acompanhe sua equipe</p>
          </div>
        </div>

        {isLoading ? (
          <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
            {[1, 2, 3].map((i) => <SkeletonCard key={i} />)}
          </div>
        ) : members.length === 0 ? (
          <Card className="border-border bg-card">
            <CardContent className="py-12 text-center">
              <Users className="mx-auto h-10 w-10 text-muted-foreground" />
              <p className="mt-3 text-muted-foreground">Nenhum colaborador encontrado no seu departamento.</p>
            </CardContent>
          </Card>
        ) : (
          <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
            {members.map((m) => (
              <Card key={m.user_id} className="border-border bg-card shadow-card transition-shadow hover:shadow-card-hover">
                <CardHeader className="pb-2">
                  <CardTitle className="flex items-center gap-2 text-base">
                    <User className="h-4 w-4 text-primary" />
                    {m.name}
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <p className="mb-4 text-sm text-muted-foreground">{m.email}</p>
                  {m.hasTest ? (
                    <div className="flex gap-2">
                      <Button
                        size="sm"
                        variant="outline"
                        onClick={() => navigate(`/resultado?userId=${m.user_id}&from=lider-equipe`)}
                      >
                        Ver Perfil
                      </Button>
                      <Button
                        size="sm"
                        onClick={() => navigate(`/lider/guia/${m.user_id}`)}
                        className="gap-1"
                      >
                        <BookOpen className="h-3 w-3" />
                        Guia
                      </Button>
                    </div>
                  ) : (
                    <p className="text-xs text-muted-foreground">Nenhum teste realizado ainda</p>
                  )}
                </CardContent>
              </Card>
            ))}
          </div>
        )}
      </div>
    </AdminLayout>
  );
}
