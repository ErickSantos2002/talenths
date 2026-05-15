import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type, x-supabase-client-platform, x-supabase-client-platform-version, x-supabase-client-runtime, x-supabase-client-runtime-version",
};

function getDISCProfile(disc: Record<string, number>): string {
  const d = disc.D ?? disc.d ?? 0;
  const i = disc.I ?? disc.i ?? 0;
  const s = disc.S ?? disc.s ?? 0;
  const c = disc.C ?? disc.c ?? 0;
  const max = Math.max(d, i, s, c);
  if (max === d) return "Determinado";
  if (max === i) return "Influenciador";
  if (max === s) return "Navegador";
  return "Analista";
}

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: corsHeaders });

  try {
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return new Response(JSON.stringify({ error: "Não autorizado" }), {
        status: 401,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_ANON_KEY")!;
    const supabase = createClient(supabaseUrl, supabaseKey, {
      global: { headers: { Authorization: authHeader } },
    });

    const { data: { user }, error: authError } = await supabase.auth.getUser();
    if (authError || !user) {
      return new Response(JSON.stringify({ error: "Não autorizado" }), {
        status: 401,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const { conversation_id, message } = await req.json();
    if (!message?.trim()) {
      return new Response(JSON.stringify({ error: "Mensagem vazia" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // Get or create conversation
    let convId = conversation_id;
    if (!convId) {
      const title = message.substring(0, 50) + (message.length > 50 ? "..." : "");
      const { data: conv, error: convError } = await supabase
        .from("hr_conversations")
        .insert({ user_id: user.id, title })
        .select("id")
        .single();
      if (convError) throw convError;
      convId = conv.id;
    }

    // Save user message
    await supabase.from("hr_messages").insert({
      conversation_id: convId,
      role: "user",
      content: message,
    });

    // Fetch user's complete profile data: DISC Natural, DISC Adapted, Big Five, IEM, AI Analysis
    let userContext = "";
    const { data: testResult } = await supabase
      .from("test_results")
      .select("disc_natural, disc_adapted, big_five, iem, ai_analysis")
      .eq("user_id", user.id)
      .order("completed_at", { ascending: false })
      .limit(1)
      .single();

    if (testResult) {
      const discNat = testResult.disc_natural as Record<string, number>;
      const discAdapt = testResult.disc_adapted as Record<string, number>;
      const big5 = testResult.big_five as Record<string, number>;
      const iem = testResult.iem as number | null;
      const aiAnalysis = testResult.ai_analysis as Record<string, unknown> | null;

      const perfilPredominante = discNat ? getDISCProfile(discNat) : "Não disponível";

      // Extract strengths and development areas from ai_analysis
      const pontosFortes = (aiAnalysis?.pontos_fortes as string[])?.join(", ") || "Não disponível";
      const areasDesenvolvimento = (aiAnalysis?.areas_desenvolvimento as string[])?.join(", ") || "Não disponível";

      userContext = `

## Dados do Perfil do Usuário

### Perfil Comportamental Natural (DNIA):
- D (Determinado): ${discNat?.D ?? discNat?.d ?? 0}%
- N (Navegador): ${discNat?.S ?? discNat?.s ?? 0}%
- I (Influenciador): ${discNat?.I ?? discNat?.i ?? 0}%
- A (Analista): ${discNat?.C ?? discNat?.c ?? 0}%

### Perfil Comportamental Adaptado (DNIA):
- D (Determinado): ${discAdapt?.D ?? discAdapt?.d ?? 0}%
- N (Navegador): ${discAdapt?.S ?? discAdapt?.s ?? 0}%
- I (Influenciador): ${discAdapt?.I ?? discAdapt?.i ?? 0}%
- A (Analista): ${discAdapt?.C ?? discAdapt?.c ?? 0}%

### Traços de Personalidade (dnia):
- Inovação (O): ${big5?.O ?? big5?.o ?? 0}/30
- Disciplina (C): ${big5?.C ?? big5?.c ?? 0}/30
- Sociabilidade (E): ${big5?.E ?? big5?.e ?? 0}/30
- Empatia (A): ${big5?.A ?? big5?.a ?? 0}/30
- Resiliência (N): ${big5?.N ?? big5?.n ?? 0}/30

### IEM (Índice de Equilíbrio Mental): ${iem ?? "Não disponível"}

### Perfil Predominante: ${perfilPredominante}

### Pontos Fortes: ${pontosFortes}

### Áreas de Desenvolvimento: ${areasDesenvolvimento}`;
    }

    // Fetch conversation history (limited to last 10 messages)
    const { data: history } = await supabase
      .from("hr_messages")
      .select("role, content")
      .eq("conversation_id", convId)
      .order("created_at", { ascending: true })
      .limit(10);

    const systemPrompt = `# Sistema: Especialista em RH e Psicologia Organizacional

Você é um especialista sênior em Recursos Humanos chamado talentIA, com 20+ anos de experiência em:
- Análise de perfis comportamentais e inteligência emocional (metodologia dnia)
- Gestão de equipes e resolução de conflitos
- Desenvolvimento de liderança
- Alocação estratégica de talentos

## Sobre a metodologia dnia
O dnia mapeia o perfil comportamental e a inteligência emocional em uma análise integrada:
- **Perfil Comportamental**: Determinado (D), Navegador (N), Influenciador (I), Analista (A)
- **Traços de Personalidade**: Inovação, Disciplina, Sociabilidade, Empatia, Resiliência
- NUNCA use os termos: DISC, Dominância, Submissão, Conformidade, Estabilidade, Executor, Inspirador, Estabilizador, Cuidador, Comunicador, Planejador, Big Five, OCEAN, Neuroticismo, Extroversão, Amabilidade, Conscienciosidade, Abertura.
${userContext}

## Diretrizes de Resposta

1. Tom: Profissional, empático e didático
2. Estrutura: Análise + Recomendações práticas
3. Exemplos: Use situações concretas do dia a dia
4. Linguagem: Português brasileiro, evite jargões excessivos
5. Tamanho: Respostas concisas (200-400 palavras)
6. Foco: Sempre conecte teoria com ações práticas
7. Formato: Use markdown para estruturar (negrito, listas, etc.)

## Tipos de Perguntas Esperadas

- Compatibilidade para trabalho em equipe
- Como delegar tarefas considerando os perfis
- Estratégias para resolver conflitos
- Desenvolvimento de carreira personalizado
- Formação de equipes balanceadas
- Como dar feedback para cada perfil
- Situações de crise e mudança

## Importante

- SEMPRE baseie suas respostas nos dados do perfil fornecido
- Seja específico e acionável - evite generalidades
- Reconheça tanto pontos positivos quanto desafios
- Termine com pergunta aberta para continuar a conversa (ex: "Quer que eu detalhe algum desses pontos?")`;

    const aiMessages = [
      { role: "system", content: systemPrompt },
      ...(history || []).map((m: any) => ({ role: m.role, content: m.content })),
    ];

    const LOVABLE_API_KEY = Deno.env.get("LOVABLE_API_KEY");
    if (!LOVABLE_API_KEY) throw new Error("LOVABLE_API_KEY não configurada");

    const aiResponse = await fetch("https://ai.gateway.lovable.dev/v1/chat/completions", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${LOVABLE_API_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: "google/gemini-3-flash-preview",
        messages: aiMessages,
        stream: true,
      }),
    });

    if (!aiResponse.ok) {
      if (aiResponse.status === 429) {
        return new Response(JSON.stringify({ error: "Limite de requisições excedido. Tente novamente em alguns instantes." }), {
          status: 429,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }
      if (aiResponse.status === 402) {
        return new Response(JSON.stringify({ error: "Créditos insuficientes para IA." }), {
          status: 402,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }
      const errText = await aiResponse.text();
      console.error("AI gateway error:", aiResponse.status, errText);
      throw new Error("Erro no gateway de IA");
    }

    // Stream the response and collect full text for saving
    const reader = aiResponse.body!.getReader();
    const encoder = new TextEncoder();
    const decoder = new TextDecoder();
    let fullAssistantText = "";

    const stream = new ReadableStream({
      async start(controller) {
        let buffer = "";
        try {
          while (true) {
            const { done, value } = await reader.read();
            if (done) break;
            buffer += decoder.decode(value, { stream: true });

            let newlineIdx: number;
            while ((newlineIdx = buffer.indexOf("\n")) !== -1) {
              let line = buffer.slice(0, newlineIdx);
              buffer = buffer.slice(newlineIdx + 1);
              if (line.endsWith("\r")) line = line.slice(0, -1);
              if (!line.startsWith("data: ")) continue;
              const jsonStr = line.slice(6).trim();
              if (jsonStr === "[DONE]") {
                controller.enqueue(encoder.encode("data: [DONE]\n\n"));
                continue;
              }
              try {
                const parsed = JSON.parse(jsonStr);
                const content = parsed.choices?.[0]?.delta?.content;
                if (content) fullAssistantText += content;
              } catch { /* partial */ }
              controller.enqueue(encoder.encode(line + "\n\n"));
            }
          }
        } finally {
          // Save assistant message with service role to bypass RLS
          const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
          const adminClient = createClient(supabaseUrl, serviceKey);
          await adminClient.from("hr_messages").insert({
            conversation_id: convId,
            role: "assistant",
            content: fullAssistantText || "(sem resposta)",
          });
          controller.close();
        }
      },
    });

    return new Response(stream, {
      headers: {
        ...corsHeaders,
        "Content-Type": "text/event-stream",
        "X-Conversation-Id": convId,
      },
    });
  } catch (e) {
    console.error("hr-chat error:", e);
    return new Response(JSON.stringify({ error: e instanceof Error ? e.message : "Erro desconhecido" }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
