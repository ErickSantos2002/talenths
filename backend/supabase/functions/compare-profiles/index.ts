import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type, x-supabase-client-platform, x-supabase-client-platform-version, x-supabase-client-runtime, x-supabase-client-runtime-version",
};

// ── Detailed profile data (replicated from src/data/detailedProfiles.ts) ──

interface ProfileSummary {
  name: string;
  description: string;
  motivations: string[];
  values: string[];
  fears: string[];
  communicationStyle: string;
  underPressure: string;
  warningSignals: string[];
  strengths: string[];
  developmentAreas: string[];
}

const profileData: Record<string, ProfileSummary> = {
  D: {
    name: "Determinado",
    description: "Pessoa orientada a resultados, com forte senso de urgência e determinação. Gosta de assumir o controle, tomar decisões rápidas e enfrentar desafios de frente. Prefere ambientes dinâmicos com autonomia e resultados tangíveis.",
    motivations: ["Desafios novos e ambiciosos", "Autonomia para decidir e agir", "Resultados mensuráveis e rápidos", "Competição saudável e oportunidades de liderar"],
    values: ["Eficiência e produtividade", "Honestidade direta", "Competência e meritocracia", "Independência e liberdade de ação"],
    fears: ["Perder o controle da situação", "Ser visto como fraco ou incompetente", "Burocracia excessiva", "Estagnação e falta de progresso"],
    communicationStyle: "Direto, objetivo e vai ao ponto rapidamente. Prefere conversas curtas e focadas em ação. Pode parecer abrupto ou impaciente em discussões longas.",
    underPressure: "Tende a se tornar mais autoritário e impaciente. Pode tomar decisões precipitadas sem consultar a equipe, elevar o tom de voz e focar exclusivamente no problema, ignorando o impacto emocional nos outros.",
    warningSignals: ["Ignora opiniões dos colegas", "Aumenta ritmo sem necessidade", "Torna-se impaciente com erros", "Isola-se e para de comunicar decisões"],
    strengths: ["Tomada de decisão rápida", "Foco em resultados", "Coragem para enfrentar desafios", "Liderança sob pressão"],
    developmentAreas: ["Paciência com processos e pessoas", "Empatia e sensibilidade interpessoal", "Delegação com acompanhamento"],
  },
  I: {
    name: "Influenciador",
    description: "Pessoa entusiasmada, comunicativa e naturalmente carismática. Constrói relacionamentos com facilidade, motiva os outros com otimismo e cria ambientes positivos. Brilha em situações de colaboração, apresentações e networking.",
    motivations: ["Reconhecimento social e aprovação", "Ambiente colaborativo e divertido", "Oportunidades de se expressar", "Interação constante com pessoas"],
    values: ["Relacionamentos autênticos", "Otimismo e positividade", "Liberdade de expressão", "Trabalho em equipe"],
    fears: ["Rejeição social ou exclusão", "Ambientes frios e impessoais", "Perder popularidade ou influência", "Rotina monótona e repetitiva"],
    communicationStyle: "Expressivo, entusiasmado e usa muitas histórias e analogias. Gosta de conversas longas e envolventes. Pode parecer disperso em reuniões técnicas ou estruturadas.",
    underPressure: "Pode se tornar desorganizado e disperso. Tende a falar demais, fazer promessas exageradas e buscar aprovação dos outros em vez de focar na solução. Pode evitar confrontos necessários.",
    warningSignals: ["Fica quieto e retraído (sinal grave)", "Para de socializar com a equipe", "Perde o entusiasmo por projetos", "Torna-se sarcástico ou negativista"],
    strengths: ["Comunicação persuasiva", "Construção de relacionamentos", "Entusiasmo contagiante", "Criatividade e brainstorming"],
    developmentAreas: ["Organização e follow-up", "Escuta ativa e profundidade", "Tomada de decisão baseada em dados"],
  },
  S: {
    name: "Navegador",
    description: "Pessoa estável, confiável e dedicada às relações e ao bem-estar da equipe. Valoriza harmonia, consistência e lealdade. É o porto seguro da equipe, sempre disponível para apoiar e manter a estabilidade em momentos turbulentos.",
    motivations: ["Ambiente harmonioso e previsível", "Relacionamentos de confiança", "Reconhecimento pela lealdade", "Processos claros e bem definidos"],
    values: ["Lealdade e compromisso", "Estabilidade e segurança", "Harmonia no ambiente", "Respeito mútuo e consideração"],
    fears: ["Mudanças abruptas e inesperadas", "Conflitos interpessoais não resolvidos", "Perder segurança ou estabilidade", "Pressão excessiva por resultados rápidos"],
    communicationStyle: "Calmo, ponderado e prefere conversas individuais a apresentações em grupo. Ouve mais do que fala e escolhe as palavras com cuidado. Pode parecer reservado em reuniões grandes.",
    underPressure: "Tende a se retrair, evitar confrontos e aceitar demandas excessivas sem reclamar. Pode se tornar passivo, acumular resentimento e se sentir sobrecarregado sem pedir ajuda.",
    warningSignals: ["Diz 'sim' para tudo sem questionar (sobrecarga)", "Fica mais quieto que o habitual", "Expressa frustração de forma passivo-agressiva", "Aumenta erros por descuido"],
    strengths: ["Confiabilidade excepcional", "Escuta ativa e empatia", "Trabalho em equipe colaborativo", "Paciência e persistência"],
    developmentAreas: ["Assertividade e expressão de opiniões", "Adaptação a mudanças", "Tomada de iniciativa proativa"],
  },
  C: {
    name: "Analista",
    description: "Pessoa meticulosa, analítica e comprometida com qualidade e precisão. Valoriza processos bem definidos, dados concretos e padrões elevados de excelência. Garante que os detalhes não sejam esquecidos e decisões sejam baseadas em fatos.",
    motivations: ["Trabalho de alta qualidade", "Acesso a informações completas", "Ambiente organizado com processos claros", "Reconhecimento pela expertise e precisão"],
    values: ["Qualidade e excelência", "Precisão e atenção aos detalhes", "Lógica e objetividade", "Conhecimento profundo e especialização"],
    fears: ["Cometer erros que afetem sua reputação", "Decidir sem informações suficientes", "Ambientes caóticos e sem padrões", "Ser criticado por trabalho mal feito"],
    communicationStyle: "Preciso, detalhado e factual. Prefere comunicação escrita a verbal e gosta de documentar tudo. Pode parecer frio ou distante em conversas informais, mas é confiável em comunicações técnicas.",
    underPressure: "Tende a se retrair e analisar excessivamente, entrando em paralisia analítica. Pode se tornar excessivamente crítico, focar em detalhes irrelevantes e resistir a decidir sem dados completos.",
    warningSignals: ["Questiona excessivamente cada decisão", "Perfeccionismo a ponto de não entregar", "Torna-se mais crítico e negativo", "Isola-se e reduz comunicação"],
    strengths: ["Análise profunda e pensamento crítico", "Atenção excepcional aos detalhes", "Tomada de decisão baseada em dados", "Planejamento estruturado"],
    developmentAreas: ["Agilidade na tomada de decisão", "Comunicação simplificada", "Flexibilidade diante de imperfeições"],
  },
};

