import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type, x-supabase-client-platform, x-supabase-client-platform-version, x-supabase-client-runtime, x-supabase-client-runtime-version",
};

// ─── Helpers ───────────────────────────────────────────────────

function escapePdf(text: string): string {
  return text
    .replace(/\\/g, "\\\\")
    .replace(/\(/g, "\\(")
    .replace(/\)/g, "\\)")
    .replace(/[áàâã]/g, "a")
    .replace(/[éèê]/g, "e")
    .replace(/[íìî]/g, "i")
    .replace(/[óòôõ]/g, "o")
    .replace(/[úùû]/g, "u")
    .replace(/[ç]/g, "c")
    .replace(/[Á]/g, "A")
    .replace(/[É]/g, "E")
    .replace(/[Í]/g, "I")
    .replace(/[Ó]/g, "O")
    .replace(/[Ú]/g, "U")
    .replace(/[Ç]/g, "C")
    .replace(/[ñ]/g, "n")
    .replace(/[Ñ]/g, "N")
    .replace(/[^\x20-\x7E]/g, "");
}

function wrapText(text: string, maxChars: number): string[] {
  if (!text) return [];
  const words = text.split(" ");
  const lines: string[] = [];
  let current = "";
  for (const word of words) {
    if ((current + " " + word).trim().length > maxChars) {
      if (current) lines.push(current);
      current = word;
    } else {
      current = current ? current + " " + word : word;
    }
  }
  if (current) lines.push(current);
  return lines;
}

function parseFullAnalysis(rawAnalysis: any) {
  let analysis =
    typeof rawAnalysis === "string"
      ? (() => {
          try {
            return JSON.parse(rawAnalysis);
          } catch {
            return {};
          }
        })()
      : rawAnalysis || {};

  if (
    analysis.perfil_dominante &&
    typeof analysis.perfil_dominante === "string" &&
    analysis.perfil_dominante.trim().startsWith("{")
  ) {
    try {
      const sanitized = analysis.perfil_dominante.replace(/,(\s*[}\]])/g, "$1");
      const inner = JSON.parse(sanitized);
      analysis = { ...analysis, ...inner };
    } catch {
      /* keep original */
    }
  }

  for (const key of [
    "tracos_dominantes",
    "pontos_fortes",
    "areas_desenvolvimento",
    "areas_melhoria_papel",
  ]) {
    if (analysis[key] && typeof analysis[key] === "string") {
      try {
        analysis[key] = JSON.parse(analysis[key]);
      } catch {
        analysis[key] = [];
      }
    }
    if (!Array.isArray(analysis[key])) analysis[key] = [];
  }

  if (analysis.estilo_disc && typeof analysis.estilo_disc === "string") {
    try {
      analysis.estilo_disc = JSON.parse(analysis.estilo_disc);
    } catch {
      analysis.estilo_disc = {};
    }
  }

  return analysis;
}

// ─── PdfBuilder ────────────────────────────────────────────────

interface PageData {
  lines: string[];
}

class PdfBuilder {
  private pages: PageData[] = [];
  private yPos = 750;
  private readonly pageWidth = 595;
  private readonly pageHeight = 842;
  private readonly topMargin = 780;
  private readonly bottomMargin = 60;
  private readonly leftMargin = 50;
  private readonly contentWidth = 495;

  constructor() {
    this.newPage();
  }

  private newPage() {
    this.pages.push({ lines: [] });
    this.yPos = this.topMargin;
  }

  private currentPage(): PageData {
    return this.pages[this.pages.length - 1];
  }

  private ensureSpace(needed: number) {
    if (this.yPos - needed < this.bottomMargin) {
      this.newPage();
    }
  }

  addLine(text: string, fontSize = 11, bold = false) {
    const lineHeight = fontSize * 1.6;
    this.ensureSpace(lineHeight);
    this.currentPage().lines.push(
      `BT /F${bold ? 2 : 1} ${fontSize} Tf ${this.leftMargin} ${this.yPos.toFixed(1)} Td (${escapePdf(text)}) Tj ET`
    );
    this.yPos -= lineHeight;
  }

