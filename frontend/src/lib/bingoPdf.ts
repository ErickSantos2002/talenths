import type { jsPDF } from "jspdf";
import type { BingoGameDetail, BingoCard } from "@/types/bingo";

/** Carrega o hs.ico e converte em PNG dataURL (jsPDF não aceita .ico direto). */
async function loadLogo(): Promise<string | null> {
  try {
    const img = new Image();
    img.src = "/hs.ico";
    await img.decode();
    const c = document.createElement("canvas");
    c.width = 64; c.height = 64;
    const ctx = c.getContext("2d");
    if (!ctx) return null;
    ctx.drawImage(img, 0, 0, 64, 64);
    return c.toDataURL("image/png");
  } catch {
    return null;
  }
}

/** Gera e baixa o PDF das cartelas (A4 paisagem, 9 por folha, vetorial). */
export async function generateBingoPdf(detail: BingoGameDetail) {
  const { jsPDF: JsPDF } = await import("jspdf");
  const logo = await loadLogo();
  const pool = detail.game.number_pool;
  const per = pool / 10;
  const cards = detail.cards;

  const pdf = new JsPDF({ orientation: "landscape", unit: "mm", format: "a4" });
  const PW = pdf.internal.pageSize.getWidth();
  const PH = pdf.internal.pageSize.getHeight();
  const M = 8;
  const perPage = 9;
  const pages = Math.max(1, Math.ceil(cards.length / perPage));

  for (let p = 0; p < pages; p++) {
    if (p > 0) pdf.addPage();

    pdf.setTextColor(15, 42, 99);
    pdf.setFont("helvetica", "bold"); pdf.setFontSize(13);
    pdf.text(detail.game.name, PW / 2, M + 4, { align: "center" });
    pdf.setFont("helvetica", "normal"); pdf.setFontSize(8); pdf.setTextColor(107, 118, 136);
    pdf.text(
      `Monte de 1 a ${pool} - marque quando seu numero for sorteado - cartela cheia (20 numeros) vence`,
      PW / 2, M + 9, { align: "center" },
    );

    const gridTop = M + 13;
    const gridBottom = PH - M - 4;
    const areaW = PW - 2 * M;
    const areaH = gridBottom - gridTop;
    const cols = 3, rows = 3, gap = 4;
    const cardW = (areaW - (cols - 1) * gap) / cols;
    const cardH = (areaH - (rows - 1) * gap) / rows;

    const pageCards = cards.slice(p * perPage, p * perPage + perPage);
    pageCards.forEach((card, idx) => {
      const x0 = M + (idx % cols) * (cardW + gap);
      const y0 = gridTop + Math.floor(idx / cols) * (cardH + gap);
      drawCard(pdf, card, x0, y0, cardW, cardH, per, logo);
    });

    pdf.setFont("helvetica", "normal"); pdf.setFontSize(8); pdf.setTextColor(154, 164, 180);
    pdf.text(`TalentHS - Folha ${p + 1} de ${pages}`, PW / 2, PH - M + 1, { align: "center" });
  }

  const safe = (detail.game.name || "bingo").replace(/[^\w.-]+/g, "_");
  pdf.save(`cartelas_${safe}.pdf`);
}

function drawCard(pdf: jsPDF, card: BingoCard, x: number, y: number, w: number, h: number, per: number, logo: string | null) {
  const pad = 3;

  pdf.setDrawColor(45, 54, 70); pdf.setLineWidth(0.3); pdf.setLineDashPattern([], 0);
  pdf.roundedRect(x, y, w, h, 2, 2, "S");

  const innerX = x + pad;
  const innerW = w - 2 * pad;
  let cursorY = y + pad;

  // Cabeçalho: logo + nome (esquerda), código (direita)
  if (logo) { try { pdf.addImage(logo, "PNG", innerX, cursorY, 4.5, 4.5); } catch { /* ignora */ } }
  pdf.setFont("helvetica", "bold"); pdf.setFontSize(9); pdf.setTextColor(23, 51, 122);
  pdf.text(card.user_name ?? "-", innerX + (logo ? 6 : 0), cursorY + 3.4);
  pdf.setFont("helvetica", "normal"); pdf.setFontSize(7); pdf.setTextColor(138, 148, 166);
  pdf.text(`#${card.code}`, x + w - pad, cursorY + 3.2, { align: "right" });
  cursorY += 6;
  pdf.setDrawColor(228, 232, 239); pdf.setLineWidth(0.2);
  pdf.line(innerX, cursorY - 1, x + w - pad, cursorY - 1);

  const gcols = 10, grows = 3, cgap = 0.7;
  const cellW = (innerW - (gcols - 1) * cgap) / gcols;

  // Faixas por coluna
  pdf.setFont("helvetica", "bold"); pdf.setFontSize(4.6); pdf.setTextColor(154, 164, 180);
  for (let c = 0; c < gcols; c++) {
    const rx = innerX + c * (cellW + cgap) + cellW / 2;
    pdf.text(`${c * per + 1}-${c * per + per}`, rx, cursorY + 2, { align: "center" });
  }
  cursorY += 3;

  const gridArea = (y + h - pad) - cursorY;
  const cellH = Math.min(cellW, (gridArea - (grows - 1) * cgap) / grows);
  const blockH = grows * cellH + (grows - 1) * cgap;
  const gy = cursorY + (gridArea - blockH) / 2;

  for (let r = 0; r < grows; r++) {
    for (let c = 0; c < gcols; c++) {
      const val = card.layout[r]?.[c] ?? null;
      const px = innerX + c * (cellW + cgap);
      const py = gy + r * (cellH + cgap);
      if (val === null) {
        pdf.setDrawColor(210, 216, 226); pdf.setLineWidth(0.2); pdf.setLineDashPattern([0.6, 0.6], 0);
        pdf.roundedRect(px, py, cellW, cellH, 0.6, 0.6, "S");
        pdf.setLineDashPattern([], 0);
      } else {
        pdf.setFillColor(239, 245, 255); pdf.setDrawColor(195, 214, 247); pdf.setLineWidth(0.25);
        pdf.roundedRect(px, py, cellW, cellH, 0.8, 0.8, "FD");
        pdf.setFont("helvetica", "bold"); pdf.setFontSize(8); pdf.setTextColor(29, 78, 216);
        pdf.text(String(val), px + cellW / 2, py + cellH / 2, { align: "center", baseline: "middle" });
      }
    }
  }
}