// ── Helper functions ──

function getDISCProfileKey(disc: Record<string, number>): string {
  const d = disc.D ?? disc.d ?? 0;
  const i = disc.I ?? disc.i ?? 0;
  const s = disc.S ?? disc.s ?? 0;
  const c = disc.C ?? disc.c ?? 0;
  const max = Math.max(d, i, s, c);
  if (max === d) return "D";
  if (max === i) return "I";
  if (max === s) return "S";
  return "C";
}

function clamp(v: number, min: number, max: number) {
  return Math.max(min, Math.min(max, v));
}

// ── System prompt (enriched from legacy) ──

const SYSTEM_PROMPT = `Você é um especialista sênior em Recursos Humanos com 20+ anos de experiência em:
- Análise de perfis comportamentais e inteligência emocional (metodologia dnia)
- Gestão de equipes e resolução de conflitos
- Desenvolvimento de liderança
- Alocação estratégica de talentos

## Sobre a metodologia dnia
O dnia mapeia o perfil comportamental e a inteligência emocional em uma análise integrada:
- **Perfil Comportamental**: Determinado (D), Navegador (N/S), Influenciador (I), Analista (A/C)
- **Traços de Personalidade**: Inovação (O), Disciplina (C), Sociabilidade (E), Empatia (A), Resiliência (N)
- NUNCA use os termos: DISC, Dominância, Submissão, Conformidade, Estabilidade, Executor, Inspirador, Estabilizador, Cuidador, Comunicador, Planejador, Big Five, OCEAN, Neuroticismo, Extroversão, Amabilidade, Conscienciosidade, Abertura.

## Diretrizes de Resposta
1. **Tom**: Profissional, empático e didático
2. **Exemplos**: Use situações concretas do dia a dia corporativo (reuniões, projetos, feedbacks, deadlines)
3. **Linguagem**: Português brasileiro, evite jargões excessivos
4. **Foco**: Sempre conecte os perfis dnia com ações práticas e específicas
5. **Qualidade**: Cada item deve ter 1-2 frases específicas e acionáveis — NUNCA use generalidades como "melhorar comunicação" ou "ser mais paciente"
6. **Personalização**: SEMPRE use os nomes reais das pessoas e referencie seus perfis específicos
7. **Perfil Natural vs Adaptado**: Considere as diferenças — o Natural mostra a essência, o Adaptado mostra como a pessoa se ajusta ao ambiente atual. Grandes diferenças indicam esforço de adaptação.

## Importante
- SEMPRE baseie suas respostas nos dados dos perfis fornecidos
- Seja específico e acionável — evite generalidades
- Reconheça tanto pontos positivos quanto desafios
- Responda APENAS com JSON válido, sem markdown e sem code blocks`;

