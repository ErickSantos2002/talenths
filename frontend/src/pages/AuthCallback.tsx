import { useEffect, useState } from "react";
import { useSearchParams, useNavigate } from "react-router-dom";
import { Loader2 } from "lucide-react";
import { Button } from "@/components/ui/button";

const BASE_URL = import.meta.env.VITE_API_URL ?? "http://localhost:8000";
const TOKEN_KEY = "talenths_token";
const USER_KEY = "talenths_user";

const ERROR_MESSAGES: Record<string, string> = {
  microsoft_auth_failed: "Falha na autenticação com Microsoft. Tente novamente.",
  user_not_found: "Nenhuma conta encontrada para este e-mail Microsoft. Contate o administrador.",
};

export default function AuthCallback() {
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const [errorMsg, setErrorMsg] = useState<string | null>(null);

  useEffect(() => {
    const handleCallback = async () => {
      const error = searchParams.get("error");
      if (error) {
        setErrorMsg(ERROR_MESSAGES[error] ?? "Erro na autenticação. Tente novamente.");
        return;
      }

      const accessToken = searchParams.get("access_token");
      if (!accessToken) {
        setErrorMsg("Token inválido. Tente fazer login novamente.");
        return;
      }

      try {
        const res = await fetch(`${BASE_URL}/auth/me`, {
          headers: {
            Authorization: `Bearer ${accessToken}`,
            "Content-Type": "application/json",
          },
        });

        if (!res.ok) throw new Error(`HTTP ${res.status}`);

        const me = await res.json();
        localStorage.setItem(TOKEN_KEY, accessToken);
        localStorage.setItem(USER_KEY, JSON.stringify(me));
        window.location.href = "/apresentacao";
      } catch (e: any) {
        setErrorMsg(`Não foi possível autenticar (${e?.message ?? "erro desconhecido"}). Tente novamente.`);
      }
    };

    handleCallback();
  }, []);

  if (errorMsg) {
    return (
      <div className="dark flex min-h-screen items-center justify-center bg-[#0A0A0A] px-4">
        <div className="w-full max-w-sm rounded-2xl border border-white/10 bg-white/5 p-8 text-center">
          <p className="mb-6 text-sm text-red-400">{errorMsg}</p>
          <Button
            onClick={() => navigate("/login")}
            className="w-full rounded-[1rem] bg-[#3D61FF] text-white hover:bg-[#3D61FF]/90"
          >
            Voltar para o login
          </Button>
        </div>
      </div>
    );
  }

  return (
    <div className="dark flex min-h-screen items-center justify-center bg-[#0A0A0A]">
      <div className="flex flex-col items-center gap-3 text-white/60">
        <Loader2 className="h-8 w-8 animate-spin" />
        <p className="text-sm">Autenticando com Microsoft...</p>
      </div>
    </div>
  );
}
