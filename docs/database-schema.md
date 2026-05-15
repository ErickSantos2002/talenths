# Talent-IA - Schema do Banco de Dados

Plataforma de testes psicometricos (DISC + Big Five/OCEAN) com gestao de RH, multi-tenancy e analise por IA.
Banco de dados PostgreSQL gerenciado pelo Supabase.

---

## Diagrama de Relacionamentos

```mermaid
erDiagram
    auth_users ||--|| profiles : "1:1"
    auth_users ||--o{ user_roles : "1:N"
    auth_users ||--o{ test_responses : "1:N"
    auth_users ||--o{ test_results : "1:N"
    auth_users ||--o{ hr_conversations : "1:N"

    companies ||--o{ departments : "1:N"
    companies ||--o{ profiles : "1:N"
    companies ||--o{ user_roles : "1:N"
    companies ||--o{ test_invitations : "1:N"

    departments ||--o{ profiles : "1:N"
    departments ||--o{ test_invitations : "1:N"

    hr_conversations ||--o{ hr_messages : "1:N"

    user_managers }o--|| auth_users : "subordinate"
    user_managers }o--|| auth_users : "manager"

    profile_comparisons }o--|| auth_users : "user1"
    profile_comparisons }o--|| auth_users : "user2"

    companies {
        uuid id PK
        text name
        text cnpj UK
        text status
    }

    departments {
        uuid id PK
        uuid company_id FK
        text name
    }

    profiles {
        uuid id PK
        uuid user_id FK_UK
        text email
        text name
        text cpf UK
        text phone
        uuid company_id FK
        uuid department_id FK
    }

    user_roles {
        uuid id PK
        uuid user_id FK
        app_role role
        uuid company_id FK
    }

    scenario_blocks {
        uuid id PK
        integer block_number UK
        text scenario
        jsonb weights_a_b_c_d
        jsonb ocean_weights_a_b_c_d
    }

    test_responses {
        uuid id PK
        uuid user_id FK
        integer block_number
        text most_option
        text least_option
    }

    test_results {
        uuid id PK
        uuid user_id FK
        jsonb disc_natural
        jsonb disc_adapted
        jsonb big_five
        integer iem
        text share_token UK
        jsonb ai_analysis
    }

    profile_comparisons {
        uuid id PK
        uuid user1_id
        uuid user2_id
        text comparison_type
        integer compatibility_score
        jsonb ai_analysis
    }

    test_invitations {
        uuid id PK
        uuid company_id FK
        uuid department_id FK
        uuid invited_by
        text token UK
        text description
    }

    user_managers {
        uuid id PK
        uuid user_id
        uuid manager_id
        boolean is_primary
    }

    hr_conversations {
        uuid id PK
        uuid user_id
        text title
    }

    hr_messages {
        uuid id PK
        uuid conversation_id FK
        text role
        text content
    }

    notifications {
        uuid id PK
        uuid user_id
        text type
        text title
        text message
        boolean read
    }
```

---

## Enum

### `app_role`

| Valor | Descricao |
|-------|-----------|
| `master_admin` | Administrador global da plataforma |
| `company_admin` | Administrador de uma empresa |
| `leader` | Lider/gestor de equipe |
| `user` | Usuario comum |

---

## Tabelas

### 1. `companies`

Armazena as empresas/organizacoes cadastradas na plataforma.

| Coluna | Tipo | Constraints | Default |
|--------|------|-------------|---------|
| `id` | UUID | PK | `gen_random_uuid()` |
| `name` | TEXT | NOT NULL | - |
| `cnpj` | TEXT | UNIQUE | `NULL` |
| `status` | TEXT | NOT NULL | `'active'` |
| `created_at` | TIMESTAMPTZ | NOT NULL | `now()` |

**RLS:**
- SELECT: membros da empresa ou master admins
- INSERT/UPDATE/DELETE: apenas master admins

---

### 2. `departments`

Departamentos dentro de cada empresa.

| Coluna | Tipo | Constraints | Default |
|--------|------|-------------|---------|
| `id` | UUID | PK | `gen_random_uuid()` |
| `company_id` | UUID | NOT NULL, FK | - |
| `name` | TEXT | NOT NULL | - |
| `created_at` | TIMESTAMPTZ | NOT NULL | `now()` |