  addTitle(text: string) {
    this.ensureSpace(30);
    this.addLine(text, 14, true);
    this.addSpacer(4);
  }

  addSectionTitle(text: string) {
    this.ensureSpace(40);
    this.addSpacer(6);
    this.addLine(text, 15, true);
    this.addSpacer(4);
  }

  addParagraph(text: string) {
    if (!text) return;
    // If perfil_dominante is still a long JSON string, just show it as text
    const displayText = typeof text === "string" ? text : String(text);
    const wrapped = wrapText(displayText, 85);
    for (const line of wrapped) {
      this.addLine(line, 10);
    }
    this.addSpacer(4);
  }

  addBulletList(items: string[]) {
    if (!items || !items.length) return;
    for (const item of items) {
      const wrapped = wrapText(item, 80);
      for (let i = 0; i < wrapped.length; i++) {
        this.addLine(i === 0 ? `  - ${wrapped[i]}` : `    ${wrapped[i]}`, 10);
      }
    }
    this.addSpacer(4);
  }

  addBar(label: string, value: number) {
    const v = Math.max(0, Math.min(100, value || 0));
    const barLen = 20;
    const filled = Math.round((v / 100) * barLen);
    const bar = "|".repeat(filled) + ".".repeat(barLen - filled);
    this.addLine(`  ${label}: ${v}/100  [${bar}]`, 10);
  }

  addSpacer(px = 10) {
    this.yPos -= px;
  }

  addSeparator() {
    this.ensureSpace(15);
    this.currentPage().lines.push(
      `q 0.7 0.7 0.7 RG 0.5 w ${this.leftMargin} ${this.yPos.toFixed(1)} m ${this.leftMargin + this.contentWidth} ${this.yPos.toFixed(1)} l S Q`
    );
    this.yPos -= 15;
  }

  build(): Uint8Array {
    const encoder = new TextEncoder();
    const pageCount = this.pages.length;

    // Object numbering:
    // 1 = Catalog
    // 2 = Pages
    // 3,4 = Font Helvetica, Helvetica-Bold
    // Then for each page: pageObj, contentStreamObj
    // So page i => obj (5 + i*2) = page, obj (6 + i*2) = stream

    const totalObjects = 4 + pageCount * 2;
    const parts: string[] = [];
    const offsets: number[] = [];
    let bytePos = 0;

    const addPart = (s: string) => {
      parts.push(s);
      bytePos += encoder.encode(s).length;
    };

    const addObj = (s: string) => {
      offsets.push(bytePos);
      addPart(s);
    };

    // Header
    addPart("%PDF-1.4\n");

    // 1: Catalog
    addObj("1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n\n");

    // 2: Pages
    const kids = [];
    for (let i = 0; i < pageCount; i++) {
      kids.push(`${5 + i * 2} 0 R`);
    }
    addObj(
      `2 0 obj\n<< /Type /Pages /Kids [${kids.join(" ")}] /Count ${pageCount} >>\nendobj\n\n`
    );

    // 3: Font Helvetica
    addObj(
      "3 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>\nendobj\n\n"
    );

    // 4: Font Helvetica-Bold
    addObj(
      "4 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold /Encoding /WinAnsiEncoding >>\nendobj\n\n"
    );

    // Pages + content streams
    for (let i = 0; i < pageCount; i++) {
      const pageObjNum = 5 + i * 2;
      const streamObjNum = 6 + i * 2;
      const streamContent = this.pages[i].lines.join("\n");
      const streamBytes = encoder.encode(streamContent);

      // Page object
      addObj(
        `${pageObjNum} 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 ${this.pageWidth} ${this.pageHeight}] /Contents ${streamObjNum} 0 R /Resources << /Font << /F1 3 0 R /F2 4 0 R >> >> >>\nendobj\n\n`
      );

      // Content stream
      addObj(
        `${streamObjNum} 0 obj\n<< /Length ${streamBytes.length} >>\nstream\n${streamContent}\nendstream\nendobj\n\n`
      );
    }

    // Xref
    const xrefPos = bytePos;
    const objCount = offsets.length + 1; // +1 for object 0
    let xref = `xref\n0 ${objCount}\n0000000000 65535 f \r\n`;
    for (const offset of offsets) {
      xref += `${String(offset).padStart(10, "0")} 00000 n \r\n`;
    }

    addPart(xref);
    addPart(
      `trailer\n<< /Size ${objCount} /Root 1 0 R >>\nstartxref\n${xrefPos}\n%%EOF\n`
    );

    // Combine
    const fullPdf = parts.join("");
    return encoder.encode(fullPdf);
  }
}

