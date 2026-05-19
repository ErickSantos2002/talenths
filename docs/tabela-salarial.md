# Tabela Salarial — Guia de Implementação no TalentHS

## Visão geral

A Tabela Salarial da HealthSafety Tech define faixas de remuneração por cargo e nível, referenciadas a dados de mercado (Robert Half). A estrutura é composta por **bandas percentuais** em relação à mediana de mercado (100%), cobrindo de 90% (mínimo) a 110% (máximo).

O objetivo da implementação no TalentHS é integrar os dados salariais ao módulo de Carreira existente, permitindo que gestores visualizem onde cada colaborador está posicionado dentro da sua faixa salarial e que o sistema sinalize desvios para cima ou para baixo.

---

## Estrutura do domínio

### Hierarquia de cargos

```
Diretor
  └── Gerente (Sênior / Pleno / Júnior)
        └── Coordenador (Sênior / Pleno / Júnior)
              └── Analista (Sênior / Pleno / Júnior)
```

### Bandas salariais

| Banda        | % da Mediana | Significado                                    |
|--------------|:------------:|------------------------------------------------|
| Mínimo       | 90%          | Entrada no cargo / abaixo da mediana           |
| Banda 95     | 95%          | Em desenvolvimento dentro do cargo             |
| Mediana      | 100%         | Referência de mercado para o cargo             |
| Banda 105    | 105%         | Acima da mediana, colaborador sênior no cargo  |
| Máximo       | 110%         | Teto do cargo, candidato a promoção            |

A tabela é segmentada por **mercado** (ex: Vendas e Marketing) e **região** (ex: Recife/PE), com fonte de referência configurável (ex: Robert Half 2025).

---

## 1. Banco de dados

### 1.1 Novas tabelas

Criar uma nova migration em `backend/supabase/migrations/`.

```sql
-- ─────────────────────────────────────────────────────────────
-- Tabela de referências de mercado salarial
-- ─────────────────────────────────────────────────────────────
CREATE TABLE public.salary_market_references (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id    UUID NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  name          TEXT NOT NULL,                    -- Ex: "Robert Half 2025"
  market        TEXT NOT NULL,                    -- Ex: "Vendas e Marketing"
  region        TEXT NOT NULL,                    -- Ex: "Recife/PE"
  reference_year INT NOT NULL,
  is_active     BOOLEAN NOT NULL DEFAULT true,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ─────────────────────────────────────────────────────────────
-- Tabela salarial: posições × bandas × valores
-- ─────────────────────────────────────────────────────────────
CREATE TABLE public.salary_table_entries (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  reference_id    UUID NOT NULL REFERENCES public.salary_market_references(id) ON DELETE CASCADE,
  company_id      UUID NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,

  -- Cargo e nível (deve refletir a hierarquia career_tracks/career_levels)
  job_family      TEXT NOT NULL,    -- Ex: "Analista", "Coordenador", "Gerente", "Diretor"
  seniority       TEXT NOT NULL,    -- Ex: "Júnior", "Pleno", "Sênior"

  -- Bandas salariais (valores absolutos em BRL)
  band_90         NUMERIC(12, 2) NOT NULL DEFAULT 0,   -- Mínimo
  band_95         NUMERIC(12, 2) NOT NULL DEFAULT 0,
  band_100        NUMERIC(12, 2) NOT NULL DEFAULT 0,   -- Mediana
  band_105        NUMERIC(12, 2) NOT NULL DEFAULT 0,
  band_110        NUMERIC(12, 2) NOT NULL DEFAULT 0,   -- Máximo

  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

  UNIQUE (reference_id, job_family, seniority)
);

-- ─────────────────────────────────────────────────────────────
-- Salário atual do colaborador (campo na tabela profiles)
-- ─────────────────────────────────────────────────────────────
-- Adicionar à tabela profiles existente:
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS current_salary   NUMERIC(12, 2),
  ADD COLUMN IF NOT EXISTS job_family       TEXT,      -- Ex: "Analista"
  ADD COLUMN IF NOT EXISTS seniority        TEXT;      -- Ex: "Pleno"

-- ─────────────────────────────────────────────────────────────
-- Índices
-- ─────────────────────────────────────────────────────────────
CREATE INDEX idx_salary_entries_company   ON public.salary_table_entries(company_id);
CREATE INDEX idx_salary_entries_reference ON public.salary_table_entries(reference_id);
CREATE INDEX idx_salary_refs_company      ON public.salary_market_references(company_id);
```