**Foreign Keys:**
- `company_id` → `companies(id)` ON DELETE CASCADE

**RLS:**
- SELECT: membros da empresa ou master admins
- INSERT/UPDATE/DELETE: company admins ou master admins

---

### 3. `profiles`

Perfil do usuario, criado automaticamente via trigger no signup.

| Coluna | Tipo | Constraints | Default |
|--------|------|-------------|---------|
| `id` | UUID | PK | `gen_random_uuid()` |
| `user_id` | UUID | NOT NULL, UNIQUE, FK | - |
| `email` | TEXT | NOT NULL | - |
| `name` | TEXT | NOT NULL | - |
| `cpf` | TEXT | UNIQUE | `NULL` |
| `phone` | TEXT | - | `NULL` |
| `company_id` | UUID | FK | `NULL` |
| `department_id` | UUID | FK | `NULL` |
| `created_at` | TIMESTAMPTZ | NOT NULL | `now()` |

**Foreign Keys:**
- `user_id` → `auth.users(id)` ON DELETE CASCADE
- `company_id` → `companies(id)` ON DELETE SET NULL
- `department_id` → `departments(id)` ON DELETE SET NULL

**RLS:**
- SELECT: proprio perfil, membros da mesma empresa, ou master admins
- INSERT: apenas proprio perfil
- UPDATE: proprio perfil, company admins, ou master admins
- DELETE: apenas master admins

---

### 4. `user_roles`

Papeis atribuidos aos usuarios (tabela separada por seguranca).

| Coluna | Tipo | Constraints | Default |
|--------|------|-------------|---------|
| `id` | UUID | PK | `gen_random_uuid()` |
| `user_id` | UUID | NOT NULL, FK | - |
| `role` | `app_role` | NOT NULL | `'user'` |
| `company_id` | UUID | FK | `NULL` |

**Constraints:** UNIQUE(`user_id`, `role`)

**Foreign Keys:**
- `user_id` → `auth.users(id)` ON DELETE CASCADE
- `company_id` → `companies(id)` ON DELETE CASCADE

**RLS:**
- SELECT: proprios papeis, master admins, ou company admins
- INSERT/UPDATE: master admins ou company admins (admins nao podem criar/editar `master_admin`)
- DELETE: apenas master admins

---

### 5. `scenario_blocks`

Cenarios do teste psicometrico com pesos DISC e Big Five (OCEAN). Contem 12 cenarios pre-populados.

| Coluna | Tipo | Constraints | Default |
|--------|------|-------------|---------|
| `id` | UUID | PK | `gen_random_uuid()` |
| `block_number` | INTEGER | NOT NULL, UNIQUE | - |
| `scenario` | TEXT | NOT NULL | - |
| `option_a` | TEXT | NOT NULL | - |
| `option_b` | TEXT | NOT NULL | - |
| `option_c` | TEXT | NOT NULL | - |
| `option_d` | TEXT | NOT NULL | - |
| `weights_a` | JSONB | NOT NULL | `'{}'` |
| `weights_b` | JSONB | NOT NULL | `'{}'` |
| `weights_c` | JSONB | NOT NULL | `'{}'` |
| `weights_d` | JSONB | NOT NULL | `'{}'` |
| `ocean_weights_a` | JSONB | NOT NULL | `'{}'` |
| `ocean_weights_b` | JSONB | NOT NULL | `'{}'` |
| `ocean_weights_c` | JSONB | NOT NULL | `'{}'` |
| `ocean_weights_d` | JSONB | NOT NULL | `'{}'` |

**RLS:**
- SELECT: publico (qualquer usuario pode ler)

---

### 6. `test_responses`

Respostas individuais do usuario para cada bloco de cenario.

| Coluna | Tipo | Constraints | Default |
|--------|------|-------------|---------|
| `id` | UUID | PK | `gen_random_uuid()` |
| `user_id` | UUID | NOT NULL, FK | - |
| `block_number` | INTEGER | NOT NULL | - |
| `most_option` | TEXT | NOT NULL | - |
| `least_option` | TEXT | NOT NULL | - |
| `created_at` | TIMESTAMPTZ | NOT NULL | `now()` |

**Constraints:** UNIQUE(`user_id`, `block_number`)

