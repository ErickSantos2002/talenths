#!/usr/bin/env python3
"""
Bruce — Assistente de RH da HealthSafety Tech
Agente de IA com acesso completo ao TalentHS (master_admin)

Pré-requisitos:
  pip install anthropic httpx
  export ANTHROPIC_API_KEY=sk-ant-...

Uso:
  python bruce_agent.py
"""

import json
import os
import sys
from datetime import datetime
from typing import Optional

import httpx
from anthropic import Anthropic

# ─────────────────────────────────────────────────────────────────────────────
# Configuração
# ─────────────────────────────────────────────────────────────────────────────

BASE_URL = "https://talenthsapi.healthsafetytech.com"
BRUCE_EMAIL = "bruce@healthsafetytech.com"
BRUCE_PASSWORD = "bruce120154@"
CLAUDE_MODEL = "claude-opus-4-6"

# ─────────────────────────────────────────────────────────────────────────────
# Autenticação JWT (cache + auto-refresh)
# ─────────────────────────────────────────────────────────────────────────────

_token: Optional[str] = None


def get_token() -> str:
    global _token
    if _token:
        return _token
    resp = httpx.post(
        f"{BASE_URL}/auth/login",
        json={"email": BRUCE_EMAIL, "password": BRUCE_PASSWORD},
        timeout=10,
    )
    resp.raise_for_status()
    _token = resp.json()["access_token"]
    return _token


def _headers() -> dict:
    return {"Authorization": f"Bearer {get_token()}", "Content-Type": "application/json"}


def api(method: str, path: str, **kwargs):
    """Chamada autenticada à API do TalentHS com auto-refresh de token."""
    global _token
    try:
        resp = httpx.request(method, f"{BASE_URL}{path}", headers=_headers(), timeout=20, **kwargs)
        if resp.status_code == 401:
            _token = None
            resp = httpx.request(method, f"{BASE_URL}{path}", headers=_headers(), timeout=20, **kwargs)
        resp.raise_for_status()
        return resp.json() if resp.content else {"ok": True}
    except httpx.HTTPStatusError as e:
        try:
            detail = e.response.json().get("detail", e.response.text[:300])
        except Exception:
            detail = e.response.text[:300]
        return {"error": f"HTTP {e.response.status_code}", "detail": detail}
    except Exception as e:
        return {"error": str(e)}


# ─────────────────────────────────────────────────────────────────────────────
# Funções de ferramenta — Perfis & Colaboradores
# ─────────────────────────────────────────────────────────────────────────────

def meu_perfil() -> dict:
    """Retorna o perfil do próprio Bruce."""
    return api("GET", "/profiles/me")


def buscar_perfil(user_id: str) -> dict:
    """Busca o perfil completo de um colaborador pelo user_id."""
    return api("GET", f"/profiles/{user_id}")


def listar_colaboradores(empresa_id: str = None) -> dict:
    """Lista todos os colaboradores. Retorna perfis, papéis e status de teste."""
    path = "/collaborators"
    if empresa_id:
        path += f"?company_id={empresa_id}"
    return {"colaboradores": api("GET", path)}


def criar_colaborador(
    email: str, nome: str, empresa_id: str,
    departamento_id: str = None, cpf: str = None,
    telefone: str = None, papel: str = "user",
) -> dict:
    """Cria um novo colaborador na plataforma."""
    payload = {"email": email, "name": nome, "company_id": empresa_id, "role": papel}
    if departamento_id:
        payload["department_id"] = departamento_id
    if cpf:
        payload["cpf"] = cpf
    if telefone:
        payload["phone"] = telefone
    return api("POST", "/collaborators", json=payload)


def atualizar_colaborador(
    profile_id: str, nome: str = None, cpf: str = None,
    telefone: str = None, empresa_id: str = None, departamento_id: str = None,
) -> dict:
    """Atualiza dados cadastrais de um colaborador."""
    payload = {k: v for k, v in {"name": nome, "cpf": cpf, "phone": telefone,
                                   "company_id": empresa_id, "department_id": departamento_id}.items() if v}
    return api("PATCH", f"/collaborators/{profile_id}", json=payload)


def remover_colaborador(profile_id: str) -> dict:
    """Remove permanentemente um colaborador da plataforma."""
    return api("DELETE", f"/collaborators/{profile_id}")


# ─────────────────────────────────────────────────────────────────────────────
# Funções de ferramenta — Testes Psicométricos
# ─────────────────────────────────────────────────────────────────────────────

def listar_resultados_testes(user_id: str = None) -> dict:
    """Lista resultados de testes psicométricos DISC + OCEAN + IEM."""
    path = "/tests/results"
    if user_id:
        path += f"?user_id={user_id}"
    return {"resultados": api("GET", path)}


def buscar_resultado_teste(result_id: str) -> dict:
    """Busca detalhes completos de um resultado de teste específico."""
    return api("GET", f"/tests/results/{result_id}")


# ─────────────────────────────────────────────────────────────────────────────
# Funções de ferramenta — Avaliações de Desempenho
# ─────────────────────────────────────────────────────────────────────────────

def comportamentos_avaliacao() -> dict:
    """Lista os comportamentos avaliados com seus pilares e pesos."""
    return {"comportamentos": api("GET", "/evaluations/behaviors")}


def listar_ciclos_avaliacao() -> dict:
    """Lista os ciclos de avaliação de desempenho cadastrados."""
    return {"ciclos": api("GET", "/evaluations/cycles")}


def criar_ciclo_avaliacao(nome: str, data_inicio: str, data_fim: str, descricao: str = None) -> dict:
    """Cria um novo ciclo de avaliação. Datas no formato YYYY-MM-DD."""
    payload = {"name": nome, "start_date": data_inicio, "end_date": data_fim}
    if descricao:
        payload["description"] = descricao
    return api("POST", "/evaluations/cycles", json=payload)


def status_avaliacoes_equipe(cycle_id: str = None) -> dict:
    """Retorna status de preenchimento das avaliações por colaborador."""
    path = "/evaluations/team-status"
    if cycle_id:
        path += f"?cycle_id={cycle_id}"
    return api("GET", path)


def pontuacoes_avaliacoes(cycle_id: str = None) -> dict:
    """Retorna pontuações das avaliações por colaborador e pilar (cultura, entregas, desenvolvimento)."""
    path = "/evaluations/scores"
    if cycle_id:
        path += f"?cycle_id={cycle_id}"
    return api("GET", path)