// ── Build rich profile context ──

function buildProfileBlock(
  name: string,
  disc: Record<string, number>,
  discAdapted: Record<string, number> | null,
  bigFive: Record<string, number> | null,
  aiAnalysis: Record<string, unknown> | null,
): string {
  const key = getDISCProfileKey(disc);
  const profile = profileData[key];
  const pontosFortes = (aiAnalysis?.pontos_fortes as string[]) || profile.strengths;
  const areasDesenv = (aiAnalysis?.areas_desenvolvimento as string[]) || profile.developmentAreas;

  return `### Perfil: ${name}

**Perfil Predominante:** ${profile.name}
**Descrição:** ${profile.description}

**Perfil Comportamental Natural (dnia):**
- D — Determinado: ${disc.D ?? disc.d ?? 0}%
- N — Navegador: ${disc.S ?? disc.s ?? 0}%
- I — Influenciador: ${disc.I ?? disc.i ?? 0}%
- A — Analista: ${disc.C ?? disc.c ?? 0}%

**Perfil Comportamental Adaptado (dnia):**
- D — Determinado: ${discAdapted?.D ?? discAdapted?.d ?? 0}%
- N — Navegador: ${discAdapted?.S ?? discAdapted?.s ?? 0}%
- I — Influenciador: ${discAdapted?.I ?? discAdapted?.i ?? 0}%
- A — Analista: ${discAdapted?.C ?? discAdapted?.c ?? 0}%

**Traços de Personalidade (dnia):**
- Inovação (O): ${bigFive?.O ?? bigFive?.o ?? 0}/30
- Disciplina (C): ${bigFive?.C ?? bigFive?.c ?? 0}/30
- Sociabilidade (E): ${bigFive?.E ?? bigFive?.e ?? 0}/30
- Empatia (A): ${bigFive?.A ?? bigFive?.a ?? 0}/30
- Resiliência (N): ${bigFive?.N ?? bigFive?.n ?? 0}/30

**Motivações:** ${profile.motivations.join("; ")}
**Valores:** ${profile.values.join("; ")}
**Medos:** ${profile.fears.join("; ")}
**Estilo de Comunicação:** ${profile.communicationStyle}
**Sob Pressão:** ${profile.underPressure}
**Sinais de Alerta:** ${profile.warningSignals.join("; ")}

**Pontos Fortes:**
${pontosFortes.map((p, i) => `${i + 1}. ${p}`).join("\n")}

**Áreas de Desenvolvimento:**
${areasDesenv.map((a, i) => `${i + 1}. ${a}`).join("\n")}`;
}

