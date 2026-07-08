import { useCallback, useState } from "react";

/** Opções de itens por página oferecidas nas tabelas do sistema. */
export const PAGE_SIZE_OPTIONS = [10, 30, 50, 100];

const storageKeyFor = (table: string) => `talenths:pageSize:${table}`;

/**
 * Tamanho de página persistido no navegador, por tabela.
 * Valores guardados fora das opções válidas são ignorados (cai no padrão).
 */
export function usePageSize(table: string, defaultSize = 10) {
  const [pageSize, setState] = useState<number>(() => {
    try {
      const raw = localStorage.getItem(storageKeyFor(table));
      const parsed = raw ? Number(raw) : NaN;
      return PAGE_SIZE_OPTIONS.includes(parsed) ? parsed : defaultSize;
    } catch {
      return defaultSize;
    }
  });

  const setPageSize = useCallback((size: number) => {
    setState(size);
    try {
      localStorage.setItem(storageKeyFor(table), String(size));
    } catch {
      // localStorage indisponível (ex.: modo privado) — segue só em memória
    }
  }, [table]);

  return [pageSize, setPageSize] as const;
}