def dados_9box(cycle_id: str = None) -> dict:
    """Retorna dados do 9-box (performance × potencial) da equipe."""
    path = "/evaluations/9box"
    if cycle_id:
        path += f"?cycle_id={cycle_id}"
    return api("GET", path)


def submeter_avaliacao(cycle_id: str, avaliado_id: str, scores: dict, comentario: str = None) -> dict:
    """Submete avaliação de desempenho.
    scores: {cultura_visivel, cultura_genuino, entregas, organizacao, colaboracao,
              feedback, autonomia, protagonismo} — valores 1 a 5."""
    payload = {"cycle_id": cycle_id, "evaluated_id": avaliado_id, "scores": scores}
    if comentario:
        payload["comment"] = comentario
    return api("POST", "/evaluations/submit", json=payload)


def consolidar_ciclo(cycle_id: str) -> dict:
    """Consolida os resultados de um ciclo de avaliação."""
    return api("POST", f"/evaluations/cycles/{cycle_id}/consolidate")


# ─────────────────────────────────────────────────────────────────────────────
# Funções de ferramenta — Metas / OKRs
# ─────────────────────────────────────────────────────────────────────────────

def listar_ciclos_metas() -> dict:
    """Lista ciclos de metas cadastrados."""
    return {"ciclos": api("GET", "/goals/cycles")}


def criar_ciclo_metas(nome: str, ano: int, descricao: str = None) -> dict:
    """Cria um novo ciclo de metas."""
    payload = {"name": nome, "year": ano}
    if descricao:
        payload["description"] = descricao
    return api("POST", "/goals/cycles", json=payload)


def visao_geral_metas(cycle_id: str = None, user_id: str = None) -> dict:
    """Retorna visão geral das metas/OKRs com progresso mensal."""
    params = "&".join(f"{k}={v}" for k, v in [("cycle_id", cycle_id), ("user_id", user_id)] if v)
    path = "/goals/overview" + (f"?{params}" if params else "")
    return api("GET", path)


def criar_meta(
    titulo: str, descricao: str, tipo_calculo: str,
    valor_alvo: float, cycle_id: str, responsavel_id: str = None,
) -> dict:
    """Cria uma nova meta/OKR. tipo_calculo: sum | average | last | subtraction."""
    payload = {
        "title": titulo, "description": descricao,
        "calculation_type": tipo_calculo, "target_value": valor_alvo,
        "cycle_id": cycle_id,
    }
    if responsavel_id:
        payload["owner_id"] = responsavel_id
    return api("POST", "/goals", json=payload)


def atualizar_meta(goal_id: str, titulo: str = None, descricao: str = None, valor_alvo: float = None) -> dict:
    """Atualiza uma meta existente."""
    payload = {k: v for k, v in {"title": titulo, "description": descricao, "target_value": valor_alvo}.items() if v is not None}
    return api("PUT", f"/goals/{goal_id}", json=payload)


# ─────────────────────────────────────────────────────────────────────────────
# Funções de ferramenta — PDI
# ─────────────────────────────────────────────────────────────────────────────

def meu_pdi() -> dict:
    """Retorna o PDI (Plano de Desenvolvimento Individual) do próprio Bruce."""
    return api("GET", "/pdi/my")


def pdi_da_equipe(user_id: str = None) -> dict:
    """Retorna PDIs de toda a equipe, ou de um colaborador específico."""
    path = "/pdi/team"
    if user_id:
        path += f"?user_id={user_id}"
    return api("GET", path)


def criar_plano_pdi(user_id: str, titulo: str, descricao: str, cycle_id: str = None) -> dict:
    """Cria um plano de desenvolvimento individual para um colaborador."""
    payload = {"user_id": user_id, "title": titulo, "description": descricao}
    if cycle_id:
        payload["eval_cycle_id"] = cycle_id
    return api("POST", "/pdi/plans", json=payload)


def atualizar_plano_pdi(plan_id: str, titulo: str = None, descricao: str = None, status: str = None) -> dict:
    """Atualiza um plano PDI. status: active | completed | cancelled."""
    payload = {k: v for k, v in {"title": titulo, "description": descricao, "status": status}.items() if v}
    return api("PUT", f"/pdi/plans/{plan_id}", json=payload)


def adicionar_acao_pdi(plan_id: str, titulo: str, descricao: str, como: str, data_limite: str) -> dict:
    """Adiciona uma ação a um plano PDI. data_limite no formato YYYY-MM-DD."""
    return api("POST", f"/pdi/plans/{plan_id}/actions", json={
        "title": titulo, "description": descricao, "how": como, "due_date": data_limite
    })


def atualizar_acao_pdi(action_id: str, status: str = None, titulo: str = None, descricao: str = None) -> dict:
    """Atualiza status de uma ação PDI. status: pending | in_progress | done."""
    payload = {k: v for k, v in {"status": status, "title": titulo, "description": descricao}.items() if v}
    return api("PUT", f"/pdi/actions/{action_id}", json=payload)


# ─────────────────────────────────────────────────────────────────────────────
# Funções de ferramenta — Relatórios
# ─────────────────────────────────────────────────────────────────────────────

def relatorio_colaboradores() -> dict:
    """Gera relatório completo de colaboradores (dados cadastrais, departamento, papel)."""
    return api("GET", "/reports/collaborators")


def relatorio_resultados_testes() -> dict:
    """Gera relatório dos resultados de testes psicométricos de todos os colaboradores."""
    return api("GET", "/reports/test-results")


def relatorio_ausencias() -> dict:
    """Gera relatório consolidado de ausências."""
    return api("GET", "/reports/absences")


def relatorio_beneficios() -> dict:
    """Gera relatório de benefícios atribuídos."""
    return api("GET", "/reports/benefits")


def relatorio_pdi() -> dict:
    """Gera relatório de PDIs — planos, ações e progresso."""
    return api("GET", "/reports/pdi")


def relatorio_aprendizado() -> dict:
    """Gera relatório de cursos e trilhas de aprendizado."""
    return api("GET", "/reports/learning")


# ─────────────────────────────────────────────────────────────────────────────
# Funções de ferramenta — Ausências
# ─────────────────────────────────────────────────────────────────────────────

