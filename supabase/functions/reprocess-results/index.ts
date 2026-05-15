import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type, x-supabase-client-platform, x-supabase-client-platform-version, x-supabase-client-runtime, x-supabase-client-runtime-version",
};

interface DISCScores { D: number; I: number; S: number; C: number; }
interface OceanScores { O: number; C: number; E: number; A: number; N: number; }

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return new Response(JSON.stringify({ error: "Missing authorization" }), {
        status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_ANON_KEY")!,
      { global: { headers: { Authorization: authHeader } } }
    );

    const { data: { user }, error: userError } = await supabase.auth.getUser();
    if (userError || !user) {
      return new Response(JSON.stringify({ error: "Unauthorized" }), {
        status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const serviceClient = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    // Check if caller is admin
    const { data: callerRoles } = await serviceClient
      .from("user_roles")
      .select("role")
      .eq("user_id", user.id);

    const isAdmin = callerRoles?.some(r => r.role === "master_admin" || r.role === "company_admin");
    if (!isAdmin) {
      return new Response(JSON.stringify({ error: "Forbidden" }), {
        status: 403, headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const { userId, testId } = await req.json();
    if (!userId || !testId) {
      return new Response(JSON.stringify({ error: "userId and testId required" }), {
        status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // Fetch saved responses
    const { data: responses, error: respError } = await serviceClient
      .from("test_responses")
      .select("block_number, most_option, least_option")
      .eq("user_id", userId)
      .order("block_number");

    if (respError || !responses || responses.length === 0) {
      return new Response(JSON.stringify({ error: "No responses found for this user" }), {
        status: 404, headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // Fetch scenario blocks
    const { data: blocks, error: blocksError } = await serviceClient
      .from("scenario_blocks")
      .select("*")
      .order("block_number");

    if (blocksError || !blocks) {
      return new Response(JSON.stringify({ error: "Failed to fetch scenarios" }), {
        status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // Calculate DISC Natural & Big Five
    const discNatural: DISCScores = { D: 0, I: 0, S: 0, C: 0 };
    const bigFive: OceanScores = { O: 0, C: 0, E: 0, A: 0, N: 0 };
    const optionKeyMap: Record<string, string> = { A: "a", B: "b", C: "c", D: "d" };

    for (const response of responses) {
      const block = blocks.find((b: any) => b.block_number === response.block_number);
      if (!block) continue;

      const mostKey = optionKeyMap[response.most_option];
      const leastKey = optionKeyMap[response.least_option];

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
    const normalize = (score: number) => Math.round((Math.max(0, score) / maxPossible) * 100);

    const discNaturalNorm = { D: normalize(discNatural.D), I: normalize(discNatural.I), S: normalize(discNatural.S), C: normalize(discNatural.C) };
    const bigFiveNorm = { O: normalize(bigFive.O), C: normalize(bigFive.C), E: normalize(bigFive.E), A: normalize(bigFive.A), N: normalize(bigFive.N) };

    const discAdapted = { ...discNaturalNorm };
    const mean = (discAdapted.D + discAdapted.I + discAdapted.S + discAdapted.C) / 4;
    for (const dim of ["D", "I", "S", "C"] as const) {
      discAdapted[dim] = Math.round(discAdapted[dim] * 0.8 + mean * 0.2);
    }

    const neuroticism = bigFiveNorm.N;
    const discVariance = Math.sqrt(
      ((discNaturalNorm.D - mean) ** 2 + (discNaturalNorm.I - mean) ** 2 +
        (discNaturalNorm.S - mean) ** 2 + (discNaturalNorm.C - mean) ** 2) / 4
    );
    const iem = Math.min(100, Math.round(neuroticism * 0.6 + (discVariance / 50) * 40));

    // Generate AI analysis
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

Gere uma análise COMPLETA e PERSONALIZADA baseada nos scores acima. Retorne EXATAMENTE um JSON com esta estrutura (sem markdown, sem code blocks):
{
  "perfil_dominante": "Texto de 200-300 palavras descrevendo o perfil comportamental geral da pessoa em 2-3 parágrafos",
  "ponto_integracao": "Texto de 100-150 palavras com dicas práticas de integração em equipe",
  "estilo_disc": {
    "D": "Texto de 60-80 palavras descrevendo como a Determinação (Determinado) se manifesta nesta pessoa",
    "I": "Texto de 60-80 palavras descrevendo como a Influência (Influenciador) se manifesta nesta pessoa",
    "S": "Texto de 60-80 palavras descrevendo como a Natureza (Navegador) se manifesta nesta pessoa",
    "C": "Texto de 60-80 palavras descrevendo como a Adaptação (Analista) se manifesta nesta pessoa"
  },
  "perfil_estilos_pessoais": "150-200 palavras sobre estilo pessoal",
  "estilos_predominantes": "100-150 palavras sobre estilos predominantes",
  "tracos_dominantes": ["traço 1", "traço 2", "traço 3", "traço 4", "traço 5"],
  "areas_melhoria_papel": ["área 1", "área 2", "área 3", "área 4", "área 5"],
  "pontos_fortes": ["ponto 1", "ponto 2", "ponto 3", "ponto 4", "ponto 5"],
  "areas_desenvolvimento": ["área 1", "área 2", "área 3", "área 4", "área 5"],
  "motivacoes": "100-150 palavras sobre motivações",
  "maturidade_emocional": "100-150 palavras sobre inteligência emocional",
  "contribuicao_papel_social": "100-150 palavras sobre contribuição em grupos",
  "maturidade": "100-150 palavras sobre maturidade profissional",
  "energia_vitalidade": "100-150 palavras sobre energia e resiliência",
  "iem_analise": "50-80 palavras sobre equilíbrio mental e recomendações"
}`;

        const aiResponse = await fetch("https://ai.gateway.lovable.dev/v1/chat/completions", {
          method: "POST",
          headers: { Authorization: `Bearer ${LOVABLE_API_KEY}`, "Content-Type": "application/json" },
          body: JSON.stringify({
            model: "google/gemini-3-flash-preview",
            messages: [
              { role: "system", content: "Você é um psicólogo organizacional especialista em perfis comportamentais e inteligência emocional (metodologia dnia). Responda APENAS com JSON válido, sem markdown." },
              { role: "user", content: prompt },
            ],
          }),
        });

        if (aiResponse.ok) {
          const aiData = await aiResponse.json();
          const content = aiData.choices?.[0]?.message?.content || "";
          const cleanContent = content.replace(/```json\n?/g, "").replace(/```\n?/g, "").trim();
          try { aiAnalysis = JSON.parse(cleanContent); } catch {
            aiAnalysis = { perfil_dominante: content, pontos_fortes: [], areas_desenvolvimento: [], iem_analise: "" };
          }
        }
      }
    } catch (aiErr) { console.error("AI analysis error:", aiErr); }

    // Update existing result
    const { data: result, error: saveError } = await serviceClient
      .from("test_results")
      .update({
        disc_natural: discNaturalNorm,
        disc_adapted: discAdapted,
        big_five: bigFiveNorm,
        iem,
        ai_analysis: aiAnalysis,
        completed_at: new Date().toISOString(),
      })
      .eq("id", testId)
      .select()
      .single();

    if (saveError) {
      return new Response(JSON.stringify({ error: "Failed to update results", details: saveError.message }), {
        status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    return new Response(JSON.stringify(result), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err) {
    return new Response(JSON.stringify({ error: "Internal error", details: String(err) }), {
      status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
