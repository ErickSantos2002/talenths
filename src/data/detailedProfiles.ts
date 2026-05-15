export interface ProfileData {
  name: string;
  description: string;
  howYouWork: {
    motivations: string[];
    values: string[];
    fears: string[];
  };
  strengthsWithHow: Array<{ strength: string; howToUse: string }>;
  developmentWithPlan: Array<{ area: string; why: string; howToDevelop: string }>;
  underPressure: {
    howYouReact: string;
    whatToDo: string[];
  };
  communicationStyle: {
    howYouCommunicate: string;
    tips: string[];
  };
  learningStyle: string;
  leadershipGuide: {
    howToMotivate: string[];
    howToDelegate: string[];
    howToGiveFeedback: {
      whatWorks: string[];
      whatDoesntWork: string[];
    };
    inCrisis: string[];
    inChange: string[];
  };
  warningSignals: string[];
  whatNotToDo: string[];
}

export const detailedProfiles: Record<string, ProfileData> = {
  D: {
    name: "Determinado",
    description:
      "Você é uma pessoa orientada a resultados, com forte senso de urgência e determinação. Seu perfil Determinado indica que você gosta de assumir o controle das situações, tomar decisões rápidas e enfrentar desafios de frente. Você prefere ambientes dinâmicos onde possa agir com autonomia e ver resultados tangíveis. Sua energia é contagiante e você naturalmente inspira os outros a agir.",
    howYouWork: {
      motivations: [
        "Desafios novos e ambiciosos",
        "Autonomia para decidir e agir",
        "Resultados mensuráveis e rápidos",
        "Competição saudável e oportunidades de liderar",
        "Problemas complexos para resolver",
      ],
      values: [
        "Eficiência e produtividade",
        "Honestidade direta",
        "Competência e meritocracia",
        "Independência e liberdade de ação",
        "Progresso constante",
      ],
      fears: [
        "Perder o controle da situação",
        "Ser visto como fraco ou incompetente",
        "Ambientes com burocracia excessiva",
        "Estagnação e falta de progresso",
        "Depender dos outros para resultados",
      ],
    },
    strengthsWithHow: [
      {
        strength: "Tomada de decisão rápida",
        howToUse:
          "Use essa habilidade em situações de crise ou quando a equipe precisa de direção clara. Ofereça-se para liderar projetos urgentes.",
      },
      {
        strength: "Foco em resultados",
        howToUse:
          "Canalize essa energia definindo metas claras para si e para a equipe. Crie dashboards de acompanhamento.",
      },
      {
        strength: "Coragem para enfrentar desafios",
        howToUse:
          "Seja o primeiro a abordar problemas difíceis. Sua disposição para enfrentar o desconhecido inspira coragem nos outros.",
      },
      {
        strength: "Capacidade de liderar sob pressão",
        howToUse:
          "Em momentos críticos, assuma a coordenação. Seu pensamento rápido e objetivo é essencial nessas horas.",
      },
    ],
    developmentWithPlan: [
      {
        area: "Paciência com processos e pessoas",
        why: "Sua velocidade pode atropelar colegas que precisam de mais tempo para processar informações e tomar decisões.",
        howToDevelop:
          "Pratique a escuta ativa: antes de responder, conte até 3. Pergunte 'O que você acha?' antes de dar sua opinião.",
      },
      {
        area: "Empatia e sensibilidade interpessoal",
        why: "Foco excessivo em resultados pode fazer você parecer insensível às necessidades emocionais dos colegas.",
        howToDevelop:
          "Reserve 5 minutos no início de reuniões para perguntar como as pessoas estão. Pratique reconhecer contribuições individuais.",
      },
      {
        area: "Delegação com acompanhamento",
        why: "Você tende a assumir tudo ou delegar sem acompanhar, gerando frustração em ambos os cenários.",
        howToDevelop:
          "Use check-ins semanais curtos (15 min) com cada pessoa. Defina entregas intermediárias para acompanhar o progresso.",
      },
    ],
    underPressure: {
      howYouReact:
        "Sob pressão, você tende a se tornar mais autoritário e impaciente. Pode tomar decisões precipitadas sem consultar a equipe, elevar o tom de voz e focar exclusivamente no problema, ignorando o impacto emocional nos outros.",
      whatToDo: [
        "Pare e respire fundo antes de reagir — 30 segundos de pausa fazem diferença",
        "Pergunte a opinião de pelo menos uma pessoa antes de decidir",
        "Lembre-se: velocidade sem direção correta gera retrabalho",
        "Delegue o que puder e foque no que é realmente crítico",
      ],
    },
    communicationStyle: {
      howYouCommunicate:
        "Você é direto, objetivo e vai ao ponto rapidamente. Prefere conversas curtas e focadas em ação. Pode parecer abrupto ou impaciente em discussões longas.",
      tips: [
        "Adicione um pouco de contexto antes de ir direto ao ponto — ajuda os outros a acompanharem seu raciocínio",
        "Use perguntas abertas em vez de afirmações diretas para engajar mais as pessoas",
        "Em e-mails, adicione uma saudação pessoal antes do conteúdo objetivo",
        "Pratique o 'sanduíche': positivo → sugestão → positivo ao dar feedback",
      ],
    },
    learningStyle:
      "Você aprende melhor fazendo. Prefere experiências práticas e hands-on a teorias extensas. Gosta de desafios que testam seus limites e aprende rapidamente quando vê aplicação imediata. Treinamentos ideais para você são workshops práticos, simulações de cenários reais e projetos com entrega rápida.",
    leadershipGuide: {
      howToMotivate: [
        "Dê autonomia e liberdade para decidir como alcançar os objetivos",
        "Estabeleça metas desafiadoras e mensuráveis",
        "Reconheça conquistas de forma direta e rápida",
        "Ofereça oportunidades de liderança e novos projetos",
      ],
      howToDelegate: [
        "Seja claro sobre o resultado esperado, não sobre o processo",
        "Dê prazos definidos e realistas",
        "Evite microgerenciamento — confie na capacidade de execução",
        "Permita que tome decisões dentro do escopo delegado",
      ],
      howToGiveFeedback: {
        whatWorks: [
          "Feedback direto e específico, sem rodeios",
          "Focado em resultados e impacto mensurável",
          "Com sugestões práticas de melhoria",
          "Entregue de forma individual e privada",
        ],
        whatDoesntWork: [
          "Feedback vago ou genérico ('precisa melhorar')",
          "Críticas públicas ou na frente da equipe",
          "Abordagem excessivamente emocional ou pessoal",
          "Falta de dados ou exemplos concretos",
        ],
      },
      inCrisis: [
        "Deixe-o liderar a resposta imediata — é onde brilha",
        "Forneça informações claras e atualizadas rapidamente",
        "Não crie obstáculos burocráticos — facilite a ação rápida",
        "Após a crise, reserve tempo para debrief e reflexão",
      ],
      inChange: [
        "Envolva-o no planejamento da mudança — não apenas na execução",
        "Mostre como a mudança cria novas oportunidades de impacto",
        "Dê-lhe um papel de liderança no processo de transição",
        "Seja transparente sobre os desafios — ele respeita honestidade",
      ],
    },
    warningSignals: [
      "Começa a ignorar ou desconsiderar opiniões dos colegas",
      "Aumenta significativamente o ritmo de trabalho sem necessidade",
      "Torna-se mais impaciente e intolerante com erros",
      "Isola-se e para de comunicar decisões à equipe",
      "Expressa frustração com a 'lentidão' de processos ou pessoas",
    ],
    whatNotToDo: [
      "Não microgerencie — isso destrói sua motivação",
      "Não ignore suas ideias sem dar uma razão clara",
      "Não crie reuniões longas e sem pauta definida",
      "Não use abordagem passivo-agressiva — seja direto",
      "Não limite sua autonomia sem explicar o porquê",
    ],
  },

  I: {
    name: "Influenciador",
    description:
      "Você é uma pessoa entusiasmada, comunicativa e naturalmente carismática. Seu perfil Influenciador indica que você constrói relacionamentos com facilidade, motiva os outros com seu otimismo e cria ambientes de trabalho positivos. Sua criatividade e capacidade de persuasão são suas maiores ferramentas. Você brilha em situações que exigem colaboração, apresentações e networking.",
    howYouWork: {
      motivations: [
        "Reconhecimento social e aprovação",
        "Ambiente colaborativo e divertido",
        "Oportunidades de se expressar e apresentar ideias",
        "Interação constante com pessoas",
        "Projetos criativos e inovadores",
      ],
      values: [
        "Relacionamentos autênticos",
        "Otimismo e positividade",
        "Liberdade de expressão",
        "Trabalho em equipe e colaboração",
        "Reconhecimento e celebração de conquistas",
      ],
      fears: [
        "Rejeição social ou exclusão do grupo",
        "Ambientes frios e impessoais",
        "Perder popularidade ou influência",
        "Rotina monótona e repetitiva",
        "Ser ignorado ou não ouvido",
      ],
    },
    strengthsWithHow: [
      {
        strength: "Comunicação persuasiva",
        howToUse:
          "Lidere apresentações importantes e pitches. Sua habilidade de contar histórias engaja e convence audiências.",
      },
      {
        strength: "Construção de relacionamentos",
        howToUse:
          "Conecte pessoas de diferentes áreas. Seja a ponte entre equipes e facilite a colaboração interdepartamental.",
      },
      {
        strength: "Entusiasmo contagiante",
        howToUse:
          "Use sua energia para motivar equipes em momentos difíceis. Seu otimismo pode transformar o clima de um projeto.",
      },
      {
        strength: "Criatividade e brainstorming",
        howToUse:
          "Proponha sessões de ideação. Sua mente criativa gera soluções não convencionais que outros não enxergariam.",
      },
    ],
    developmentWithPlan: [
      {
        area: "Organização e follow-up",
        why: "Seu entusiasmo com novas ideias pode fazer você abandonar projetos em andamento antes de concluí-los.",
        howToDevelop:
          "Use listas de tarefas simples e defina no máximo 3 prioridades por dia. Configure lembretes para follow-ups pendentes.",
      },
      {
        area: "Escuta ativa e profundidade",
        why: "Sua vontade de se expressar pode fazer você falar mais do que ouvir, perdendo informações importantes.",
        howToDevelop:
          "Pratique a regra 70/30: ouça 70% do tempo. Antes de responder, parafraseie o que ouviu para confirmar entendimento.",
      },
      {
        area: "Tomada de decisão baseada em dados",
        why: "Você tende a decidir com base na intuição e emoção, o que pode gerar resultados inconsistentes.",
        howToDevelop:
          "Antes de decidir, liste 3 dados ou fatos que suportam sua escolha. Peça a opinião de alguém mais analítico.",
      },
    ],
    underPressure: {
      howYouReact:
        "Sob pressão, você pode se tornar desorganizado e disperso. Tende a falar demais, fazer promessas exageradas e buscar aprovação dos outros em vez de focar na solução. Pode também evitar confrontos necessários.",
      whatToDo: [
        "Pare e priorize: escolha UMA coisa para resolver primeiro",
        "Escreva suas ideias antes de comunicá-las — isso ajuda a organizar o pensamento",
        "Peça ajuda a alguém organizado para estruturar o plano de ação",
        "Evite fazer promessas no momento de pressão — diga 'vou avaliar e retorno'",
      ],
    },
    communicationStyle: {
      howYouCommunicate:
        "Você é expressivo, entusiasmado e usa muitas histórias e analogias. Gosta de conversas longas e envolventes. Pode parecer disperso em reuniões muito técnicas ou estruturadas.",
      tips: [
        "Em reuniões formais, prepare 3 pontos-chave para não se dispersar",
        "Use bullet points em comunicações escritas para ser mais objetivo",
        "Equilibre histórias com dados concretos para ganhar credibilidade",
        "Ajuste seu estilo conforme a audiência — nem todos gostam de conversas longas",
      ],
    },
    learningStyle:
      "Você aprende melhor em grupo e por meio de discussões. Prefere treinamentos interativos, role-playing e estudos de caso a leituras solitárias. Vídeos, podcasts e workshops colaborativos são ideais. Você retém mais informações quando pode compartilhar o que aprendeu com outras pessoas.",
    leadershipGuide: {
      howToMotivate: [
        "Reconheça publicamente suas conquistas e contribuições",
        "Crie oportunidades para apresentar ideias e liderar discussões",
        "Mantenha o ambiente leve e positivo",
        "Inclua-o em projetos que envolvam networking e colaboração",
      ],
      howToDelegate: [
        "Explique o 'porquê' do projeto — conecte ao propósito maior",
        "Defina checkpoints intermediários para manter o foco",
        "Permita criatividade na execução, mas estabeleça prazos claros",
        "Pareie com alguém organizado em projetos complexos",
      ],
      howToGiveFeedback: {
        whatWorks: [
          "Comece com reconhecimento genuíno do que foi bem feito",
          "Use exemplos concretos e específicos",
          "Mantenha o tom positivo e construtivo",
          "Faça em conversa informal e acolhedora",
        ],
        whatDoesntWork: [
          "Feedback frio, técnico e sem conexão pessoal",
          "Críticas que pareçam rejeição pessoal",
          "Lista longa de problemas sem reconhecer os acertos",
          "Feedback por escrito sem contexto verbal",
        ],
      },
      inCrisis: [
        "Ajude-o a priorizar — ele pode se dispersar tentando resolver tudo",
        "Dê tarefas que envolvam comunicação e alinhamento com stakeholders",
        "Cuidado com promessas exageradas no calor do momento",
        "Após a crise, reconheça o esforço e a contribuição emocional",
      ],
      inChange: [
        "Envolva-o como embaixador da mudança — ele influencia os outros",
        "Destaque os aspectos positivos e as oportunidades da nova situação",
        "Dê-lhe papel de comunicador oficial do processo de mudança",
        "Permita que expresse preocupações — ele processa falando",
      ],
    },
    warningSignals: [
      "Fica quieto e retraído em reuniões (sinal grave)",
      "Para de socializar com a equipe",
      "Começa a reclamar frequentemente do ambiente ou das pessoas",
      "Perde o entusiasmo por projetos que antes o empolgavam",
      "Torna-se sarcástico ou negativista",
    ],
    whatNotToDo: [
      "Não ignore suas contribuições ou ideias sem reconhecimento",
      "Não o exclua de decisões que afetam o grupo",
      "Não crie um ambiente excessivamente formal e rígido",
      "Não dê feedback apenas por escrito — ele precisa do contato humano",
      "Não critique publicamente — isso o destrói emocionalmente",
    ],
  },

  S: {
    name: "Navegador",
    description:
      "Você é uma pessoa estável, confiável e profundamente dedicada às relações e ao bem-estar da equipe. Seu perfil Navegador indica que você valoriza harmonia, consistência e lealdade. Você é o porto seguro da equipe, sempre disponível para apoiar, ouvir e manter a estabilidade mesmo em momentos turbulentos. Sua paciência e capacidade de manter a calma são inestimáveis.",
    howYouWork: {
      motivations: [
        "Ambiente harmonioso e previsível",
        "Relacionamentos de confiança e profundidade",
        "Reconhecimento pela lealdade e dedicação",
        "Processos claros e bem definidos",
        "Oportunidade de ajudar e apoiar os outros",
      ],
      values: [
        "Lealdade e compromisso",
        "Estabilidade e segurança",
        "Harmonia no ambiente de trabalho",
        "Respeito mútuo e consideração",
        "Consistência e confiabilidade",
      ],
      fears: [
        "Mudanças abruptas e inesperadas",
        "Conflitos interpessoais não resolvidos",
        "Perder a segurança ou estabilidade",
        "Pressão excessiva por resultados rápidos",
        "Ambientes caóticos e imprevisíveis",
      ],
    },
    strengthsWithHow: [
      {
        strength: "Confiabilidade excepcional",
        howToUse:
          "Assuma responsabilidades que exigem consistência a longo prazo. Projetos de manutenção e melhoria contínua são ideais para você.",
      },
      {
        strength: "Escuta ativa e empatia",
        howToUse:
          "Seja o mediador em conflitos da equipe. Sua capacidade de ouvir todos os lados sem julgar é rara e valiosa.",
      },
      {
        strength: "Trabalho em equipe colaborativo",
        howToUse:
          "Facilite a integração de novos membros. Seu acolhimento natural ajuda pessoas a se sentirem parte do grupo rapidamente.",
      },
      {
        strength: "Paciência e persistência",
        howToUse:
          "Lidere projetos de longo prazo que exigem dedicação constante. Sua persistência garante que nada fique incompleto.",
      },
    ],
    developmentWithPlan: [
      {
        area: "Assertividade e expressão de opiniões",
        why: "Sua busca por harmonia pode fazer você evitar conflitos necessários e engolir opiniões importantes.",
        howToDevelop:
          "Comece expressando opiniões em reuniões pequenas. Use frases como 'Eu vejo de outra forma...' para discordar de forma segura.",
      },
      {
        area: "Adaptação a mudanças",
        why: "Mudanças rápidas podem paralisar ou gerar ansiedade, afetando sua produtividade e bem-estar.",
        howToDevelop:
          "Peça antecipação sobre mudanças ao seu líder. Crie um 'plano pessoal de transição' com etapas que você possa controlar.",
      },
      {
        area: "Tomada de iniciativa proativa",
        why: "Você tende a esperar que outros tomem a iniciativa, o que pode limitar seu crescimento profissional.",
        howToDevelop:
          "Desafie-se a propor uma ideia nova por mês. Comece com sugestões de melhoria em processos que você já domina.",
      },
    ],
    underPressure: {
      howYouReact:
        "Sob pressão, você tende a se retrair, evitar confrontos e aceitar demandas excessivas sem reclamar. Pode se tornar passivo, acumular resentimento e se sentir sobrecarregado sem pedir ajuda. Em casos extremos, pode ter reações emocionais intensas.",
      whatToDo: [
        "Comunique seus limites antes de chegar ao ponto de ruptura",
        "Peça ajuda — isso não é fraqueza, é inteligência emocional",
        "Estabeleça limites claros sobre prazos e carga de trabalho",
        "Reserve momentos de descompressão durante o dia",
      ],
    },
    communicationStyle: {
      howYouCommunicate:
        "Você é calmo, ponderado e prefere conversas individuais a apresentações em grupo. Ouve mais do que fala e escolhe as palavras com cuidado. Pode parecer reservado ou tímido em reuniões grandes.",
      tips: [
        "Prepare-se antes de reuniões importantes — anote seus pontos-chave",
        "Não espere ser perguntado — ofereça sua opinião proativamente",
        "Use e-mails quando precisar expressar algo difícil — dá mais tempo para formular",
        "Pratique compartilhar ideias em reuniões menores antes das maiores",
      ],
    },
    learningStyle:
      "Você aprende melhor de forma gradual e estruturada. Prefere materiais organizados passo a passo, com tempo suficiente para absorver cada conceito antes de avançar. Mentoria individual e treinamentos com ritmo controlado são ideais. Evite sobrecarga de informações — aprende mais com profundidade do que com amplitude.",
    leadershipGuide: {
      howToMotivate: [
        "Crie um ambiente seguro e previsível",
        "Reconheça sua lealdade e dedicação consistente",
        "Avise sobre mudanças com antecedência sempre que possível",
        "Demonstre que valoriza sua contribuição para o clima da equipe",
      ],
      howToDelegate: [
        "Explique o contexto completo e o que se espera",
        "Dê tempo suficiente para planejar e executar",
        "Ofereça suporte — pergunte 'precisa de algo?' regularmente",
        "Evite mudanças constantes de prioridade dentro de um mesmo projeto",
      ],
      howToGiveFeedback: {
        whatWorks: [
          "Em conversa individual, calma e privada",
          "Comece reconhecendo o que está funcionando bem",
          "Use tom acolhedor e construtivo",
          "Dê tempo para processar — não espere resposta imediata",
        ],
        whatDoesntWork: [
          "Feedback agressivo, direto demais ou apressado",
          "Críticas na frente de outras pessoas",
          "Mudanças de expectativa sem aviso prévio",
          "Ignorar o esforço para focar apenas no resultado",
        ],
      },
      inCrisis: [
        "Dê instruções claras e específicas — a ambiguidade o paralisa",
        "Mantenha a calma — ele espelha a energia do líder",
        "Proteja-o de conflitos desnecessários durante a crise",
        "Após a crise, faça debrief e agradeça pelo suporte constante",
      ],
      inChange: [
        "Comunique com antecedência — surpresas o desestabilizam",
        "Explique o 'porquê' da mudança e o impacto pessoal",
        "Dê tempo para se adaptar — não force aceleração",
        "Ofereça acompanhamento individual durante a transição",
      ],
    },
    warningSignals: [
      "Começa a dizer 'sim' para tudo sem questionar (sobrecarga)",
      "Fica mais quieto que o habitual e evita interações",
      "Expressa frustração de forma indireta ou passivo-agressiva",
      "Aumenta significativamente os erros por descuido",
      "Apresenta sinais de esgotamento físico (cansaço, dores)",
    ],
    whatNotToDo: [
      "Não mude tudo de uma vez — faça mudanças graduais",
      "Não force confrontos públicos ou debates acalorados",
      "Não ignore seus sentimentos dizendo 'não leve para o pessoal'",
      "Não sobrecarregue com prazos irreais só porque ele não reclama",
      "Não confunda quietude com falta de opinião — pergunte",
    ],
  },

  C: {
    name: "Analista",
    description:
      "Você é uma pessoa meticulosa, analítica e comprometida com a qualidade e a precisão. Seu perfil Analista indica que você valoriza processos bem definidos, dados concretos e padrões elevados de excelência. Você é a pessoa que garante que os detalhes não sejam esquecidos e que as decisões sejam tomadas com base em fatos. Sua capacidade de análise profunda é um ativo raro e valioso.",
    howYouWork: {
      motivations: [
        "Oportunidade de fazer trabalho de alta qualidade",
        "Acesso a informações e dados completos",
        "Ambiente organizado e com processos claros",
        "Reconhecimento pela expertise e precisão",
        "Tempo suficiente para analisar antes de decidir",
      ],
      values: [
        "Qualidade e excelência",
        "Precisão e atenção aos detalhes",
        "Lógica e objetividade",
        "Conhecimento profundo e especialização",
        "Integridade e consistência",
      ],
      fears: [
        "Cometer erros que afetem sua reputação",
        "Tomar decisões sem informações suficientes",
        "Ambientes caóticos e sem padrões",
        "Ser criticado por trabalho mal feito",
        "Perder credibilidade profissional",
      ],
    },
    strengthsWithHow: [
      {
        strength: "Análise profunda e pensamento crítico",
        howToUse:
          "Assuma o papel de revisor em projetos críticos. Sua capacidade de encontrar falhas antes que se tornem problemas é insubstituível.",
      },
      {
        strength: "Atenção excepcional aos detalhes",
        howToUse:
          "Lidere processos de qualidade e auditoria. Sua meticulosidade garante que padrões sejam mantidos e melhorados.",
      },
      {
        strength: "Tomada de decisão baseada em dados",
        howToUse:
          "Forneça análises e recomendações antes de decisões importantes. Sua objetividade equilibra decisões emocionais.",
      },
      {
        strength: "Planejamento estruturado e organização",
        howToUse:
          "Crie frameworks e processos que a equipe toda possa seguir. Sua capacidade de sistematizar é um diferencial.",
      },
    ],
    developmentWithPlan: [
      {
        area: "Agilidade na tomada de decisão",
        why: "Sua busca pela perfeição pode paralisar decisões, gerando atrasos em entregas e frustrando colegas.",
        howToDevelop:
          "Defina um tempo máximo para cada decisão. Use a regra 80/20: 80% das decisões podem ser tomadas com 80% das informações.",
      },
      {
        area: "Comunicação simplificada",
        why: "Sua riqueza de detalhes pode sobrecarregar interlocutores que precisam de informações resumidas.",
        howToDevelop:
          "Use a técnica 'pirâmide invertida': conclusão primeiro, detalhes depois. Prepare versões de 1 min e 5 min de cada apresentação.",
      },
      {
        area: "Flexibilidade diante de imperfeições",
        why: "Nem tudo precisa ser perfeito para funcionar. O perfeccionismo pode ser inimigo da entrega.",
        howToDevelop:
          "Pratique entregar versões 'boas o suficiente'. Defina antecipadamente o que é aceitável vs. ideal para cada projeto.",
      },
    ],
    underPressure: {
      howYouReact:
        "Sob pressão, você tende a se retrair e analisar excessivamente, entrando em paralisia analítica. Pode se tornar excessivamente crítico (consigo e com os outros), focar em detalhes irrelevantes e resistir a tomar decisões sem dados completos.",
      whatToDo: [
        "Defina o que é 'bom o suficiente' antes de começar a análise",
        "Estabeleça um prazo máximo para cada decisão e respeite-o",
        "Peça a opinião de alguém que você confia para validar sua análise",
        "Lembre-se: uma decisão imperfeita é melhor que nenhuma decisão",
      ],
    },
    communicationStyle: {
      howYouCommunicate:
        "Você é preciso, detalhado e factual. Prefere comunicação escrita a verbal e gosta de documentar tudo. Pode parecer frio ou distante em conversas informais, mas é incrivelmente confiável em comunicações técnicas.",
      tips: [
        "Adapte o nível de detalhe ao público — nem todos precisam de todos os dados",
        "Adicione exemplos práticos para tornar informações técnicas mais acessíveis",
        "Pratique small talk — ajuda a criar conexões que facilitam a colaboração",
        "Em apresentações, use gráficos e visualizações para tornar dados mais digeríveis",
      ],
    },
    learningStyle:
      "Você aprende melhor de forma autônoma e profunda. Prefere materiais escritos, documentação detalhada e cursos com base teórica sólida. Gosta de ter tempo para pesquisar e dominar um assunto antes de aplicá-lo. E-learning, livros técnicos e artigos científicos são seus formatos ideais.",
    leadershipGuide: {
      howToMotivate: [
        "Dê acesso a informações, dados e contexto completos",
        "Reconheça a qualidade e profundidade do seu trabalho",
        "Permita tempo para análise e planejamento adequados",
        "Ofereça oportunidades de se especializar e aprofundar conhecimentos",
      ],
      howToDelegate: [
        "Forneça briefing detalhado com expectativas claras de qualidade",
        "Defina critérios de sucesso e padrões esperados",
        "Dê autonomia no 'como' — ele encontrará o melhor processo",
        "Respeite o tempo necessário para fazer bem feito",
      ],
      howToGiveFeedback: {
        whatWorks: [
          "Feedback específico, factual e baseado em evidências",
          "Com tempo para processar — envie por escrito antes de discutir verbalmente",
          "Focado no trabalho, não na pessoa",
          "Com sugestões claras de como melhorar",
        ],
        whatDoesntWork: [
          "Feedback vago sem dados ou exemplos concretos",
          "Críticas que questionam sua competência técnica",
          "Pressão para responder imediatamente sem tempo de reflexão",
          "Generalização — 'você sempre' ou 'você nunca'",
        ],
      },
      inCrisis: [
        "Dê-lhe dados atualizados e precisos sobre a situação",
        "Peça análise de riscos e plano de mitigação — é onde brilha",
        "Não apresse decisões sem necessidade — respeite o processo analítico",
        "Proteja-o de decisões emocionais dos outros — ele precisa de lógica",
      ],
      inChange: [
        "Forneça documentação detalhada sobre o que muda e por quê",
        "Dê tempo para estudar e se preparar para a nova realidade",
        "Envolva-o na definição dos novos processos e padrões",
        "Responda perguntas com dados — 'porque sim' não funciona",
      ],
    },
    warningSignals: [
      "Começa a questionar excessivamente cada decisão e processo",
      "Aumenta o perfeccionismo a ponto de não entregar nada",
      "Torna-se mais crítico e negativo em relação à equipe",
      "Isola-se e reduz drasticamente a comunicação",
      "Expressa preocupação excessiva com possíveis erros futuros",
    ],
    whatNotToDo: [
      "Não force decisões sem dados — isso gera ansiedade paralisante",
      "Não mude processos sem documentação clara e justificativa",
      "Não desconsidere suas análises para 'ir mais rápido'",
      "Não critique a qualidade do seu trabalho sem evidências",
      "Não confunda introversão com desinteresse — ele está processando",
    ],
  },
};
