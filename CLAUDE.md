# TalentHS — CLAUDE.md

## Visão do Projeto

**TalentHS** é um sistema de RH focado no desenvolvimento pessoal de colaboradores da HealthSafety Tech. Partiu de um remix do sistema DN.IA e está sendo transformado em produto próprio — **single-tenant**, feito exclusivamente para uso interno da empresa.

O objetivo central é: cada colaborador consegue ver seu próprio desenvolvimento pessoal na empresa — via avaliações comportamentais, histórico de resultados, comparações de perfil e orientações de RH.

---

## Filosofia de Desenvolvimento

**Qualidade acima de velocidade.** Não há pressa. Cada decisão deve ser tomada da forma correta, mesmo que leve mais tempo. Isso inclui:

- Fazer migrações de banco de dados adequadas em vez de gambiarras de frontend
- Renomear conceitos no código quando o domínio muda, não só nos labels da UI
- Não acumular dívida técnica por conveniência momentânea

---

## Stack Técnica

**Frontend**
- **React 18** + **TypeScript** + **Vite** (SWC)
- **React Router DOM 6** — roteamento client-side
- **Tailwind CSS** + **shadcn/ui** (Radix UI) — sistema de design
- **TanStack React Query 5** — estado de servidor e cache
- **React Hook Form** + **Zod** — formulários e validação
- **Recharts** — gráficos e visualizações
- **next-themes** — dark mode
- **Bun** — package manager preferido (`bun install`, `bun dev`)

**Backend**
- **FastAPI** + **Python 3.13** — API REST
- **asyncpg** — driver PostgreSQL assíncrono
- **PyJWT** + **bcrypt** — autenticação JWT
- **Anthropic SDK** — integração com Claude AI
- **uvicorn** — servidor ASGI (desenvolvimento)

**Banco de Dados**
- **PostgreSQL** hospedado na VPS (Easypanel, `62.72.11.28:9632`)
- RLS (Row Level Security) para isolamento por empresa
- Migrações em `backend/migrations/` — sempre criar nova, nunca editar existentes

---

## Comandos Essenciais

```bash
# Executar sempre a partir de frontend/
cd frontend
bun dev          # servidor de desenvolvimento (porta 8080)
bun build        # build de produção
bun lint         # ESLint
bun test         # Vitest
bun test:watch   # testes em modo watch
```

---

## Estrutura de Pastas

```
talenths/                        # raiz do repositório git
├── frontend/                    # aplicação React
│   ├── src/
│   │   ├── components/
│   │   │   ├── ui/              # Primitivos shadcn/ui (não editar diretamente)
│   │   │   ├── chat/            # Widget e modal de chat com IA
│   │   │   ├── result/          # Componentes da página de resultado
│   │   │   └── team-analysis/   # Análise de equipe (admin/líder)
│   │   ├── pages/               # Uma página por rota
│   │   ├── contexts/            # AuthContext (usuário, sessão, papéis)
│   │   ├── hooks/               # Hooks reutilizáveis
│   │   ├── integrations/
│   │   │   └── supabase/        # Cliente Supabase e tipos gerados
│   │   ├── data/                # Dados estáticos (labels DISC/OCEAN, perfis)
│   │   └── lib/                 # Utilitários (utils.ts, teamAnalysisUtils.ts)
│   ├── public/                  # Assets estáticos
│   ├── index.html
│   ├── package.json
│   ├── vite.config.ts
│   ├── tailwind.config.ts
│   └── tsconfig.json
├── backend/
│   ├── supabase/
│   │   ├── migrations/          # Migrações SQL em ordem cronológica
│   │   ├── functions/           # Edge Functions Deno (lógica de negócio)
│   │   └── config.toml
│   └── scripts/                 # Scripts de migração auxiliares
├── docs/
│   └── database-schema.md       # Diagrama Mermaid do banco de dados
├── CLAUDE.md
└── README.md
```

---

## Autenticação e Papéis

Gerenciado pelo `AuthContext` (`src/contexts/AuthContext.tsx`).

| Papel (banco)   | Nome exibido     | Acesso                                                        |
|-----------------|------------------|---------------------------------------------------------------|
| `master_admin`  | Administrador    | Acesso total — logs, configurações internas, tudo             |
| `manager`       | Gerente (RH)     | Cadastro, gestão de colaboradores, relatórios, análise        |
| `user`          | Colaborador      | Próprio perfil, histórico de resultados, chat IA              |

- Auth via JWT (FastAPI backend)
- RLS no banco garante isolamento por empresa
- Trigger automático cria perfil + papel `user` no signup
- Sistema single-tenant — uma única empresa (`company_id` fixo por usuário)

---

## Banco de Dados

Tabelas principais:
- `profiles` — perfis de usuário (1:1 com auth.users)
- `companies` + `departments` — estrutura da empresa
- `user_roles` — papéis por usuário (`master_admin`, `manager`, `user`)
- `scenario_blocks` — questões do teste psicométrico
- `test_responses` + `test_results` — respostas e resultados calculados
- `profile_comparisons` — compatibilidade entre perfis
- `test_invitations` — tokens de convite
- `hr_conversations` + `hr_messages` — histórico do chat IA
- `notifications` — sistema de notificações