**Foreign Keys:**
- `user_id` → `auth.users(id)` ON DELETE CASCADE

**RLS:**
- SELECT: proprias respostas ou master admins
- INSERT/UPDATE: apenas proprias respostas
- DELETE: proprias respostas ou master admins

---

### 7. `test_results`

Resultados finais calculados do teste psicometrico.

| Coluna | Tipo | Constraints | Default |
|--------|------|-------------|---------|
| `id` | UUID | PK | `gen_random_uuid()` |
| `user_id` | UUID | NOT NULL, FK | - |
| `disc_natural` | JSONB | NOT NULL | `'{}'` |
| `disc_adapted` | JSONB | NOT NULL | `'{}'` |
| `big_five` | JSONB | NOT NULL | `'{}'` |
| `iem` | INTEGER | - | `0` |
| `share_token` | TEXT | UNIQUE | `gen_random_uuid()::text` |
| `ai_analysis` | JSONB | - | `'{}'` |
| `completed_at` | TIMESTAMPTZ | NOT NULL | `now()` |

**Foreign Keys:**
- `user_id` → `auth.users(id)` ON DELETE CASCADE

**Realtime:** habilitado via `supabase_realtime`

**RLS:**
- SELECT: proprios resultados, company admins (usuarios da empresa), leaders (subordinados ou mesmo departamento), ou publico via `share_token`
- INSERT: apenas proprios resultados
- DELETE: apenas master admins

---

### 8. `profile_comparisons`

Comparacoes de compatibilidade entre dois perfis de usuarios.

| Coluna | Tipo | Constraints | Default |
|--------|------|-------------|---------|
| `id` | UUID | PK | `gen_random_uuid()` |
| `user1_id` | UUID | NOT NULL | - |
| `user2_id` | UUID | NOT NULL | - |
| `comparison_type` | TEXT | NOT NULL | `'peer_to_peer'` |
| `compatibility_score` | INTEGER | - | `NULL` |
| `ai_analysis` | JSONB | - | `'{}'` |
| `created_at` | TIMESTAMPTZ | NOT NULL | `now()` |

**RLS:**
- SELECT: master admins, company admins (usuarios na mesma empresa), ou os proprios usuarios comparados
- INSERT: master admins ou company admins (usuarios na mesma empresa)
- DELETE: master admins ou company admins

---

### 9. `test_invitations`

Convites para realizacao de testes.

| Coluna | Tipo | Constraints | Default |
|--------|------|-------------|---------|
| `id` | UUID | PK | `gen_random_uuid()` |
| `company_id` | UUID | NOT NULL, FK | - |
| `department_id` | UUID | FK | `NULL` |
| `invited_by` | UUID | NOT NULL | - |
| `token` | TEXT | NOT NULL, UNIQUE | `gen_random_uuid()::text` |
| `description` | TEXT | - | `NULL` |
| `expires_at` | TIMESTAMPTZ | - | `NULL` |
| `max_uses` | INTEGER | - | `NULL` |
| `used_count` | INTEGER | - | `0` |
| `is_active` | BOOLEAN | - | `true` |
| `created_at` | TIMESTAMPTZ | - | `now()` |

**Foreign Keys:**
- `company_id` → `companies(id)`
- `department_id` → `departments(id)`

**RLS:**
- SELECT: qualquer pessoa pode ler por token (pagina publica), criador do convite, master admins, ou company admins
- INSERT: master admins, company admins, ou leaders (para sua empresa)
- ALL: master admins ou company admins

---

### 10. `user_managers`

Relacionamento gestor-subordinado.

| Coluna | Tipo | Constraints | Default |
|--------|------|-------------|---------|
| `id` | UUID | PK | `gen_random_uuid()` |
| `user_id` | UUID | NOT NULL | - |
| `manager_id` | UUID | NOT NULL | - |
| `is_primary` | BOOLEAN | - | `true` |
| `created_at` | TIMESTAMPTZ | - | `now()` |

**Constraints:** UNIQUE(`user_id`, `manager_id`)

**RLS:**
- SELECT: proprio gestor, proprios subordinados, master admins, ou company admins
- ALL: master admins ou company admins

---

### 11. `hr_conversations`

Conversas com o assistente de RH (chat IA).