def tipos_ausencia() -> dict:
    """Lista tipos de ausência cadastrados (férias, atestado, licença, etc)."""
    return {"tipos": api("GET", "/absences/types")}


def ausencias_da_equipe(user_id: str = None) -> dict:
    """Lista ausências da equipe, opcionalmente filtradas por colaborador."""
    path = "/absences/team"
    if user_id:
        path += f"?user_id={user_id}"
    return api("GET", path)


def solicitar_ausencia(tipo_id: str, data_inicio: str, data_fim: str, motivo: str = None) -> dict:
    """Solicita uma ausência. Datas no formato YYYY-MM-DD."""
    payload = {"type_id": tipo_id, "start_date": data_inicio, "end_date": data_fim}
    if motivo:
        payload["reason"] = motivo
    return api("POST", "/absences/request", json=payload)


def aprovar_ausencia(request_id: str) -> dict:
    """Aprova uma solicitação de ausência."""
    return api("PUT", f"/absences/{request_id}/approve")


def rejeitar_ausencia(request_id: str, motivo: str = None) -> dict:
    """Rejeita uma solicitação de ausência."""
    payload = {"reason": motivo} if motivo else {}
    return api("PUT", f"/absences/{request_id}/reject", json=payload)


# ─────────────────────────────────────────────────────────────────────────────
# Funções de ferramenta — Benefícios
# ─────────────────────────────────────────────────────────────────────────────

def catalogo_beneficios() -> dict:
    """Lista o catálogo de benefícios disponíveis na empresa."""
    return {"catalogo": api("GET", "/benefits/catalog")}


def resumo_beneficios() -> dict:
    """Retorna resumo agregado dos benefícios por colaborador."""
    return api("GET", "/benefits/summary")


def beneficios_da_equipe() -> dict:
    """Lista benefícios atribuídos à equipe."""
    return api("GET", "/benefits/team")


def beneficios_do_colaborador(user_id: str) -> dict:
    """Lista benefícios de um colaborador específico."""
    return api("GET", f"/benefits/employee/{user_id}")


def atribuir_beneficio(user_id: str, benefit_id: str, valor: float = None) -> dict:
    """Atribui um benefício a um colaborador."""
    payload = {"user_id": user_id, "benefit_id": benefit_id}
    if valor is not None:
        payload["value"] = valor
    return api("POST", "/benefits/assign", json=payload)


# ─────────────────────────────────────────────────────────────────────────────
# Funções de ferramenta — Aprendizado
# ─────────────────────────────────────────────────────────────────────────────

def catalogo_aprendizado() -> dict:
    """Lista catálogo de cursos e treinamentos disponíveis."""
    return {"catalogo": api("GET", "/learning/catalog")}


def aprendizado_da_equipe() -> dict:
    """Lista progresso de aprendizado de toda a equipe."""
    return api("GET", "/learning/team")


def meu_aprendizado() -> dict:
    """Lista trilhas de aprendizado do próprio Bruce."""
    return api("GET", "/learning/my")


def atribuir_curso(user_id: str, course_id: str) -> dict:
    """Atribui um curso a um colaborador."""
    return api("POST", f"/learning/employee/{user_id}", json={"course_id": course_id})


# ─────────────────────────────────────────────────────────────────────────────
# Funções de ferramenta — Carreira
# ─────────────────────────────────────────────────────────────────────────────

def trilhas_carreira() -> dict:
    """Lista trilhas de carreira configuradas na empresa."""
    return {"trilhas": api("GET", "/career/tracks")}


def carreira_da_equipe() -> dict:
    """Lista posicionamento de carreira de toda a equipe."""
    return api("GET", "/career/team")


def minha_carreira() -> dict:
    """Retorna posição de carreira do próprio Bruce."""
    return api("GET", "/career/my")


def atualizar_carreira_colaborador(user_id: str, level_id: str) -> dict:
    """Atualiza o nível de carreira de um colaborador."""
    return api("PUT", f"/career/employee/{user_id}", json={"level_id": level_id})


# ─────────────────────────────────────────────────────────────────────────────
# Funções de ferramenta — Workshops
# ─────────────────────────────────────────────────────────────────────────────

def listar_workshops() -> dict:
    """Lista workshops disponíveis na empresa."""
    return {"workshops": api("GET", "/workshops")}


def criar_workshop(titulo: str, descricao: str, data: str, vagas: int = None) -> dict:
    """Cria um novo workshop. data no formato YYYY-MM-DD."""
    payload = {"title": titulo, "description": descricao, "date": data}
    if vagas:
        payload["capacity"] = vagas
    return api("POST", "/workshops", json=payload)


# ─────────────────────────────────────────────────────────────────────────────
# Funções de ferramenta — Comunicações
# ─────────────────────────────────────────────────────────────────────────────

def comunicados() -> dict:
    """Lista comunicados e anúncios da empresa."""
    return {"comunicados": api("GET", "/communications/announcements")}


def criar_comunicado(titulo: str, conteudo: str, urgente: bool = False) -> dict:
    """Cria um comunicado para todos os colaboradores."""
    return api("POST", "/communications/announcements", json={
        "title": titulo, "content": conteudo, "urgent": urgente
    })


def aniversarios() -> dict:
    """Lista aniversariantes do mês atual."""
    return api("GET", "/communications/birthdays")


def marcos_comemoracao() -> dict:
    """Lista marcos comemorativos (tempo de empresa, promoções)."""
    return api("GET", "/communications/milestones")


# ─────────────────────────────────────────────────────────────────────────────
# Funções de ferramenta — Onboarding
# ─────────────────────────────────────────────────────────────────────────────

def onboarding_da_equipe() -> dict:
    """Lista status de onboarding dos novos colaboradores."""
    return api("GET", "/onboarding/team")


def meu_onboarding() -> dict:
    """Retorna checklist de onboarding do próprio Bruce."""
    return api("GET", "/onboarding/my")


# ─────────────────────────────────────────────────────────────────────────────
# Funções de ferramenta — Pesquisas
# ─────────────────────────────────────────────────────────────────────────────

def listar_pesquisas() -> dict:
    """Lista pesquisas de clima e engajamento."""
    return {"pesquisas": api("GET", "/surveys")}


