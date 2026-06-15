from fastapi import APIRouter, Depends, HTTPException, status, Query
from datetime import datetime, timezone, timedelta, date as date_type
from zoneinfo import ZoneInfo
from typing import Optional
import asyncpg

from app.dependencies import get_db, get_current_user_id, require_manager

router = APIRouter(prefix="/timeclock", tags=["timeclock"])

BRT = ZoneInfo("America/Sao_Paulo")


# ── Helpers ───────────────────────────────────────────────────────────────────

async def _get_company_id(user_id: str, conn: asyncpg.Connection) -> str:
    row = await conn.fetchrow("SELECT company_id FROM public.profiles WHERE user_id = $1", user_id)
    if not row or not row["company_id"]:
        raise HTTPException(status_code=404, detail="Empresa não encontrada")
    return str(row["company_id"])


async def _get_profile(user_id: str, conn: asyncpg.Connection):
    row = await conn.fetchrow(
        "SELECT user_id, company_id, timeclock_enabled, daily_work_hours FROM public.profiles WHERE user_id = $1",
        user_id,
    )
    if not row:
        raise HTTPException(status_code=404, detail="Perfil não encontrado")
    return row


def _ser_punch(p, adj_map: Optional[dict] = None) -> dict:
    d = {
        "id": str(p["id"]),
        "user_id": str(p["user_id"]),
        "punched_at": p["punched_at"].isoformat(),
        "work_date": p["work_date"].isoformat(),
        "kind": p["kind"],
        "source": p["source"],
        "status": p["status"],
        "reason": p["reason"],
        "latitude": float(p["latitude"]) if p["latitude"] is not None else None,
        "longitude": float(p["longitude"]) if p["longitude"] is not None else None,
        "note": p["note"],
        "pending_adjustment": (adj_map or {}).get(str(p["id"]), {}).get("pending"),
        "adjusted": (adj_map or {}).get(str(p["id"]), {}).get("adjusted", False),
    }
    return d


async def _adjustments_map(punch_ids: list, conn: asyncpg.Connection) -> dict:
    """Mapeia punch_id -> {pending: <ajuste pendente|None>, adjusted: <bool aprovado>}."""
    if not punch_ids:
        return {}
    rows = await conn.fetch(
        """SELECT id, punch_id, requested_punched_at, reason, created_at, status
           FROM public.timeclock_adjustment_requests
           WHERE punch_id = ANY($1::uuid[])""",
        punch_ids,
    )
    m: dict = {}
    for r in rows:
        pid = str(r["punch_id"])
        entry = m.setdefault(pid, {"pending": None, "adjusted": False})
        if r["status"] == "pending":
            entry["pending"] = {
                "id": str(r["id"]),
                "requested_punched_at": r["requested_punched_at"].isoformat(),
                "reason": r["reason"],
                "created_at": r["created_at"].isoformat(),
            }
        elif r["status"] == "approved":
            entry["adjusted"] = True
    return m


def _worked_minutes(rows) -> tuple[int, bool]:
    """Pareia in→out (ordenado por horário) e soma a duração. Retorna (minutos, em_aberto)."""
    total = 0.0
    last_in = None
    for p in rows:
        if p["kind"] == "in":
            if last_in is None:
                last_in = p["punched_at"]
        else:  # out
            if last_in is not None:
                total += (p["punched_at"] - last_in).total_seconds() / 60
                last_in = None
    return int(round(total)), last_in is not None


def _day_summary(work_date, rows, expected_hours: float, adj_map: Optional[dict] = None) -> dict:
    worked, is_open = _worked_minutes(rows)
    return {
        "work_date": work_date.isoformat(),
        "expected_minutes": int(round(expected_hours * 60)),
        "worked_minutes": worked,
        "open": is_open,
        "odd": len(rows) % 2 == 1 and not is_open,
        "punches": [_ser_punch(p, adj_map) for p in rows],
    }


# ── Colaborador ───────────────────────────────────────────────────────────────

