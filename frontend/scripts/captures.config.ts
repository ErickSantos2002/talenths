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
  /**
   * Cliques depois de `click`, pelo papel e nome acessíveis, para abrir uma aba, escolher num
   * seletor ou abrir um detalhe que a URL não abre. `exact` quando o nome é o rótulo inteiro;
   * sem ele, o nome casa por trecho. O alvo tem de ser único: o script falha se achar 0 ou 2+.
   */
  steps?: { role: "button" | "tab" | "combobox" | "option" | "row"; name?: string; exact?: boolean }[];
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
  { name: "ajuda-desta-tela", account: "ana", route: () => "/meus-videos", click: "help-button" },

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
  { name: "admin-feedbacks", account: "gestor", route: () => "/admin/feedbacks" },
  { name: "admin-documentos", account: "gestor", route: () => "/admin/documentos" },
  {
    name: "admin-video-detalhe",
    account: "gestor",
    route: () => "/admin/videos",
    steps: [{ role: "row", name: "Técnicas de negociação" }],
  },
  { name: "admin-bingo", account: "gestor", route: () => "/admin/bingo" },
  { name: "admin-bingo-jogo", account: "gestor", route: () => "/admin/bingo", steps: [{ role: "button", name: "Abrir", exact: true }] },
  { name: "admin-bingo-imprimir", account: "gestor", route: (ids) => `/admin/bingo/${ids.bingo_game}/imprimir` },
  { name: "admin-ausencias", account: "gestor", route: () => "/admin/ausencias" },
  {
    name: "admin-beneficios",
    account: "gestor",
    route: () => "/admin/beneficios",
    steps: [{ role: "tab", name: "Colaboradores", exact: true }],
  },
  { name: "admin-ponto", account: "gestor", route: () => "/admin/ponto" },
  { name: "admin-ponto-solicitacoes", account: "gestor", route: () => "/admin/ponto", steps: [{ role: "tab", name: "Solicitações" }] },
  {
    name: "admin-tabela-salarial",
    account: "gestor",
    route: () => "/admin/tabela-salarial",
    steps: [
      { role: "combobox" },
      { role: "option", name: "Pesquisa salarial Exemplo" },
    ],
  },
  {
    name: "admin-tabela-salarial-posicionamento",
    account: "gestor",
    route: () => "/admin/tabela-salarial",
    steps: [
      { role: "combobox" },
      { role: "option", name: "Pesquisa salarial Exemplo" },
      { role: "tab", name: "Posicionamento", exact: true },
    ],
  },
  { name: "admin-empresa", account: "gestor", route: () => "/admin/empresa" },

  // Logs só abrem para o master_admin.
  { name: "admin-logs", account: "admin", route: () => "/admin/logs" },
];
