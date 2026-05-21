import { useState } from "react";
import { reports as reportsApi } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { useToast } from "@/hooks/use-toast";
import { FileDown, Users, CalendarOff, Gift, BookOpen, Target } from "lucide-react";

interface ReportCard {
  title: string;
  description: string;
  filename: string;
  icon: React.ElementType;
  iconBg: string;
  iconColor: string;
  fn: () => Promise<void>;
}

const REPORTS: ReportCard[] = [
  {
    title: "Colaboradores",
    description: "Lista completa com nome, e-mail, departamento, cargo, data de admissão e nascimento.",
    filename: "colaboradores.csv",
    icon: Users,
    iconBg: "bg-primary/10",
    iconColor: "text-primary",
    fn: reportsApi.collaborators,
  },
  {
    title: "Ausências",
    description: "Todas as solicitações de ausência com tipo, período, status e notas do gestor.",
    filename: "ausencias.csv",
    icon: CalendarOff,
    iconBg: "bg-amber-500/10",
    iconColor: "text-amber-400",
    fn: reportsApi.absences,
  },
  {
    title: "Benefícios",
    description: "Benefícios atribuídos por colaborador com valor, fornecedor e período de vigência.",
    filename: "beneficios.csv",
    icon: Gift,
    iconBg: "bg-rose-500/10",
    iconColor: "text-rose-400",
    fn: reportsApi.benefits,
  },
  {
    title: "PDI",
    description: "Planos de desenvolvimento e ações com status, prazos e datas de conclusão.",
    filename: "pdi.csv",
    icon: Target,
    iconBg: "bg-blue-500/10",
    iconColor: "text-blue-400",
    fn: reportsApi.pdi,
  },
  {
    title: "Treinamentos",
    description: "Cursos e capacitações concluídos por colaborador com carga horária e área.",
    filename: "treinamentos.csv",
    icon: BookOpen,
    iconBg: "bg-violet-500/10",
    iconColor: "text-violet-400",
    fn: reportsApi.learning,
  },
];

export default function ReportsAdminPage() {
  const { toast } = useToast();
  const [loading, setLoading] = useState<string | null>(null);

  const handleDownload = async (report: ReportCard) => {
    setLoading(report.filename);
    try {
      await report.fn();
      toast({ title: `Relatório "${report.title}" baixado com sucesso.` });
    } catch (e: unknown) {
      const message = e instanceof Error ? e.message : "Erro desconhecido";
      toast({ title: "Erro ao gerar relatório", description: message, variant: "destructive" });
    } finally {
      setLoading(null);
    }
  };

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div className="flex items-center gap-3">
          <FileDown className="h-6 w-6 text-primary" />
          <div>
            <h1 className="text-2xl font-bold tracking-tight">Relatórios</h1>
            <p className="text-sm text-muted-foreground">
              Exporte dados em formato CSV — compatível com Excel, Google Planilhas e outros.
            </p>
          </div>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          {REPORTS.map((report) => (
            <Card key={report.filename} className="flex flex-col">
              <CardContent className="p-5 flex flex-col gap-3 flex-1">
                <div className="flex items-center gap-3">
                  <div className={`flex h-10 w-10 items-center justify-center rounded-lg ${report.iconBg}`}>
                    <report.icon className={`h-5 w-5 ${report.iconColor}`} />
                  </div>
                  <h2 className="font-semibold text-sm">{report.title}</h2>
                </div>
                <p className="text-xs text-muted-foreground flex-1">{report.description}</p>
                <Button
                  size="sm"
                  variant="outline"
                  className="w-full mt-auto"
                  disabled={loading === report.filename}
                  onClick={() => handleDownload(report)}
                >
                  <FileDown className="h-4 w-4 mr-2" />
                  {loading === report.filename ? "Gerando..." : `Baixar ${report.filename}`}
                </Button>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </AdminLayout>
  );
}
