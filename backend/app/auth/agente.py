"""Token de agente do HS.OS (JWT EdDSA). Funções puras: sem config e sem banco.

O Guardi (assistente pessoal do HS.OS) lê o TalentHS COMO o dono dele: o token traz o
e-mail do dono em `sub` e o bot em `act.sub`. Mesmo desenho do DataCore
(`DataCore/backend/app/core/agente.py`), com `aud="talenths"`.
"""
import time

import jwt

# HS.OS emite tokens de 5 min; a folga cobre diferença de relógio.
VIDA_MAXIMA_SEGUNDOS = 600
AUDIENCIA = "talenths"
EMISSOR = "hsos"

# Leitura: só o que o catálogo do Guardi usa, casado pelo TEMPLATE da rota (não por
# prefixo). Fora de propósito, de fora daqui: download de arquivo, prova/teste, convites,
# /auth/* (menos /auth/me), logs, administração de vídeo, bingo e tour.
ROTAS_DO_AGENTE = frozenset({
    "/auth/me",
    "/profiles/me", "/profiles", "/profiles/{user_id}",
    "/collaborators", "/departments",
    "/companies/presentation", "/companies/internal-rules", "/culture",
    "/communications/birthdays", "/communications/milestones", "/communications/announcements",
    "/notifications",
    "/absences/types", "/absences/my", "/absences/team", "/absences/calendar",
    "/calendar/feed",
    "/timeclock/my/today", "/timeclock/my", "/timeclock/team", "/timeclock/requests",
    "/goals/cycles", "/goals/overview", "/goals/{goal_id}", "/goals/{goal_id}/comments",
    "/pdi/my", "/pdi/team",
    "/evaluations/cycles", "/evaluations/behaviors", "/evaluations/my", "/evaluations/scores",
    "/evaluations/team-status", "/evaluations/9box",
    "/feedbacks/my", "/feedbacks", "/feedbacks/{feedback_id}/responses",
    "/learning/catalog", "/learning/my", "/learning/my-tracks", "/learning/team",
    "/learning/team-tracks",
    "/workshops", "/videos/mine",
    "/calendar/events",
    "/onboarding/my", "/onboarding/team", "/onboarding/templates",
    "/benefits/catalog", "/benefits/my", "/benefits/team",
    "/benefits/employee/{target_user_id}", "/benefits/summary",
    "/career/tracks", "/career/my", "/career/team",
    "/salary/references", "/salary/table", "/salary/positioning",
    "/surveys", "/surveys/{survey_id}/results",
    "/documents/my",
    "/tests/available", "/tests/my-attempts",
    "/reports/collaborators", "/reports/absences", "/reports/benefits", "/reports/pdi",
    "/reports/learning",
})


# Escritas que o Guardi faz depois de o dono confirmar o cartão no HS.OS. Quem pode cada
# uma continua sendo o papel do dono aqui. Fora, de propósito: bater ponto
# (POST /timeclock/punch, registro legal), cadastro/desligamento/senha/papel, salário,
# enviar ou calibrar avaliação, exclusões, configurações e anexos.
ESCRITAS_DO_AGENTE = frozenset({
    # colaborador
    ("POST", "/absences/request"),
    ("DELETE", "/absences/{request_id}"),
    ("POST", "/timeclock/{punch_id}/adjust"),
    ("POST", "/timeclock/manual-self"),
    ("POST", "/feedbacks/{feedback_id}/respond"),
    ("POST", "/workshops/{workshop_id}/register"),
    ("DELETE", "/workshops/{workshop_id}/register"),
    ("PUT", "/onboarding/checklist-tasks/{task_id}/complete"),
    # RH — aprovações
    ("PUT", "/absences/{request_id}/approve"),
    ("PUT", "/absences/{request_id}/reject"),
    ("POST", "/timeclock/adjustments/{req_id}/approve"),
    ("POST", "/timeclock/adjustments/{req_id}/reject"),
    ("POST", "/timeclock/punches/{punch_id}/confirm"),
    ("POST", "/timeclock/punches/{punch_id}/reject"),
    # RH — comunicação
    ("POST", "/communications/announcements"),
    ("PUT", "/communications/announcements/{announcement_id}"),
    ("POST", "/calendar/events"),
    ("PUT", "/calendar/events/{event_id}"),
    ("POST", "/feedbacks"),
    # RH — desenvolvimento (a ação de PDI também é do colaborador, no próprio plano)
    ("POST", "/pdi/plans"),
    ("PUT", "/pdi/plans/{plan_id}"),
    ("POST", "/pdi/plans/{plan_id}/actions"),
    ("PUT", "/pdi/actions/{action_id}"),
    ("PUT", "/goals/{goal_id}/actuals/{month}"),
    ("POST", "/goals/{goal_id}/comments"),
    ("POST", "/learning/employee/{target_user_id}"),
    ("POST", "/onboarding/assign"),
})


class TokenDeAgenteInvalido(Exception):
    pass


def eh_token_de_agente(token: str) -> bool:
    """Olha o payload SEM verificar: só decide o caminho (agente ou login normal)."""
    try:
        payload = jwt.decode(token, options={"verify_signature": False})
    except Exception:
        return False
    return isinstance(payload, dict) and payload.get("iss") == EMISSOR


def validar_token_de_agente(token: str, chave_pem: str) -> tuple[str, str]:
    """→ (email em minúsculas, bot). Qualquer falha lança TokenDeAgenteInvalido."""
    # O EasyPanel guarda o PEM numa linha só, com \n literal.
    chave = (chave_pem or "").replace("\\n", "\n").strip()
    if not chave:
        raise TokenDeAgenteInvalido("chave pública não configurada")
    try:
        payload = jwt.decode(
            token,
            chave,
            algorithms=["EdDSA"],
            audience=AUDIENCIA,
            issuer=EMISSOR,
            options={"require": ["exp", "sub", "iss", "aud"]},
        )
    except (jwt.PyJWTError, ValueError, TypeError) as exc:
        raise TokenDeAgenteInvalido(str(exc)) from exc
    if payload["exp"] - time.time() > VIDA_MAXIMA_SEGUNDOS:
        raise TokenDeAgenteInvalido("exp longe demais")
    email = payload.get("sub")
    act = payload.get("act")
    bot = act.get("sub") if isinstance(act, dict) else None
    if not isinstance(email, str) or not email or not isinstance(bot, str) or not bot:
        raise TokenDeAgenteInvalido("sub ou act.sub ausente")
    return email.strip().lower(), bot


def rota_liberada_ao_agente(method: str, route_template: str | None) -> bool:
    if method == "GET":
        return route_template in ROTAS_DO_AGENTE
    return (method, route_template) in ESCRITAS_DO_AGENTE
