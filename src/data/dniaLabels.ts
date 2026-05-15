/**
 * dnia – Mapeamento Central de Nomenclatura
 *
 * Este arquivo é a fonte de verdade para toda a nomenclatura proprietária "dnia".
 * As colunas do banco de dados permanecem inalteradas (disc_natural, disc_adapted, big_five).
 * Apenas a camada de exibição usa estes labels.
 */

// Ordem de exibição fixa: D, N, I, A (chaves do banco: D, S, I, C)
export const dniaDisplayOrder = ["D", "S", "I", "C"] as const;

// Mapeamento de chaves do banco (D/I/S/C) para letras de exibição DNIA (D/N/I/A)
export const discToDisplayKey: Record<string, string> = {
  D: "D",
  I: "I",
  S: "N",
  C: "A",
};

// Dimensões do Perfil Comportamental (mapeadas de D/I/S/C)
export const dniaDimensions: Record<string, string> = {
  D: "Determinado",
  I: "Influenciador",
  S: "Navegador",
  C: "Analista",
};

// Dimensões com prefixo de letra DNIA para tabelas e gráficos
export const dniaDimensionLabels: Record<string, string> = {
  D: "D — Determinado",
  I: "I — Influenciador",
  S: "N — Navegador",
  C: "A — Analista",
};

// Traços de Personalidade (mapeados de O/C/E/A/N)
export const dniaTraits: Record<string, string> = {
  O: "Inovação",
  C: "Disciplina",
  E: "Sociabilidade",
  A: "Empatia",
  N: "Resiliência",
};

// Descrições expandidas para UI
export const dniaDescriptions: Record<string, string> = {
  Determinado: "Assertivo, direto, orientado a resultados",
  Influenciador: "Comunicativo, entusiasmado, orientado a pessoas",
  Navegador: "Estável, confiável, orientado à harmonia",
  Analista: "Meticuloso, analítico, orientado à qualidade",
};

// Descrições dos traços de personalidade
export const dniaTraitDescriptions: Record<string, string> = {
  Inovação: "Curiosidade, criatividade e abertura a novas experiências",
  Disciplina: "Organização, planejamento e foco em metas",
  Sociabilidade: "Energia social, assertividade e expressividade",
  Empatia: "Cooperação, confiança e sensibilidade interpessoal",
  Resiliência: "Estabilidade emocional e capacidade de lidar com pressão",
};

// Significado do Acronimo DNIA
export const dniaAcronym: Record<string, { letter: string; meaning: string; description: string }> = {
  D: {
    letter: "D",
    meaning: "Determinação",
    description: "Força de vontade, foco em resultados e tomada de decisão assertiva",
  },
  N: {
    letter: "N",
    meaning: "Natureza",
    description: "Estabilidade, consistência e capacidade de navegar com segurança",
  },
  I: {
    letter: "I",
    meaning: "Influência",
    description: "Capacidade de comunicar, engajar e inspirar outras pessoas",
  },
  A: {
    letter: "A",
    meaning: "Adaptação",
    description: "Flexibilidade e capacidade de ajuste ao ambiente e contexto",
  },
};