def resultados_pesquisa(survey_id: str) -> dict:
    """Retorna resultados consolidados de uma pesquisa."""
    return api("GET", f"/surveys/{survey_id}/results")


# ─────────────────────────────────────────────────────────────────────────────
# Funções de ferramenta — Calendário
# ─────────────────────────────────────────────────────────────────────────────

def eventos_calendario(inicio: str = None, fim: str = None) -> dict:
    """Lista eventos do calendário da empresa. Datas no formato YYYY-MM-DD."""
    params = "&".join(f"{k}={v}" for k, v in [("start", inicio), ("end", fim)] if v)
    path = "/calendar/events" + (f"?{params}" if params else "")
    return {"eventos": api("GET", path)}


# ─────────────────────────────────────────────────────────────────────────────
# Funções de ferramenta — Estrutura organizacional
# ─────────────────────────────────────────────────────────────────────────────

def listar_empresas() -> dict:
    """Lista empresas cadastradas na plataforma."""
    return {"empresas": api("GET", "/companies")}


def listar_departamentos(empresa_id: str = None) -> dict:
    """Lista departamentos da empresa."""
    path = "/departments"
    if empresa_id:
        path += f"?company_id={empresa_id}"
    return {"departamentos": api("GET", path)}


def cultura_empresa() -> dict:
    """Retorna cultura e valores da empresa."""
    return api("GET", "/culture")


# ─────────────────────────────────────────────────────────────────────────────
# Funções de ferramenta — Comparações de perfil
# ─────────────────────────────────────────────────────────────────────────────

def listar_comparacoes() -> dict:
    """Lista comparações de compatibilidade entre perfis psicométricos."""
    return {"comparacoes": api("GET", "/comparisons")}


def criar_comparacao(user_id_a: str, user_id_b: str) -> dict:
    """Cria uma comparação de compatibilidade entre dois colaboradores."""
    return api("POST", "/comparisons", json={"user_id_a": user_id_a, "user_id_b": user_id_b})


# ─────────────────────────────────────────────────────────────────────────────
# Funções de ferramenta — Convites
# ─────────────────────────────────────────────────────────────────────────────

def listar_convites() -> dict:
    """Lista convites de acesso enviados."""
    return {"convites": api("GET", "/invitations")}


def criar_convite(empresa_id: str, departamento_id: str = None, max_usos: int = None) -> dict:
    """Cria um token de convite para novos colaboradores se cadastrarem."""
    payload = {"company_id": empresa_id}
    if departamento_id:
        payload["department_id"] = departamento_id
    if max_usos:
        payload["max_uses"] = max_usos
    return api("POST", "/invitations", json=payload)


# ─────────────────────────────────────────────────────────────────────────────
# Funções de ferramenta — Notificações & Logs
# ─────────────────────────────────────────────────────────────────────────────

def notificacoes() -> dict:
    """Lista notificações do Bruce."""
    return {"notificacoes": api("GET", "/notifications")}


def logs_auditoria(limit: int = 50, offset: int = 0) -> dict:
    """Retorna logs de auditoria da plataforma (master_admin)."""
    return {"logs": api("GET", f"/logs?limit={limit}&offset={offset}")}


# ─────────────────────────────────────────────────────────────────────────────
# Mapeamento nome → função
# ─────────────────────────────────────────────────────────────────────────────

TOOL_FUNCTIONS = {
    "meu_perfil": meu_perfil,
    "buscar_perfil": buscar_perfil,
    "listar_colaboradores": listar_colaboradores,
    "criar_colaborador": criar_colaborador,
    "atualizar_colaborador": atualizar_colaborador,
    "remover_colaborador": remover_colaborador,
    "listar_resultados_testes": listar_resultados_testes,
    "buscar_resultado_teste": buscar_resultado_teste,
    "comportamentos_avaliacao": comportamentos_avaliacao,
    "listar_ciclos_avaliacao": listar_ciclos_avaliacao,
    "criar_ciclo_avaliacao": criar_ciclo_avaliacao,
    "status_avaliacoes_equipe": status_avaliacoes_equipe,
    "pontuacoes_avaliacoes": pontuacoes_avaliacoes,
    "dados_9box": dados_9box,
    "submeter_avaliacao": submeter_avaliacao,
    "consolidar_ciclo": consolidar_ciclo,
    "listar_ciclos_metas": listar_ciclos_metas,
    "criar_ciclo_metas": criar_ciclo_metas,
    "visao_geral_metas": visao_geral_metas,
    "criar_meta": criar_meta,
    "atualizar_meta": atualizar_meta,
    "meu_pdi": meu_pdi,
    "pdi_da_equipe": pdi_da_equipe,
    "criar_plano_pdi": criar_plano_pdi,
    "atualizar_plano_pdi": atualizar_plano_pdi,
    "adicionar_acao_pdi": adicionar_acao_pdi,
    "atualizar_acao_pdi": atualizar_acao_pdi,
    "relatorio_colaboradores": relatorio_colaboradores,
    "relatorio_resultados_testes": relatorio_resultados_testes,
    "relatorio_ausencias": relatorio_ausencias,
    "relatorio_beneficios": relatorio_beneficios,
    "relatorio_pdi": relatorio_pdi,
    "relatorio_aprendizado": relatorio_aprendizado,
    "tipos_ausencia": tipos_ausencia,
    "ausencias_da_equipe": ausencias_da_equipe,
    "solicitar_ausencia": solicitar_ausencia,
    "aprovar_ausencia": aprovar_ausencia,
    "rejeitar_ausencia": rejeitar_ausencia,
    "catalogo_beneficios": catalogo_beneficios,
    "resumo_beneficios": resumo_beneficios,
    "beneficios_da_equipe": beneficios_da_equipe,
    "beneficios_do_colaborador": beneficios_do_colaborador,
    "atribuir_beneficio": atribuir_beneficio,
    "catalogo_aprendizado": catalogo_aprendizado,
    "aprendizado_da_equipe": aprendizado_da_equipe,
    "meu_aprendizado": meu_aprendizado,
    "atribuir_curso": atribuir_curso,
    "trilhas_carreira": trilhas_carreira,
    "carreira_da_equipe": carreira_da_equipe,
    "minha_carreira": minha_carreira,
    "atualizar_carreira_colaborador": atualizar_carreira_colaborador,
    "listar_workshops": listar_workshops,
    "criar_workshop": criar_workshop,
    "comunicados": comunicados,
    "criar_comunicado": criar_comunicado,
    "aniversarios": aniversarios,
    "marcos_comemoracao": marcos_comemoracao,
    "onboarding_da_equipe": onboarding_da_equipe,
    "meu_onboarding": meu_onboarding,
    "listar_pesquisas": listar_pesquisas,
    "resultados_pesquisa": resultados_pesquisa,
    "eventos_calendario": eventos_calendario,
    "listar_empresas": listar_empresas,
    "listar_departamentos": listar_departamentos,
    "cultura_empresa": cultura_empresa,
    "listar_comparacoes": listar_comparacoes,
    "criar_comparacao": criar_comparacao,
    "listar_convites": listar_convites,
    "criar_convite": criar_convite,
    "notificacoes": notificacoes,
    "logs_auditoria": logs_auditoria,
}

