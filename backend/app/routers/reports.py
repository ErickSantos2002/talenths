import csv
import io
import json
from fastapi import APIRouter, Depends, HTTPException
from fastapi.responses import StreamingResponse
import asyncpg

from app.dependencies import get_db, get_current_user_id

router = APIRouter(prefix="/reports", tags=["reports"])


# ── Helpers ───────────────────────────────────────────────────────────────────

async def _require_manager(user_id: str, conn: asyncpg.Connection):
    row = await conn.fetchrow(
        "SELECT id FROM public.user_roles WHERE user_id = $1 AND role IN ('manager', 'master_admin')",
        user_id,
    )
    if not row:
        raise HTTPException(status_code=403, detail="Acesso restrito")


async def _get_company_id(user_id: str, conn: asyncpg.Connection) -> str:
    row = await conn.fetchrow("SELECT company_id FROM public.profiles WHERE user_id = $1", user_id)
    if not row or not row["company_id"]:
        raise HTTPException(status_code=404, detail="Empresa não encontrada")
    return str(row["company_id"])


def _csv_response(rows: list[list], headers: list[str], filename: str) -> StreamingResponse:
    buf = io.StringIO()
    buf.write("﻿")  # BOM for Excel UTF-8
    writer = csv.writer(buf, delimiter=";")
    writer.writerow(headers)
    writer.writerows(rows)
    buf.seek(0)
    return StreamingResponse(
        iter([buf.getvalue()]),
        media_type="text/csv; charset=utf-8",
        headers={"Content-Disposition": f'attachment; filename="{filename}"'},
    )


def _fmt_date(val) -> str:
    if val is None:
        return ""
    if hasattr(val, "isoformat"):
        return val.isoformat()[:10]
    return str(val)


def _fmt_money(val) -> str:
    if val is None:
        return ""
    return f"{float(val):.2f}".replace(".", ",")


# ── Collaborators ─────────────────────────────────────────────────────────────

