import { useAuth } from "@/contexts/AuthContext";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import {
  Users, Building2, MessageSquare, FileText, ClipboardCheck,
  ArrowRight, UserPen, HeartHandshake, CalendarDays, BarChart2,
} from "lucide-react";
import { useQuery } from "@tanstack/react-query";
import { profiles, departments, feedbacks, documents } from "@/lib/api";
import { Skeleton } from "@/components/ui/skeleton";
import { Link } from "react-router-dom";

function StatCard({
  title, value, icon: Icon, color, loading,
}: {
  title: string;
  value: number;
  icon: React.ElementType;
  color: string;
  loading: boolean;
}) {
  return (
    <Card className="transition-all hover:shadow-md hover:border-primary/20">
      <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
        <CardTitle className="text-sm font-medium text-muted-foreground">{title}</CardTitle>
        <div className={`rounded-lg p-2 ${color}`}>
          <Icon className="h-4 w-4" />
        </div>
      </CardHeader>
      <CardContent>
        {loading ? (
          <Skeleton className="h-9 w-16" />
        ) : (
          <div className="text-3xl font-bold tracking-tight">{value}</div>
        )}
      </CardContent>
    </Card>
  );
}

function QuickLinkCard({
  title, description, icon: Icon, to, color,
}: {
  title: string;
  description: string;
  icon: React.ElementType;
  to: string;
  color: string;
}) {
  return (
    <Link to={to}>
      <Card className="group h-full transition-all hover:shadow-md hover:border-primary/30 cursor-pointer">
        <CardContent className="p-5 flex items-start gap-4">
          <div className={`mt-0.5 rounded-lg p-2.5 shrink-0 ${color}`}>
            <Icon className="h-5 w-5" />
          </div>
          <div className="flex-1 min-w-0">
            <p className="font-semibold text-sm">{title}</p>
            <p className="text-xs text-muted-foreground mt-0.5 leading-relaxed">{description}</p>
          </div>
          <ArrowRight className="h-4 w-4 text-muted-foreground/40 mt-0.5 shrink-0 transition-transform group-hover:translate-x-1 group-hover:text-primary" />
        </CardContent>
      </Card>
    </Link>
  );
}

function CollaboratorDashboard({ profile }: { profile: any }) {
  const quickLinks = [
    { title: "Meu Perfil", description: "Atualize suas informações pessoais", icon: UserPen, to: "/meu-perfil", color: "bg-primary/10 text-primary" },
    { title: "Feedbacks", description: "Veja e responda feedbacks do RH", icon: MessageSquare, to: "/meus-feedbacks", color: "bg-blue-500/10 text-blue-500" },
    { title: "Documentos", description: "Acesse documentos enviados para você", icon: FileText, to: "/meus-documentos", color: "bg-amber-500/10 text-amber-500" },
    { title: "Nossa Cultura", description: "Conheça os valores da empresa", icon: HeartHandshake, to: "/cultura", color: "bg-rose-500/10 text-rose-500" },
    { title: "Calendário", description: "Eventos e datas importantes", icon: CalendarDays, to: "/calendario", color: "bg-violet-500/10 text-violet-500" },
    { title: "Pesquisas", description: "Participe das pesquisas de clima", icon: BarChart2, to: "/pesquisas", color: "bg-cyan-500/10 text-cyan-500" },
  ];

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">
          Olá, {profile?.name?.split(" ")[0] ?? "Colaborador"} 👋
        </h1>
        <p className="mt-1 text-muted-foreground">
          Bem-vindo ao seu painel. Acesse rapidamente tudo que é seu.
        </p>
      </div>

      <div>
        <h2 className="text-sm font-semibold text-muted-foreground uppercase tracking-widest mb-4">
          Acesso Rápido
        </h2>
        <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {quickLinks.map((link) => (
            <QuickLinkCard key={link.to} {...link} />
          ))}
        </div>
      </div>
    </div>
  );
}

