import { describe, expect, it } from "vitest";
import { loginErrorMessage } from "./loginError";

describe("loginErrorMessage", () => {
  it("mostra o aviso de acesso desativado vindo do servidor", () => {
    expect(loginErrorMessage(new Error("Seu acesso foi desativado. Procure o RH."))).toBe(
      "Seu acesso foi desativado. Procure o RH.",
    );
  });

  it("mantém a mensagem padrão para os demais erros", () => {
    expect(loginErrorMessage(new Error("Email ou senha incorretos"))).toBe(
      "Email ou senha incorretos. Verifique suas credenciais.",
    );
    expect(loginErrorMessage(new Error("Failed to fetch"))).toBe(
      "Email ou senha incorretos. Verifique suas credenciais.",
    );
  });
});