> **Convenção de migrations:** criar um novo arquivo com timestamp no nome, nunca editar migrations existentes.

### 1.2 Relação com o módulo de Carreira existente

O módulo de Carreira (`career_tracks` / `career_levels`) já controla a trilha e o nível de cada colaborador. Os campos `job_family` e `seniority` em `profiles` devem ser preenchidos no mesmo momento em que `career/employee/{user_id}` é atualizado — ou seja, eles são derivados do nível de carreira e ficam desnormalizados no perfil para facilitar queries de posicionamento salarial.

---

## 2. Backend (FastAPI)

### 2.1 Novo router: `salary.py`

Criar `backend/app/routers/salary.py` e registrá-lo em `main.py`.

```python
# backend/app/routers/salary.py

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from typing import Optional
import asyncpg

from app.dependencies import get_db, get_current_user_id, require_manager

router = APIRouter(prefix="/salary", tags=["salary"])
```

### 2.2 Endpoints necessários

```
# Referências de mercado
GET    /salary/references          → lista referências (manager+)
POST   /salary/references          → cria referência (manager+)
PUT    /salary/references/{id}     → atualiza referência (manager+)
DELETE /salary/references/{id}     → remove referência (manager+)

# Tabela salarial
GET    /salary/table               → lista entradas da tabela ativa
POST   /salary/table               → cria / atualiza entradas em lote (manager+)
PUT    /salary/table/{entry_id}    → atualiza uma entrada específica (manager+)

# Posicionamento de colaboradores
GET    /salary/positioning         → retorna todos os colaboradores com seu
                                     salário atual × banda do cargo (manager+)
GET    /salary/positioning/{uid}   → posicionamento de um colaborador (manager+)

# Salário do colaborador
PATCH  /salary/employee/{uid}      → atualiza salário atual + job_family + seniority
```

### 2.3 Lógica de posicionamento

O endpoint `/salary/positioning` deve calcular, para cada colaborador:

```python
def compute_positioning(current_salary: float, entry: dict) -> dict:
    """
    Retorna em qual banda percentual o colaborador se encontra
    e qual o desvio em relação à mediana.
    """
    median = entry["band_100"]
    if median == 0:
        return {"band": None, "pct_of_median": None, "deviation": None}

    pct = (current_salary / median) * 100
    deviation = current_salary - median

    if pct < 92.5:
        band = "abaixo_minimo"
    elif pct < 97.5:
        band = "band_90"
    elif pct < 102.5:
        band = "mediana"
    elif pct < 107.5:
        band = "band_105"
    else:
        band = "maximo_ou_acima"

    return {
        "pct_of_median": round(pct, 1),
        "deviation": round(deviation, 2),
        "band": band,
        "is_above_max": current_salary > entry["band_110"],
        "is_below_min": current_salary < entry["band_90"],
    }
```

### 2.4 Registro em `main.py`

```python
# Adicionar junto aos outros imports:
from app.routers.salary import router as salary_router

# E na sequência dos include_router:
app.include_router(salary_router)
```

---

## 3. Frontend (React + TypeScript)

### 3.1 Novas páginas

Criar os arquivos abaixo em `frontend/src/pages/`:

```
src/pages/admin/TabelaSalarial.tsx       → visualização e edição da tabela
src/pages/admin/PosicionamentoSalarial.tsx → onde cada colaborador está na faixa
```

Registrar as rotas em `src/App.tsx`:

```tsx
<Route path="/admin/tabela-salarial"       element={<TabelaSalarial />} />
<Route path="/admin/posicionamento-salarial" element={<PosicionamentoSalarial />} />
```

Ambas protegidas para `manager` e `master_admin`.

### 3.2 Componentes sugeridos

```
src/components/salary/
  SalaryTableGrid.tsx          → tabela editável (posições × bandas)
  SalaryBandBadge.tsx          → badge colorido indicando a banda do colaborador
  SalaryPositioningCard.tsx    → card individual de posicionamento
  SalaryReferenceSelector.tsx  → dropdown para alternar entre referências de mercado
```

### 3.3 SalaryTableGrid — estrutura da tabela

A grade deve renderizar as posições nas linhas e as bandas nas colunas, com células editáveis:

