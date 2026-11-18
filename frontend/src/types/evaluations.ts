export interface Behavior {
  key: string;
  label: string;
  description: string;
  pillar: "cultura" | "entregas" | "desenvolvimento";
}

// Mesmo texto de backend/app/evaluation_rules.py (material da consultoria de RH).
export const BEHAVIORS: Behavior[] = [
  {
    key: "cultura_visivel", pillar: "cultura",
    label: "Alinhamento Cultural Visível (comportamento em público)",
    description: "Demonstra, no dia a dia e na frente das pessoas, comportamentos alinhados à Cultura H&S, atuando com foco na proteção da vida, no cuidado com o cliente, na colaboração com o time, na responsabilidade com as entregas e no respeito à ética, à segurança e às normas da empresa.",
  },
  {
    key: "cultura_genuino", pillar: "cultura",
    label: "Alinhamento Cultural Genuíno (postura consistente)",
    description: "Mantém uma postura coerente com a Cultura H&S mesmo fora do ambiente formal, demonstrando integridade, respeito, responsabilidade e compromisso real com a segurança, com as pessoas e com a empresa, sem atitudes ou discursos que enfraqueçam o time, a confiança ou a cultura.",
  },
  {
    key: "entregas", pillar: "entregas",
    label: "Entregas (qualidade, prazo e impacto)",
    description: "Entrega o que foi combinado, com qualidade, dentro do prazo e gerando impacto positivo para a área e para o negócio.",
  },
  {
    key: "organizacao", pillar: "entregas",
    label: "Organização e priorização",
    description: "Organiza suas atividades, define prioridades corretamente e gerencia bem o tempo e as demandas do dia a dia.",
  },
  {
    key: "colaboracao", pillar: "entregas",
    label: "Colaboração entre as pessoas do time e outras áreas",
    description: "Colabora ativamente com o time e com outras áreas, compartilhando informações e contribuindo para objetivos comuns.",
  },
  {
    key: "feedback", pillar: "desenvolvimento",
    label: "Abertura a feedback",
    description: "Recebe feedbacks com maturidade, escuta com atenção e demonstra disposição para ajustar comportamentos e melhorar.",
  },
  {
    key: "autonomia", pillar: "desenvolvimento",
    label: "Autonomia e aprendizado",
    description: "Atua com autonomia nas suas responsabilidades e busca aprender continuamente para evoluir no desempenho.",
  },
  {
    key: "protagonismo", pillar: "desenvolvimento",
    label: "Protagonismo com o próprio desenvolvimento",
    description: "Assume responsabilidade pelo próprio desenvolvimento, busca oportunidades de crescimento e aplica aprendizados no dia a dia.",
  },
];

export const PILLAR_INFO = {
  cultura:       { label: "Cultura e Comportamentos", weight: 0.40, color: "text-violet-500" },
  entregas:      { label: "Entregas e Resultados",    weight: 0.30, color: "text-blue-500" },
  desenvolvimento: { label: "Desenvolvimento e Evolução", weight: 0.30, color: "text-emerald-500" },
} as const;

export const SCORE_LABELS: Record<number, string> = {
  1: "Precisa Melhorar",
  2: "Tá no Caminho",
  3: "Atende às Expectativas",
  4: "Tá Mandando Bem",
  5: "É Referência",
};

export interface EvalCycle {
  id: string;
  company_id: string;
  management_cycle_id: string | null;
  name: string;
  eval_start: string | null;
  eval_end: string | null;
  calibration_start: string | null;
  calibration_end: string | null;
  feedback_start: string | null;
  feedback_end: string | null;
  pdi_start: string | null;
  pdi_end: string | null;
  /** Etapa em que o ciclo está hoje (pelas datas, se `stage_by_dates`). */
  status: EvalStatus;
  /** Etapa escolhida à mão; vale quando `stage_by_dates` é falso. */
  manual_status: EvalStatus;
  stage_by_dates: boolean;
  created_at: string;
}

export type EvalStatus = "draft" | "evaluation" | "calibration" | "feedback" | "pdi" | "closed";

export const EVAL_STAGES = [
  { status: "evaluation", label: "Avaliação", start: "eval_start", end: "eval_end" },
  { status: "calibration", label: "Calibragem", start: "calibration_start", end: "calibration_end" },
  { status: "feedback", label: "Feedback", start: "feedback_start", end: "feedback_end" },
  { status: "pdi", label: "PDI", start: "pdi_start", end: "pdi_end" },
] as const;

export const EVAL_STATUS_LABELS: Record<EvalStatus, string> = {
  draft: "Rascunho",
  evaluation: "Avaliação",
  calibration: "Calibragem",
  feedback: "Feedback",
  pdi: "PDI",
  closed: "Encerrado",
};

export interface TeamMemberStatus {
  deactivated_at?: string | null;
  user_id: string;
  name: string;
  email: string;
  department: string | null;
  manager_user_id: string | null;
  manager_name: string | null;
  manager_deactivated: boolean;
  self_submitted: boolean;
  manager_submitted: boolean;
  score_final: number | null;
  score_manager: number | null;
  score_self: number | null;
  nine_box_quadrant: string | null;
}

export interface MyTeamMember {
  user_id: string;
  name: string;
  email: string;
  department: string | null;
  self_submitted: boolean;
  manager_submitted: boolean;
  submitted_at: string | null;
  scores: ScoreItem[];
}

export interface ScoreItem {
  behavior_key: string;
  score: number;
  comment?: string;
}

export interface NineBoxEntry {
  deactivated_at?: string | null;
  user_id: string;
  name: string;
  email: string;
  department: string | null;
  score_final: number | null;
  nine_box_x: number;
  nine_box_y: number;
  nine_box_quadrant: string;
  calibrated: boolean;
}

export const NINE_BOX_QUADRANTS: Record<string, { label: string; eligible: boolean }> = {
  "Insuficiente":            { label: "Insuficiente",            eligible: false },
  "Contribuidor":            { label: "Contribuidor",            eligible: false },
  "Alcança Resultados":      { label: "Alcança Resultados",      eligible: false },
  "Competência Consistente": { label: "Competência Consistente", eligible: false },
  "Essenciais":              { label: "Essenciais",              eligible: false },
  "Futuro Talento":          { label: "Futuro Talento",          eligible: true  },
  "Alta Competência":        { label: "Alta Competência",        eligible: true  },
  "Forte Talento":           { label: "Forte Talento",           eligible: true  },
  "Super Talento":           { label: "Super Talento",           eligible: true  },
};