@router.get("/collaborators")
async def report_collaborators(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    rows = await conn.fetch(
        """SELECT p.name, p.email, d.name AS department, ur.role,
                  p.birth_date, p.hire_date, p.phone, p.position
           FROM profiles p
           LEFT JOIN departments d ON d.id = p.department_id
           LEFT JOIN user_roles ur ON ur.user_id = p.user_id
           WHERE p.company_id = $1
           ORDER BY p.name""",
        company_id,
    )
    ROLE_PT = {"master_admin": "Administrador", "manager": "Gestor", "user": "Colaborador"}
    data = [
        [
            r["name"] or "",
            r["email"] or "",
            r["department"] or "",
            ROLE_PT.get(r["role"] or "", r["role"] or ""),
            r["position"] or "",
            _fmt_date(r["birth_date"]),
            _fmt_date(r["hire_date"]),
            r["phone"] or "",
        ]
        for r in rows
    ]
    headers = ["Nome", "E-mail", "Departamento", "Perfil", "Cargo", "Data de Nascimento", "Data de Admissão", "Telefone"]
    return _csv_response(data, headers, "colaboradores.csv")


# ── Test Results ──────────────────────────────────────────────────────────────

@router.get("/test-results")
async def report_test_results(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    rows = await conn.fetch(
        """SELECT DISTINCT ON (tr.user_id)
                  p.name, p.email, d.name AS department,
                  tr.disc_natural, tr.disc_adapted, tr.big_five, tr.iem, tr.completed_at
           FROM test_results tr
           JOIN profiles p ON p.user_id = tr.user_id
           LEFT JOIN departments d ON d.id = p.department_id
           WHERE p.company_id = $1
           ORDER BY tr.user_id, tr.completed_at DESC""",
        company_id,
    )
    data = []
    for r in rows:
        dn = json.loads(r["disc_natural"]) if r["disc_natural"] else {}
        da = json.loads(r["disc_adapted"]) if r["disc_adapted"] else {}
        bf = json.loads(r["big_five"]) if r["big_five"] else {}
        data.append([
            r["name"] or "",
            r["email"] or "",
            r["department"] or "",
            _fmt_date(r["completed_at"]),
            dn.get("D", ""), dn.get("I", ""), dn.get("S", ""), dn.get("C", ""),
            da.get("D", ""), da.get("I", ""), da.get("S", ""), da.get("C", ""),
            bf.get("O", ""), bf.get("C", ""), bf.get("E", ""), bf.get("A", ""), bf.get("N", ""),
            r["iem"] or "",
        ])
    headers = [
        "Nome", "E-mail", "Departamento", "Data do Teste",
        "DISC Natural D", "DISC Natural I", "DISC Natural S", "DISC Natural C",
        "DISC Adaptado D", "DISC Adaptado I", "DISC Adaptado S", "DISC Adaptado C",
        "OCEAN O", "OCEAN C", "OCEAN E", "OCEAN A", "OCEAN N",
        "IEM",
    ]
    return _csv_response(data, headers, "resultados-testes.csv")


# ── Absences ──────────────────────────────────────────────────────────────────

@router.get("/absences")
async def report_absences(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    rows = await conn.fetch(
        """SELECT p.name, p.email, d.name AS department,
                  at.name AS type_name, ar.start_date, ar.end_date, ar.days,
                  ar.status, ar.reason, ar.review_note, ar.created_at
           FROM absence_requests ar
           JOIN profiles p ON p.user_id = ar.user_id
           LEFT JOIN departments d ON d.id = p.department_id
           JOIN absence_types at ON at.id = ar.type_id
           WHERE ar.company_id = $1
           ORDER BY ar.created_at DESC""",
        company_id,
    )
    STATUS_PT = {"pending": "Pendente", "approved": "Aprovada", "rejected": "Recusada"}
    data = [
        [
            r["name"] or "",
            r["email"] or "",
            r["department"] or "",
            r["type_name"] or "",
            _fmt_date(r["start_date"]),
            _fmt_date(r["end_date"]),
            r["days"],
            STATUS_PT.get(r["status"] or "", r["status"] or ""),
            r["reason"] or "",
            r["review_note"] or "",
            _fmt_date(r["created_at"]),
        ]
        for r in rows
    ]
    headers = ["Nome", "E-mail", "Departamento", "Tipo", "Início", "Fim", "Dias", "Status", "Motivo", "Nota do Gestor", "Solicitado em"]
    return _csv_response(data, headers, "ausencias.csv")


# ── Benefits ──────────────────────────────────────────────────────────────────

@router.get("/benefits")
async def report_benefits(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    rows = await conn.fetch(
        """SELECT p.name, p.email, d.name AS department,
                  bc.name AS benefit_name, bc.category, bc.provider,
                  bc.value_type, bc.value AS catalog_value, eb.value_override,
                  eb.start_date, eb.end_date, eb.notes
           FROM employee_benefits eb
           JOIN benefit_catalog bc ON bc.id = eb.benefit_id
           JOIN profiles p ON p.user_id = eb.user_id
           LEFT JOIN departments d ON d.id = p.department_id
           WHERE eb.company_id = $1
           ORDER BY p.name, bc.name""",
        company_id,
    )
    CATEGORY_PT = {
        "saude": "Saúde", "alimentacao": "Alimentação", "transporte": "Transporte",
        "financeiro": "Financeiro", "educacao": "Educação", "bem_estar": "Bem-estar", "outro": "Outro",
    }
    data = [
        [
            r["name"] or "",
            r["email"] or "",
            r["department"] or "",
            r["benefit_name"] or "",
            CATEGORY_PT.get(r["category"] or "", r["category"] or ""),
            r["provider"] or "",
            _fmt_money(r["value_override"] if r["value_override"] is not None else r["catalog_value"]),
            _fmt_date(r["start_date"]),
            _fmt_date(r["end_date"]),
            r["notes"] or "",
        ]
        for r in rows
    ]
    headers = ["Nome", "E-mail", "Departamento", "Benefício", "Categoria", "Fornecedor", "Valor", "Início", "Fim", "Observações"]
    return _csv_response(data, headers, "beneficios.csv")


# ── PDI ───────────────────────────────────────────────────────────────────────

@router.get("/pdi")
async def report_pdi(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    rows = await conn.fetch(
        """SELECT p.name, p.email, pp.title AS plan_title, pp.status AS plan_status,
                  pa.title AS action_title, pa.status AS action_status,
                  pa.due_date, pa.completed_at, pp.created_at
           FROM pdi_plans pp
           JOIN profiles p ON p.user_id = pp.user_id
           LEFT JOIN pdi_actions pa ON pa.plan_id = pp.id
           WHERE pp.company_id = $1
           ORDER BY p.name, pp.created_at DESC, pa.position""",
        company_id,
    )
    STATUS_PT = {"pending": "Pendente", "in_progress": "Em andamento", "done": "Concluído", "active": "Ativo", "completed": "Concluído", "cancelled": "Cancelado"}
    data = [
        [
            r["name"] or "",
            r["email"] or "",
            r["plan_title"] or "",
            STATUS_PT.get(r["plan_status"] or "", r["plan_status"] or ""),
            r["action_title"] or "",
            STATUS_PT.get(r["action_status"] or "", r["action_status"] or ""),
            _fmt_date(r["due_date"]),
            _fmt_date(r["completed_at"]),
            _fmt_date(r["created_at"]),
        ]
        for r in rows
    ]
    headers = ["Nome", "E-mail", "Plano", "Status do Plano", "Ação", "Status da Ação", "Prazo", "Concluído em", "Criado em"]
    return _csv_response(data, headers, "pdi.csv")


# ── Learning ──────────────────────────────────────────────────────────────────

@router.get("/learning")
async def report_learning(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    rows = await conn.fetch(
        """SELECT p.name, p.email, d.name AS department,
                  ec.course_title, ec.area, ec.hours, ec.completed_at, ec.source
           FROM employee_courses ec
           JOIN profiles p ON p.user_id = ec.user_id
           LEFT JOIN departments d ON d.id = p.department_id
           WHERE ec.company_id = $1
           ORDER BY p.name, ec.completed_at DESC""",
        company_id,
    )
    data = [
        [
            r["name"] or "",
            r["email"] or "",
            r["department"] or "",
            r["course_title"] or "",
            r["area"] or "",
            r["hours"] or "",
            _fmt_date(r["completed_at"]),
            r["source"] or "",
        ]
        for r in rows
    ]
    headers = ["Nome", "E-mail", "Departamento", "Curso", "Área", "Horas", "Concluído em", "Origem"]
    return _csv_response(data, headers, "treinamentos.csv")
