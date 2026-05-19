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

# Map (METHOD, regex_pattern) → human-readable Portuguese action
_ACTION_MAP: list[tuple[re.Pattern, str]] = [
    (re.compile(r"POST /auth/login"), "Login"),
    (re.compile(r"POST /auth/register$"), "Cadastro de usuário"),
    (re.compile(r"POST /auth/register-invite"), "Cadastro via convite"),

    (re.compile(r"POST /invitations"), "Convite enviado"),
    (re.compile(r"DELETE /invitations/"), "Convite removido"),

    (re.compile(r"PUT /collaborators/"), "Colaborador atualizado"),

    (re.compile(r"POST /absences/request"), "Solicitação de ausência criada"),
    (re.compile(r"PUT /absences/.+/approve"), "Ausência aprovada"),
    (re.compile(r"PUT /absences/.+/reject"), "Ausência recusada"),
    (re.compile(r"DELETE /absences/types/"), "Tipo de ausência removido"),
    (re.compile(r"POST /absences/types"), "Tipo de ausência criado"),
    (re.compile(r"PUT /absences/types/"), "Tipo de ausência atualizado"),
    (re.compile(r"DELETE /absences/"), "Solicitação de ausência removida"),

    (re.compile(r"POST /benefits/assign"), "Benefício atribuído a colaborador"),
    (re.compile(r"DELETE /benefits/assignment/"), "Benefício removido de colaborador"),
    (re.compile(r"POST /benefits/catalog"), "Benefício criado no catálogo"),
    (re.compile(r"PUT /benefits/catalog/"), "Benefício atualizado no catálogo"),
    (re.compile(r"DELETE /benefits/catalog/"), "Benefício removido do catálogo"),

    (re.compile(r"POST /pdi/plans"), "Plano de PDI criado"),
    (re.compile(r"PUT /pdi/plans/"), "Plano de PDI atualizado"),
    (re.compile(r"DELETE /pdi/plans/"), "Plano de PDI removido"),
    (re.compile(r"POST /pdi/actions"), "Ação de PDI criada"),
    (re.compile(r"PUT /pdi/actions/"), "Ação de PDI atualizada"),
    (re.compile(r"DELETE /pdi/actions/"), "Ação de PDI removida"),

    (re.compile(r"POST /evaluations"), "Avaliação criada"),
    (re.compile(r"PUT /evaluations/"), "Avaliação atualizada"),
    (re.compile(r"POST /evaluations/.+/submit"), "Avaliação submetida"),
    (re.compile(r"POST /evaluations/.+/publish"), "Avaliação publicada"),

    (re.compile(r"POST /surveys/.+/respond"), "Pesquisa respondida"),
    (re.compile(r"POST /surveys"), "Pesquisa criada"),
    (re.compile(r"PUT /surveys/"), "Pesquisa atualizada"),
    (re.compile(r"DELETE /surveys/"), "Pesquisa removida"),

    (re.compile(r"POST /calendar/events"), "Evento criado no calendário"),
    (re.compile(r"PUT /calendar/events/"), "Evento atualizado no calendário"),
    (re.compile(r"DELETE /calendar/events/"), "Evento removido do calendário"),

    (re.compile(r"POST /onboarding/templates"), "Template de onboarding criado"),
    (re.compile(r"PUT /onboarding/templates/"), "Template de onboarding atualizado"),
    (re.compile(r"DELETE /onboarding/templates/"), "Template de onboarding removido"),
    (re.compile(r"POST /onboarding/assign"), "Onboarding atribuído a colaborador"),

    (re.compile(r"POST /communications/announcements"), "Comunicado publicado"),
    (re.compile(r"DELETE /communications/announcements/"), "Comunicado removido"),

    (re.compile(r"POST /workshops"), "Workshop criado"),
    (re.compile(r"PUT /workshops/"), "Workshop atualizado"),
    (re.compile(r"DELETE /workshops/"), "Workshop removido"),
    (re.compile(r"POST /workshops/.+/register"), "Inscrição em workshop"),
    (re.compile(r"DELETE /workshops/.+/register"), "Cancelamento de inscrição em workshop"),

    (re.compile(r"POST /goals"), "Meta criada"),
    (re.compile(r"PUT /goals/"), "Meta atualizada"),
    (re.compile(r"DELETE /goals/"), "Meta removida"),

    (re.compile(r"POST /learning/catalog"), "Curso criado no catálogo"),
    (re.compile(r"PUT /learning/catalog/"), "Curso atualizado no catálogo"),
    (re.compile(r"DELETE /learning/catalog/"), "Curso removido do catálogo"),
    (re.compile(r"POST /learning/employee/"), "Treinamento registrado"),
    (re.compile(r"DELETE /learning/employee/"), "Treinamento removido"),

    (re.compile(r"POST /tests/responses"), "Teste respondido"),
    (re.compile(r"POST /tests/calculate"), "Resultado de teste calculado"),

    (re.compile(r"PUT /profiles/"), "Perfil atualizado"),
    (re.compile(r"PUT /companies/"), "Dados da empresa atualizados"),

    (re.compile(r"POST /departments"), "Departamento criado"),
    (re.compile(r"PUT /departments/"), "Departamento atualizado"),
    (re.compile(r"DELETE /departments/"), "Departamento removido"),

    (re.compile(r"POST /career"), "Trilha de carreira criada"),
    (re.compile(r"PUT /career/"), "Trilha de carreira atualizada"),
    (re.compile(r"DELETE /career/"), "Trilha de carreira removida"),
]


def _resolve_action(method: str, path: str) -> str:
    key = f"{method} {path}"
    for pattern, label in _ACTION_MAP:
        if pattern.search(key):
            return label
    method_labels = {"POST": "Criação", "PUT": "Atualização", "PATCH": "Atualização", "DELETE": "Remoção"}
    return method_labels.get(method, method)


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
                       (user_id, user_name, company_id, method, path, action, status_code, ip_address)
                   VALUES ($1, $2, $3, $4, $5, $6, $7, $8)""",
                user_id, user_name, company_id,
                method, path, action, status_code, ip_address,
            )
    except Exception:
        pass  # never let logging break the request


class AuditMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        response = await call_next(request)

        method = request.method
        path = request.url.path

        # Only log write operations
        if method not in ("POST", "PUT", "PATCH", "DELETE"):
            return response

        # Skip internal/docs paths
        if path in _SKIP_PATHS or any(path.startswith(p) for p in _SKIP_PREFIXES):
            return response

        # Decode JWT without raising (token may be absent for public routes)
        user_id: str | None = None
        auth = request.headers.get("Authorization", "")
        if auth.startswith("Bearer "):
            try:
                payload = jwt.decode(
                    auth[7:], settings.JWT_SECRET,
                    algorithms=[settings.JWT_ALGORITHM],
                )
                user_id = payload.get("sub")
            except Exception:
                pass

        action = _resolve_action(method, path)
        ip = _get_client_ip(request)
        status_code = response.status_code

        # Fire-and-forget — don't await, doesn't block response
        asyncio.create_task(_write_log(user_id, method, path, action, status_code, ip))

        return response
