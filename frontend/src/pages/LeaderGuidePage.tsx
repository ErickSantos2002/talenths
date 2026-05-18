import { useState, useEffect } from "react";
import { useParams } from "react-router-dom";
import { useAuth } from "@/contexts/AuthContext";
import { getToken } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Loader2, MessageCircle, Zap, AlertTriangle } from "lucide-react";
import { toast } from "@/hooks/use-toast";

interface Guide {
  comunicacao: string[];
  motivacao: string[];
  pontos_atencao: string[];
}

export default function LeaderGuidePage() {
  const { userId } = useParams<{ userId: string }>();
  const [name, setName] = useState("");
  const [guide, setGuide] = useState<Guide | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    if (!userId) return;

    const fetchGuide = async () => {
      const token = getToken();

      const res = await fetch(
        `${import.meta.env.VITE_API_URL ?? "http://localhost:8000"}/leader-guide`,
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${token}`,
          },
          body: JSON.stringify({ user_id: userId }),
        }
      );

      if (!res.ok) {
        const err = await res.json().catch(() => ({}));
        toast({
          title: "Erro ao gerar guia",
          description: err.error || "Tente novamente mais tarde.",
          variant: "destructive",
        });
        setIsLoading(false);
        return;
      }

      const data = await res.json();
      setName(data.name || "Colaborador");
      setGuide(data.guide);
      setIsLoading(false);
    };
    fetchGuide();
  }, [userId]);

  const sections = [
    { key: "comunicacao" as const, title: "Como Comunicar", icon: MessageCircle, color: "text-primary" },
    { key: "motivacao" as const, title: "Como Motivar", icon: Zap, color: "text-emerald-500" },
    { key: "pontos_atencao" as const, title: "Pontos de Atenção", icon: AlertTriangle, color: "text-brand-red" },
  ];

  return (
    <AdminLayout>
      <div className="animate-fade-in max-w-3xl space-y-6">
        <div>
          <h1 className="text-2xl font-bold text-foreground">
            Guia de Gestão {name && `- ${name}`}
          </h1>
          <p className="text-sm text-muted-foreground">
            Dicas personalizadas baseadas no perfil comportamental
          </p>
        </div>

        {isLoading ? (
          <div className="flex items-center justify-center py-16">
            <Loader2 className="h-8 w-8 animate-spin text-primary" />
            <span className="ml-3 text-muted-foreground">Gerando guia com IA...</span>
          </div>
        ) : guide ? (
          <div className="space-y-4">
            {sections.map(({ key, title, icon: Icon, color }) => (
              <Card key={key} className="border-border bg-card shadow-card">
                <CardHeader className="pb-2">
                  <CardTitle className={`flex items-center gap-2 text-lg ${color}`}>
                    <Icon className="h-5 w-5" />
                    {title}
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <ul className="space-y-2">
                    {(guide[key] || []).map((item, i) => (
                      <li key={i} className="flex items-start gap-2 text-sm text-muted-foreground">
                        <span className="mt-1 h-1.5 w-1.5 shrink-0 rounded-full bg-primary" />
                        {item}
                      </li>
                    ))}
                  </ul>
                </CardContent>
              </Card>
            ))}
          </div>
        ) : (
          <Card className="border-border bg-card">
            <CardContent className="py-12 text-center text-muted-foreground">
              Não foi possível gerar o guia. Verifique se o colaborador já realizou o teste.
            </CardContent>
          </Card>
        )}
      </div>
    </AdminLayout>
  );
}