| Coluna | Tipo | Constraints | Default |
|--------|------|-------------|---------|
| `id` | UUID | PK | `gen_random_uuid()` |
| `user_id` | UUID | NOT NULL | - |
| `title` | TEXT | - | `NULL` |
| `created_at` | TIMESTAMPTZ | NOT NULL | `now()` |

**RLS:**
- SELECT/INSERT/DELETE: apenas proprias conversas

---

### 12. `hr_messages`

Mensagens individuais dentro das conversas de RH.

| Coluna | Tipo | Constraints | Default |
|--------|------|-------------|---------|
| `id` | UUID | PK | `gen_random_uuid()` |
| `conversation_id` | UUID | NOT NULL, FK | - |
| `role` | TEXT | NOT NULL | - |
| `content` | TEXT | NOT NULL | - |
| `created_at` | TIMESTAMPTZ | NOT NULL | `now()` |

**Foreign Keys:**
- `conversation_id` → `hr_conversations(id)` ON DELETE CASCADE

**RLS:**
- SELECT/INSERT/DELETE: apenas proprias mensagens (via dono da conversa)

---

### 13. `notifications`

Notificacoes do usuario.

| Coluna | Tipo | Constraints | Default |
|--------|------|-------------|---------|
| `id` | UUID | PK | `gen_random_uuid()` |
| `user_id` | UUID | NOT NULL | - |
| `type` | TEXT | NOT NULL | - |
| `title` | TEXT | NOT NULL | - |
| `message` | TEXT | - | `NULL` |
| `read` | BOOLEAN | NOT NULL | `false` |
| `created_at` | TIMESTAMPTZ | NOT NULL | `now()` |

**RLS:**
- SELECT/UPDATE/DELETE: apenas proprias notificacoes
- INSERT: apenas via service role (sem policy para usuarios)

---

## Funcoes

| Funcao | Retorno | Descricao |
|--------|---------|-----------|
| `has_role(_user_id UUID, _role app_role)` | BOOLEAN | Verifica se um usuario possui um papel especifico |
| `is_master_admin()` | BOOLEAN | Verifica se o usuario atual e master admin |
| `is_company_admin(_company_id UUID)` | BOOLEAN | Verifica se o usuario atual e admin de uma empresa |
| `is_member(_company_id UUID)` | BOOLEAN | Verifica se o usuario atual e membro de uma empresa |
| `get_user_company_id()` | UUID | Retorna o `company_id` do usuario atual |
| `claim_invitation(token_param TEXT)` | SETOF test_invitations | Resgata um convite atomicamente (incrementa `used_count`, valida ativo/expirado/limite) |

Todas as funcoes usam `SECURITY DEFINER` para evitar recursao nas policies RLS.

---

## Trigger

### `on_auth_user_created`

- **Evento:** AFTER INSERT em `auth.users`
- **Funcao:** `handle_new_user()`
- **Acoes:**
  1. Cria um registro em `profiles` com email e nome do usuario (metadata ou email)
  2. Cria um registro em `user_roles` com papel padrao `'user'`

---

## Edge Functions

| Funcao | Descricao |
|--------|-----------|
| `calculate-results` | Calcula os resultados do teste psicometrico |
| `compare-profiles` | Compara compatibilidade entre dois perfis |
| `hr-chat` | Chat com assistente de RH via IA |
| `generate-pdf` | Gera relatorios em PDF |
| `leader-guide` | Guia de lideranca |
| `create-collaborator` | Cria novo colaborador |
| `register-invite` | Registra utilizacao de convite |
| `reprocess-results` | Reprocessa resultados de testes |

Todas configuradas com `verify_jwt = false`.

---

## Realtime

A tabela `test_results` esta publicada via `supabase_realtime` para atualizacoes em tempo real.

---

## Modelo de Seguranca

O banco implementa **Row Level Security (RLS)** em todas as tabelas com:

- **RBAC hierarquico:** `master_admin` > `company_admin` > `leader` > `user`
- **Isolamento por empresa:** dados sao filtrados por `company_id`
- **Funcoes auxiliares** (`SECURITY DEFINER`) para verificacao de permissoes sem recursao RLS
- **Tabela separada `user_roles`** para seguranca dos papeis
- **Compartilhamento publico** via `share_token` nos resultados de teste
- **Criacao automatica de perfil** via trigger no signup
