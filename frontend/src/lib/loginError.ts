const DEACTIVATED = "Seu acesso foi desativado. Procure o RH.";
const DEFAULT = "Email ou senha incorretos. Verifique suas credenciais.";

export function loginErrorMessage(error: Error): string {
  return error.message === DEACTIVATED ? DEACTIVATED : DEFAULT;
}
