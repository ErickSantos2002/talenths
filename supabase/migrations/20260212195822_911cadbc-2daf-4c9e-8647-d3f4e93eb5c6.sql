
-- Table: scenario_blocks
CREATE TABLE public.scenario_blocks (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  block_number INTEGER NOT NULL UNIQUE,
  scenario TEXT NOT NULL,
  option_a TEXT NOT NULL,
  option_b TEXT NOT NULL,
  option_c TEXT NOT NULL,
  option_d TEXT NOT NULL,
  weights_a JSONB NOT NULL DEFAULT '{}',
  weights_b JSONB NOT NULL DEFAULT '{}',
  weights_c JSONB NOT NULL DEFAULT '{}',
  weights_d JSONB NOT NULL DEFAULT '{}',
  ocean_weights_a JSONB NOT NULL DEFAULT '{}',
  ocean_weights_b JSONB NOT NULL DEFAULT '{}',
  ocean_weights_c JSONB NOT NULL DEFAULT '{}',
  ocean_weights_d JSONB NOT NULL DEFAULT '{}'
);

ALTER TABLE public.scenario_blocks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read scenario blocks"
  ON public.scenario_blocks FOR SELECT
  USING (true);

-- Table: test_responses
CREATE TABLE public.test_responses (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  block_number INTEGER NOT NULL,
  most_option TEXT NOT NULL,
  least_option TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  UNIQUE(user_id, block_number)
);

ALTER TABLE public.test_responses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own responses"
  ON public.test_responses FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own responses"
  ON public.test_responses FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own responses"
  ON public.test_responses FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own responses"
  ON public.test_responses FOR DELETE
  USING (auth.uid() = user_id);

-- Table: test_results
CREATE TABLE public.test_results (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  disc_natural JSONB NOT NULL DEFAULT '{}',
  disc_adapted JSONB NOT NULL DEFAULT '{}',
  big_five JSONB NOT NULL DEFAULT '{}',
  completed_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

ALTER TABLE public.test_results ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own results"
  ON public.test_results FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own results"
  ON public.test_results FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Company admins can read company results"
  ON public.test_results FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.user_id = test_results.user_id
        AND (
          public.is_master_admin()
          OR public.is_company_admin(p.company_id)
        )
    )
  );

