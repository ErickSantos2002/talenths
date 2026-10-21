// Short tours of the dense screens, started by "Mostrar nesta tela" in the "?"
// when a guide of the screen has `tour: <id>` in its front matter. They never
// navigate, and steps whose block is not on screen are dropped when the tour
// starts, so each text talks about its block without assuming the situation.
// Bump `version` when the screen changes; a new step gets `since: <version>`.
import type { ScreenTour } from "./types";

export const SCREEN_TOURS: ScreenTour[] = [
  {
    id: "tela-minha-avaliacao",
    version: 1,
    screen: "/minha-avaliacao",
    roles: ["master_admin", "manager", "user"],
    steps: [
      {
        element: "my-evaluation-title",
        title: "Minha Avaliação",
        text: "Faça aqui a sua autoavaliação de desempenho, dando de 1 a 5 estrelas para cada comportamento esperado na empresa.",
      },
      {
        element: "my-evaluation-cycle",
        title: "O ciclo",
        text: "Clique no seletor para trocar de ciclo. A etiqueta **Avaliação** marca o ciclo que está aberto.",
      },
      {
        element: "my-evaluation-sent",
        title: "Autoavaliação enviada",
        text: "Este aviso mostra que a sua autoavaliação deste ciclo foi enviada, com a data e a hora do envio.",
      },
      {
        element: "my-evaluation-form",
        title: "Os comportamentos",
        text: "Clique nas estrelas de cada comportamento e, se quiser, escreva um comentário. Quando todos tiverem nota, clique em **Enviar Avaliação** no fim da tela.",
      },
    ],
  },
  {
    id: "tela-meu-pdi",
    version: 1,
    screen: "/meu-pdi",
    roles: ["master_admin", "manager", "user"],
    steps: [
      {
        element: "pdi-header",
        title: "Meu PDI",
        text: "Acompanhe aqui o seu Plano de Desenvolvimento Individual, com as ações combinadas com o seu gestor.",
      },
      {
        element: "pdi-summary",
        title: "O resumo",
        text: "Veja quantos **Planos** você tem, quantos estão **Ativos** e o **Progresso médio** das ações.",
      },
      {
        element: "pdi-plan",
        title: "O plano",
        text: "Cada plano mostra a situação, o ciclo de avaliação ligado a ele e quantas ações já foram concluídas. Clique na seta à direita para esconder ou mostrar as ações.",
      },
      {
        element: "pdi-actions",
        title: "As ações",
        text: "Clique no ícone à esquerda de uma ação para avançar de **Pendente** para **Em andamento** e depois **Concluído**. À direita ficam a situação e o prazo.",
      },
    ],
  },
  {
    id: "tela-video",
    version: 1,
    screen: "/videos/:id",
    roles: ["master_admin", "manager", "user"],
    steps: [
      {
        element: "video-title",
        title: "O vídeo",
        text: "No alto ficam o título, a sua situação neste vídeo e a descrição.",
      },
      {
        element: "video-player",
        title: "Assistir",
        text: "Clique no play para assistir. Até concluir, o vídeo retoma de onde você parou e não dá para avançar além do ponto já assistido.",
      },
      {
        element: "video-progress",
        title: "O seu progresso",
        text: "A barra mostra quanto você já assistiu. Ao chegar ao fim, aparece a data em que o vídeo foi concluído.",
      },
      {
        element: "video-back",
        title: "Voltar à lista",
        text: "Clique em **Vídeos** para voltar à lista dos seus vídeos.",
      },
    ],
  },
  {
    id: "tela-admin-videos",
    version: 1,
    screen: "/admin/videos",
    roles: ["master_admin", "manager"],
    steps: [
      {
        element: "admin-videos-new",
        title: "Publicar um vídeo",
        text: "Clique em **Novo vídeo** para enviar um MP4, definir o prazo e escolher quem deve assistir.",
      },
      {
        element: "admin-videos-list",
        title: "Os vídeos",
        text: "Cada linha mostra a **Duração** e o **Prazo** do vídeo. **Concluídos** conta quem já terminou entre os obrigatórios e **Atrasados**, quem passou do prazo.",
      },
      {
        element: "admin-videos-rows",
        title: "O detalhe",
        text: "Clique na linha de um vídeo para ver quem já assistiu. No detalhe ficam também **Editar**, **Trocar arquivo**, **Arquivar** e **Excluir**.",
      },
    ],
  },
  {
    id: "tela-admin-avaliacao",
    version: 1,
    screen: "/admin/avaliacao",
    roles: ["master_admin", "manager"],
    steps: [
      {
        element: "evaluation-new-cycle",
        title: "Novo ciclo",
        text: "Clique em **Novo Ciclo** para abrir um ciclo de avaliação e ligá-lo, se quiser, a um ciclo de metas.",
      },
      {
        element: "evaluation-cycle",
        title: "O ciclo",
        text: "Clique no seletor para trocar de ciclo. A etiqueta ao lado do nome mostra a etapa em que ele está.",
      },
      {
        element: "evaluation-controls",
        title: "Etapa e notas",
        text: "Em **Etapa atual**, mude a etapa do ciclo. Clique em **Calcular Notas** para gerar a nota final de cada pessoa e a posição dela no 9Box.",
      },
      {
        element: "evaluation-summary",
        title: "O resumo",
        text: "Veja quantos colaboradores há no ciclo e quantas autoavaliações e avaliações de gestor já foram enviadas.",
      },
      {
        element: "evaluation-table",
        title: "Os colaboradores",
        text: "Nas colunas **Auto** e **Gestor**, o visto verde é avaliação enviada e o relógio, pendente. Clique em **Avaliar** na linha da pessoa para fazer a avaliação de gestor.",
      },
    ],
  },
  {
    id: "tela-admin-9box",
    version: 1,
    screen: "/admin/9box",
    roles: ["master_admin", "manager"],
    steps: [
      {
        element: "ninebox-cycle",
        title: "O ciclo",
        text: "Clique no seletor para escolher o ciclo de avaliação que o quadro mostra.",
      },
      {
        element: "ninebox-grid",
        title: "O quadro",
        text: "De baixo para cima vai a nota da avaliação e, da esquerda para a direita, o progresso das metas do time. Passe o mouse sobre um nome para ver o departamento e a nota.",
      },
      {
        element: "ninebox-legend",
        title: "A legenda",
        text: "A coroa marca os quadrantes elegíveis para a Trilha de Carreira, e a estrela, quem foi calibrado manualmente.",
      },
      {
        element: "ninebox-refresh",
        title: "Atualizar",
        text: "Depois de calcular as notas de novo na tela **Avaliação**, clique em **Atualizar** para recarregar o quadro.",
      },
    ],
  },
];
