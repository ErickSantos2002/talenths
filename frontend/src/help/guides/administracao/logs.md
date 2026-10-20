---
titulo: Logs de Auditoria
modulo: administracao
papeis: [master_admin]
telas: [/admin/logs]
ordem: 230
---

## Para que serve

Nos **Logs de Auditoria** o administrador do sistema consulta o registro das alterações feitas no TalentHS: quem fez, o quê, quando, de qual endereço de rede e se deu certo.

## Quando usar

- Para descobrir quem alterou ou apagou um dado.
- Para investigar um erro relatado por alguém.
- Para acompanhar o que foi feito no sistema num período.

## Passo a passo

1. No menu, no bloco **Empresa**, em **Sistema**, clique em **Logs**. Este item só aparece para o administrador do sistema.
2. Veja os registros, do mais recente para o mais antigo. Cada linha mostra a **Data / Hora**, o **Usuário**, a **Ação**, o **Método**, a **Rota**, o **Status** e o **IP**.

![Logs de Auditoria com as ações de cada usuário, o método, a rota, o status e o IP, incluindo uma exclusão recusada com status 409](/capturas/admin-logs.webp)

**Para filtrar:**

1. Para buscar por nome, ação ou rota, digite na busca e tecle Enter ou clique na lupa.
2. Para ver só um tipo de alteração, escolha o método: **POST** (criação), **PUT** e **PATCH** (alteração) ou **DELETE** (exclusão).
3. Para ver só o que deu certo ou só o que falhou, escolha **Sucesso (2xx/3xx)** ou **Erro (4xx/5xx)**.
4. Para voltar à lista completa, clique em **Limpar filtros**.

Use a paginação, no fim da lista, para ver registros mais antigos ou mudar quantos aparecem por página.

## O que acontece depois

Os logs só mostram os registros; nada é alterado por esta tela.

## Dúvidas comuns

**Uma consulta não aparece nos logs.** Só as alterações são registradas: criar, alterar e excluir. Abrir uma tela ou consultar dados não gera registro.

**O Status está em vermelho.** A alteração foi recusada ou falhou: o código 4xx indica um pedido recusado, como uma exclusão bloqueada, e o 5xx, um erro do sistema. A **Ação** mostra o que a pessoa tentou fazer, mesmo que não tenha dado certo.

**A Ação aparece só como "Criação", "Atualização" ou "Remoção".** Algumas alterações não têm um nome próprio. Nesses casos, a **Rota** mostra a parte do sistema que foi alterada.

**Os logins não aparecem.** A entrada no sistema é registrada sem o usuário e sem a empresa, por isso fica fora desta lista. Os logs não servem para saber quem entrou e quando.

**Os gestores veem esta tela?** Não. Os logs só abrem para o administrador do sistema.
