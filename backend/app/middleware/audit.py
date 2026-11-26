import asyncio
import re
from datetime import datetime, timezone

import jwt
from fastapi import Request
from starlette.middleware.base import BaseHTTPMiddleware

from app.config import settings
from app.database import get_pool

# Paths that should never be logged
_SKIP_PATHS = {"/health", "/docs", "/openapi.json", "/redoc"}
_SKIP_PREFIXES = ("/docs", "/redoc", "/openapi")
# Disparadas a cada poucos segundos durante um vídeo ou envio: inundariam o log.
_SKIP_PATTERNS = (
    re.compile(r"^POST /videos/[^/]+/progress$"),
    re.compile(r"^PUT /videos/uploads/[^/]+/parts/[^/]+$"),
    re.compile(r"^(PUT|POST) /tour/progress/"),
)

# "MÉTODO caminho" → ação em português. Casa a chave INTEIRA (fullmatch): sem âncora,
# "POST /workshops" pegava a inscrição e "POST /goals" o comentário da meta.
_ID = r"[^/]+"
_ACTION_MAP: list[tuple[re.Pattern, str]] = [(re.compile(p), label) for p, label in [
    (r"POST /auth/login", "Login"),
    (r"POST /auth/register", "Cadastro de usuário"),
    (r"POST /auth/register-invite", "Cadastro via convite"),

    (r"POST /invitations", "Convite enviado"),
    (rf"DELETE /invitations/{_ID}", "Convite removido"),

    (rf"PATCH /collaborators/{_ID}", "Colaborador atualizado"),
    (rf"POST /collaborators/{_ID}/deactivate", "Colaborador desligado"),
    (rf"POST /collaborators/{_ID}/reactivate", "Colaborador reativado"),

    (r"POST /absences/request", "Solicitação de ausência criada"),
    (rf"PUT /absences/{_ID}/approve", "Ausência aprovada"),
    (rf"PUT /absences/{_ID}/reject", "Ausência recusada"),
    (rf"DELETE /absences/{_ID}", "Solicitação de ausência removida"),

    (rf"POST /timeclock/{_ID}/adjust", "Ajuste de ponto solicitado"),
    (r"POST /timeclock/manual-self", "Batida lançada pelo colaborador"),
    (rf"POST /timeclock/adjustments/{_ID}/approve", "Ajuste de ponto aprovado"),
    (rf"POST /timeclock/adjustments/{_ID}/reject", "Ajuste de ponto recusado"),
    (rf"POST /timeclock/punches/{_ID}/confirm", "Batida confirmada"),
    (rf"POST /timeclock/punches/{_ID}/reject", "Batida recusada"),

    (r"POST /benefits/assign", "Benefício atribuído a colaborador"),
    (rf"DELETE /benefits/assignment/{_ID}", "Benefício removido de colaborador"),
    (r"POST /benefits/catalog", "Benefício criado no catálogo"),
    (rf"PUT /benefits/catalog/{_ID}", "Benefício atualizado no catálogo"),
    (rf"DELETE /benefits/catalog/{_ID}", "Benefício removido do catálogo"),

    (r"POST /pdi/plans", "Plano de PDI criado"),
    (rf"PUT /pdi/plans/{_ID}", "Plano de PDI atualizado"),
    (rf"DELETE /pdi/plans/{_ID}", "Plano de PDI removido"),
    (rf"POST /pdi/plans/{_ID}/actions", "Ação de PDI criada"),
    (rf"PUT /pdi/actions/{_ID}", "Ação de PDI atualizada"),
    (rf"DELETE /pdi/actions/{_ID}", "Ação de PDI removida"),

    (r"POST /evaluations/submit", "Avaliação enviada"),
    (rf"PUT /collaborators/{_ID}/manager", "Gestor responsável definido"),
    (r"POST /evaluations/cycles", "Ciclo de avaliação criado"),
    (rf"PUT /evaluations/cycles/{_ID}", "Ciclo de avaliação atualizado"),
    (rf"PUT /evaluations/cycles/{_ID}/calibrate", "Avaliação calibrada"),
    (rf"POST /evaluations/cycles/{_ID}/consolidate", "Notas do ciclo consolidadas"),

    (rf"POST /surveys/{_ID}/respond", "Pesquisa respondida"),
    (r"POST /surveys", "Pesquisa criada"),
    (rf"PUT /surveys/{_ID}", "Pesquisa atualizada"),
    (rf"DELETE /surveys/{_ID}", "Pesquisa removida"),

    (r"POST /feedbacks", "Pedido de feedback criado"),
    (rf"POST /feedbacks/{_ID}/respond", "Feedback respondido"),

    (r"POST /calendar/events", "Evento criado no calendário"),
    (rf"PUT /calendar/events/{_ID}", "Evento atualizado no calendário"),
    (rf"DELETE /calendar/events/{_ID}", "Evento removido do calendário"),

    (r"POST /onboarding/templates", "Template de onboarding criado"),
    (rf"PUT /onboarding/templates/{_ID}", "Template de onboarding atualizado"),
    (rf"DELETE /onboarding/templates/{_ID}", "Template de onboarding removido"),
    (r"POST /onboarding/assign", "Onboarding atribuído a colaborador"),
    (rf"PUT /onboarding/checklist-tasks/{_ID}/complete", "Tarefa de onboarding marcada ou desmarcada"),

    (r"POST /communications/announcements", "Comunicado criado"),
    (rf"PUT /communications/announcements/{_ID}", "Comunicado atualizado"),
    (rf"DELETE /communications/announcements/{_ID}", "Comunicado removido"),

    (r"POST /workshops", "Workshop criado"),
    (rf"PUT /workshops/{_ID}", "Workshop atualizado"),
    (rf"DELETE /workshops/{_ID}", "Workshop removido"),
    (rf"POST /workshops/{_ID}/register", "Inscrição em workshop"),
    (rf"DELETE /workshops/{_ID}/register", "Cancelamento de inscrição em workshop"),
    (rf"PUT /workshops/{_ID}/attendance", "Presença em workshop registrada"),

    (r"POST /goals", "Meta criada"),
    (rf"PUT /goals/{_ID}", "Meta atualizada"),
    (rf"DELETE /goals/{_ID}", "Meta removida"),
    (rf"PUT /goals/{_ID}/actuals/{_ID}", "Realizado de meta lançado"),
    (rf"DELETE /goals/{_ID}/actuals/{_ID}", "Realizado de meta removido"),
    (rf"POST /goals/{_ID}/comments", "Comentário em meta"),
    (rf"DELETE /goals/comments/{_ID}", "Comentário de meta removido"),

    (r"POST /learning/catalog", "Curso criado no catálogo"),
    (rf"PUT /learning/catalog/{_ID}", "Curso atualizado no catálogo"),
    (rf"DELETE /learning/catalog/{_ID}", "Curso removido do catálogo"),
    (rf"POST /learning/employee/{_ID}", "Treinamento registrado"),
    (rf"DELETE /learning/employee/.+", "Treinamento removido"),

    (r"POST /tests/responses", "Teste respondido"),
    (r"POST /tests/calculate", "Resultado de teste calculado"),

    (r"PATCH /profiles/me", "Perfil atualizado"),
    (r"PATCH /companies/.+", "Dados da empresa atualizados"),

    (r"POST /departments", "Departamento criado"),
    (rf"PATCH /departments/{_ID}", "Departamento atualizado"),
    (rf"DELETE /departments/{_ID}", "Departamento removido"),

    (r"POST /career/tracks", "Trilha de carreira criada"),
    (rf"PUT /career/tracks/{_ID}", "Trilha de carreira atualizada"),
    (rf"DELETE /career/tracks/{_ID}", "Trilha de carreira removida"),
    (rf"POST /career/tracks/{_ID}/levels", "Nível de carreira criado"),
    (rf"PUT /career/levels/{_ID}", "Nível de carreira atualizado"),
    (rf"DELETE /career/levels/{_ID}", "Nível de carreira removido"),
    (rf"PUT /career/employee/{_ID}", "Carreira do colaborador atualizada"),

    (r"POST /videos", "Vídeo criado"),
    (rf"PATCH /videos/{_ID}", "Vídeo atualizado"),
    (rf"POST /videos/{_ID}/replace-file", "Arquivo de vídeo substituído"),
    (rf"POST /videos/{_ID}/archive", "Vídeo arquivado"),
    (rf"POST /videos/{_ID}/unarchive", "Vídeo desarquivado"),
    (rf"POST /videos/{_ID}/viewers/{_ID}/remove", "Colaborador removido de vídeo"),
    (rf"POST /videos/{_ID}/viewers/{_ID}/complete", "Conclusão de vídeo registrada"),
    (rf"POST /videos/{_ID}/viewers/{_ID}/uncomplete", "Registro de conclusão desfeito"),
    (r"DELETE /videos/(?!uploads/)[^/]+", "Vídeo removido"),
]]


