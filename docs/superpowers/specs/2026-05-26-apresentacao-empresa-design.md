# ApresentacaoEmpresaPage — Redesign Cinemático

**Data:** 2026-05-26
**Status:** Aprovado pelo usuário

---

## Visão Geral

Transformar a página de apresentação da empresa de um formulário CRUD simples em uma experiência cinematográfica de leitura guiada. Cada seção aparece com animação ao entrar na viewport, criando a sensação de que o colaborador está "descobrindo" a empresa progressivamente.

---

## Layout Geral

- Mantém o `AdminLayout` (sidebar de navegação permanece)
- Conteúdo ocupa toda a área disponível — sem cards com borda, sem padding comprimido
- Background: `#0d1117` (levemente mais escuro que o tema padrão)
- Cada seção tem `min-height: 80vh` para forçar leitura antes de rolar

---

## Seções e Animações

### 1. Hero (nome da empresa)
- Sem imagem de capa
- Blobs decorativos em emerald com blur forte (`filter: blur(90px)`)
- Elementos revelados em sequência via `setTimeout`:
  - Eyebrow label ("Bem-vindo à empresa") → fade in, 150ms
  - Nome da empresa (`company.name`) → fade + translateY(24px→0), 350ms
  - CNPJ se preenchido (`CNPJ: XX.XXX.XXX/XXXX-XX`), senão omitido → fade, 700ms
- Seta com animação "bob" indicando para rolar

### 2. Missão
- Sticky tag no topo: `• Missão`
- Label "NOSSA MISSÃO" → fade + translateY(8px→0) ao entrar na viewport
- Texto: **efeito typewriter** — caracteres aparecem a ~32ms cada
- Fonte: 26px bold, cor `#f1f5f9`

### 3. Visão
- Mesmo padrão da Missão
- Label "NOSSA VISÃO"
- Typewriter com mesmo timing

### 4. Valores
- Label "NOSSOS VALORES" → reveal ao entrar viewport
- Grid 2×2, máx 600px de largura
- Cada card: ícone SVG em container circular emerald + título + descrição
- Stagger: cards aparecem com 130ms de diferença entre si
- Ícones por valor:
  - Integridade → shield-check (escudo)
  - Inovação → lightbulb (lâmpada)
  - Cuidado → heart (coração)
  - Excelência → bolt (raio)

### 5. Nossa História
- Label "NOSSA HISTÓRIA"
- Typewriter mais lento (~28ms/char), fonte menor (17px), cor `#94a3b8`
- Estilo narrativo — parece que está sendo contado

---

## Modo de Edição (Admin)

- Botão "Editar conteúdo" fixo no canto inferior direito (só visível para `manager` e `master_admin`)
- Ao clicar: troca para o formulário atual (Textarea por campo, salvar/cancelar)
- Formulário = mesma lógica já implementada, sem alteração funcional
- Campo `presentation_cover_url` permanece no formulário de edição mas **não é exibido** na view cinemática

---

## Trigger de Animação

- `IntersectionObserver` com `threshold: 0.25`
- Cada seção é observada individualmente
- Animação dispara **uma única vez** (flag `triggered` por seção)
- Hero dispara automaticamente após 200ms (sem necessidade de scroll)

---

## Responsivo

- Mobile: grid de valores vira 1 coluna
- Hero: fonte reduz para 36px em telas menores
- Padding lateral reduz de 56px para 24px em mobile

---

## Dados

- Mesma query: `companies.getPresentation` (TanStack Query, key `["company-presentation"]`)
- Mesma mutation: `companies.updatePresentation`
- Nenhuma mudança no backend ou na API

---

## O que NÃO muda

- Lógica de autenticação e permissões
- Estrutura de dados da API
- Formulário de edição (mesma UX)
- AdminLayout e navegação lateral

---

## Arquivos Afetados

- `frontend/src/pages/ApresentacaoEmpresaPage.tsx` — reescrita total do modo visualização