export default function DashboardPage() {
  const { profile, hasRole, selectedCompanyId } = useAuth();
  const isManager = hasRole("master_admin") || hasRole("manager");
  const isMaster = hasRole("master_admin");
  const companyFilter = isMaster ? selectedCompanyId : profile?.company_id;

  const { data: profilesData = [], isLoading: loadingProfiles } = useQuery({
    queryKey: ["profiles", companyFilter],
    queryFn: () => profiles.list(companyFilter ?? undefined),
    enabled: !!isManager,
  });

  const { data: deptsData = [], isLoading: loadingDepts } = useQuery({
    queryKey: ["departments", companyFilter],
    queryFn: () => departments.list(companyFilter ?? undefined),
    enabled: !!isManager,
  });

  const { data: feedbacksData = [], isLoading: loadingFeedbacks } = useQuery({
    queryKey: ["admin-feedbacks"],
    queryFn: () => feedbacks.list(),
    enabled: !!isManager,
  });

  const { data: docsData = [], isLoading: loadingDocs } = useQuery({
    queryKey: ["admin-documents"],
    queryFn: () => documents.list(),
    enabled: !!isManager,
  });

  if (!isManager) {
    return (
      <AdminLayout>
        <CollaboratorDashboard profile={profile} />
      </AdminLayout>
    );
  }

  const loading = loadingProfiles || loadingDepts || loadingFeedbacks || loadingDocs;

  const stats = [
    { title: "Colaboradores", value: (profilesData as any[]).length, icon: Users, color: "bg-primary/10 text-primary", loading },
    { title: "Departamentos", value: (deptsData as any[]).length, icon: Building2, color: "bg-blue-500/10 text-blue-500", loading },
    { title: "Feedbacks Ativos", value: (feedbacksData as any[]).length, icon: MessageSquare, color: "bg-violet-500/10 text-violet-500", loading },
    { title: "Documentos", value: (docsData as any[]).length, icon: FileText, color: "bg-amber-500/10 text-amber-500", loading },
  ];

  const adminLinks = [
    { title: "Colaboradores", description: "Gerencie os membros da equipe e departamentos", icon: Users, to: "/admin/colaboradores", color: "bg-primary/10 text-primary" },
    { title: "Feedbacks", description: "Crie e acompanhe feedbacks enviados ao time", icon: MessageSquare, to: "/admin/feedbacks", color: "bg-violet-500/10 text-violet-500" },
    { title: "Documentos", description: "Envie e organize documentos para colaboradores", icon: FileText, to: "/admin/documentos", color: "bg-amber-500/10 text-amber-500" },
    { title: "Testes", description: "Crie avaliações e acompanhe tentativas", icon: ClipboardCheck, to: "/admin/testes", color: "bg-cyan-500/10 text-cyan-500" },
    { title: "Empresa", description: "Perfil, missão, visão e valores da empresa", icon: Building2, to: "/admin/empresa", color: "bg-blue-500/10 text-blue-500" },
    { title: "Pesquisas", description: "Pesquisas de clima e engajamento", icon: BarChart2, to: "/admin/pesquisas", color: "bg-rose-500/10 text-rose-500" },
  ];

  return (
    <AdminLayout>
      <div className="space-y-8">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Dashboard</h1>
          <p className="mt-1 text-muted-foreground">
            Bem-vindo de volta, {profile?.name?.split(" ")[0] ?? "Usuário"}. Aqui está um resumo da empresa.
          </p>
        </div>

        <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
          {stats.map((stat) => (
            <StatCard key={stat.title} {...stat} />
          ))}
        </div>

        <div>
          <h2 className="text-sm font-semibold text-muted-foreground uppercase tracking-widest mb-4">
            Módulos
          </h2>
          <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
            {adminLinks.map((link) => (
              <QuickLinkCard key={link.to} {...link} />
            ))}
          </div>
        </div>
      </div>
    </AdminLayout>
  );
}
