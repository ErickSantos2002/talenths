export interface Behavior {
  key: string;
  label: string;
  pillar: "cultura" | "entregas" | "desenvolvimento";
}

export const BEHAVIORS: Behavior[] = [
  { key: "cultura_visivel", label: "Alinhamento Cultural Visível",         pillar: "cultura" },
  { key: "cultura_genuino", label: "Alinhamento Cultural Genuíno",          pillar: "cultura" },
  { key: "entregas",        label: "Entregas (qualidade, prazo e impacto)", pillar: "entregas" },
  { key: "organizacao",     label: "Organização e priorização",             pillar: "entregas" },
  { key: "colaboracao",     label: "Colaboração",                           pillar: "entregas" },
  { key: "feedback",        label: "Abertura a feedback",                   pillar: "desenvolvimento" },
  { key: "autonomia",       label: "Autonomia e aprendizado",               pillar: "desenvolvimento" },
  { key: "protagonismo",    label: "Protagonismo",                          pillar: "desenvolvimento" },
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
  status: "draft" | "evaluation" | "calibration" | "feedback" | "pdi" | "closed";
  created_at: string;
}

export const EVAL_STATUS_LABELS: Record<EvalCycle["status"], string> = {
  draft: "Rascunho",
  evaluation: "Avaliação",
  calibration: "Calibragem",
  feedback: "Feedback",
  pdi: "PDI",
  closed: "Encerrado",
};

export interface TeamMemberStatus {
  user_id: string;
  name: string;
  email: string;
  department: string | null;
  self_submitted: boolean;
  manager_submitted: boolean;
  score_final: number | null;
  nine_box_quadrant: string | null;
}

export interface ScoreItem {
  behavior_key: string;
  score: number;
  comment?: string;
}

export interface NineBoxEntry {
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