// ── Prompt builders ──

const PEER_TOOL = {
  type: "function" as const,
  function: {
    name: "analyze_peer_compatibility",
    description: "Retorna a análise de compatibilidade entre dois colegas de trabalho.",
    parameters: {
      type: "object",
      properties: {
        pontos_fortes: { type: "array", items: { type: "string" }, description: "3 pontos fortes da dupla" },
        conflitos: { type: "array", items: { type: "string" }, description: "3 potenciais conflitos" },
        recomendacoes: { type: "array", items: { type: "string" }, description: "3 recomendações práticas" },
        complementaridades: { type: "array", items: { type: "string" }, description: "3 complementaridades" },
        dicas_trabalho: { type: "array", items: { type: "string" }, description: "3 dicas de trabalho conjunto" },
        projetos_ideais: { type: "array", items: { type: "string" }, description: "3 tipos de projetos ideais" },
        o_que_evitar: { type: "array", items: { type: "string" }, description: "3 coisas a evitar" },
      },
      required: ["pontos_fortes", "conflitos", "recomendacoes", "complementaridades", "dicas_trabalho", "projetos_ideais", "o_que_evitar"],
      additionalProperties: false,
    },
  },
};

const LEADER_TOOL = {
  type: "function" as const,
  function: {
    name: "analyze_leader_compatibility",
    description: "Retorna a análise de compatibilidade líder-liderado.",
    parameters: {
      type: "object",
      properties: {
        pontos_fortes: { type: "array", items: { type: "string" }, description: "3 pontos fortes da relação" },
        conflitos: { type: "array", items: { type: "string" }, description: "3 potenciais conflitos" },
        recomendacoes: { type: "array", items: { type: "string" }, description: "3 recomendações" },
        estilo_lideranca: { type: "array", items: { type: "string" }, description: "3 aspectos do estilo de liderança ideal" },
        estrategias_delegacao: { type: "array", items: { type: "string" }, description: "3 estratégias de delegação" },
        comunicacao_efetiva: { type: "array", items: { type: "string" }, description: "3 dicas de comunicação" },
        motivadores_chave: { type: "array", items: { type: "string" }, description: "3 motivadores-chave do liderado" },
        sinais_alerta: { type: "array", items: { type: "string" }, description: "3 sinais de alerta" },
        nivel_autonomia: { type: "array", items: { type: "string" }, description: "3 aspectos sobre autonomia" },
        frequencia_feedback: { type: "array", items: { type: "string" }, description: "3 recomendações de feedback" },
      },
      required: ["pontos_fortes", "conflitos", "recomendacoes", "estilo_lideranca", "estrategias_delegacao", "comunicacao_efetiva", "motivadores_chave", "sinais_alerta", "nivel_autonomia", "frequencia_feedback"],
      additionalProperties: false,
    },
  },
};

function buildPeerPrompt(name1: string, name2: string, ctx: string, score: number) {
  return `${ctx}

---

## Score de compatibilidade calculado: ${score}/100

Analise detalhadamente a compatibilidade entre **${name1}** e **${name2}** como COLEGAS DE TRABALHO (peer-to-peer).

### Diretrizes de qualidade para cada item:
- Cada item deve ser específico para os perfis de ${name1} e ${name2} — NÃO use frases genéricas
- Use os nomes reais em cada item
- Dê exemplos de situações concretas do dia a dia (reuniões, projetos, deadlines, feedbacks)
- Considere as diferenças entre DISC Natural e Adaptado de cada pessoa
- Conecte os traços comportamentais (motivações, medos, estilo de comunicação) com as recomendações`;
}

