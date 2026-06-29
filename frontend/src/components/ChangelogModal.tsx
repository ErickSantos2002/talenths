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
    version: "v1.7.1",
    date: "29/06/2026",
    current: true,
    entries: [
      {
        type: "corrigido",
        text: "Metas: a nota pela curva agora é limitada entre 0 e 120 — acima do ponto de 120% ela trava em 120 (em vez de extrapolar para valores como 175) e não fica negativa abaixo do mínimo. O cálculo dentro da curva permanece o mesmo.",
      },
    ],
  },
  {
    version: "v1.7.0",
    date: "29/06/2026",
    entries: [
      {
        type: "novidade",
        text: "Metas: opção de 'curva de nota' por meta. Ao criar/editar, você pode ativar e definir quais percentuais do 'Do ano' correspondem às notas 80, 100 e 120 — entre eles a nota é interpolada. A nota aparece no detalhe da meta.",
      },
    ],
  },
  {
    version: "v1.6.10",
    date: "29/06/2026",
    entries: [
      {
        type: "corrigido",
        text: "Metas: os campos de valor (peso, valor alvo e os meses da mensalização) deixam de vir com '0' preenchido — agora começam vazios e podem ser apagados normalmente.",
      },
    ],
  },
  {
    version: "v1.6.9",
    date: "29/06/2026",
    entries: [
      {
        type: "melhoria",
        text: "Metas: o Desvio (mensal e acumulado) agora mostra também o percentual de atingimento entre parênteses — ex.: '+5 (150%)', onde 150% = realizado ÷ meta.",
      },
    ],
  },
  {
    version: "v1.6.8",
    date: "29/06/2026",
    entries: [
      {
        type: "novidade",
        text: "Metas: cada meta agora tem um menu (⋮) à direita com Editar, Mover para cima, Mover para baixo e Excluir. A ordem das metas dentro do time fica salva.",
      },
    ],
  },
  {
    version: "v1.6.7",
    date: "29/06/2026",
    entries: [
      {
        type: "corrigido",
        text: "Metas: ao criar/editar uma meta, mudar Objetivo, Expressão de cálculo ou Tipo de resultado e navegar entre as etapas (Próximo/Voltar) não reverte mais a seleção para o valor padrão.",
      },
    ],
  },
  {
    version: "v1.6.6",
    date: "29/06/2026",
    entries: [
      {
        type: "melhoria",
        text: "Metas: no progresso mensal, os meses ainda sem valor realizado passam a mostrar '—' nas colunas de realizado e desvio (não repetem mais o valor acumulado do mês anterior). A 'Meta acumulado' continua sendo exibida.",
      },
      {
        type: "melhoria",
        text: "Metas: adicionada uma divisória visual entre as colunas pontuais e as acumuladas, para facilitar a leitura da tabela.",
      },
    ],
  },
  {
    version: "v1.6.5",
    date: "29/06/2026",
    entries: [
      {
        type: "novidade",
        text: "Metas: na mensalização, agora há três modos de distribuir o valor pelos meses — dividir igualmente (alvo ÷ 12), repetir o valor alvo em todos os meses, ou personalizado (você digita cada mês).",
      },
    ],
  },
  {
    version: "v1.6.4",
    date: "29/06/2026",
    entries: [
      {
        type: "melhoria",
        text: "Metas: removido o botão 'Nova Meta' duplicado que aparecia dentro de cada time — o botão do topo da página continua disponível.",
      },
    ],
  },
  {
    version: "v1.6.3",
    date: "29/06/2026",
    entries: [
      {
        type: "melhoria",
        text: "Metas: ao criar ou editar um ciclo, a escolha de data inicial e final passou a usar um calendário próprio no tema do sistema (escuro), com seletor de mês e ano, no lugar do calendário padrão do navegador.",
      },
    ],
  },
  {
    version: "v1.6.2",
    date: "29/06/2026",
    entries: [
      {
        type: "melhoria",
        text: "Campos de busca (Time, Responsável e demais seletores): agora dá para digitar direto no campo. Basta dar TAB e começar a digitar para filtrar — sem precisar do mouse. Use as setas para navegar e Enter para escolher.",
      },
    ],
  },
  {
    version: "v1.6.1",
    date: "16/06/2026",
    entries: [
      {
        type: "novidade",
        text: "Metas: é possível excluir um ciclo pelo seletor. Por segurança, só apaga ciclos sem metas (se houver metas, o sistema avisa para movê-las ou excluí-las antes).",
      },
    ],
  },
  {
    version: "v1.6.0",
    date: "16/06/2026",
    entries: [
      {
        type: "novidade",
        text: "Metas: botão para exportar a visão geral do ciclo em planilha (CSV) com os indicadores de cada time e meta.",
      },
      {
        type: "novidade",
        text: "Metas: dá para editar um ciclo (nome, datas, status) direto no seletor de ciclos.",
      },
      {
        type: "melhoria",
        text: "Metas: a divisão por 'Departamento' passou a se chamar 'Time'.",
      },
    ],
  },
  {
    version: "v1.5.0",
    date: "16/06/2026",
    entries: [
      {
        type: "novidade",
        text: "Metas: o histórico de cada meta agora tem comentários, com possibilidade de anexar arquivos (PDF, Excel, imagem) e baixá-los.",
      },
    ],
  },
  {
    version: "v1.4.1",
    date: "16/06/2026",
    entries: [
      {
        type: "melhoria",
        text: "Metas: ao atualizar o realizado de um mês, o sistema mostra o planejado ('/ meta') e permite limpar o mês.",
      },
      {
        type: "melhoria",
        text: "Metas: ao criar uma meta, a opção 'Dividir o valor alvo igualmente entre os meses' virou um marcador que distribui automaticamente.",
      },
    ],
  },
  {
    version: "v1.4.0",
    date: "16/06/2026",
    entries: [
      {
        type: "novidade",
        text: "Metas: seletor de mês na visão geral — escolha o mês de referência e os indicadores (Mês / Até o mês / Do ano) se ajustam.",
      },
      {
        type: "novidade",
        text: "Metas: cada time passa a exibir os indicadores agregados no topo (média ponderada pelo peso das metas).",
      },
    ],
  },
  {
    version: "v1.3.2",
    date: "16/06/2026",
    entries: [
      {
        type: "melhoria",
        text: "Metas: os três indicadores agora se chamam Mês, Até o mês e Do ano, deixando mais claro o que cada um representa.",
      },
      {
        type: "melhoria",
        text: "Metas: o indicador 'Do ano' mostra o realizado acumulado sobre o valor alvo do ano. A curva de nota foi removida para simplificar.",
      },
      {
        type: "melhoria",
        text: "Metas: a tabela de detalhe foi renomeada para Meta pontual, Realizado pontual, Meta acumulado e Realizado acumulado.",
      },
    ],
  },
  {
    version: "v1.3.1",
    date: "15/06/2026",
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