// ─── PDF Content Builder ───────────────────────────────────────

function buildPdfContent(result: any, userName: string): Uint8Array {
  const pdf = new PdfBuilder();
  const analysis = parseFullAnalysis(result.ai_analysis);

  // Header
  pdf.addLine("talentIA - Relatorio de Perfil Comportamental", 18, true);
  pdf.addSpacer(6);
  pdf.addLine(`Colaborador: ${userName}`, 12);
  const dateStr = new Date(result.completed_at).toLocaleDateString("pt-BR", {
    day: "2-digit",
    month: "long",
    year: "numeric",
  });
  pdf.addLine(`Data do teste: ${dateStr}`, 10);
  pdf.addSpacer(4);
  pdf.addSeparator();

  // DISC Natural
  const discN = result.disc_natural || {};
  pdf.addSectionTitle("DISC Natural");
  pdf.addBar("D - Dominancia  ", discN.D);
  pdf.addBar("I - Influencia  ", discN.I);
  pdf.addBar("S - Estabilidade", discN.S);
  pdf.addBar("C - Conformidade", discN.C);

  // DISC Adapted
  const discA = result.disc_adapted || {};
  pdf.addSectionTitle("DISC Adaptado");
  pdf.addBar("D - Dominancia  ", discA.D);
  pdf.addBar("I - Influencia  ", discA.I);
  pdf.addBar("S - Estabilidade", discA.S);
  pdf.addBar("C - Conformidade", discA.C);

  // Big Five
  const bf = result.big_five || {};
  pdf.addSectionTitle("Big Five (OCEAN)");
  pdf.addBar("O - Abertura         ", bf.O);
  pdf.addBar("C - Conscienciosidade", bf.C);
  pdf.addBar("E - Extroversao      ", bf.E);
  pdf.addBar("A - Amabilidade      ", bf.A);
  pdf.addBar("N - Neuroticismo     ", bf.N);

  // IEM
  pdf.addSectionTitle(`IEM (Indice de Estresse Mental): ${result.iem ?? "N/A"}/100`);
  if (analysis.iem_analise) {
    pdf.addParagraph(analysis.iem_analise);
  }

  // Perfil Comportamental
  if (analysis.perfil_dominante && typeof analysis.perfil_dominante === "string" && !analysis.perfil_dominante.trim().startsWith("{")) {
    pdf.addSectionTitle("Seu Perfil Comportamental");
    pdf.addParagraph(analysis.perfil_dominante);
  }

  // Ponto de Integracao
  if (analysis.ponto_integracao) {
    pdf.addSectionTitle("Ponto de Partida para Integracao");
    pdf.addParagraph(analysis.ponto_integracao);
  }

  // Estilo DISC Detalhado
  if (analysis.estilo_disc && typeof analysis.estilo_disc === "object") {
    pdf.addSectionTitle("Estilo DISC Natural");
    const labels: Record<string, string> = {
      D: "Dominancia",
      I: "Influencia",
      S: "Estabilidade",
      C: "Conformidade",
    };
    for (const dim of ["D", "I", "S", "C"]) {
      if (analysis.estilo_disc[dim]) {
        pdf.addTitle(`  ${dim} - ${labels[dim]}:`);
        pdf.addParagraph(analysis.estilo_disc[dim]);
      }
    }
  }

  // Estilos Predominantes
  if (analysis.estilos_predominantes) {
    pdf.addSectionTitle("Identificando os Estilos Predominantes");
    pdf.addParagraph(analysis.estilos_predominantes);
  }

  // Perfil de Estilos Pessoais
  if (analysis.perfil_estilos_pessoais) {
    pdf.addSectionTitle("Perfil de Estilos Pessoais");
    pdf.addParagraph(analysis.perfil_estilos_pessoais);
  }

  // Tracos Dominantes
  if (analysis.tracos_dominantes?.length) {
    pdf.addSectionTitle("Tracos Dominantes");
    pdf.addBulletList(analysis.tracos_dominantes);
  }

  // Pontos Fortes
  if (analysis.pontos_fortes?.length) {
    pdf.addSectionTitle("Pontos Fortes");
    pdf.addBulletList(analysis.pontos_fortes);
  }

  // Areas de Melhoria no Papel
  if (analysis.areas_melhoria_papel?.length) {
    pdf.addSectionTitle("Areas de Melhoria no Papel Atual");
    pdf.addBulletList(analysis.areas_melhoria_papel);
  }

  // Areas de Desenvolvimento
  if (analysis.areas_desenvolvimento?.length) {
    pdf.addSectionTitle("Areas de Desenvolvimento");
    pdf.addBulletList(analysis.areas_desenvolvimento);
  }

  // Motivacoes
  if (analysis.motivacoes) {
    pdf.addSectionTitle("Motivacoes");
    pdf.addParagraph(analysis.motivacoes);
  }

  // Maturidade Emocional
  if (analysis.maturidade_emocional) {
    pdf.addSectionTitle("Perfil de Maturidade Emocional");
    pdf.addParagraph(analysis.maturidade_emocional);
  }

  // Contribuicao e Papel Social
  if (analysis.contribuicao_papel_social) {
    pdf.addSectionTitle("Contribuicao e Papel Social");
    pdf.addParagraph(analysis.contribuicao_papel_social);
  }

  // Maturidade
  if (analysis.maturidade) {
    pdf.addSectionTitle("Maturidade");
    pdf.addParagraph(analysis.maturidade);
  }

  // Energia e Vitalidade
  if (analysis.energia_vitalidade) {
    pdf.addSectionTitle("Energia e Vitalidade");
    pdf.addParagraph(analysis.energia_vitalidade);
  }

  // Footer
  pdf.addSeparator();
  pdf.addLine(`Gerado por talentIA - ${new Date().toLocaleDateString("pt-BR")}`, 9);

  return pdf.build();
}

