import { describe, it, expect } from "vitest";
import { render, screen, fireEvent } from "@testing-library/react";
import { MemoryRouter, Routes, Route } from "react-router-dom";
import { GuideContent } from "./GuideContent";

const setup = (body: string) =>
  render(
    <MemoryRouter initialEntries={["/ajuda"]}>
      <Routes>
        <Route path="/ajuda" element={<GuideContent body={body} />} />
        <Route path="/meu-perfil" element={<p>Página do perfil</p>} />
      </Routes>
    </MemoryRouter>,
  );

describe("GuideContent", () => {
  it("renderiza markdown básico", () => {
    const { container } = setup("# Título\n\n**Salvar**\n\n- um\n- dois");
    expect(container.querySelector("h1")?.textContent).toBe("Título");
    expect(container.querySelector("strong")?.textContent).toBe("Salvar");
    expect(container.querySelectorAll("li")).toHaveLength(2);
    expect(container.firstElementChild?.className).toContain("prose");
  });

  it("mostra HTML cru como texto", () => {
    const { container } = setup(
      "<script>alert(1)</script>\n\n<img src=x onerror=alert(1)>",
    );
    expect(container.querySelector("script")).toBeNull();
    expect(container.querySelector("img")).toBeNull();
    expect(container.textContent).toContain("<script>alert(1)</script>");
    expect(container.textContent).toContain("onerror=alert(1)");
  });

  it("links javascript: e http: viram só texto", () => {
    const { container } = setup(
      "[perigo](javascript:alert(1)) e [inseguro](http://exemplo.com)",
    );
    expect(container.querySelector("a")).toBeNull();
    expect(container.textContent).toContain("perigo");
    expect(container.textContent).toContain("inseguro");
  });

  it("link https abre em nova aba", () => {
    setup("[site](https://exemplo.com)");
    const a = screen.getByRole("link", { name: "site" });
    expect(a.getAttribute("href")).toBe("https://exemplo.com");
    expect(a.getAttribute("target")).toBe("_blank");
    expect(a.getAttribute("rel")).toBe("noreferrer");
  });

  it("link interno navega pelo router", () => {
    setup("[Meu Perfil](/meu-perfil)");
    fireEvent.click(screen.getByRole("link", { name: "Meu Perfil" }));
    expect(screen.getByText("Página do perfil")).toBeTruthy();
  });

  it("imagem de /capturas/*.webp com alt é renderizada", () => {
    setup("![Tela de vídeos](/capturas/meus-videos.webp)");
    const img = screen.getByAltText("Tela de vídeos");
    expect(img.getAttribute("src")).toBe("/capturas/meus-videos.webp");
    expect(img.getAttribute("loading")).toBe("lazy");
  });

  it("imagem externa, fora do padrão ou sem alt não vira <img>", () => {
    const { container } = setup(
      "![externa](https://x.com/a.webp) ![traversal](/capturas/../a.webp) ![](/capturas/ok.webp) ![png](/capturas/ok.png)",
    );
    expect(container.querySelector("img")).toBeNull();
    expect(container.textContent).toContain("externa");
  });
});
