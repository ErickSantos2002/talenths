

# Tornar CPF opcional no cadastro e obrigatorio antes do teste

## Resumo

1. Remover a obrigatoriedade do CPF nos formularios de cadastro (admin e convite)
2. Adicionar verificacao de CPF antes de iniciar o teste -- se nao tiver CPF, exibir um modal/tela pedindo para preencher
3. No primeiro acesso (dashboard), se o CPF estiver vazio, exibir um banner/modal solicitando o preenchimento

## Alteracoes

### 1. Formulario de cadastro pelo admin (`AdminCollaboratorsPage.tsx`)

**Adicionar colaborador (handleAdd)**: Remover CPF da lista de campos obrigatorios (linhas 271-274). O campo CPF continuara visivel no formulario, mas sera opcional.

**Editar colaborador (handleSave)**: Remover CPF da validacao obrigatoria (linha 209). Manter o campo editavel.

### 2. Formulario de convite (`InvitePage.tsx`)

Nenhuma mudanca necessaria -- este formulario ja nao pede CPF.

### 3. Edge function `create-collaborator`

Nenhuma mudanca necessaria -- o CPF ja e tratado como opcional no backend (so envia se preenchido).

### 4. Tela antes do teste (`TestIntro.tsx`)

Antes de navegar para `/teste/cenarios`, verificar se o perfil do usuario tem CPF preenchido:
- Buscar o perfil do usuario no Supabase
- Se CPF estiver vazio, exibir um Dialog modal pedindo para preencher o CPF (com mascara 000.000.000-00)
- Ao salvar, atualizar o perfil e so entao navegar para `/teste/cenarios`
- Se CPF ja existir, navegar normalmente

### 5. Banner no Dashboard (`DashboardPage.tsx`)

No componente `CollaboratorDashboard`, adicionar uma verificacao:
- Se `profile.cpf` estiver vazio/null, exibir um card de alerta no topo pedindo para completar o cadastro
- O card tera um botao que abre um Dialog inline para preencher o CPF, ou redireciona para `/meu-perfil`
- Apos preenchido, o banner desaparece

## Detalhes tecnicos

### Arquivos modificados

1. **`src/pages/AdminCollaboratorsPage.tsx`**
   - Remover `addCpf` da validacao obrigatoria em `handleAdd` (linha 273)
   - Remover `editCpf` da validacao obrigatoria em `handleSave` (linha 209)

2. **`src/pages/TestIntro.tsx`**
   - Importar `supabase`, `useAuth`, `Dialog`, `Input`, `Label`, `useState`
   - Ao clicar "Comecar Teste", verificar CPF no perfil
   - Se ausente, abrir modal com campo CPF mascarado
   - Ao confirmar, fazer `update` no profiles e navegar

3. **`src/pages/DashboardPage.tsx`**
   - No `CollaboratorDashboard`, verificar `profile.cpf`
   - Se vazio, renderizar um `Card` de alerta com icone e botao "Completar Cadastro" que leva a `/meu-perfil`

4. **`src/contexts/AuthContext.tsx`** (verificacao)
   - Confirmar que o campo `cpf` esta disponivel no objeto `profile` retornado pelo contexto

### Fluxo do usuario

```text
Cadastro (admin ou convite)
  -> CPF opcional
  -> Usuario faz login

Primeiro acesso (Dashboard)
  -> Banner: "Complete seu cadastro informando seu CPF"
  -> Botao leva a /meu-perfil

Antes do teste (TestIntro)
  -> Clica "Comecar Teste"
  -> Se CPF vazio -> Modal pede CPF
  -> Preenche -> Salva -> Navega para /teste/cenarios
  -> Se CPF ja existe -> Navega direto
```