@router.post("/punch", status_code=201)
async def punch(
    body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    profile = await _get_profile(user_id, conn)
    if not profile["timeclock_enabled"]:
        raise HTTPException(status_code=403, detail="Você não está habilitado para bater ponto.")
    company_id = str(profile["company_id"])

    now_utc = datetime.now(timezone.utc)
    work_date = now_utc.astimezone(BRT).date()

    # Anti-duplo-clique: ignora batida do mesmo usuário há menos de 40s
    last = await conn.fetchrow(
        "SELECT punched_at FROM public.timeclock_punches WHERE user_id = $1 ORDER BY punched_at DESC LIMIT 1",
        user_id,
    )
    if last and (now_utc - last["punched_at"]) < timedelta(seconds=40):
        raise HTTPException(status_code=409, detail="Aguarde alguns segundos antes de bater novamente.")

    count_today = await conn.fetchval(
        "SELECT COUNT(*) FROM public.timeclock_punches WHERE user_id = $1 AND work_date = $2 AND status <> 'rejected'",
        user_id, work_date,
    )
    kind = "in" if count_today % 2 == 0 else "out"

    lat = body.get("latitude")
    lng = body.get("longitude")
    row = await conn.fetchrow(
        """INSERT INTO public.timeclock_punches
           (company_id, user_id, punched_at, work_date, kind, source, latitude, longitude, note, created_by)
           VALUES ($1, $2, $3, $4, $5, 'self', $6, $7, $8, $2) RETURNING *""",
        company_id, user_id, now_utc, work_date, kind, lat, lng, (body.get("note") or None),
    )
    return _ser_punch(row)


@router.get("/my/today")
async def my_today(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    profile = await _get_profile(user_id, conn)
    work_date = datetime.now(timezone.utc).astimezone(BRT).date()
    rows = await conn.fetch(
        "SELECT * FROM public.timeclock_punches WHERE user_id = $1 AND work_date = $2 AND status <> 'rejected' ORDER BY punched_at",
        user_id, work_date,
    )
    adj_map = await _adjustments_map([r["id"] for r in rows], conn)
    summary = _day_summary(work_date, rows, float(profile["daily_work_hours"]), adj_map)
    summary["enabled"] = profile["timeclock_enabled"]
    summary["next_action"] = "out" if len(rows) % 2 == 1 else "in"
    return summary


@router.get("/my")
async def my_range(
    start_date: Optional[str] = Query(None),
    end_date: Optional[str] = Query(None),
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    profile = await _get_profile(user_id, conn)
    today = datetime.now(timezone.utc).astimezone(BRT).date()
    start = date_type.fromisoformat(start_date) if start_date else today.replace(day=1)
    end = date_type.fromisoformat(end_date) if end_date else today
    rows = await conn.fetch(
        """SELECT * FROM public.timeclock_punches
           WHERE user_id = $1 AND work_date BETWEEN $2 AND $3 AND status <> 'rejected'
           ORDER BY work_date, punched_at""",
        user_id, start, end,
    )
    return await _group_days(rows, float(profile["daily_work_hours"]), conn)


async def _group_days(rows, expected_hours: float, conn: asyncpg.Connection) -> list:
    adj_map = await _adjustments_map([r["id"] for r in rows], conn)
    by_day: dict = {}
    for r in rows:
        by_day.setdefault(r["work_date"], []).append(r)
    return [_day_summary(d, by_day[d], expected_hours, adj_map) for d in sorted(by_day.keys(), reverse=True)]


# ── Gestor ────────────────────────────────────────────────────────────────────

@router.get("/team")
async def team(
    date: Optional[str] = Query(None),
    user_id_filter: Optional[str] = Query(None, alias="user_id"),
    start_date: Optional[str] = Query(None),
    end_date: Optional[str] = Query(None),
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    today = datetime.now(timezone.utc).astimezone(BRT).date()

    # Colaborador específico → agrupa por dia no período
    if user_id_filter:
        start = date_type.fromisoformat(start_date) if start_date else today.replace(day=1)
        end = date_type.fromisoformat(end_date) if end_date else today
        prof = await conn.fetchrow(
            "SELECT daily_work_hours FROM public.profiles WHERE user_id = $1 AND company_id = $2",
            user_id_filter, company_id,
        )
        if not prof:
            raise HTTPException(status_code=404, detail="Colaborador não encontrado")
        rows = await conn.fetch(
            """SELECT * FROM public.timeclock_punches
               WHERE user_id = $1 AND company_id = $2 AND work_date BETWEEN $3 AND $4 AND status <> 'rejected'
               ORDER BY work_date, punched_at""",
            user_id_filter, company_id, start, end,
        )
        return {"mode": "user", "days": await _group_days(rows, float(prof["daily_work_hours"]), conn)}

    # Todos os habilitados → resumo de um dia
    day = date_type.fromisoformat(date) if date else today
    people = await conn.fetch(
        """SELECT p.user_id, p.name, p.daily_work_hours, d.name AS department
           FROM public.profiles p
           LEFT JOIN public.departments d ON d.id = p.department_id
           WHERE p.company_id = $1 AND p.timeclock_enabled = true
           ORDER BY p.name""",
        company_id,
    )
    punch_rows = await conn.fetch(
        """SELECT * FROM public.timeclock_punches
           WHERE company_id = $1 AND work_date = $2 AND status <> 'rejected' ORDER BY punched_at""",
        company_id, day,
    )
    by_user: dict = {}
    for r in punch_rows:
        by_user.setdefault(str(r["user_id"]), []).append(r)

    result = []
    for person in people:
        uid = str(person["user_id"])
        rows = by_user.get(uid, [])
        worked, is_open = _worked_minutes(rows)
        result.append({
            "user_id": uid,
            "user_name": person["name"],
            "department": person["department"],
            "expected_minutes": int(round(float(person["daily_work_hours"]) * 60)),
            "worked_minutes": worked,
            "open": is_open,
            "status": "working" if is_open else ("done" if rows else "none"),
            "punches": [_ser_punch(p) for p in rows],
        })
    return {"mode": "day", "work_date": day.isoformat(), "people": result}


@router.post("/manual", status_code=201)
async def manual_punch(
    body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)

    target = body.get("user_id")
    kind = body.get("kind")
    punched_at_raw = body.get("punched_at")
    if not target or kind not in ("in", "out") or not punched_at_raw:
        raise HTTPException(status_code=400, detail="Dados inválidos (user_id, kind, punched_at obrigatórios).")

    if not await conn.fetchrow(
        "SELECT user_id FROM public.profiles WHERE user_id = $1 AND company_id = $2", target, company_id
    ):
        raise HTTPException(status_code=404, detail="Colaborador não encontrado")

    punched_at = datetime.fromisoformat(punched_at_raw)
    if punched_at.tzinfo is None:
        punched_at = punched_at.replace(tzinfo=BRT)
    work_date = punched_at.astimezone(BRT).date()

    row = await conn.fetchrow(
        """INSERT INTO public.timeclock_punches
           (company_id, user_id, punched_at, work_date, kind, source, note, created_by)
           VALUES ($1, $2, $3, $4, $5, 'manual', $6, $7) RETURNING *""",
        company_id, target, punched_at, work_date, kind, (body.get("note") or None), user_id,
    )
    return _ser_punch(row)


@router.put("/{punch_id}")
async def update_punch(
    punch_id: str,
    body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)

    existing = await conn.fetchrow(
        "SELECT * FROM public.timeclock_punches WHERE id = $1 AND company_id = $2", punch_id, company_id
    )
    if not existing:
        raise HTTPException(status_code=404, detail="Batida não encontrada")

    punched_at = existing["punched_at"]
    work_date = existing["work_date"]
    if body.get("punched_at"):
        punched_at = datetime.fromisoformat(body["punched_at"])
        if punched_at.tzinfo is None:
            punched_at = punched_at.replace(tzinfo=BRT)
        work_date = punched_at.astimezone(BRT).date()

    kind = body.get("kind", existing["kind"])
    if kind not in ("in", "out"):
        raise HTTPException(status_code=400, detail="kind inválido")
    note = body.get("note", existing["note"])

    row = await conn.fetchrow(
        """UPDATE public.timeclock_punches
           SET punched_at = $1, work_date = $2, kind = $3, note = $4, updated_at = now()
           WHERE id = $5 AND company_id = $6 RETURNING *""",
        punched_at, work_date, kind, note, punch_id, company_id,
    )
    return _ser_punch(row)


@router.delete("/{punch_id}", status_code=204)
async def delete_punch(
    punch_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    result = await conn.execute(
        "DELETE FROM public.timeclock_punches WHERE id = $1 AND company_id = $2", punch_id, company_id
    )
    if result == "DELETE 0":
        raise HTTPException(status_code=404, detail="Batida não encontrada")


# ── Solicitações do colaborador ────────────────────────────────────────────────

@router.post("/manual-self", status_code=201)
async def manual_self(
    body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    """Colaborador registra uma batida manualmente — entra como 'pending' até o RH confirmar."""
    profile = await _get_profile(user_id, conn)
    if not profile["timeclock_enabled"]:
        raise HTTPException(status_code=403, detail="Você não está habilitado para bater ponto.")
    company_id = str(profile["company_id"])

    kind = body.get("kind")
    punched_at_raw = body.get("punched_at")
    reason = (body.get("reason") or "").strip()
    if kind not in ("in", "out") or not punched_at_raw or not reason:
        raise HTTPException(status_code=400, detail="Informe horário, tipo (entrada/saída) e motivo.")

    punched_at = datetime.fromisoformat(punched_at_raw)
    if punched_at.tzinfo is None:
        punched_at = punched_at.replace(tzinfo=BRT)
    work_date = punched_at.astimezone(BRT).date()

    row = await conn.fetchrow(
        """INSERT INTO public.timeclock_punches
           (company_id, user_id, punched_at, work_date, kind, source, status, reason, created_by)
           VALUES ($1, $2, $3, $4, $5, 'self_manual', 'pending', $6, $2) RETURNING *""",
        company_id, user_id, punched_at, work_date, kind, reason,
    )
    return _ser_punch(row)


@router.post("/{punch_id}/adjust", status_code=201)
async def request_adjustment(
    punch_id: str,
    body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    """Colaborador solicita ajuste de horário de uma batida válida sua."""
    profile = await _get_profile(user_id, conn)
    company_id = str(profile["company_id"])

    punch = await conn.fetchrow(
        "SELECT * FROM public.timeclock_punches WHERE id = $1 AND user_id = $2", punch_id, user_id
    )
    if not punch:
        raise HTTPException(status_code=404, detail="Batida não encontrada")
    if punch["status"] != "valid":
        raise HTTPException(status_code=409, detail="Só é possível ajustar batidas válidas.")

    requested_raw = body.get("requested_punched_at")
    reason = (body.get("reason") or "").strip()
    if not requested_raw or not reason:
        raise HTTPException(status_code=400, detail="Informe o horário correto e o motivo.")
    requested = datetime.fromisoformat(requested_raw)
    if requested.tzinfo is None:
        requested = requested.replace(tzinfo=BRT)

    dup = await conn.fetchrow(
        "SELECT id FROM public.timeclock_adjustment_requests WHERE punch_id = $1 AND status = 'pending'",
        punch_id,
    )
    if dup:
        raise HTTPException(status_code=409, detail="Já existe uma solicitação de ajuste pendente para esta batida.")

    row = await conn.fetchrow(
        """INSERT INTO public.timeclock_adjustment_requests
           (company_id, punch_id, user_id, previous_punched_at, requested_punched_at, reason)
           VALUES ($1, $2, $3, $4, $5, $6) RETURNING *""",
        company_id, punch_id, user_id, punch["punched_at"], requested, reason,
    )
    return {
        "id": str(row["id"]),
        "punch_id": str(row["punch_id"]),
        "requested_punched_at": row["requested_punched_at"].isoformat(),
        "reason": row["reason"],
        "status": row["status"],
    }


# ── Caixa de solicitações do gestor ────────────────────────────────────────────

@router.get("/requests")
async def list_requests(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)

    pending_punches = await conn.fetch(
        """SELECT tp.*, p.name AS user_name
           FROM public.timeclock_punches tp
           JOIN public.profiles p ON p.user_id = tp.user_id
           WHERE tp.company_id = $1 AND tp.status = 'pending'
           ORDER BY tp.punched_at DESC""",
        company_id,
    )
    adjustments = await conn.fetch(
        """SELECT ar.*, p.name AS user_name, tp.kind AS punch_kind, tp.punched_at AS current_punched_at
           FROM public.timeclock_adjustment_requests ar
           JOIN public.profiles p ON p.user_id = ar.user_id
           JOIN public.timeclock_punches tp ON tp.id = ar.punch_id
           WHERE ar.company_id = $1 AND ar.status = 'pending'
           ORDER BY ar.created_at DESC""",
        company_id,
    )
    return {
        "pending_punches": [{**_ser_punch(r), "user_name": r["user_name"]} for r in pending_punches],
        "adjustments": [
            {
                "id": str(r["id"]),
                "punch_id": str(r["punch_id"]),
                "user_name": r["user_name"],
                "punch_kind": r["punch_kind"],
                "previous_punched_at": r["previous_punched_at"].isoformat(),
                "current_punched_at": r["current_punched_at"].isoformat(),
                "requested_punched_at": r["requested_punched_at"].isoformat(),
                "reason": r["reason"],
                "created_at": r["created_at"].isoformat(),
            }
            for r in adjustments
        ],
    }


@router.post("/punches/{punch_id}/confirm")
async def confirm_punch(
    punch_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    row = await conn.fetchrow(
        """UPDATE public.timeclock_punches SET status = 'valid', reviewed_by = $1, reviewed_at = now()
           WHERE id = $2 AND company_id = $3 AND status = 'pending' RETURNING *""",
        user_id, punch_id, company_id,
    )
    if not row:
        raise HTTPException(status_code=404, detail="Batida pendente não encontrada")
    return _ser_punch(row)


@router.post("/punches/{punch_id}/reject")
async def reject_punch(
    punch_id: str,
    body: dict | None = None,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    row = await conn.fetchrow(
        """UPDATE public.timeclock_punches SET status = 'rejected', reviewed_by = $1, reviewed_at = now()
           WHERE id = $2 AND company_id = $3 AND status = 'pending' RETURNING *""",
        user_id, punch_id, company_id,
    )
    if not row:
        raise HTTPException(status_code=404, detail="Batida pendente não encontrada")
    return _ser_punch(row)


@router.post("/adjustments/{req_id}/approve")
async def approve_adjustment(
    req_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    req = await conn.fetchrow(
        "SELECT * FROM public.timeclock_adjustment_requests WHERE id = $1 AND company_id = $2 AND status = 'pending'",
        req_id, company_id,
    )
    if not req:
        raise HTTPException(status_code=404, detail="Solicitação não encontrada")

    new_at = req["requested_punched_at"]
    work_date = new_at.astimezone(BRT).date()
    await conn.execute(
        "UPDATE public.timeclock_punches SET punched_at = $1, work_date = $2, updated_at = now() WHERE id = $3",
        new_at, work_date, req["punch_id"],
    )
    await conn.execute(
        "UPDATE public.timeclock_adjustment_requests SET status = 'approved', reviewed_by = $1, reviewed_at = now() WHERE id = $2",
        user_id, req_id,
    )
    return {"ok": True}


@router.post("/adjustments/{req_id}/reject")
async def reject_adjustment(
    req_id: str,
    body: dict | None = None,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    note = (body or {}).get("note")
    row = await conn.fetchrow(
        """UPDATE public.timeclock_adjustment_requests
           SET status = 'rejected', reviewed_by = $1, reviewed_at = now(), review_note = $2
           WHERE id = $3 AND company_id = $4 AND status = 'pending' RETURNING id""",
        user_id, note, req_id, company_id,
    )
    if not row:
        raise HTTPException(status_code=404, detail="Solicitação não encontrada")
    return {"ok": True}


@router.get("/punches/{punch_id}/history")
async def punch_history(
    punch_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    """Histórico de ajustes de uma batida. Acessível ao dono da batida ou a um gestor."""
    punch = await conn.fetchrow(
        "SELECT user_id, company_id FROM public.timeclock_punches WHERE id = $1", punch_id
    )
    if not punch:
        raise HTTPException(status_code=404, detail="Batida não encontrada")
    if str(punch["user_id"]) != user_id:
        await require_manager(user_id, conn)
        company_id = await _get_company_id(user_id, conn)
        if str(punch["company_id"]) != company_id:
            raise HTTPException(status_code=404, detail="Batida não encontrada")

    rows = await conn.fetch(
        """SELECT ar.*, p.name AS reviewer_name, req.name AS requester_name
           FROM public.timeclock_adjustment_requests ar
           LEFT JOIN public.profiles p ON p.user_id = ar.reviewed_by
           LEFT JOIN public.profiles req ON req.user_id = ar.user_id
           WHERE ar.punch_id = $1 ORDER BY ar.created_at""",
        punch_id,
    )
    return [
        {
            "id": str(r["id"]),
            "previous_punched_at": r["previous_punched_at"].isoformat(),
            "requested_punched_at": r["requested_punched_at"].isoformat(),
            "reason": r["reason"],
            "status": r["status"],
            "requester_name": r["requester_name"],
            "reviewer_name": r["reviewer_name"],
            "reviewed_at": r["reviewed_at"].isoformat() if r["reviewed_at"] else None,
            "created_at": r["created_at"].isoformat(),
        }
        for r in rows
    ]