// ─── Edge Function Handler ─────────────────────────────────────

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

    const { result_id } = await req.json();

    const serviceClient = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    const { data: result, error: resultError } = await serviceClient
      .from("test_results")
      .select("*")
      .eq("id", result_id)
      .single();

    if (resultError || !result) {
      return new Response(
        JSON.stringify({ error: "Resultado nao encontrado" }),
        {
          status: 404,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    // Allow owner, master admins, and company admins
    if (result.user_id !== user.id) {
      const { data: roles } = await serviceClient
        .from("user_roles")
        .select("role, company_id")
        .eq("user_id", user.id);

      const isMaster = roles?.some((r: any) => r.role === "master_admin");

      let isCompanyAdmin = false;
      if (!isMaster) {
        const { data: targetProfile } = await serviceClient
          .from("profiles")
          .select("company_id")
          .eq("user_id", result.user_id)
          .single();
        if (targetProfile?.company_id) {
          isCompanyAdmin = roles?.some(
            (r: any) => r.role === "company_admin" && r.company_id === targetProfile.company_id
          ) ?? false;
        }
      }

      if (!isMaster && !isCompanyAdmin) {
        return new Response(JSON.stringify({ error: "Acesso negado" }), {
          status: 403,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }
    }

    const { data: profile } = await serviceClient
      .from("profiles")
      .select("name")
      .eq("user_id", user.id)
      .single();

    const pdfBytes = buildPdfContent(
      result,
      profile?.name || user.email || "Usuario"
    );

    return new Response(new Blob([pdfBytes], { type: "application/pdf" }), {
      headers: {
        ...corsHeaders,
        "Content-Type": "application/pdf",
        "Content-Disposition": `attachment; filename="dnia-resultado.pdf"`,
      },
    });
  } catch (err) {
    console.error("PDF error:", err);
    return new Response(JSON.stringify({ error: "Erro ao gerar PDF" }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