function buildLeaderPrompt(name1: string, name2: string, ctx: string, score: number) {
  return `${ctx}

---

## Score de compatibilidade calculado: ${score}/100

Analise detalhadamente a relação LÍDER-LIDERADO entre **${name1}** (líder) e **${name2}** (liderado).

### Diretrizes de qualidade para cada item:
- Cada item deve ser específico para os perfis de ${name1} e ${name2} — NÃO use frases genéricas
- Use os nomes reais em cada item
- Dê exemplos de situações concretas do dia a dia (delegação, 1:1, feedback, projetos)
- Considere as diferenças entre DISC Natural e Adaptado de cada pessoa
- Conecte os traços comportamentais (motivações, medos, estilo de comunicação, reação sob pressão) com as estratégias`;
}

function cleanTrailingCommas(str: string): string {
  return str.replace(/,\s*([\]}])/g, "$1");
}

// ── Main handler ──

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return new Response(JSON.stringify({ error: "Missing authorization" }), {
        status: 401,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_ANON_KEY")!,
      { global: { headers: { Authorization: authHeader } } }
    );

    const token = authHeader.replace("Bearer ", "");
    const { data: claimsData, error: claimsError } = await supabase.auth.getClaims(token);
    if (claimsError || !claimsData?.claims) {
      return new Response(JSON.stringify({ error: "Unauthorized" }), {
        status: 401,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }
    const user = { id: claimsData.claims.sub as string };

    const { user1_id, user2_id, comparison_type = "peer_to_peer" } = await req.json();
    if (!user1_id || !user2_id || user1_id === user2_id) {
      return new Response(JSON.stringify({ error: "Two different user IDs required" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const serviceClient = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    const [res1, res2, profile1, profile2] = await Promise.all([
      serviceClient.from("test_results").select("disc_natural, disc_adapted, big_five, iem, ai_analysis").eq("user_id", user1_id).order("completed_at", { ascending: false }).limit(1).single(),
      serviceClient.from("test_results").select("disc_natural, disc_adapted, big_five, iem, ai_analysis").eq("user_id", user2_id).order("completed_at", { ascending: false }).limit(1).single(),
      serviceClient.from("profiles").select("name").eq("user_id", user1_id).single(),
      serviceClient.from("profiles").select("name").eq("user_id", user2_id).single(),
    ]);

    if (res1.error || !res1.data || res2.error || !res2.data) {
      return new Response(JSON.stringify({ error: "Test results not found for one or both users" }), {
        status: 404,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const disc1 = res1.data.disc_natural as { D: number; I: number; S: number; C: number };
    const disc2 = res2.data.disc_natural as { D: number; I: number; S: number; C: number };
    const discAdapt1 = res1.data.disc_adapted as { D: number; I: number; S: number; C: number } | null;
    const discAdapt2 = res2.data.disc_adapted as { D: number; I: number; S: number; C: number } | null;
    const big5_1 = res1.data.big_five as Record<string, number> | null;
    const big5_2 = res2.data.big_five as Record<string, number> | null;
    const ai1 = res1.data.ai_analysis as Record<string, unknown> | null;
    const ai2 = res2.data.ai_analysis as Record<string, unknown> | null;

    // Weighted compatibility: DISC 60% + Big Five 40%
    const diffD = Math.abs(disc1.D - disc2.D);
    const diffI = Math.abs(disc1.I - disc2.I);
    const diffS = Math.abs(disc1.S - disc2.S);
    const diffC = Math.abs(disc1.C - disc2.C);
    const discScore = clamp(100 - ((diffD + diffI + diffS + diffC) / 80 * 100), 0, 100);

    let oceanScore = 50;
    if (big5_1 && big5_2) {
      const diffO = Math.abs((big5_1.O ?? big5_1.o ?? 0) - (big5_2.O ?? big5_2.o ?? 0));
      const diffCo = Math.abs((big5_1.C ?? big5_1.c ?? 0) - (big5_2.C ?? big5_2.c ?? 0));
      const diffE = Math.abs((big5_1.E ?? big5_1.e ?? 0) - (big5_2.E ?? big5_2.e ?? 0));
      const diffA = Math.abs((big5_1.A ?? big5_1.a ?? 0) - (big5_2.A ?? big5_2.a ?? 0));
      const diffN = Math.abs((big5_1.N ?? big5_1.n ?? 0) - (big5_2.N ?? big5_2.n ?? 0));
      oceanScore = clamp(100 - ((diffO + diffCo + diffE + diffA + diffN) / 150 * 100), 0, 100);
    }

    const compatibilityScore = Math.round(discScore * 0.6 + oceanScore * 0.4);

    const name1 = profile1.data?.name || "Perfil 1";
    const name2 = profile2.data?.name || "Perfil 2";

    // Build rich context
    const profileContext = `# Contexto da Comparação

${buildProfileBlock(name1, disc1, discAdapt1, big5_1, ai1)}

---

${buildProfileBlock(name2, disc2, discAdapt2, big5_2, ai2)}`;

    // AI analysis
    let aiAnalysis: Record<string, unknown> = { pontos_fortes: [], conflitos: [], recomendacoes: [] };
    try {
      const LOVABLE_API_KEY = Deno.env.get("LOVABLE_API_KEY");
      if (LOVABLE_API_KEY) {
        const isLeader = comparison_type === "leader_member";
        const prompt = isLeader
          ? buildLeaderPrompt(name1, name2, profileContext, compatibilityScore)
          : buildPeerPrompt(name1, name2, profileContext, compatibilityScore);
        const tool = isLeader ? LEADER_TOOL : PEER_TOOL;
        const toolName = tool.function.name;

        const aiResponse = await fetch("https://ai.gateway.lovable.dev/v1/chat/completions", {
          method: "POST",
          headers: {
            Authorization: `Bearer ${LOVABLE_API_KEY}`,
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            model: "google/gemini-3-flash-preview",
            messages: [
              { role: "system", content: SYSTEM_PROMPT },
              { role: "user", content: prompt },
            ],
            tools: [tool],
            tool_choice: { type: "function", function: { name: toolName } },
          }),
        });

        if (aiResponse.ok) {
          const aiData = await aiResponse.json();
          const msg = aiData.choices?.[0]?.message;

          // Primary: extract from tool call
          const toolCall = msg?.tool_calls?.[0];
          if (toolCall?.function?.arguments) {
            try {
              aiAnalysis = JSON.parse(toolCall.function.arguments);
              console.log("AI analysis parsed via tool calling successfully");
            } catch (e) {
              console.error("Failed to parse tool call arguments:", e);
            }
          }

          // Fallback: try content with trailing comma cleanup
          if (!toolCall?.function?.arguments || Object.keys(aiAnalysis).length <= 3) {
            const content = msg?.content || "";
            if (content) {
              const cleanContent = cleanTrailingCommas(
                content.replace(/```json\n?/g, "").replace(/```\n?/g, "").trim()
              );
              try {
                aiAnalysis = JSON.parse(cleanContent);
                console.log("AI analysis parsed via content fallback");
              } catch {
                console.error("Failed to parse AI content fallback:", cleanContent.substring(0, 200));
              }
            }
          }
        } else {
          console.error("AI error:", aiResponse.status);
        }
      }
    } catch (aiErr) {
      console.error("AI analysis error:", aiErr);
    }

    // Save comparison
    const { error: saveError } = await serviceClient.from("profile_comparisons").insert({
      user1_id,
      user2_id,
      compatibility_score: compatibilityScore,
      ai_analysis: aiAnalysis,
      comparison_type,
    });
    if (saveError) console.error("Save error:", saveError);

    // Notification
    await serviceClient.from("notifications").insert({
      user_id: user.id,
      type: "comparison_done",
      title: "Comparação concluída! 📊",
      message: `Comparação entre ${name1} e ${name2} realizada. Compatibilidade: ${compatibilityScore}%`,
    });

    return new Response(JSON.stringify({
      compatibility_score: compatibilityScore,
      comparison_type,
      ai_analysis: aiAnalysis,
      user1: { name: name1, disc: disc1, disc_adapted: discAdapt1, big_five: big5_1 },
      user2: { name: name2, disc: disc2, disc_adapted: discAdapt2, big_five: big5_2 },
    }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("Error:", err);
    return new Response(JSON.stringify({ error: "Internal error", details: String(err) }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