Migrações ficam em `backend/migrations/` — sempre criar nova, nunca editar as existentes.

---

## Endpoints Backend (FastAPI)

| Rota                        | Responsabilidade                              |
|-----------------------------|-----------------------------------------------|
| `POST /auth/login`          | Login com email/senha, retorna JWT            |
| `POST /auth/register`       | Cadastro direto                               |
| `POST /auth/register-invite`| Cadastro via token de convite                 |
| `GET  /auth/me`             | Dados do usuário autenticado                  |
| `GET  /tests/scenarios`     | Cenários do teste psicométrico                |
| `POST /tests/responses`     | Salva respostas do teste                      |
| `POST /tests/calculate`     | Calcula DISC + OCEAN + IEM                    |
| `GET  /tests/results`       | Histórico de resultados do usuário            |
| `POST /chat/message`        | Chat IA contextualizado com perfil            |

---

## Rotas Principais

```
/                         → redireciona para /login
/login                    Login
/dashboard                Dashboard do colaborador
/teste                    Introdução ao teste
/teste/cenarios           Teste psicométrico (cenários)
/resultado                Resultado do usuário
/resultado/compartilhado  Resultado público compartilhado
/meu-perfil               Perfil pessoal
/meu-historico            Histórico de testes
/meu-perfil/compatibilidade  Compatibilidade de perfil
/convite/:token           Cadastro via convite
/admin/empresa            Dashboard da empresa  (manager, master_admin)
/admin/colaboradores      Gestão de colaboradores (manager, master_admin)
/admin/testes             Gestão de testes       (manager, master_admin)
/admin/analise-equipe     Análise de equipe      (manager, master_admin)
/comparar-perfis          Comparação de perfis   (manager, master_admin)
/lider/equipe             Visão de equipe        (manager, master_admin)
/lider/guia/:userId       Guia de liderança IA   (manager, master_admin)
```

---

## Modelo Psicométrico (Domínio)

O sistema usa dois frameworks combinados:

- **DISC** — Dominância (D), Influência (I), Estabilidade (S→N), Conscienciosidade (C→A)
  - Perfil Natural: comportamento base
  - Perfil Adaptado: comportamento situacional
- **Big Five / OCEAN** — Abertura, Conscienciosidade, Extroversão, Amabilidade, Neuroticismo
- **IEM** — Índice de Maturidade Emocional

Labels e descrições de perfil ficam em `src/data/`.

---

## Convenções de Código

- **Idioma**: interface em português (pt-BR); código e variáveis em inglês
- **Tipos**: TypeScript com `strict` desabilitado — não adicionar `any` desnecessários ao evoluir
- **Componentes UI**: usar os primitivos de `src/components/ui/` (shadcn); não criar duplicatas
- **Estilos**: Tailwind — sem CSS customizado salvo exceções justificadas
- **Comentários**: apenas quando o *porquê* não é óbvio; sem comentários descritivos do *o quê*
- **Novos componentes**: um componente por arquivo, nome em PascalCase
- **Novas páginas**: arquivo em `src/pages/`, rota adicionada em `src/App.tsx`

---

## Variáveis de Ambiente

**Frontend** (`frontend/.env`):
```env
VITE_API_URL=http://localhost:8000
```

**Backend** (`backend/.env`):
```env
DATABASE_URL=postgresql://...
JWT_SECRET=...
JWT_ALGORITHM=HS256
JWT_EXPIRE_HOURS=24
ANTHROPIC_API_KEY=...
FRONTEND_URL=http://localhost:8080
```

Nunca commitar `.env`. Usar `.env.example` para documentar.

---

## Changelog e Versionamento

Ao **concluir uma entrega visível ao usuário** (nova funcionalidade ou correção relevante), atualizar o changelog e a versão **antes do commit final**, em **3 lugares**:

1. **`frontend/src/components/ChangelogModal.tsx`** — adicionar uma nova entrada **no topo** do array `CHANGELOG`:
   - `version` (ex.: `"v1.2.0"`), `date` (`DD/MM/AAAA`), `current: true`.
   - **Remover `current: true` da versão anterior** (só a mais nova é a atual).
   - `entries`: lista de `{ type, text }`, com `type` ∈ `"novidade" | "melhoria" | "corrigido"`.
   - O `text` é **voltado ao usuário final** (pt-BR, sem jargão técnico) — esse modal é exibido a todos ao clicar na versão na sidebar.

2. **`frontend/src/components/AdminSidebar.tsx`** — atualizar a string `TalentHS vX.Y.Z` no rodapé.

3. **`frontend/package.json`** — atualizar o campo `"version"`.

**Versionamento (semver):** funcionalidade nova → bump **minor** (`x.Y.0`); correções → bump **patch** (`x.y.Z`). Manter a data igual nos 3 e a do dia da entrega.

---

## Contexto do Projeto

Este projeto foi iniciado como um remix do sistema DN.IA e está sendo transformado no **TalentHS** — produto próprio de RH. O foco da evolução é empoderar cada colaborador com visibilidade sobre seu próprio desenvolvimento dentro da empresa.
