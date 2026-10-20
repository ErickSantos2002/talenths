import type { Audience, Tour, TourStep } from "./types";

export const COLLABORATOR_STEPS: TourStep[] = [
  {
    route: "/dashboard",
    element: "dashboard-header",
    title: "Sua tela inicial",
    text: "Aqui você vê o que precisa da sua atenção, como os vídeos que o RH pediu para assistir. Volte sempre que quiser começar o dia por aqui.",
  },
  {
    route: "/dashboard",
    element: "menu",
    title: "O menu",
    text: "Tudo fica agrupado em **Meu Espaço**, **Desempenho**, **Desenvolvimento**, **Comunicação** e **RH**. Clique em um item para abrir a tela.",
  },
  {
    route: "/meus-videos",
    element: "my-videos",
    title: "Vídeos",
    text: "Veja abaixo os vídeos que o RH pede para você assistir, em **Obrigatórios**, e os demais, na **Biblioteca**. Clique em **Assistir** para abrir um vídeo.",
  },
  {
    route: "/comunicados",
    element: "announcements",
    title: "Comunicados",
    text: "Confira aqui os avisos da empresa, junto com aniversários e tempo de casa.",
  },
  {
    route: "/minha-avaliacao",
    element: "my-evaluation",
    title: "Minha Avaliação",
    text: "Quando houver uma avaliação aberta para você, responda por esta tela. Use o seletor de ciclo para ver avaliações anteriores.",
  },
  {
    route: "/meus-testes",
    element: "my-tests",
    title: "Meus Testes",
    text: "Faça aqui os testes que o RH aplicar. Consulte também os que você já concluiu.",
  },
  {
    route: "/meu-perfil",
    element: "my-profile",
    title: "Meu Perfil",
    text: "Mantenha seus dados pessoais atualizados nesta tela.",
  },
  {
    route: "/meu-perfil",
    element: "notifications",
    title: "Notificações",
    text: "Fique de olho no sino: ele avisa quando chega algo novo para você. Clique nele para ver as notificações.",
  },
];

export const ADMIN_STEPS: TourStep[] = [
  {
    route: "/dashboard",
    element: "menu-company",
    title: "Menu de gestão",
    text: "Como gestor, você também vê **Pessoas**, **Desempenho**, **Desenvolvimento**, **Comunicação**, **Gestão de RH** e **Sistema**.",
  },
  {
    route: "/admin/colaboradores",
    element: "admin-collaborators",
    title: "Colaboradores",
    text: "Clique em **Adicionar Colaborador** para cadastrar alguém; deixe a senha em branco para enviar um convite por e-mail.",
  },
  {
    route: "/admin/videos",
    element: "admin-videos",
    title: "Vídeos",
    text: "Publique vídeos para a equipe com **Novo vídeo**. Abra um vídeo para ver quem já assistiu.",
  },
  {
    route: "/admin/relatorios",
    element: "admin-reports",
    title: "Relatórios",
    text: "Baixe os dados da empresa em planilha para analisar no Excel ou no Google Planilhas.",
  },
];

export const FINAL_STEPS: TourStep[] = [
  {
    route: "/ajuda",
    element: "menu-help",
    title: "Ajuda",
    text: "Para ver este tour de novo, abra **Ajuda** no menu e clique em **Fazer o tour de boas-vindas**.",
  },
];

export const WELCOME_TOURS: Record<Audience, Tour> = {
  collaborator: {
    id: "boas-vindas-colaborador",
    version: 1,
    steps: [...COLLABORATOR_STEPS, ...FINAL_STEPS],
  },
  manager: {
    id: "boas-vindas-gestor",
    version: 1,
    steps: [...COLLABORATOR_STEPS, ...ADMIN_STEPS, ...FINAL_STEPS],
  },
};
