import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Badge } from "@/components/ui/badge";
import { cn } from "@/lib/utils";

interface ChangelogEntry {
  type: "novidade" | "melhoria" | "corrigido";
  text: string;
}

interface ChangelogVersion {
  version: string;
  date: string;
  current?: boolean;
  entries: ChangelogEntry[];
}

const CHANGELOG: ChangelogVersion[] = [
  {
    version: "v1.3.1",
    date: "15/06/2026",
    current: true,
    entries: [
      {
        type: "corrigido",
        text: "Ponto: dias com batida faltando (ex.: esqueceu a saída) aparecem como 'Incompleto' para correção, em vez de 'Trabalhando'. A contagem de entrada/saída reseta corretamente a cada dia.",
      },
      {
        type: "corrigido",
        text: "Ponto: a sequência entrada/saída agora é sempre alternada pela ordem dos horários, corrigindo casos com duas 'Entrada' (ou duas 'Saída') seguidas após ajustes ou registros manuais — o total de horas também passa a refletir o pareamento correto.",
      },
    ],
  },
  {
    version: "v1.3.0",
    date: "15/06/2026",
    entries: [
      {
        type: "novidade",
        text: "Ponto: o colaborador pode registrar uma batida manualmente (ex.: esquecimento) e solicitar o ajuste do horário de uma batida — ambos vão para aprovação do RH.",
      },
      {
        type: "novidade",
        text: "Ponto: o RH tem uma aba 'Solicitações' para confirmar ou cancelar registros manuais e aprovar ou negar ajustes de horário.",
      },
      {
        type: "novidade",
        text: "Ponto: cada batida ajustada guarda o histórico completo (horário anterior, novo horário, motivo e quem aprovou) — nenhuma informação é perdida.",
      },
    ],
  },
  {
    version: "v1.2.0",
    date: "15/06/2026",
    entries: [
      {
        type: "novidade",
        text: "Ponto Eletrônico: colaboradores habilitados podem bater ponto pelo sistema (entrada/saída), com horário, localização e observação opcional.",
      },
      {
        type: "novidade",
        text: "Ponto: o RH define quem bate ponto e a jornada diária de cada colaborador (padrão 8h30, configurável).",
      },
      {
        type: "novidade",
        text: "Ponto: o gestor acompanha as batidas do dia e por período, com total de horas trabalhadas, e pode corrigir ou adicionar batidas.",
      },
    ],
  },
  {
    version: "v1.1.0",
    date: "15/06/2026",
    entries: [
      {
        type: "novidade",
        text: "Metas: nota de atingimento por curva — o realizado vira uma nota (%), com 100% sempre no valor alvo total. Funciona também em metas de redução.",
      },
      {
        type: "novidade",
        text: "Metas: agora é possível editar e excluir uma meta, e reabrir um mês já fechado.",
      },
      {
        type: "corrigido",
        text: "Metas: corrigido o cálculo das metas de média, que mostrava desvios acumulados incorretos.",
      },
      {
        type: "novidade",
        text: "Benefícios: o Vale-Transporte ganhou um ajuste de dias úteis no catálogo (+/-), para meses que precisam de um dia a mais ou a menos.",
      },
      {
        type: "melhoria",
        text: "Campos de seleção de pessoa e de departamento agora permitem buscar por texto, facilitando achar o nome em listas grandes.",
      },
      {
        type: "melhoria",
        text: "Adicionados pontos de ajuda (?) explicando os conceitos das Metas (nota, curva, tipos de cálculo, peso e colunas).",
      },
    ],
  },
  {
    version: "v1.0.0",
    date: "21/05/2026",
    entries: [
      {
        type: "novidade",
        text: "Lançamento do TalentHS — sistema de gestão de pessoas da Health & Safety Tech.",
      },
      {
        type: "novidade",
        text: "Módulo de Colaboradores com cadastro, edição e gestão de perfis.",
      },
      {
        type: "novidade",
        text: "Módulo de Feedbacks com envio por RH e resposta pelos colaboradores.",
      },
      {
        type: "novidade",
        text: "Módulo de Documentos com upload, filtros por destino e download autenticado.",
      },
      {
        type: "novidade",
        text: "Módulo de Ausências com solicitação, aprovação e tipos configuráveis.",
      },
      {
        type: "novidade",
        text: "Módulo de Benefícios com categorias e gestão individual.",
      },
      {
        type: "novidade",
        text: "Módulo de Onboarding com checklists e acompanhamento por colaborador.",
      },
      {
        type: "novidade",
        text: "Dashboard do colaborador com visão personalizada de desenvolvimento.",
      },
      {
        type: "novidade",
        text: "Sistema de avaliações psicométricas DISC + Big Five com histórico de resultados.",
      },
      {
        type: "novidade",
        text: "Chat IA contextualizado com perfil comportamental do colaborador.",
      },
    ],
  },
];

const TYPE_CONFIG = {
  novidade: { label: "Novidade", className: "bg-blue-500/15 text-blue-400 border-blue-500/20" },
  melhoria: { label: "Melhoria", className: "bg-emerald-500/15 text-emerald-400 border-emerald-500/20" },
  corrigido: { label: "Corrigido", className: "bg-amber-500/15 text-amber-400 border-amber-500/20" },
};

interface Props {
  open: boolean;
  onOpenChange: (open: boolean) => void;
}

export function ChangelogModal({ open, onOpenChange }: Props) {
  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-lg max-h-[80vh] flex flex-col p-0 gap-0">
        <DialogHeader className="px-6 pt-6 pb-4 border-b shrink-0">
          <DialogTitle className="text-xl font-bold">O que há de novo?</DialogTitle>
          <p className="text-sm text-muted-foreground">Atualizações recentes do TalentHS</p>
        </DialogHeader>

        <div className="flex-1 overflow-y-auto px-6 py-4 space-y-6">
          {CHANGELOG.map((version) => (
            <div key={version.version}>
              {/* Version header */}
              <div className="flex items-center gap-3 mb-3">
                <span
                  className={cn(
                    "inline-flex items-center rounded-md px-2.5 py-1 text-xs font-bold tracking-wide",
                    version.current
                      ? "bg-primary text-primary-foreground"
                      : "bg-secondary text-muted-foreground"
                  )}
                >
                  {version.version}
                </span>
                <span className="text-xs text-muted-foreground">{version.date}</span>
                {version.current && (
                  <Badge variant="outline" className="text-[10px] h-5 bg-primary/10 text-primary border-primary/20">
                    Versão atual
                  </Badge>
                )}
              </div>

              {/* Entries */}
              <div className="space-y-2">
                {version.entries.map((entry, i) => {
                  const config = TYPE_CONFIG[entry.type];
                  return (
                    <div
                      key={i}
                      className="flex gap-3 rounded-lg border bg-card p-3"
                    >
                      <span
                        className={cn(
                          "inline-flex shrink-0 items-center rounded-md border px-2 py-0.5 text-[10px] font-semibold h-fit mt-0.5",
                          config.className
                        )}
                      >
                        {config.label}
                      </span>
                      <p className="text-sm text-foreground/80 leading-relaxed">{entry.text}</p>
                    </div>
                  );
                })}
              </div>
            </div>
          ))}
        </div>

        <div className="px-6 py-3 border-t shrink-0 text-center">
          <p className="text-[11px] text-muted-foreground/50">
            TalentHS — desenvolvido internamente pela equipe
          </p>
        </div>
      </DialogContent>
    </Dialog>
  );
}