# ─────────────────────────────────────────────────────────────────────────────
# Definição de ferramentas para o Claude
# ─────────────────────────────────────────────────────────────────────────────

TOOLS = [
    # ── Perfis & Colaboradores ────────────────────────────────────────────────
    {
        "name": "meu_perfil",
        "description": "Retorna o perfil do próprio Bruce no sistema.",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "buscar_perfil",
        "description": "Busca perfil completo de um colaborador pelo user_id.",
        "input_schema": {
            "type": "object",
            "properties": {"user_id": {"type": "string", "description": "ID do usuário"}},
            "required": ["user_id"],
        },
    },
    {
        "name": "listar_colaboradores",
        "description": "Lista todos os colaboradores da empresa com perfis, papéis e status de teste psicométrico.",
        "input_schema": {
            "type": "object",
            "properties": {"empresa_id": {"type": "string", "description": "Filtrar por empresa (opcional)"}},
        },
    },
    {
        "name": "criar_colaborador",
        "description": "Cadastra um novo colaborador na plataforma.",
        "input_schema": {
            "type": "object",
            "properties": {
                "email": {"type": "string"},
                "nome": {"type": "string"},
                "empresa_id": {"type": "string"},
                "departamento_id": {"type": "string"},
                "cpf": {"type": "string"},
                "telefone": {"type": "string"},
                "papel": {"type": "string", "enum": ["user", "manager", "master_admin"], "default": "user"},
            },
            "required": ["email", "nome", "empresa_id"],
        },
    },
    {
        "name": "atualizar_colaborador",
        "description": "Atualiza dados cadastrais de um colaborador.",
        "input_schema": {
            "type": "object",
            "properties": {
                "profile_id": {"type": "string"},
                "nome": {"type": "string"},
                "cpf": {"type": "string"},
                "telefone": {"type": "string"},
                "empresa_id": {"type": "string"},
                "departamento_id": {"type": "string"},
            },
            "required": ["profile_id"],
        },
    },
    {
        "name": "remover_colaborador",
        "description": "Remove permanentemente um colaborador da plataforma.",
        "input_schema": {
            "type": "object",
            "properties": {"profile_id": {"type": "string"}},
            "required": ["profile_id"],
        },
    },

    # ── Testes Psicométricos ──────────────────────────────────────────────────
    {
        "name": "listar_resultados_testes",
        "description": "Lista resultados de testes psicométricos DISC + OCEAN + IEM. Pode filtrar por colaborador.",
        "input_schema": {
            "type": "object",
            "properties": {"user_id": {"type": "string", "description": "Filtrar por usuário (opcional)"}},
        },
    },
    {
        "name": "buscar_resultado_teste",
        "description": "Busca resultado de teste completo (DISC natural/adaptado, OCEAN, IEM) de um colaborador.",
        "input_schema": {
            "type": "object",
            "properties": {"result_id": {"type": "string"}},
            "required": ["result_id"],
        },
    },

    # ── Avaliações de Desempenho ──────────────────────────────────────────────
    {
        "name": "comportamentos_avaliacao",
        "description": "Lista os 8 comportamentos avaliados com pilares (cultura 40%, entregas 30%, desenvolvimento 30%).",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "listar_ciclos_avaliacao",
        "description": "Lista ciclos de avaliação de desempenho cadastrados.",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "criar_ciclo_avaliacao",
        "description": "Cria um novo ciclo de avaliação de desempenho.",
        "input_schema": {
            "type": "object",
            "properties": {
                "nome": {"type": "string"},
                "data_inicio": {"type": "string", "description": "YYYY-MM-DD"},
                "data_fim": {"type": "string", "description": "YYYY-MM-DD"},
                "descricao": {"type": "string"},
            },
            "required": ["nome", "data_inicio", "data_fim"],
        },
    },
    {
        "name": "status_avaliacoes_equipe",
        "description": "Retorna quem preencheu / não preencheu as avaliações num ciclo.",
        "input_schema": {
            "type": "object",
            "properties": {"cycle_id": {"type": "string"}},
        },
    },
    {
        "name": "pontuacoes_avaliacoes",
        "description": "Retorna pontuações de desempenho por colaborador e pilar.",
        "input_schema": {
            "type": "object",
            "properties": {"cycle_id": {"type": "string"}},
        },
    },
    {
        "name": "dados_9box",
        "description": "Retorna dados do 9-box (performance × potencial) para mapeamento da equipe.",
        "input_schema": {
            "type": "object",
            "properties": {"cycle_id": {"type": "string"}},
        },
    },
    {
        "name": "submeter_avaliacao",
        "description": (
            "Submete avaliação de desempenho para um colaborador. "
            "scores: objeto com chaves cultura_visivel, cultura_genuino, entregas, "
            "organizacao, colaboracao, feedback, autonomia, protagonismo — valores 1 a 5."
        ),
        "input_schema": {
            "type": "object",
            "properties": {
                "cycle_id": {"type": "string"},
                "avaliado_id": {"type": "string"},
                "scores": {
                    "type": "object",
                    "description": "Ex: {\"cultura_visivel\": 4, \"entregas\": 5, ...}",
                },
                "comentario": {"type": "string"},
            },
            "required": ["cycle_id", "avaliado_id", "scores"],
        },
    },
    {
        "name": "consolidar_ciclo",
        "description": "Consolida os resultados de um ciclo de avaliação após todos preencherem.",
        "input_schema": {
            "type": "object",
            "properties": {"cycle_id": {"type": "string"}},
            "required": ["cycle_id"],
        },
    },

    # ── Metas / OKRs ─────────────────────────────────────────────────────────
    {
        "name": "listar_ciclos_metas",
        "description": "Lista ciclos de metas cadastrados.",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "criar_ciclo_metas",
        "description": "Cria um novo ciclo de metas.",
        "input_schema": {
            "type": "object",
            "properties": {
                "nome": {"type": "string"},
                "ano": {"type": "integer"},
                "descricao": {"type": "string"},
            },
            "required": ["nome", "ano"],
        },
    },
    {
        "name": "visao_geral_metas",
        "description": "Retorna visão geral das metas/OKRs com progresso mensal por colaborador.",
        "input_schema": {
            "type": "object",
            "properties": {
                "cycle_id": {"type": "string"},
                "user_id": {"type": "string"},
            },
        },
    },
    {
        "name": "criar_meta",
        "description": "Cria uma nova meta/OKR.",
        "input_schema": {
            "type": "object",
            "properties": {
                "titulo": {"type": "string"},
                "descricao": {"type": "string"},
                "tipo_calculo": {
                    "type": "string",
                    "enum": ["sum", "average", "last", "subtraction"],
                    "description": "sum=acumulado, average=média, last=último valor, subtraction=subtração",
                },
                "valor_alvo": {"type": "number"},
                "cycle_id": {"type": "string"},
                "responsavel_id": {"type": "string"},
            },
            "required": ["titulo", "descricao", "tipo_calculo", "valor_alvo", "cycle_id"],
        },
    },
    {
        "name": "atualizar_meta",
        "description": "Atualiza título, descrição ou valor alvo de uma meta.",
        "input_schema": {
            "type": "object",
            "properties": {
                "goal_id": {"type": "string"},
                "titulo": {"type": "string"},
                "descricao": {"type": "string"},
                "valor_alvo": {"type": "number"},
            },
            "required": ["goal_id"],
        },
    },

    # ── PDI ───────────────────────────────────────────────────────────────────
    {
        "name": "meu_pdi",
        "description": "Retorna o PDI do próprio Bruce.",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "pdi_da_equipe",
        "description": "Retorna PDIs da equipe inteira ou de um colaborador específico.",
        "input_schema": {
            "type": "object",
            "properties": {"user_id": {"type": "string"}},
        },
    },
    {
        "name": "criar_plano_pdi",
        "description": "Cria um Plano de Desenvolvimento Individual para um colaborador.",
        "input_schema": {
            "type": "object",
            "properties": {
                "user_id": {"type": "string"},
                "titulo": {"type": "string"},
                "descricao": {"type": "string"},
                "cycle_id": {"type": "string", "description": "Vincular a um ciclo de avaliação (opcional)"},
            },
            "required": ["user_id", "titulo", "descricao"],
        },
    },
    {
        "name": "atualizar_plano_pdi",
        "description": "Atualiza status ou conteúdo de um plano PDI.",
        "input_schema": {
            "type": "object",
            "properties": {
                "plan_id": {"type": "string"},
                "titulo": {"type": "string"},
                "descricao": {"type": "string"},
                "status": {"type": "string", "enum": ["active", "completed", "cancelled"]},
            },
            "required": ["plan_id"],
        },
    },
    {
        "name": "adicionar_acao_pdi",
        "description": "Adiciona uma ação (tarefa) a um plano PDI.",
        "input_schema": {
            "type": "object",
            "properties": {
                "plan_id": {"type": "string"},
                "titulo": {"type": "string"},
                "descricao": {"type": "string"},
                "como": {"type": "string", "description": "Como a ação será executada"},
                "data_limite": {"type": "string", "description": "YYYY-MM-DD"},
            },
            "required": ["plan_id", "titulo", "descricao", "como", "data_limite"],
        },
    },
    {
        "name": "atualizar_acao_pdi",
        "description": "Atualiza status de uma ação PDI.",
        "input_schema": {
            "type": "object",
            "properties": {
                "action_id": {"type": "string"},
                "status": {"type": "string", "enum": ["pending", "in_progress", "done"]},
                "titulo": {"type": "string"},
                "descricao": {"type": "string"},
            },
            "required": ["action_id"],
        },
    },

    # ── Relatórios ────────────────────────────────────────────────────────────
    {
        "name": "relatorio_colaboradores",
        "description": "Gera relatório completo de colaboradores (dados cadastrais, departamento, papel).",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "relatorio_resultados_testes",
        "description": "Gera relatório dos resultados de testes psicométricos de todos os colaboradores.",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "relatorio_ausencias",
        "description": "Gera relatório consolidado de ausências.",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "relatorio_beneficios",
        "description": "Gera relatório de benefícios atribuídos.",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "relatorio_pdi",
        "description": "Gera relatório de PDIs — planos, ações e progresso.",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "relatorio_aprendizado",
        "description": "Gera relatório de cursos e trilhas de aprendizado.",
        "input_schema": {"type": "object", "properties": {}},
    },

    # ── Ausências ─────────────────────────────────────────────────────────────
    {
        "name": "tipos_ausencia",
        "description": "Lista tipos de ausência cadastrados (férias, atestado, licença, etc).",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "ausencias_da_equipe",
        "description": "Lista ausências da equipe, com datas e status de aprovação.",
        "input_schema": {
            "type": "object",
            "properties": {"user_id": {"type": "string", "description": "Filtrar por colaborador (opcional)"}},
        },
    },
    {
        "name": "solicitar_ausencia",
        "description": "Solicita uma ausência para o próprio Bruce.",
        "input_schema": {
            "type": "object",
            "properties": {
                "tipo_id": {"type": "string"},
                "data_inicio": {"type": "string", "description": "YYYY-MM-DD"},
                "data_fim": {"type": "string", "description": "YYYY-MM-DD"},
                "motivo": {"type": "string"},
            },
            "required": ["tipo_id", "data_inicio", "data_fim"],
        },
    },
    {
        "name": "aprovar_ausencia",
        "description": "Aprova uma solicitação de ausência.",
        "input_schema": {
            "type": "object",
            "properties": {"request_id": {"type": "string"}},
            "required": ["request_id"],
        },
    },
    {
        "name": "rejeitar_ausencia",
        "description": "Rejeita uma solicitação de ausência.",
        "input_schema": {
            "type": "object",
            "properties": {
                "request_id": {"type": "string"},
                "motivo": {"type": "string"},
            },
            "required": ["request_id"],
        },
    },

    # ── Benefícios ────────────────────────────────────────────────────────────
    {
        "name": "catalogo_beneficios",
        "description": "Lista o catálogo de benefícios disponíveis na empresa.",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "resumo_beneficios",
        "description": "Retorna resumo agregado dos benefícios por colaborador.",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "beneficios_da_equipe",
        "description": "Lista benefícios atribuídos a toda a equipe.",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "beneficios_do_colaborador",
        "description": "Lista benefícios atribuídos a um colaborador específico.",
        "input_schema": {
            "type": "object",
            "properties": {"user_id": {"type": "string"}},
            "required": ["user_id"],
        },
    },
    {
        "name": "atribuir_beneficio",
        "description": "Atribui um benefício do catálogo a um colaborador.",
        "input_schema": {
            "type": "object",
            "properties": {
                "user_id": {"type": "string"},
                "benefit_id": {"type": "string"},
                "valor": {"type": "number", "description": "Valor monetário (opcional)"},
            },
            "required": ["user_id", "benefit_id"],
        },
    },

    # ── Aprendizado ───────────────────────────────────────────────────────────
    {
        "name": "catalogo_aprendizado",
        "description": "Lista catálogo de cursos e treinamentos disponíveis.",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "aprendizado_da_equipe",
        "description": "Lista progresso de aprendizado de toda a equipe.",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "meu_aprendizado",
        "description": "Lista trilhas de aprendizado do próprio Bruce.",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "atribuir_curso",
        "description": "Atribui um curso do catálogo a um colaborador.",
        "input_schema": {
            "type": "object",
            "properties": {
                "user_id": {"type": "string"},
                "course_id": {"type": "string"},
            },
            "required": ["user_id", "course_id"],
        },
    },

    # ── Carreira ──────────────────────────────────────────────────────────────
    {
        "name": "trilhas_carreira",
        "description": "Lista trilhas e níveis de carreira configurados.",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "carreira_da_equipe",
        "description": "Lista posicionamento de carreira de toda a equipe.",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "minha_carreira",
        "description": "Retorna posição de carreira do próprio Bruce.",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "atualizar_carreira_colaborador",
        "description": "Atualiza o nível de carreira de um colaborador.",
        "input_schema": {
            "type": "object",
            "properties": {
                "user_id": {"type": "string"},
                "level_id": {"type": "string"},
            },
            "required": ["user_id", "level_id"],
        },
    },

    # ── Workshops ─────────────────────────────────────────────────────────────
    {
        "name": "listar_workshops",
        "description": "Lista workshops disponíveis na empresa.",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "criar_workshop",
        "description": "Cria um novo workshop.",
        "input_schema": {
            "type": "object",
            "properties": {
                "titulo": {"type": "string"},
                "descricao": {"type": "string"},
                "data": {"type": "string", "description": "YYYY-MM-DD"},
                "vagas": {"type": "integer"},
            },
            "required": ["titulo", "descricao", "data"],
        },
    },

    # ── Comunicações ──────────────────────────────────────────────────────────
    {
        "name": "comunicados",
        "description": "Lista comunicados e anúncios da empresa.",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "criar_comunicado",
        "description": "Cria um comunicado para todos os colaboradores.",
        "input_schema": {
            "type": "object",
            "properties": {
                "titulo": {"type": "string"},
                "conteudo": {"type": "string"},
                "urgente": {"type": "boolean", "default": False},
            },
            "required": ["titulo", "conteudo"],
        },
    },
    {
        "name": "aniversarios",
        "description": "Lista aniversariantes do mês atual.",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "marcos_comemoracao",
        "description": "Lista marcos comemorativos — tempo de empresa, promoções recentes.",
        "input_schema": {"type": "object", "properties": {}},
    },

    # ── Onboarding ────────────────────────────────────────────────────────────
    {
        "name": "onboarding_da_equipe",
        "description": "Lista status de onboarding dos novos colaboradores.",
        "input_schema": {"type": "object", "properties": {}},
    },

    # ── Pesquisas ─────────────────────────────────────────────────────────────
    {
        "name": "listar_pesquisas",
        "description": "Lista pesquisas de clima e engajamento.",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "resultados_pesquisa",
        "description": "Retorna resultados consolidados de uma pesquisa.",
        "input_schema": {
            "type": "object",
            "properties": {"survey_id": {"type": "string"}},
            "required": ["survey_id"],
        },
    },

    # ── Calendário ────────────────────────────────────────────────────────────
    {
        "name": "eventos_calendario",
        "description": "Lista eventos do calendário da empresa num período.",
        "input_schema": {
            "type": "object",
            "properties": {
                "inicio": {"type": "string", "description": "YYYY-MM-DD"},
                "fim": {"type": "string", "description": "YYYY-MM-DD"},
            },
        },
    },

    # ── Estrutura organizacional ──────────────────────────────────────────────
    {
        "name": "listar_empresas",
        "description": "Lista empresas cadastradas na plataforma.",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "listar_departamentos",
        "description": "Lista departamentos da empresa.",
        "input_schema": {
            "type": "object",
            "properties": {"empresa_id": {"type": "string"}},
        },
    },
    {
        "name": "cultura_empresa",
        "description": "Retorna cultura e valores da empresa.",
        "input_schema": {"type": "object", "properties": {}},
    },

    # ── Comparações de perfil ─────────────────────────────────────────────────
    {
        "name": "listar_comparacoes",
        "description": "Lista comparações de compatibilidade entre perfis psicométricos.",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "criar_comparacao",
        "description": "Cria comparação de compatibilidade psicométrica entre dois colaboradores.",
        "input_schema": {
            "type": "object",
            "properties": {
                "user_id_a": {"type": "string"},
                "user_id_b": {"type": "string"},
            },
            "required": ["user_id_a", "user_id_b"],
        },
    },

    # ── Convites ──────────────────────────────────────────────────────────────
    {
        "name": "listar_convites",
        "description": "Lista convites de acesso já enviados.",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "criar_convite",
        "description": "Gera um link de convite para novos colaboradores se cadastrarem.",
        "input_schema": {
            "type": "object",
            "properties": {
                "empresa_id": {"type": "string"},
                "departamento_id": {"type": "string"},
                "max_usos": {"type": "integer", "description": "Limite de usos (opcional)"},
            },
            "required": ["empresa_id"],
        },
    },

    # ── Notificações & Logs ───────────────────────────────────────────────────
    {
        "name": "notificacoes",
        "description": "Lista notificações do Bruce no sistema.",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "logs_auditoria",
        "description": "Retorna logs de auditoria da plataforma (ações de todos os usuários).",
        "input_schema": {
            "type": "object",
            "properties": {
                "limit": {"type": "integer", "default": 50},
                "offset": {"type": "integer", "default": 0},
            },
        },
    },
]