| Posição             | Mínimo 90% | 95%  | Mediana 100% | 105% | Máximo 110% |
|---------------------|------------|------|--------------|------|-------------|
| Gerente Sênior      | R$ —       | R$ — | R$ —         | R$ — | R$ —        |
| Gerente Pleno       | R$ —       | R$ — | R$ —         | R$ — | R$ —        |
| Gerente Júnior      | R$ —       | R$ — | R$ —         | R$ — | R$ —        |
| Coordenador Sênior  | R$ —       | R$ — | R$ —         | R$ — | R$ —        |
| ...                 | ...        | ...  | ...          | ...  | ...         |

Ao salvar, enviar todas as linhas em lote para `POST /salary/table`.

### 3.4 SalaryBandBadge — código de cores

```tsx
const BAND_COLORS = {
  abaixo_minimo:  "bg-red-100 text-red-700",
  band_90:        "bg-yellow-100 text-yellow-700",
  mediana:        "bg-green-100 text-green-700",
  band_105:       "bg-blue-100 text-blue-700",
  maximo_ou_acima:"bg-purple-100 text-purple-700",
};
```

### 3.5 Hooks React Query

```tsx
// hooks/useSalaryTable.ts
export const useSalaryTable = (referenceId: string) =>
  useQuery({ queryKey: ["salary-table", referenceId], queryFn: () => api.get(`/salary/table?reference_id=${referenceId}`) });

// hooks/useSalaryPositioning.ts
export const useSalaryPositioning = () =>
  useQuery({ queryKey: ["salary-positioning"], queryFn: () => api.get("/salary/positioning") });
```

---

## 4. Integração com módulos existentes

### 4.1 Módulo de Carreira

Ao atualizar o nível de carreira de um colaborador via `PUT /career/employee/{user_id}`, o backend deve também atualizar `job_family` e `seniority` em `profiles` — extraindo esses valores do `career_level` atribuído.

Isso garante que o posicionamento salarial sempre reflete o cargo atual sem joins adicionais.

### 4.2 Módulo de Avaliações (9-box)

O endpoint `GET /evaluations/9box` retorna performance × potencial. O posicionamento salarial pode ser cruzado com o 9-box para identificar padrões críticos:

- **Alto desempenho + salário abaixo de 95%** → risco de turnover elevado
- **Baixo desempenho + salário acima de 105%** → custo desproporcional

Sugestão: adicionar o campo `salary_band` ao payload do 9-box para habilitar esse cruzamento no frontend.

### 4.3 Módulo de PDI

Quando um colaborador atingir a banda 110% (teto do cargo), o sistema pode sugerir automaticamente a criação de um PDI focado em preparação para o próximo nível hierárquico.

### 4.4 Módulo de Relatórios

Adicionar um novo endpoint ao `reports.py`:

```
GET /reports/salary-positioning   → CSV com: nome, cargo, nível, salário atual,
                                    mediana do mercado, % da mediana, banda, desvio
```

---

## 5. Regras de negócio

- Apenas `manager` e `master_admin` podem visualizar e editar a tabela salarial e os salários individuais.
- Colaboradores com papel `user` **não têm acesso** a dados salariais (nem os próprios).
- A tabela é versionada por referência de mercado — é possível manter histórico de anos anteriores sem sobrescrever.
- O campo `current_salary` em `profiles` deve ser tratado como dado sensível: nunca exposto em endpoints públicos ou compartilhados.
- Ao importar valores da tabela, o sistema deve validar que `band_90 < band_95 < band_100 < band_105 < band_110`.

---

## 6. Checklist de implementação

- [ ] Criar migration SQL com as novas tabelas e `ALTER TABLE profiles`
- [ ] Criar `backend/app/routers/salary.py` com todos os endpoints
- [ ] Registrar o router em `main.py`
- [ ] Criar `src/pages/admin/TabelaSalarial.tsx`
- [ ] Criar `src/pages/admin/PosicionamentoSalarial.tsx`
- [ ] Criar componentes em `src/components/salary/`
- [ ] Adicionar rotas em `src/App.tsx`
- [ ] Adicionar hooks React Query
- [ ] Integrar `job_family` e `seniority` ao fluxo de atualização de carreira
- [ ] Adicionar cruzamento com 9-box (opcional, segunda etapa)
- [ ] Adicionar relatório CSV de posicionamento salarial
- [ ] Garantir que o campo `current_salary` não vaze em endpoints públicos
