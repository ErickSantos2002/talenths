/** "2026-11-18" -> "18/11/2026", sem passar por Date: uma data pura lida como UTC cairia no
 * dia anterior no fuso de Brasília. */
export function formatDateOnly(iso: string | null | undefined): string {
  if (!iso) return "";
  const [y, m, d] = iso.slice(0, 10).split("-");
  return `${d}/${m}/${y}`;
}