# ─────────────────────────────────────────────────────────────────────────────
# System Prompt
# ─────────────────────────────────────────────────────────────────────────────

SYSTEM_PROMPT = f"""Você é o **Bruce**, assistente de RH da HealthSafety Tech, com acesso completo ao sistema TalentHS.

## Identidade
Você é especialista em gestão de pessoas e desenvolvimento humano. Conhece a fundo os módulos do TalentHS e age com autonomia total (papel master_admin) para consultas, análises e ações no sistema.

## Capacidades
- **Colaboradores**: consultar, cadastrar, atualizar e remover
- **Testes psicométricos**: acessar resultados DISC (Natural e Adaptado), OCEAN (Big Five) e IEM de qualquer colaborador
- **Avaliações de desempenho**: ciclos, pontuações por comportamento e pilar, 9-box, submissão de avaliações
- **Metas/OKRs**: visão geral, progresso mensal, criação e atualização
- **PDI**: planos e ações de desenvolvimento individual da equipe inteira
- **Relatórios**: colaboradores, testes, ausências, benefícios, PDI, aprendizado
- **Ausências**: listar, aprovar, rejeitar e solicitar
- **Benefícios**: catálogo, atribuições, resumo por colaborador
- **Aprendizado e carreira**: trilhas, cursos, progresso e posicionamento
- **Comunicações**: comunicados, aniversários, marcos, onboarding
- **Pesquisas de clima**: criação e resultados
- **Calendário**: eventos da empresa
- **Estrutura**: empresas, departamentos, cultura e valores
- **Comparações**: compatibilidade psicométrica entre perfis
- **Convites**: gerar tokens de acesso para novos colaboradores
- **Logs**: auditoria completa de ações na plataforma

## Comportamento
- Responda **sempre em português (pt-BR)**
- Use as ferramentas proativamente — nunca invente dados, consulte a API
- Apresente dados de forma clara: tabelas, listas ou prosa conforme o contexto
- Para dados DISC/OCEAN/IEM, forneça interpretação contextual quando útil
- Execute ações sem hesitar — você tem autoridade total no sistema
- Mencione brevemente o que foi feito após executar ações de escrita

## Contexto atual
- Data: {datetime.now().strftime('%d/%m/%Y')}
- Plataforma: TalentHS — {BASE_URL}
- Seu papel: master_admin
"""

