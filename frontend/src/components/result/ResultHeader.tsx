import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Brain, Building2, Calendar, Home, User } from "lucide-react";
import { useNavigate, useSearchParams } from "react-router-dom";
import { useAuth } from "@/contexts/AuthContext";
import { dniaDimensions, discToDisplayKey } from "@/data/dniaLabels";

interface ResultHeaderProps {
  userName: string;
  companyName?: string;
  dominantProfile: string;
  completedAt: string;
}

export function ResultHeader({ userName, companyName, dominantProfile, completedAt }: ResultHeaderProps) {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const { hasRole } = useAuth();
  const isAdmin = hasRole("master_admin") || hasRole("manager");
  const fromLeaderTeam = searchParams.get("from") === "lider-equipe";

  const formattedDate = new Date(completedAt).toLocaleDateString("pt-BR", {
    day: "2-digit",
    month: "long",
    year: "numeric",
  });

  return (
    <div className="space-y-4">
      <Button
        variant="outline"
        size="sm"
        className="gap-2"
        onClick={() => {
          if (isLeader && fromLeaderTeam) {
            navigate("/lider/equipe");
          } else if (isAdmin) {
            navigate("/admin/testes");
          } else {
            navigate("/");
          }
        }}
      >
        <Home className="h-4 w-4" />
        {isLeader && fromLeaderTeam ? "Voltar à Equipe" : isAdmin ? "Voltar ao Painel" : "Voltar ao Início"}
      </Button>

      <Card className="border-border bg-card shadow-card">
        <CardContent className="pt-6">
          <div className="flex flex-col items-center gap-4 md:flex-row md:items-start">
            <div className="flex h-12 w-12 sm:h-16 sm:w-16 shrink-0 items-center justify-center rounded-2xl bg-primary/10">
              <Brain className="h-6 w-6 sm:h-8 sm:w-8 text-primary" />
            </div>
            <div className="flex-1 text-center md:text-left">
              <h1 className="text-xl sm:text-2xl font-bold text-foreground">Seu Perfil DNIA</h1>
              <div className="mt-3 flex flex-col sm:flex-row sm:flex-wrap justify-center gap-x-6 gap-y-1.5 sm:gap-y-2 text-sm text-muted-foreground md:justify-start">
                <span className="flex items-center gap-1.5">
                  <User className="h-4 w-4" />
                  {userName}
                </span>
                <span className="flex items-center gap-1.5">
                  <Brain className="h-4 w-4 text-primary" />
                  Perfil {discToDisplayKey[dominantProfile] || dominantProfile} — {dniaDimensions[dominantProfile] || dominantProfile}
                </span>
                {companyName && (
                  <span className="flex items-center gap-1.5">
                    <Building2 className="h-4 w-4" />
                    {companyName}
                  </span>
                )}
                <span className="flex items-center gap-1.5">
                  <Calendar className="h-4 w-4" />
                  {formattedDate}
                </span>
              </div>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