-- Insert 12 scenarios
INSERT INTO public.scenario_blocks (block_number, scenario, option_a, option_b, option_c, option_d, weights_a, weights_b, weights_c, weights_d, ocean_weights_a, ocean_weights_b, ocean_weights_c, ocean_weights_d) VALUES
(1, 'Você está em uma reunião de equipe e surge um problema urgente que precisa ser resolvido imediatamente. Como você reage?', 'Assumo a liderança e proponho uma solução imediata', 'Converso com todos para entender diferentes perspectivas antes de agir', 'Analiso calmamente os dados disponíveis antes de sugerir algo', 'Verifico os procedimentos estabelecidos para esse tipo de situação', '{"D":3,"I":1,"S":0,"C":0}', '{"D":0,"I":3,"S":1,"C":0}', '{"D":0,"I":0,"S":3,"C":1}', '{"D":0,"I":0,"S":0,"C":3}', '{"O":2,"C":1,"E":2,"A":0,"N":0}', '{"O":2,"C":0,"E":3,"A":2,"N":0}', '{"O":1,"C":3,"E":0,"A":1,"N":0}', '{"O":0,"C":3,"E":0,"A":0,"N":1}'),
(2, 'Você recebe um feedback negativo sobre um projeto que você liderou. Como você reage?', 'Defendo meu ponto de vista com argumentos sólidos', 'Agradeço o feedback e peço mais detalhes para entender melhor', 'Reflito internamente sobre o feedback antes de responder', 'Analiso os dados do projeto para entender o que deu errado', '{"D":3,"I":0,"S":0,"C":1}', '{"D":0,"I":3,"S":1,"C":0}', '{"D":0,"I":0,"S":3,"C":1}', '{"D":0,"I":0,"S":0,"C":3}', '{"O":1,"C":0,"E":2,"A":0,"N":2}', '{"O":2,"C":1,"E":3,"A":3,"N":0}', '{"O":2,"C":2,"E":0,"A":2,"N":1}', '{"O":1,"C":3,"E":0,"A":1,"N":0}'),
(3, 'Você recebe um novo projeto desafiador com prazo curto. Como você reage?', 'Aceito o desafio com entusiasmo e começo imediatamente', 'Mobilizo a equipe para dividir as tarefas e trabalharmos juntos', 'Planejo as etapas com calma para garantir qualidade', 'Estudo os requisitos detalhadamente antes de começar', '{"D":3,"I":1,"S":0,"C":0}', '{"D":1,"I":3,"S":1,"C":0}', '{"D":0,"I":0,"S":3,"C":1}', '{"D":0,"I":0,"S":1,"C":3}', '{"O":3,"C":1,"E":2,"A":0,"N":0}', '{"O":2,"C":1,"E":3,"A":2,"N":0}', '{"O":1,"C":3,"E":0,"A":1,"N":1}', '{"O":2,"C":3,"E":0,"A":0,"N":0}'),
(4, 'Dois colegas da equipe discordam sobre a melhor abordagem para um problema. Como você age?', 'Tomo a decisão final baseado na minha experiência', 'Facilito uma conversa para que cheguem a um consenso', 'Espero os ânimos acalmarem antes de intervir', 'Analiso os prós e contras de cada abordagem objetivamente', '{"D":3,"I":0,"S":0,"C":1}', '{"D":0,"I":3,"S":1,"C":0}', '{"D":0,"I":1,"S":3,"C":0}', '{"D":0,"I":0,"S":0,"C":3}', '{"O":1,"C":2,"E":2,"A":0,"N":0}', '{"O":2,"C":1,"E":3,"A":3,"N":0}', '{"O":1,"C":1,"E":0,"A":3,"N":1}', '{"O":1,"C":3,"E":0,"A":1,"N":0}'),
(5, 'A empresa muda um processo que você dominava completamente. Como você reage?', 'Proponho melhorias no novo processo baseado na minha experiência', 'Ajudo os colegas a se adaptarem ao novo processo', 'Me adapto gradualmente, mantendo meu ritmo de trabalho', 'Estudo o novo processo a fundo antes de implementá-lo', '{"D":3,"I":1,"S":0,"C":0}', '{"D":0,"I":3,"S":1,"C":0}', '{"D":0,"I":0,"S":3,"C":1}', '{"D":0,"I":0,"S":0,"C":3}', '{"O":3,"C":1,"E":2,"A":0,"N":1}', '{"O":2,"C":1,"E":3,"A":3,"N":0}', '{"O":0,"C":2,"E":0,"A":2,"N":1}', '{"O":2,"C":3,"E":0,"A":0,"N":0}'),
(6, 'Você precisa apresentar um projeto importante para a diretoria. Como você se prepara?', 'Foco nos resultados e impacto, apresento com confiança e assertividade', 'Preparo uma apresentação envolvente com histórias e exemplos práticos', 'Organizo os dados de forma clara e estruturada, apresento com calma', 'Reviso todos os detalhes técnicos e me preparo para perguntas difíceis', '{"D":3,"I":1,"S":0,"C":0}', '{"D":1,"I":3,"S":0,"C":0}', '{"D":0,"I":0,"S":3,"C":1}', '{"D":0,"I":0,"S":0,"C":3}', '{"O":2,"C":2,"E":3,"A":0,"N":0}', '{"O":3,"C":1,"E":3,"A":1,"N":0}', '{"O":1,"C":3,"E":0,"A":1,"N":1}', '{"O":1,"C":3,"E":0,"A":0,"N":1}'),
(7, 'O prazo de um projeto foi antecipado inesperadamente. Como você reage?', 'Reorganizo as prioridades rapidamente e foco no essencial', 'Converso com os stakeholders para negociar o escopo', 'Mantenho meu ritmo de trabalho para garantir qualidade', 'Reviso o escopo detalhadamente para garantir que nada seja esquecido', '{"D":3,"I":0,"S":0,"C":1}', '{"D":1,"I":3,"S":0,"C":0}', '{"D":0,"I":0,"S":3,"C":1}', '{"D":0,"I":0,"S":1,"C":3}', '{"O":2,"C":2,"E":2,"A":0,"N":1}', '{"O":2,"C":1,"E":3,"A":2,"N":0}', '{"O":0,"C":3,"E":0,"A":1,"N":2}', '{"O":1,"C":3,"E":0,"A":0,"N":1}'),
(8, 'Sua proposta de melhoria foi rejeitada pela liderança. Como você reage?', 'Insisto com novos argumentos e dados que comprovem meu ponto', 'Busco aliados que possam apoiar minha proposta', 'Aceito a decisão e sigo em frente sem ressentimentos', 'Analiso os motivos da rejeição para entender o que faltou', '{"D":3,"I":0,"S":0,"C":1}', '{"D":1,"I":3,"S":0,"C":0}', '{"D":0,"I":1,"S":3,"C":0}', '{"D":0,"I":0,"S":1,"C":3}', '{"O":2,"C":1,"E":2,"A":0,"N":1}', '{"O":2,"C":1,"E":3,"A":1,"N":0}', '{"O":0,"C":1,"E":0,"A":3,"N":0}', '{"O":2,"C":3,"E":0,"A":1,"N":0}'),
(9, 'Um novo membro entra na equipe. Como você age?', 'Delego tarefas imediatamente para integrá-lo ao trabalho', 'Apresento a pessoa para todos e organizo um almoço de boas-vindas', 'Dou tempo para a pessoa se adaptar antes de cobrar resultados', 'Explico detalhadamente os processos e padrões da equipe', '{"D":3,"I":1,"S":0,"C":0}', '{"D":0,"I":3,"S":1,"C":0}', '{"D":0,"I":1,"S":3,"C":0}', '{"D":0,"I":0,"S":0,"C":3}', '{"O":1,"C":2,"E":2,"A":0,"N":0}', '{"O":2,"C":1,"E":3,"A":3,"N":0}', '{"O":1,"C":1,"E":0,"A":3,"N":0}', '{"O":1,"C":3,"E":0,"A":1,"N":0}'),
(10, 'Você identifica um erro crítico em um projeto quase finalizado. Como você age?', 'Comunico imediatamente e proponho uma solução rápida', 'Reúno a equipe para discutir a melhor forma de corrigir', 'Corrijo o erro com calma para não comprometer a qualidade', 'Analiso o impacto do erro antes de decidir como proceder', '{"D":3,"I":1,"S":0,"C":0}', '{"D":1,"I":3,"S":1,"C":0}', '{"D":0,"I":0,"S":3,"C":1}', '{"D":0,"I":0,"S":1,"C":3}', '{"O":1,"C":2,"E":2,"A":0,"N":1}', '{"O":2,"C":1,"E":3,"A":2,"N":0}', '{"O":1,"C":3,"E":0,"A":1,"N":1}', '{"O":2,"C":3,"E":0,"A":0,"N":0}'),
(11, 'Você precisa escolher entre dois projetos igualmente importantes. Como decide?', 'Escolho o que traz maior impacto e resultados mais rápidos', 'Consulto a equipe para entender qual é a prioridade coletiva', 'Analiso calmamente os prós e contras de cada um', 'Avalio objetivamente os critérios técnicos e recursos disponíveis', '{"D":3,"I":0,"S":0,"C":1}', '{"D":0,"I":3,"S":1,"C":0}', '{"D":0,"I":0,"S":3,"C":1}', '{"D":0,"I":0,"S":0,"C":3}', '{"O":2,"C":2,"E":2,"A":0,"N":0}', '{"O":2,"C":1,"E":3,"A":3,"N":0}', '{"O":1,"C":3,"E":0,"A":2,"N":1}', '{"O":1,"C":3,"E":0,"A":0,"N":0}'),
(12, 'A equipe está desmotivada após um resultado ruim. Como você age?', 'Reforço as metas e cobro mais foco e disciplina', 'Organizo uma atividade para elevar o ânimo da equipe', 'Dou espaço para que todos processem o resultado no seu tempo', 'Analiso o que deu errado e apresento um plano de ação detalhado', '{"D":3,"I":0,"S":0,"C":1}', '{"D":0,"I":3,"S":1,"C":0}', '{"D":0,"I":1,"S":3,"C":0}', '{"D":1,"I":0,"S":0,"C":3}', '{"O":1,"C":3,"E":2,"A":0,"N":0}', '{"O":2,"C":1,"E":3,"A":3,"N":0}', '{"O":1,"C":1,"E":0,"A":3,"N":1}', '{"O":1,"C":3,"E":0,"A":1,"N":0}');