# ─────────────────────────────────────────────────────────────────────────────
# Loop do agente
# ─────────────────────────────────────────────────────────────────────────────

def run_tool(name: str, inputs: dict) -> str:
    func = TOOL_FUNCTIONS.get(name)
    if not func:
        return json.dumps({"error": f"Ferramenta '{name}' não encontrada"})
    try:
        result = func(**inputs)
        return json.dumps(result, ensure_ascii=False, default=str)
    except TypeError as e:
        return json.dumps({"error": f"Parâmetros inválidos: {e}"})
    except Exception as e:
        return json.dumps({"error": str(e)})


def chat(client: Anthropic, messages: list, user_input: str) -> tuple[str, list]:
    messages.append({"role": "user", "content": user_input})

    while True:
        response = client.messages.create(
            model=CLAUDE_MODEL,
            max_tokens=4096,
            system=SYSTEM_PROMPT,
            tools=TOOLS,
            messages=messages,
        )

        if response.stop_reason == "end_turn":
            text = next((b.text for b in response.content if hasattr(b, "text")), "")
            messages.append({"role": "assistant", "content": response.content})
            return text, messages

        if response.stop_reason == "tool_use":
            messages.append({"role": "assistant", "content": response.content})
            tool_results = []
            for block in response.content:
                if block.type == "tool_use":
                    args_preview = json.dumps(block.input, ensure_ascii=False)[:80]
                    print(f"  🔧 {block.name}({args_preview}{'...' if len(json.dumps(block.input)) > 80 else ''})")
                    result = run_tool(block.name, block.input)
                    tool_results.append({
                        "type": "tool_result",
                        "tool_use_id": block.id,
                        "content": result,
                    })
            messages.append({"role": "user", "content": tool_results})
        else:
            break

    return "Não consegui processar sua solicitação.", messages


