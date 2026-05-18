import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type, x-supabase-client-platform, x-supabase-client-platform-version, x-supabase-client-runtime, x-supabase-client-runtime-version",
};

interface ResponseItem {
  blockNumber: number;
  most: string;
  least: string;
}

interface DISCScores {
  D: number;
  I: number;
  S: number;
  C: number;
}

interface OceanScores {
  O: number;
  C: number;
  E: number;
  A: number;
  N: number;
}

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

    const {
      data: { user },
      error: userError,
    } = await supabase.auth.getUser();
    if (userError || !user) {
      return new Response(JSON.stringify({ error: "Unauthorized" }), {
        status: 401,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const { responses } = (await req.json()) as { responses: ResponseItem[] };

    if (!responses || responses.length !== 12) {
      return new Response(
        JSON.stringify({ error: "Exactly 12 responses required" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const serviceClient = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    const { data: blocks, error: blocksError } = await serviceClient
      .from("scenario_blocks")
      .select("*")
      .order("block_number");

    if (blocksError || !blocks) {
      return new Response(
        JSON.stringify({ error: "Failed to fetch scenarios" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Calculate DISC Natural & Big Five
    const discNatural: DISCScores = { D: 0, I: 0, S: 0, C: 0 };
    const bigFive: OceanScores = { O: 0, C: 0, E: 0, A: 0, N: 0 };

    const optionKeyMap: Record<string, string> = { A: "a", B: "b", C: "c", D: "d" };

    for (const response of responses) {
      const block = blocks.find((b: any) => b.block_number === response.blockNumber);
      if (!block) continue;

      const mostKey = optionKeyMap[response.most];
      const leastKey = optionKeyMap[response.least];

      const mostWeights = block[`weights_${mostKey}`] as DISCScores;
      const leastWeights = block[`weights_${leastKey}`] as DISCScores;
      const mostOcean = block[`ocean_weights_${mostKey}`] as OceanScores;
      const leastOcean = block[`ocean_weights_${leastKey}`] as OceanScores;

      for (const dim of ["D", "I", "S", "C"] as const) {
        discNatural[dim] += (mostWeights[dim] || 0) * 3 - (leastWeights[dim] || 0);
      }
      for (const dim of ["O", "C", "E", "A", "N"] as const) {
        bigFive[dim] += (mostOcean[dim] || 0) * 3 - (leastOcean[dim] || 0);
      }
    }

    const maxPossible = 12 * 3 * 3;
    const normalize = (score: number) =>
      Math.round((Math.max(0, score) / maxPossible) * 100);

    const discNaturalNorm = {
      D: normalize(discNatural.D),
      I: normalize(discNatural.I),
      S: normalize(discNatural.S),
      C: normalize(discNatural.C),
    };

    const bigFiveNorm = {
      O: normalize(bigFive.O),
      C: normalize(bigFive.C),
      E: normalize(bigFive.E),
      A: normalize(bigFive.A),
      N: normalize(bigFive.N),
    };

    // DISC Adapted
    const discAdapted = { ...discNaturalNorm };
    const mean = (discAdapted.D + discAdapted.I + discAdapted.S + discAdapted.C) / 4;
    for (const dim of ["D", "I", "S", "C"] as const) {
      discAdapted[dim] = Math.round(discAdapted[dim] * 0.8 + mean * 0.2);
    }

    // Calculate IEM
    const neuroticism = bigFiveNorm.N;
    const discVariance = Math.sqrt(
      ((discNaturalNorm.D - mean) ** 2 +
        (discNaturalNorm.I - mean) ** 2 +
        (discNaturalNorm.S - mean) ** 2 +
        (discNaturalNorm.C - mean) ** 2) / 4
    );
    const iem = Math.min(100, Math.round(neuroticism * 0.6 + (discVariance / 50) * 40));

    // Save result FIRST (before responses, to ensure user always gets scores)
    const { data: result, error: saveError } = await serviceClient
      .from("test_results")
      .insert({
        user_id: user.id,
        disc_natural: discNaturalNorm,
        disc_adapted: discAdapted,
        big_five: bigFiveNorm,
        iem,
        ai_analysis: {}, // Will be filled by AI below if successful
      })
      .select()
      .single();

    if (saveError) {
      return new Response(
        JSON.stringify({ error: "Failed to save results", details: saveError.message }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Save responses as batch (single INSERT instead of 12)
    const allResponses = responses.map((r) => ({
      user_id: user.id,
      block_number: r.blockNumber,
      most_option: r.most,
      least_option: r.least,
    }));

    // Delete old responses first, then batch insert new ones
    await serviceClient.from("test_responses").delete().eq("user_id", user.id);
    await serviceClient.from("test_responses").insert(allResponses);

    // Generate AI analysis with timeout (non-blocking for result)
    let aiAnalysis = {};
    try {
      const LOVABLE_API_KEY = Deno.env.get("LOVABLE_API_KEY");
      if (LOVABLE_API_KEY) {
        const prompt = `Analise este perfil comportamental dnia e responda em português brasileiro. Você é um psicólogo organizacional sênior com 20+ anos de experiência em perfis comportamentais e inteligência emocional.

IMPORTANTE — NOMENCLATURA OBRIGATÓRIA (metodologia dnia):
- As 4 dimensões comportamentais são: D (Determinação / Determinado), N (Natureza / Navegador), I (Influência / Influenciador), A (Adaptação / Analista).
- Os 5 traços de personalidade são: Inovação, Disciplina, Sociabilidade, Empatia e Resiliência.
- O indicador de saúde mental é o IEM (Índice de Equilíbrio Mental).
- NUNCA use os termos: DISC, Dominância, Submissão, Conformidade, Estabilidade, Executor, Inspirador, Estabilizador, Cuidador, Comunicador, Planejador, Big Five, OCEAN, Neuroticismo, Extroversão, Amabilidade, Conscienciosidade, Abertura.
- Ao se referir à dimensão D, chame de "Determinação" (perfil Determinado).
- Ao se referir à dimensão N, chame de "Natureza" (perfil Navegador).
- Ao se referir à dimensão I, chame de "Influência" (perfil Influenciador).
- Ao se referir à dimensão A, chame de "Adaptação" (perfil Analista).

Perfil Comportamental Natural (dnia): D-Determinado=${discNaturalNorm.D}, N-Navegador=${discNaturalNorm.S}, I-Influenciador=${discNaturalNorm.I}, A-Analista=${discNaturalNorm.C}
Perfil Comportamental Adaptado (dnia): D-Determinado=${discAdapted.D}, N-Navegador=${discAdapted.S}, I-Influenciador=${discAdapted.I}, A-Analista=${discAdapted.C}
Traços de Personalidade (dnia): Inovação=${bigFiveNorm.O}, Disciplina=${bigFiveNorm.C}, Sociabilidade=${bigFiveNorm.E}, Empatia=${bigFiveNorm.A}, Resiliência=${bigFiveNorm.N}
IEM (Índice de Equilíbrio Mental): ${iem}

Gere uma análise COMPLETA e PERSONALIZADA baseada nos scores acima. Cada texto deve ser único e refletir os números específicos deste perfil. Retorne EXATAMENTE um JSON com esta estrutura (sem markdown, sem code blocks):
{
  "perfil_dominante": "Texto de 200-300 palavras descrevendo o perfil comportamental geral da pessoa em 2-3 parágrafos. Inclua estilo de comunicação, tomada de decisão, como lida com pressão e como interage com equipes",
  "ponto_integracao": "Texto de 100-150 palavras com dicas práticas de como essa pessoa pode se integrar melhor em uma equipe, considerando seus pontos fortes e fracos",
  "estilo_disc": {
    "D": "Texto de 60-80 palavras descrevendo como a Determinação (Determinado) se manifesta nesta pessoa",
    "I": "Texto de 60-80 palavras descrevendo como a Influência (Influenciador) se manifesta nesta pessoa",
    "S": "Texto de 60-80 palavras descrevendo como a Natureza (Navegador) se manifesta nesta pessoa",
    "C": "Texto de 60-80 palavras descrevendo como a Adaptação (Analista) se manifesta nesta pessoa"
  },
  "perfil_estilos_pessoais": "Texto de 150-200 palavras descrevendo o estilo pessoal geral, como se apresenta profissionalmente, como se comunica e como é percebido pelos colegas",
  "estilos_predominantes": "Texto de 100-150 palavras identificando os 2-3 estilos que mais se destacam e como eles se combinam para formar o perfil único desta pessoa",
  "tracos_dominantes": ["traço 1", "traço 2", "traço 3", "traço 4", "traço 5"],
  "areas_melhoria_papel": ["área de melhoria no papel atual 1", "área 2", "área 3", "área 4", "área 5"],
  "pontos_fortes": ["ponto forte 1", "ponto forte 2", "ponto forte 3", "ponto forte 4", "ponto forte 5"],
  "areas_desenvolvimento": ["área de desenvolvimento 1", "área 2", "área 3", "área 4", "área 5"],
  "motivacoes": "Texto de 100-150 palavras sobre o que motiva essa pessoa no trabalho, que tipo de ambiente a energiza e quais são seus principais drivers internos",
  "maturidade_emocional": "Texto de 100-150 palavras analisando o nível de inteligência emocional, autoconsciência, empatia e gestão de emoções",
  "contribuicao_papel_social": "Texto de 100-150 palavras sobre como essa pessoa contribui em grupos e equipes, qual papel social ela tende a assumir e como impacta a dinâmica do time",
  "maturidade": "Texto de 100-150 palavras sobre o nível de maturidade profissional, capacidade de lidar com responsabilidades e visão de longo prazo",
  "energia_vitalidade": "Texto de 100-150 palavras sobre o nível de energia, disposição, resiliência e vitalidade no trabalho, relacionando com o IEM",
  "iem_analise": "Texto de 50-80 palavras explicando o nível de equilíbrio mental e recomendações práticas"
}`;

        // 30-second timeout for AI call
        const controller = new AbortController();
        const timeoutId = setTimeout(() => controller.abort(), 30000);

        try {
          const aiResponse = await fetch(
            "https://ai.gateway.lovable.dev/v1/chat/completions",
            {
              method: "POST",
              headers: {
                Authorization: `Bearer ${LOVABLE_API_KEY}`,
                "Content-Type": "application/json",
              },
              body: JSON.stringify({
                model: "google/gemini-3-flash-preview",
                messages: [
                  {
                    role: "system",
                    content: "Você é um psicólogo organizacional especialista em perfis comportamentais e inteligência emocional (metodologia dnia). Responda APENAS com JSON válido, sem markdown.",
                  },
                  { role: "user", content: prompt },
                ],
              }),
              signal: controller.signal,
            }
          );

          clearTimeout(timeoutId);

          if (aiResponse.ok) {
            const aiData = await aiResponse.json();
            const content = aiData.choices?.[0]?.message?.content || "";
            const cleanContent = content.replace(/```json\n?/g, "").replace(/```\n?/g, "").trim();
            try {
              aiAnalysis = JSON.parse(cleanContent);
            } catch {
              aiAnalysis = { perfil_dominante: content, pontos_fortes: [], areas_desenvolvimento: [], iem_analise: "" };
            }
          }
        } catch (fetchErr) {
          clearTimeout(timeoutId);
          console.error("AI fetch error (timeout or network):", fetchErr);
          // AI failed - result already saved with empty ai_analysis
        }
      }
    } catch (aiErr) {
      console.error("AI analysis error:", aiErr);
    }

    // Update result with AI analysis (even if empty)
    if (Object.keys(aiAnalysis).length > 0) {
      await serviceClient
        .from("test_results")
        .update({ ai_analysis: aiAnalysis })
        .eq("id", result.id);
    }

    // Create notification
    const hasAi = Object.keys(aiAnalysis).length > 0;
    await serviceClient.from("notifications").insert({
      user_id: user.id,
      type: "test_completed",
      title: hasAi ? "Teste concluído! 🎉" : "Teste concluído! 📊",
      message: hasAi
        ? "Seu perfil comportamental foi gerado com sucesso. Acesse a página de resultados para ver sua análise completa."
        : "Seus scores foram calculados com sucesso. A análise detalhada por IA pode estar sendo processada.",
    });

    // Return the result with AI analysis merged
    return new Response(JSON.stringify({ ...result, ai_analysis: aiAnalysis }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err) {
    return new Response(
      JSON.stringify({ error: "Internal error", details: String(err) }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
