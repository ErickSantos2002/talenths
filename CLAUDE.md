# TalentHS — CLAUDE.md

## Visão do Projeto

**TalentHS** é um sistema de RH focado no desenvolvimento pessoal de colaboradores dentro de suas empresas. Partiu de um remix do sistema DN.IA (disponibilizado pela dn.ia) e está sendo transformado em produto próprio.

O objetivo central é: cada colaborador consegue ver seu próprio desenvolvimento pessoal na empresa — via avaliações comportamentais, histórico de resultados, comparações de perfil e orientações de liderança.

---

## Stack Técnica

- **React 18** + **TypeScript** + **Vite** (SWC)
- **React Router DOM 6** — roteamento client-side
- **Tailwind CSS** + **shadcn/ui** (Radix UI) — sistema de design
- **TanStack React Query 5** — estado de servidor e cache
- **React Hook Form** + **Zod** — formulários e validação
- **Supabase** — banco PostgreSQL, auth, Edge Functions (Deno), RLS
- **Recharts** — gráficos e visualizações
- **next-themes** — dark mode
- **Bun** — package manager preferido (`bun install`, `bun dev`)

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

| Papel           | Acesso                                          |
|-----------------|------------------------------------------------|
| `master_admin`  | Plataforma inteira, todas as empresas          |
| `company_admin` | Empresa específica, colaboradores, relatórios  |
| `leader`        | Equipe sob sua liderança                       |
| `user`          | Próprio perfil, histórico, resultados          |

- Auth via Supabase (email/password + JWT)
- RLS no banco garante isolamento por empresa
- Trigger automático cria perfil + papel `user` no signup

---

## Banco de Dados (Supabase)

Tabelas principais:
- `profiles` — perfis de usuário (1:1 com auth.users)
- `companies` + `departments` — multi-tenancy
- `user_roles` — papéis por usuário/empresa
- `scenario_blocks` — questões do teste psicométrico
- `test_responses` + `test_results` — respostas e resultados calculados
- `profile_comparisons` — compatibilidade entre perfis
- `test_invitations` — tokens de convite
- `hr_conversations` + `hr_messages` — histórico do chat IA
- `notifications` — sistema de notificações

Migrações ficam em `supabase/migrations/` — sempre criar nova migration, nunca editar as existentes.

---

## Edge Functions (Deno)

| Função               | Responsabilidade                                  |
|----------------------|---------------------------------------------------|
| `calculate-results`  | Cálculo DISC + OCEAN a partir das respostas       |
| `compare-profiles`   | Score de compatibilidade entre usuários           |
| `create-collaborator`| Criação de novo colaborador na empresa            |
| `generate-pdf`       | Exportação de resultados em PDF                   |
| `hr-chat`            | Chat IA contextualizado com perfil do usuário     |
| `leader-guide`       | Recomendações IA para líderes                     |
| `register-invite`    | Processamento de tokens de convite                |
| `reprocess-results`  | Reprocessamento em batch                          |

---

## Rotas Principais

```
/                         HomePage
/login                    Login
/dashboard                Dashboard do colaborador
/teste                    Introdução ao teste
/teste/cenarios           Teste psicométrico (cenários)
/resultado                Resultado do usuário
/meu-perfil               Perfil pessoal
/meu-historico            Histórico de testes
/lider/equipe             Visão de equipe (líder)
/admin/colaboradores      Gestão de colaboradores
/admin/analise-equipe     Análise de equipe
/admin/empresas           Gestão de empresas (master_admin)
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

```env
VITE_SUPABASE_URL
VITE_SUPABASE_PUBLISHABLE_KEY
VITE_SUPABASE_PROJECT_ID
```

Nunca commitar o `.env`. Usar `.env.example` para documentar.

---

## Contexto do Projeto

Este projeto foi iniciado como um remix do sistema DN.IA e está sendo transformado no **TalentHS** — produto próprio de RH. O foco da evolução é empoderar cada colaborador com visibilidade sobre seu próprio desenvolvimento dentro da empresa.
