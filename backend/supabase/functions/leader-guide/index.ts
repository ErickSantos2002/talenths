import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type, x-supabase-client-platform, x-supabase-client-platform-version, x-supabase-client-runtime, x-supabase-client-runtime-version",
};

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

    const { data: { user }, error: userError } = await supabase.auth.getUser();
    if (userError || !user) {
      return new Response(JSON.stringify({ error: "Unauthorized" }), {
        status: 401,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const { user_id: targetUserId } = await req.json();
    if (!targetUserId) {
      return new Response(JSON.stringify({ error: "user_id is required" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const serviceClient = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    // Verify caller is a leader
    const { data: callerRole } = await serviceClient
      .from("user_roles")
      .select("role")
      .eq("user_id", user.id)
      .in("role", ["leader", "master_admin", "company_admin"])
      .limit(1)
      .single();

    if (!callerRole) {
      return new Response(JSON.stringify({ error: "Acesso negado" }), {
        status: 403,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // Fetch target user's profile and test results
    const [profileRes, resultRes] = await Promise.all([
      serviceClient.from("profiles").select("name").eq("user_id", targetUserId).single(),
      serviceClient.from("test_results").select("*").eq("user_id", targetUserId)
        .order("completed_at", { ascending: false }).limit(1).single(),
    ]);

    if (!resultRes.data) {
      return new Response(JSON.stringify({ error: "Resultado do teste nao encontrado para este colaborador" }), {
        status: 404,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const disc = resultRes.data.disc_natural as { D: number; I: number; S: number; C: number };
    const bigFive = resultRes.data.big_five as { O: number; C: number; E: number; A: number; N: number };
    const userName = profileRes.data?.name || "Colaborador";

    const LOVABLE_API_KEY = Deno.env.get("LOVABLE_API_KEY");
    if (!LOVABLE_API_KEY) {
      return new Response(JSON.stringify({ error: "AI not configured" }), {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const prompt = `Gere um guia de gestao personalizado para o liderado "${userName}" baseado no perfil dnia:

Perfil Comportamental (dnia): D-Determinado=${disc.D}, N-Navegador=${disc.S}, I-Influenciador=${disc.I}, A-Analista=${disc.C}
Traços de Personalidade (dnia): Inovação=${bigFive.O}, Disciplina=${bigFive.C}, Sociabilidade=${bigFive.E}, Empatia=${bigFive.A}, Resiliência=${bigFive.N}

Retorne EXATAMENTE um JSON com esta estrutura (sem markdown, sem code blocks):
{
  "comunicacao": ["dica pratica 1", "dica pratica 2", "dica pratica 3"],
  "motivacao": ["estrategia 1", "estrategia 2", "estrategia 3"],
  "pontos_atencao": ["ponto 1", "ponto 2", "ponto 3"]
}

Cada dica deve ter 1-2 frases, ser pratica e especifica ao perfil.`;

    const aiResponse = await fetch("https://ai.gateway.lovable.dev/v1/chat/completions", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${LOVABLE_API_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: "google/gemini-3-flash-preview",
        messages: [
          { role: "system", content: "Voce e um consultor de lideranca e gestao de pessoas especialista em perfis comportamentais e inteligencia emocional (metodologia dnia). Use apenas nomenclatura DNIA: Determinado, Navegador, Influenciador, Analista. NUNCA use os termos: DISC, Dominância, Submissão, Conformidade, Estabilidade, Executor, Inspirador, Estabilizador, Cuidador, Comunicador, Planejador, Big Five, OCEAN, Neuroticismo, Extroversão, Amabilidade, Conscienciosidade, Abertura. Responda APENAS com JSON valido." },
          { role: "user", content: prompt },
        ],
      }),
    });

    if (!aiResponse.ok) {
      const status = aiResponse.status;
      if (status === 429) {
        return new Response(JSON.stringify({ error: "Limite de requisicoes excedido. Tente novamente em alguns minutos." }), {
          status: 429,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }
      if (status === 402) {
        return new Response(JSON.stringify({ error: "Creditos de IA esgotados." }), {
          status: 402,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }
      return new Response(JSON.stringify({ error: "Erro na IA" }), {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const aiData = await aiResponse.json();
    const content = aiData.choices?.[0]?.message?.content || "";
    const cleanContent = content.replace(/```json\n?/g, "").replace(/```\n?/g, "").trim();

    let guide;
    try {
      guide = JSON.parse(cleanContent);
    } catch {
      guide = { comunicacao: [], motivacao: [], pontos_atencao: [cleanContent] };
    }

    return new Response(JSON.stringify({ name: userName, guide }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("Leader guide error:", err);
    return new Response(JSON.stringify({ error: "Erro interno" }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