def _resolve_action(method: str, path: str) -> str:
    key = f"{method} {path.rstrip('/') or '/'}"
    for pattern, label in _ACTION_MAP:
        if pattern.fullmatch(key):
            return label
    method_labels = {"POST": "Criação", "PUT": "Atualização", "PATCH": "Atualização", "DELETE": "Remoção"}
    return method_labels.get(method, method)


def _should_log(method: str, path: str) -> bool:
    if method not in ("POST", "PUT", "PATCH", "DELETE"):
        return False
    if path in _SKIP_PATHS or any(path.startswith(p) for p in _SKIP_PREFIXES):
        return False
    key = f"{method} {path}"
    return not any(p.search(key) for p in _SKIP_PATTERNS)


def _should_log_agent(path: str) -> bool:
    # Leitura feita pelo Guardi também entra: é o rastro de o que o assistente consultou.
    return path not in _SKIP_PATHS and not any(path.startswith(p) for p in _SKIP_PREFIXES)


def _get_client_ip(request: Request) -> str:
    forwarded = request.headers.get("X-Forwarded-For")
    if forwarded:
        return forwarded.split(",")[0].strip()
    if request.client:
        return request.client.host
    return "unknown"


async def _write_log(
    user_id: str | None,
    method: str,
    path: str,
    action: str,
    status_code: int,
    ip_address: str,
    via: str | None = None,
):
    pool = get_pool()
    if not pool:
        return
    try:
        async with pool.acquire() as conn:
            user_name = None
            company_id = None
            if user_id:
                row = await conn.fetchrow(
                    "SELECT name, company_id FROM public.profiles WHERE user_id = $1",
                    user_id,
                )
                if row:
                    user_name = row["name"]
                    company_id = row["company_id"]

            await conn.execute(
                """INSERT INTO audit_logs
                       (user_id, user_name, company_id, method, path, action, status_code, ip_address, via)
                   VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)""",
                user_id, user_name, company_id,
                method, path, action, status_code, ip_address, via,
            )
    except Exception:
        pass  # never let logging break the request


class AuditMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        response = await call_next(request)

        method = request.method
        path = request.url.path

        # Postos por get_current_user_id quando o token é de agente e passou na validação.
        via = getattr(request.state, "agente_bot", None)
        if via:
            if not _should_log_agent(path):
                return response
        elif not _should_log(method, path):
            return response

        # Decode JWT without raising (token may be absent for public routes)
        user_id: str | None = getattr(request.state, "agente_user_id", None)
        auth = request.headers.get("Authorization", "")
        if not via and auth.startswith("Bearer "):
            try:
                payload = jwt.decode(
                    auth[7:], settings.JWT_SECRET,
                    algorithms=[settings.JWT_ALGORITHM],
                )
                user_id = payload.get("sub")
            except Exception:
                pass

        action = "Consulta pelo assistente" if via and method == "GET" else _resolve_action(method, path)
        ip = _get_client_ip(request)
        status_code = response.status_code

        # Fire-and-forget — don't await, doesn't block response
        asyncio.create_task(_write_log(user_id, method, path, action, status_code, ip, via))

        return response