def main():
    print("╔══════════════════════════════════════════╗")
    print("║   Bruce — Assistente de RH TalentHS      ║")
    print("║   HealthSafety Tech  |  master_admin      ║")
    print("╚══════════════════════════════════════════╝\n")

    print("Autenticando no TalentHS... ", end="", flush=True)
    try:
        get_token()
        print("✅ OK\n")
    except Exception as e:
        print(f"❌ Falha na autenticação: {e}")
        sys.exit(1)

    api_key = os.environ.get("ANTHROPIC_API_KEY")
    if not api_key:
        print("❌ ANTHROPIC_API_KEY não definida. Execute:")
        print("   export ANTHROPIC_API_KEY=sk-ant-...")
        sys.exit(1)

    client = Anthropic(api_key=api_key)
    messages = []

    print(f"Pronto! {len(TOOLS)} ferramentas disponíveis.")
    print("Digite sua pergunta ou comando. Ctrl+C para sair.\n")
    print("─" * 44)

    try:
        while True:
            try:
                user_input = input("\nVocê: ").strip()
            except EOFError:
                break
            if not user_input:
                continue

            print("\nBruce: ", end="", flush=True)
            response, messages = chat(client, messages, user_input)
            print(response)

    except KeyboardInterrupt:
        print("\n\nAté logo!")


if __name__ == "__main__":
    main()
