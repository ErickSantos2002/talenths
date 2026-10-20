// As telas fotografadas para os guias da Ajuda. Cada captura vira
// `public/capturas/<name>.webp` e os guias citam a imagem por esse caminho
// (`![Tela X](/capturas/<name>.webp)`). Mudou uma tela citada? Refaça a captura
// no mesmo commit: `bun run capturas -- --only <name>`.
//
// Contas e ids vêm de `backend/scripts/seed_captures.py` — só dado fictício.

export type Account = "ana" | "bruno" | "gestor" | "admin";

/** E-mail de cada conta fictícia da semente (todas com a mesma senha). */
export const ACCOUNTS: Record<Account, string> = {
  ana: "ana@exemplo.com.br", // colaboradora
  bruno: "bruno@exemplo.com.br", // colaborador com ponto habilitado
  gestor: "gestor@exemplo.com.br", // manager
  admin: "admin@exemplo.com.br", // master_admin
};

/** A senha das contas da semente (`CAPTURES_PASSWORD` nos dois lados). */
export const PASSWORD = process.env.CAPTURES_PASSWORD ?? "exemplo123";

/** Os ids que a semente imprime na última linha da saída. */
export interface Ids {
  company: string;
  users: Record<Account | "carla" | "diego" | "eduarda" | "felipe" | "helena" | "igor", string>;
  video: string;
  test: string;
  /** o teste em rascunho, com perguntas (captura do editor) */
  draft_test: string;
  attempt: string;
  bingo_game: string;
  survey: string;
  eval_cycle: string;
  goals_cycle: string;
}

export interface Capture {
  /** kebab-case; vira o nome do arquivo */
  name: string;
  account: Account;
  route: (ids: Ids) => string;
  /** valor de `data-tour` do elemento a clicar antes da foto */
  click?: string;
  width?: number;
  height?: number;
}

export const CAPTURES: Capture[] = [
  // Telas do tour de boas-vindas (colaborador) e o guia "O tour de boas-vindas" (/ajuda).
  { name: "dashboard", account: "ana", route: () => "/dashboard" },
  { name: "meus-videos", account: "ana", route: () => "/meus-videos" },
  { name: "comunicados", account: "ana", route: () => "/comunicados" },
  { name: "minha-avaliacao", account: "ana", route: () => "/minha-avaliacao" },
  { name: "meus-testes", account: "ana", route: () => "/meus-testes" },
  { name: "meu-perfil", account: "ana", route: () => "/meu-perfil" },
  { name: "ajuda", account: "ana", route: () => "/ajuda" },

  // Guias de Primeiros passos, Meu Espaço e Desempenho.
  { name: "dashboard-gestor", account: "gestor", route: () => "/dashboard" },
  { name: "notificacoes", account: "ana", route: () => "/dashboard", click: "notifications" },
  { name: "apresentacao", account: "ana", route: () => "/apresentacao" },
  { name: "cultura", account: "ana", route: () => "/cultura" },
  { name: "regras-internas", account: "ana", route: () => "/regras-internas" },
  { name: "calendario", account: "ana", route: () => "/calendario" },
  { name: "resultado-teste", account: "ana", route: (ids) => `/meus-testes/tentativas/${ids.attempt}` },

  // Guias de Desenvolvimento, Comunicação e RH.
  { name: "minha-trilha", account: "ana", route: () => "/minha-trilha" },
  { name: "meu-pdi", account: "ana", route: () => "/meu-pdi" },
  { name: "minha-universidade", account: "ana", route: () => "/minha-universidade" },
  { name: "workshops", account: "ana", route: () => "/workshops" },
  { name: "pesquisas", account: "ana", route: () => "/pesquisas" },
  { name: "meus-feedbacks", account: "ana", route: () => "/meus-feedbacks" },
  { name: "meus-documentos", account: "ana", route: () => "/meus-documentos" },
  { name: "video", account: "ana", route: (ids) => `/videos/${ids.video}` },
  { name: "bingo", account: "ana", route: () => "/bingo" },
  { name: "minhas-ausencias", account: "ana", route: () => "/minhas-ausencias" },
  { name: "meus-beneficios", account: "ana", route: () => "/meus-beneficios" },
  { name: "meu-onboarding", account: "ana", route: () => "/meu-onboarding" },
  { name: "meu-ponto", account: "bruno", route: () => "/meu-ponto" },

  // Telas do tour de boas-vindas (gestor).
  { name: "admin-colaboradores", account: "gestor", route: () => "/admin/colaboradores" },
  { name: "admin-videos", account: "gestor", route: () => "/admin/videos" },
  { name: "admin-relatorios", account: "gestor", route: () => "/admin/relatorios" },

  // Guias de Administração (gestor).
  { name: "admin-metas", account: "gestor", route: () => "/admin/metas" },
  { name: "admin-avaliacao", account: "gestor", route: () => "/admin/avaliacao" },
  { name: "admin-9box", account: "gestor", route: () => "/admin/9box" },
  { name: "admin-testes", account: "gestor", route: () => "/admin/testes" },
  { name: "admin-teste-editar", account: "gestor", route: (ids) => `/admin/testes/${ids.draft_test}/editar` },
  { name: "admin-teste-tentativas", account: "gestor", route: (ids) => `/admin/testes/${ids.test}/tentativas` },
  { name: "admin-trilhas", account: "gestor", route: () => "/admin/trilhas" },
  { name: "admin-pdi", account: "gestor", route: () => "/admin/pdi" },
  { name: "admin-universidade", account: "gestor", route: () => "/admin/universidade" },
  { name: "admin-workshops", account: "gestor", route: () => "/admin/workshops" },
  { name: "admin-comunicados", account: "gestor", route: () => "/admin/comunicados" },
  { name: "admin-onboarding", account: "gestor", route: () => "/admin/onboarding" },
  { name: "admin-pesquisas", account: "gestor", route: () => "/admin/pesquisas" },
];
