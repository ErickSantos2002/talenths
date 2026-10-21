import { Button } from "@/components/ui/button";

/** Lazy guide chunks get new hashed names on each deploy: a tab opened before it can only recover by reloading. */
export function GuideLoadError({ what = "os guias" }: { what?: string }) {
  return (
    <div className="space-y-3">
      <p className="text-sm">
        Não foi possível carregar {what}. Se o TalentHS foi atualizado, recarregue a página.
      </p>
      <Button variant="outline" onClick={() => window.location.reload()}>
        Recarregar a página
      </Button>
    </div>
  );
}
