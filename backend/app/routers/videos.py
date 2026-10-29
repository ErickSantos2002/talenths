import asyncio
import os
import uuid
from contextlib import asynccontextmanager
from datetime import datetime, timedelta, timezone
from typing import Literal

import asyncpg
import jwt
from fastapi import APIRouter, Depends, HTTPException, Request, Response, status
from fastapi.responses import FileResponse, JSONResponse
from pydantic import BaseModel, ConfigDict, Field

from app import video_storage
from app.config import settings
from app.database import get_pool
from app.dependencies import ensure_active_user, get_current_user_id, get_db, require_manager
from app.roster import active_unless, iso_or_none
from app.video_logic import (
    MAX_FILE_SIZE,
    due_at,
    evaluate_progress,
    read_mp4_duration,
    validate_duration,
    viewer_status,
)

router = APIRouter(prefix="/videos", tags=["videos"])


class StartUploadBody(BaseModel):
    total_size: int


@asynccontextmanager
async def _open_conn(user_id: str):
    async with get_pool().acquire() as conn:
        async with conn.transaction():
            await conn.execute("SELECT set_config('app.current_user_id', $1, true)", str(user_id))
            await ensure_active_user(conn, str(user_id))
            yield conn


def get_conn_opener():
    """Injetável para o PUT de parte abrir a conexão só depois de receber o corpo."""
    return _open_conn


async def _read_capped_body(request: Request, limit: int) -> bytes:
    declared = request.headers.get("content-length")
    if declared and declared.isdigit() and int(declared) > limit:
        raise HTTPException(status_code=413, detail="Parte maior que o permitido.")
    chunks, received = [], 0
    async for chunk in request.stream():
        received += len(chunk)
        if received > limit:
            raise HTTPException(status_code=413, detail="Parte maior que o permitido.")
        chunks.append(chunk)
    return b"".join(chunks)


async def _get_company_id(user_id: str, conn: asyncpg.Connection) -> str:
    row = await conn.fetchrow("SELECT company_id FROM public.profiles WHERE user_id = $1", user_id)
    if not row or not row["company_id"]:
        raise HTTPException(status_code=400, detail="Usuário sem empresa")
    return str(row["company_id"])


async def _get_open_upload(upload_id: uuid.UUID, company_id: str, conn: asyncpg.Connection):
    row = await conn.fetchrow(
        """SELECT id, total_size, parts_received, completed_at, consumed_at, file_path
           FROM public.internal_video_uploads
           WHERE id = $1 AND company_id = $2::uuid FOR UPDATE""",
        upload_id, company_id,
    )
    if not row:
        raise HTTPException(status_code=404, detail="Upload não encontrado")
    return row


# Rotas estáticas de /videos/uploads ficam antes de qualquer /videos/{id}.

@router.post("/uploads", status_code=status.HTTP_201_CREATED)
async def start_upload(
    body: StartUploadBody,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    if body.total_size <= 0:
        raise HTTPException(status_code=400, detail="Tamanho do arquivo inválido.")
    if body.total_size > MAX_FILE_SIZE:
        raise HTTPException(status_code=400, detail="O arquivo excede o limite de 2 GB.")
    await video_storage.cleanup_stale_uploads(conn)
    try:
        await asyncio.to_thread(video_storage.ensure_free_space, company_id, body.total_size)
    except ValueError as e:
        raise HTTPException(status_code=507, detail=str(e))
    upload_id = await conn.fetchval(
        """INSERT INTO public.internal_video_uploads (company_id, created_by, total_size)
           VALUES ($1::uuid, $2::uuid, $3) RETURNING id""",
        company_id, user_id, body.total_size,
    )
    return {
        "upload_id": str(upload_id),
        "part_size": video_storage.PART_SIZE,
        "parts": video_storage.expected_parts(body.total_size),
    }


@router.put("/uploads/{upload_id}/parts/{part_number}", status_code=status.HTTP_204_NO_CONTENT)
async def upload_part(
    upload_id: uuid.UUID,
    part_number: int,
    request: Request,
    user_id: str = Depends(get_current_user_id),
    open_conn=Depends(get_conn_opener),
):
    # O corpo chega antes de abrir a transação: não segura conexão nem lock durante a rede.
    data = await _read_capped_body(request, video_storage.PART_SIZE)
    async with open_conn(user_id) as conn:
        await require_manager(user_id, conn)
        company_id = await _get_company_id(user_id, conn)
        row = await _get_open_upload(upload_id, company_id, conn)
        if row["completed_at"]:
            raise HTTPException(status_code=409, detail="Upload já concluído.")
        canonical = str(row["id"])
        try:
            await asyncio.to_thread(
                video_storage.write_part,
                video_storage.tmp_path(company_id, canonical), part_number, data, row["total_size"],
            )
        except ValueError as e:
            raise HTTPException(status_code=400, detail=str(e))
        await conn.execute(
            """UPDATE public.internal_video_uploads
               SET parts_received = array_append(parts_received, $2)
               WHERE id = $1 AND NOT ($2 = ANY(parts_received))""",
            row["id"], part_number,
        )
    return Response(status_code=status.HTTP_204_NO_CONTENT)


@router.post("/uploads/{upload_id}/complete")
async def complete_upload(
    upload_id: uuid.UUID,
    user_id: str = Depends(get_current_user_id),
    open_conn=Depends(get_conn_opener),
):
    # Commit antes de responder: o cliente cria o vídeo logo em seguida, possivelmente em
    # outro worker. Se o commit falhar, o arquivo final não pode ficar órfão no disco.
    final_path = None
    try:
        async with open_conn(user_id) as conn:
            await require_manager(user_id, conn)
            company_id = await _get_company_id(user_id, conn)
            row = await _get_open_upload(upload_id, company_id, conn)
            if row["completed_at"]:
                raise HTTPException(status_code=409, detail="Upload já concluído.")
            # Conferir o tamanho do arquivo não basta: pwrite deixa buracos até a última parte.
            if len(row["parts_received"]) != video_storage.expected_parts(row["total_size"]):
                raise HTTPException(status_code=400, detail="Faltam partes do arquivo. Tente enviar novamente.")
            tmp = video_storage.tmp_path(company_id, str(row["id"]))
            if not os.path.exists(tmp):
                raise HTTPException(status_code=400, detail="Arquivo temporário não encontrado. Envie novamente.")
            try:
                final_path, size, duration = await asyncio.to_thread(
                    video_storage.finalize_file, tmp, company_id
                )
            except ValueError as e:
                raise HTTPException(status_code=400, detail=str(e))
            await conn.execute(
                "UPDATE public.internal_video_uploads SET file_path = $2, completed_at = now() WHERE id = $1",
                row["id"], final_path,
            )
    except Exception:
        if final_path:
            await asyncio.to_thread(video_storage.remove_file, final_path)
        raise
    return {"upload_id": str(row["id"]), "duration_seconds": duration, "file_size": size}


@router.delete("/uploads/{upload_id}", status_code=status.HTTP_204_NO_CONTENT)
async def cancel_upload(
    upload_id: uuid.UUID,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    row = await _get_open_upload(upload_id, company_id, conn)
    if row["consumed_at"]:
        raise HTTPException(status_code=409, detail="Este arquivo já foi usado em um vídeo.")
    # Concluído e ainda não usado: o modal fechado antes de salvar descarta o arquivo final.
    path = row["file_path"] if row["completed_at"] else video_storage.tmp_path(company_id, str(row["id"]))
    await asyncio.to_thread(video_storage.remove_file, path)
    await conn.execute("DELETE FROM public.internal_video_uploads WHERE id = $1", row["id"])
    return Response(status_code=status.HTTP_204_NO_CONTENT)


# ── Gestão pelo RH ────────────────────────────────────────────────────────────

REPLACED_TITLE = "Vídeo atualizado: assista novamente"


class RulesIn(BaseModel):
    all: bool = False
    department_ids: list[str] = []
    user_ids: list[str] = []


class CreateVideoBody(BaseModel):
    upload_id: uuid.UUID
    title: str = Field(min_length=1, max_length=200)
    description: str | None = Field(default=None, max_length=2000)
    due_days: int | None = Field(default=None, gt=0)
    rules: RulesIn = RulesIn()


class UpdateVideoBody(BaseModel):
    title: str | None = Field(default=None, min_length=1, max_length=200)
    description: str | None = Field(default=None, max_length=2000)
    due_days: int | None = Field(default=None, gt=0)
    rules: RulesIn | None = None


class ReplaceFileBody(BaseModel):
    upload_id: uuid.UUID
    mode: Literal["keep_completed", "reset_all"]


class MoveBody(BaseModel):
    model_config = ConfigDict(extra="forbid")
    direction: Literal["up", "down"]


_VIDEO_COLUMNS = """id, title, description, file_size, duration_seconds, due_days, file_version,
                    archived_at, created_at, updated_at"""


def _video_out(row) -> dict:
    out = dict(row)
    out["id"] = str(out["id"])
    out["duration_seconds"] = float(out["duration_seconds"])
    return out


async def _get_video(video_id: uuid.UUID, company_id: str, conn: asyncpg.Connection, lock: bool = False):
    row = await conn.fetchrow(
        f"""SELECT {_VIDEO_COLUMNS}, file_path FROM public.internal_videos
            WHERE id = $1 AND company_id = $2::uuid {'FOR UPDATE' if lock else ''}""",
        video_id, company_id,
    )
    if not row:
        raise HTTPException(status_code=404, detail="Vídeo não encontrado")
    return row


async def _manager_company(user_id: str, conn: asyncpg.Connection) -> str:
    await require_manager(user_id, conn)
    return await _get_company_id(user_id, conn)


async def _consume_upload(upload_id: uuid.UUID, company_id: str, conn: asyncpg.Connection):
    row = await conn.fetchrow(
        """SELECT id, file_path, completed_at, consumed_at FROM public.internal_video_uploads
           WHERE id = $1 AND company_id = $2::uuid FOR UPDATE""",
        upload_id, company_id,
    )
    if not row:
        raise HTTPException(status_code=404, detail="Upload não encontrado")
    if not row["completed_at"]:
        raise HTTPException(status_code=400, detail="O envio do arquivo ainda não foi concluído.")
    if row["consumed_at"]:
        raise HTTPException(status_code=409, detail="Este arquivo já foi usado em um vídeo.")
    if not row["file_path"] or not os.path.exists(row["file_path"]):
        raise HTTPException(status_code=400, detail="Arquivo enviado não encontrado. Envie novamente.")
    await conn.execute(
        "UPDATE public.internal_video_uploads SET consumed_at = now() WHERE id = $1", row["id"]
    )
    try:
        size, duration = await asyncio.to_thread(_file_info, row["file_path"])
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    return row["file_path"], size, duration


def _file_info(path: str) -> tuple[int, float]:
    return os.path.getsize(path), validate_duration(read_mp4_duration(path))


def _clean_title(title: str | None) -> str:
    if not title or not title.strip():
        raise HTTPException(status_code=400, detail="Informe o título do vídeo.")
    return title.strip()


def _clean_description(description: str | None) -> str | None:
    return (description or "").strip() or None


def _parse_ids(values: list[str]) -> list[uuid.UUID]:
    try:
        return sorted({uuid.UUID(v) for v in values})
    except ValueError:
        raise HTTPException(status_code=400, detail="Seleção de pessoas ou departamentos inválida.")


async def _validated_targets(rules: RulesIn, company_id: str, conn: asyncpg.Connection):
    dept_ids = _parse_ids(rules.department_ids)
    user_ids = _parse_ids(rules.user_ids)
    if dept_ids:
        found = await conn.fetchval(
            "SELECT count(*) FROM public.departments WHERE id = ANY($1::uuid[]) AND company_id = $2::uuid",
            dept_ids, company_id,
        )
        if found != len(dept_ids):
            raise HTTPException(status_code=400, detail="Departamento não encontrado.")
    if user_ids:
        found = await conn.fetchval(
            "SELECT count(*) FROM public.profiles WHERE user_id = ANY($1::uuid[]) AND company_id = $2::uuid",
            user_ids, company_id,
        )
        if found != len(user_ids):
            raise HTTPException(status_code=400, detail="Colaborador não encontrado.")
    targets = {("department", d) for d in dept_ids} | {("user", u) for u in user_ids}
    if rules.all:
        targets.add(("all", None))
    return targets


async def _save_rules(video_id, wanted: set, conn: asyncpg.Connection) -> int:
    """Grava o conjunto de regras e materializa só as que são novas (regras só acrescentam)."""
    existing = {
        (r["target_type"], r["department_id"] or r["user_id"]): r["id"]
        for r in await conn.fetch(
            "SELECT id, target_type, department_id, user_id FROM public.internal_video_rules WHERE video_id = $1",
            video_id,
        )
    }
    removed = [rid for key, rid in existing.items() if key not in wanted]
    if removed:
        await conn.execute("DELETE FROM public.internal_video_rules WHERE id = ANY($1::uuid[])", removed)

    new_ids, readded_users = [], []
    for target_type, target in wanted - existing.keys():
        new_ids.append(await conn.fetchval(
            """INSERT INTO public.internal_video_rules (video_id, target_type, department_id, user_id)
               VALUES ($1, $2, $3, $4) RETURNING id""",
            video_id, target_type,
            target if target_type == "department" else None,
            target if target_type == "user" else None,
        ))
        if target_type == "user":
            readded_users.append(target)
    if readded_users:
        # internal_video_assign nunca limpa excluded: marcar de novo individualmente é o que desfaz a remoção.
        await conn.execute(
            """UPDATE public.internal_video_viewers SET excluded = false
               WHERE video_id = $1 AND user_id = ANY($2::uuid[])""",
            video_id, readded_users,
        )
    if not new_ids:
        return 0
    return await conn.fetchval(
        "SELECT public.internal_video_apply_rules($1, $2::uuid[])", video_id, new_ids
    )


async def _rules_out(video_id, conn: asyncpg.Connection) -> dict:
    rows = await conn.fetch(
        "SELECT target_type, department_id, user_id FROM public.internal_video_rules WHERE video_id = $1",
        video_id,
    )
    return {
        "all": any(r["target_type"] == "all" for r in rows),
        "department_ids": sorted(str(r["department_id"]) for r in rows if r["target_type"] == "department"),
        "user_ids": sorted(str(r["user_id"]) for r in rows if r["target_type"] == "user"),
    }


def _progress_pct(watched: float, duration: float, completed_at) -> int:
    if completed_at:
        return 100
    return min(100, round(watched / duration * 100)) if duration > 0 else 0


def _viewer_out(row, video, now: datetime) -> dict:
    duration = float(video["duration_seconds"])
    watched = float(row["max_watched_s"])
    due_days = video["due_days"] if row["required"] else None
    pct = _progress_pct(watched, duration, row["completed_at"])
    return {
        "user_id": str(row["user_id"]) if row["user_id"] else None,
        "name": row["name"],
        "department": row["department"],
        "deactivated_at": iso_or_none(row.get("deactivated_at")),
        "status": viewer_status(row["completed_at"], watched, row["assigned_at"], due_days, now),
        "progress_pct": pct,
        "completed_at": row["completed_at"],
        "assigned_at": row["assigned_at"],
        "due_at": due_at(row["assigned_at"], due_days),
    }


@router.post("", status_code=status.HTTP_201_CREATED)
async def create_video(
    body: CreateVideoBody,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _manager_company(user_id, conn)
    title = _clean_title(body.title)
    targets = await _validated_targets(body.rules, company_id, conn)
    file_path, size, duration = await _consume_upload(body.upload_id, company_id, conn)
    row = await conn.fetchrow(
        f"""INSERT INTO public.internal_videos
              (company_id, title, description, file_path, file_size, duration_seconds, due_days, created_by)
            VALUES ($1::uuid, $2, $3, $4, $5, $6, $7, $8::uuid)
            RETURNING {_VIDEO_COLUMNS}""",
        company_id, title, _clean_description(body.description), file_path, size, duration, body.due_days, user_id,
    )
    await _save_rules(row["id"], targets, conn)
    return _video_out(row)


@router.get("/admin")
async def list_videos_admin(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _manager_company(user_id, conn)
    rows = await conn.fetch(
        """SELECT v.id, v.title, v.duration_seconds, v.due_days, v.archived_at, v.created_at,
                  count(w.id) AS required_count,
                  count(w.id) FILTER (WHERE w.completed_at IS NOT NULL) AS completed_count,
                  count(w.id) FILTER (
                    WHERE w.completed_at IS NULL AND v.due_days IS NOT NULL
                      AND now() > w.assigned_at + make_interval(days => v.due_days)
                  ) AS overdue_count
           FROM public.internal_videos v
           LEFT JOIN public.internal_video_viewers w
             ON w.video_id = v.id AND w.required AND NOT w.excluded AND w.user_id IS NOT NULL
             AND NOT EXISTS (SELECT 1 FROM public.profiles p
                             WHERE p.user_id = w.user_id AND p.deactivated_at IS NOT NULL)
           WHERE v.company_id = $1::uuid
           GROUP BY v.id
           ORDER BY v.archived_at IS NOT NULL, v.position, v.created_at DESC, v.id""",
        company_id,
    )
    # O número é a posição entre os ativos: arquivado não ocupa lugar na ordem do RH.
    active = 0
    out = []
    for r in rows:
        order = None
        if r["archived_at"] is None:
            active += 1
            order = active
        out.append({**dict(r), "id": str(r["id"]), "duration_seconds": float(r["duration_seconds"]), "order": order})
    return out


@router.post("/{video_id}/move", status_code=status.HTTP_204_NO_CONTENT)
async def move_video(
    video_id: uuid.UUID,
    body: MoveBody,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _manager_company(user_id, conn)
    video = await _get_video(video_id, company_id, conn)
    if video["archived_at"] is not None:
        raise HTTPException(status_code=409, detail="Vídeo arquivado não tem lugar na ordem")
    # Uma mudança de ordem por empresa de cada vez: duas setas ao mesmo tempo (outra aba,
    # outra pessoa do RH) leriam a mesma lista e uma desfaria a outra.
    await conn.execute("SELECT pg_advisory_xact_lock(hashtext('internal_videos_order:' || $1))", company_id)
    ids = [
        r["id"]
        for r in await conn.fetch(
            """SELECT id FROM public.internal_videos
               WHERE company_id = $1::uuid AND archived_at IS NULL
               ORDER BY position, created_at DESC, id""",
            company_id,
        )
    ]
    if video_id not in ids:
        # Arquivado (ou excluído) entre a leitura acima e a trava.
        raise HTTPException(status_code=409, detail="Vídeo arquivado não tem lugar na ordem")
    i = ids.index(video_id)
    j = i - 1 if body.direction == "up" else i + 1
    if 0 <= j < len(ids):
        ids[i], ids[j] = ids[j], ids[i]
        await conn.execute(
            """UPDATE public.internal_videos v SET position = o.n
               FROM unnest($1::uuid[]) WITH ORDINALITY AS o(id, n)
               WHERE v.id = o.id""",
            ids,
        )
    return Response(status_code=status.HTTP_204_NO_CONTENT)


@router.get("/{video_id}/admin")
async def get_video_admin(
    video_id: uuid.UUID,
    include_inactive: bool = False,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _manager_company(user_id, conn)
    video = await _get_video(video_id, company_id, conn)
    rows = await conn.fetch(
        f"""SELECT w.user_id, w.required, w.excluded, w.assigned_at, w.max_watched_s, w.completed_at,
                   COALESCE(p.name, w.user_name_snapshot) AS name, p.deactivated_at,
                   CASE WHEN w.user_id IS NULL THEN w.department_name_snapshot ELSE d.name END AS department
            FROM public.internal_video_viewers w
            LEFT JOIN public.profiles p ON p.user_id = w.user_id
            LEFT JOIN public.departments d ON d.id = p.department_id
            WHERE w.video_id = $1 AND (w.user_id IS NULL OR {active_unless("p", 2)})
            ORDER BY name""",
        video_id, include_inactive,
    )
    now = datetime.now(timezone.utc)
    required, voluntary, former = [], [], []
    for r in rows:
        if r["user_id"] is None:
            former.append(_viewer_out(r, video, now))
        elif r["required"] and not r["excluded"]:
            required.append(_viewer_out(r, video, now))
        elif r["max_watched_s"] > 0 or r["completed_at"]:
            # Removido pelo RH sem nunca ter assistido não é voluntário: some da lista.
            voluntary.append(_viewer_out(r, video, now))
    return {
        "video": _video_out({k: v for k, v in dict(video).items() if k != "file_path"}),
        "rules": await _rules_out(video_id, conn),
        "required": required,
        "voluntary": voluntary,
        "former": former,
    }


@router.patch("/{video_id}")
async def update_video(
    video_id: uuid.UUID,
    body: UpdateVideoBody,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _manager_company(user_id, conn)
    await _get_video(video_id, company_id, conn, lock=True)
    targets = None if body.rules is None else await _validated_targets(body.rules, company_id, conn)
    fields = body.model_dump(exclude_unset=True, exclude={"rules"})
    if "title" in fields:
        fields["title"] = _clean_title(fields["title"])
    if "description" in fields:
        fields["description"] = _clean_description(fields["description"])
    sets = [f"{col} = ${i}" for i, col in enumerate(fields, start=2)]
    await conn.execute(
        f"UPDATE public.internal_videos SET {', '.join(sets + ['updated_at = now()'])} WHERE id = $1",
        video_id, *fields.values(),
    )
    if targets is not None:
        await _save_rules(video_id, targets, conn)
    return _video_out(await conn.fetchrow(
        f"SELECT {_VIDEO_COLUMNS} FROM public.internal_videos WHERE id = $1", video_id
    ))


@router.post("/{video_id}/viewers/{target_user_id}/remove")
async def remove_viewer(
    video_id: uuid.UUID,
    target_user_id: uuid.UUID,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _manager_company(user_id, conn)
    await _get_video(video_id, company_id, conn, lock=True)
    updated = await conn.fetchval(
        """UPDATE public.internal_video_viewers SET excluded = true, required = false
           WHERE video_id = $1 AND user_id = $2 RETURNING id""",
        video_id, target_user_id,
    )
    if not updated:
        raise HTTPException(status_code=404, detail="Pessoa não está na lista deste vídeo")
    await conn.execute(
        "DELETE FROM public.internal_video_rules WHERE video_id = $1 AND target_type = 'user' AND user_id = $2",
        video_id, target_user_id,
    )
    await conn.execute("UPDATE public.internal_videos SET updated_at = now() WHERE id = $1", video_id)
    return {"ok": True}


# Arquivo só sai do disco depois do commit: o commit de get_db roda após a resposta, e
# uma falha ali deixaria o banco apontando para um arquivo já apagado.
@router.post("/{video_id}/replace-file")
async def replace_file(
    video_id: uuid.UUID,
    body: ReplaceFileBody,
    user_id: str = Depends(get_current_user_id),
    open_conn=Depends(get_conn_opener),
):
    async with open_conn(user_id) as conn:
        company_id = await _manager_company(user_id, conn)
        video = await _get_video(video_id, company_id, conn, lock=True)
        file_path, size, duration = await _consume_upload(body.upload_id, company_id, conn)
        row = await conn.fetchrow(
            f"""UPDATE public.internal_videos
                SET file_path = $2, file_size = $3, duration_seconds = $4,
                    file_version = file_version + 1, updated_at = now()
                WHERE id = $1 RETURNING {_VIDEO_COLUMNS}""",
            video_id, file_path, size, duration,
        )
        # A linha do tempo mudou: progresso parcial não vale mais. assigned_at fica (prazo original).
        # Arquivado não aparece para ninguém: zera o progresso, mas não avisa.
        reset_filter = "" if body.mode == "reset_all" else "AND completed_at IS NULL"
        await conn.execute(
            f"""WITH reset AS (
                  UPDATE public.internal_video_viewers
                  SET max_watched_s = 0, completed_at = NULL, last_report_at = NULL
                  WHERE video_id = $1 {reset_filter}
                    AND (max_watched_s > 0 OR completed_at IS NOT NULL)
                  RETURNING user_id, required, excluded
                )
                INSERT INTO public.notifications (user_id, type, title, message)
                SELECT user_id, 'video', $2, $3 FROM reset
                WHERE $4 AND required AND NOT excluded AND user_id IS NOT NULL""",
            video_id, REPLACED_TITLE, row["title"], video["archived_at"] is None,
        )
    await asyncio.to_thread(video_storage.remove_file, video["file_path"])
    return _video_out(row)


async def _set_archived(video_id: uuid.UUID, archived: bool, user_id: str, conn: asyncpg.Connection) -> dict:
    company_id = await _manager_company(user_id, conn)
    await _get_video(video_id, company_id, conn, lock=True)
    row = await conn.fetchrow(
        f"""UPDATE public.internal_videos
            SET archived_at = CASE WHEN $2 THEN COALESCE(archived_at, now()) END,
                -- Reativado volta no fim da lista do RH.
                position = CASE WHEN NOT $2 AND archived_at IS NOT NULL THEN (
                  SELECT COALESCE(max(o.position), 0) + 1 FROM public.internal_videos o
                  WHERE o.company_id = internal_videos.company_id
                ) ELSE position END,
                updated_at = now()
            WHERE id = $1 RETURNING {_VIDEO_COLUMNS}""",
        video_id, archived,
    )
    if not archived:
        # Quem entrou ou mudou de departamento enquanto estava arquivado não foi atribuído.
        await conn.execute("SELECT public.internal_video_apply_rules($1)", video_id)
    return _video_out(row)


@router.post("/{video_id}/archive")
async def archive_video(
    video_id: uuid.UUID,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    return await _set_archived(video_id, True, user_id, conn)


@router.post("/{video_id}/unarchive")
async def unarchive_video(
    video_id: uuid.UUID,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    return await _set_archived(video_id, False, user_id, conn)


@router.delete("/{video_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_video(
    video_id: uuid.UUID,
    user_id: str = Depends(get_current_user_id),
    open_conn=Depends(get_conn_opener),
):
    async with open_conn(user_id) as conn:
        company_id = await _manager_company(user_id, conn)
        video = await _get_video(video_id, company_id, conn, lock=True)
        await conn.execute("DELETE FROM public.internal_videos WHERE id = $1", video_id)
    await asyncio.to_thread(video_storage.remove_file, video["file_path"])
    return Response(status_code=status.HTTP_204_NO_CONTENT)


# ── Colaborador ───────────────────────────────────────────────────────────────
# /mine e /stream/{token} ficam antes de GET /{video_id}.

STREAM_TOKEN_TYPE = "video_stream"
STREAM_TOKEN_TTL = timedelta(minutes=10)


class ProgressBody(BaseModel):
    position_s: float = Field(ge=0, allow_inf_nan=False)


_MY_VIDEO_QUERY = """
    SELECT v.id, v.title, v.description, v.duration_seconds, v.due_days, v.file_version,
           COALESCE(w.required AND NOT w.excluded, false) AS is_required,
           w.assigned_at, COALESCE(w.max_watched_s, 0) AS max_watched_s, w.completed_at
    FROM public.internal_videos v
    LEFT JOIN public.internal_video_viewers w ON w.video_id = v.id AND w.user_id = $2::uuid
    WHERE v.company_id = $1::uuid AND v.archived_at IS NULL"""


def _my_video_out(row, now: datetime) -> dict:
    duration = float(row["duration_seconds"])
    watched = float(row["max_watched_s"])
    due_days = row["due_days"] if row["is_required"] else None
    assigned_at = row["assigned_at"] or now
    return {
        "id": str(row["id"]),
        "title": row["title"],
        "description": row["description"],
        "duration_seconds": duration,
        "status": viewer_status(row["completed_at"], watched, assigned_at, due_days, now),
        "progress_pct": _progress_pct(watched, duration, row["completed_at"]),
        "due_at": due_at(assigned_at, due_days),
        "completed_at": row["completed_at"],
    }


async def _get_my_video(video_id: uuid.UUID, user_id: str, conn: asyncpg.Connection):
    company_id = await _get_company_id(user_id, conn)
    row = await conn.fetchrow(f"{_MY_VIDEO_QUERY} AND v.id = $3", company_id, user_id, video_id)
    if not row:
        raise HTTPException(status_code=404, detail="Vídeo não encontrado")
    return row


@router.get("/mine")
async def list_my_videos(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)
    rows = await conn.fetch(
        f"{_MY_VIDEO_QUERY} ORDER BY v.position, v.created_at DESC, v.id", company_id, user_id
    )
    now = datetime.now(timezone.utc)
    required, library = [], []
    # O número é o da lista do RH para todos: quem não recebeu um vídeo vê o buraco (1º, 3º).
    for order, r in enumerate(rows, start=1):
        (required if r["is_required"] else library).append({**_my_video_out(r, now), "order": order})
    return {"required": required, "library": library}


def _stream_not_found() -> HTTPException:
    return HTTPException(status_code=404, detail="Vídeo não encontrado")


@router.get("/stream/{token}")
async def stream_video(token: str, open_conn=Depends(get_conn_opener)):
    # Sem get_db_public: dependência de request só sai depois do corpo inteiro enviado,
    # e isso prenderia uma conexão do pool por espectador durante o vídeo todo.
    try:
        claims = jwt.decode(
            token, settings.JWT_SECRET, algorithms=[settings.JWT_ALGORITHM],
            options={"require": ["exp"]},
        )
        if claims.get("typ") != STREAM_TOKEN_TYPE:
            raise _stream_not_found()
        video_id, user_id = uuid.UUID(claims["vid"]), uuid.UUID(claims["uid"])
        version = int(claims["ver"])
    except (jwt.InvalidTokenError, KeyError, TypeError, ValueError):
        raise _stream_not_found()
    async with open_conn(str(user_id)) as conn:
        row = await conn.fetchrow(
            """SELECT v.file_path, v.file_version FROM public.internal_videos v
               JOIN public.profiles p ON p.company_id = v.company_id AND p.user_id = $2
                 AND p.deactivated_at IS NULL
               WHERE v.id = $1 AND v.archived_at IS NULL""",
            video_id, user_id,
        )
    if not row or row["file_version"] != version or not os.path.isfile(row["file_path"]):
        raise _stream_not_found()
    return FileResponse(row["file_path"], media_type="video/mp4", headers={"Cache-Control": "no-store"})


@router.get("/{video_id}")
async def get_my_video(
    video_id: uuid.UUID,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    row = await _get_my_video(video_id, user_id, conn)
    return {**_my_video_out(row, datetime.now(timezone.utc)), "max_watched_s": float(row["max_watched_s"])}


@router.post("/{video_id}/stream-token")
async def create_stream_token(
    video_id: uuid.UUID,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    row = await _get_my_video(video_id, user_id, conn)
    # Sem "sub" de propósito: get_current_user_id recusa, então não serve como login.
    token = jwt.encode(
        {
            "typ": STREAM_TOKEN_TYPE,
            "vid": str(row["id"]),
            "uid": str(user_id),
            "ver": row["file_version"],
            "exp": datetime.now(timezone.utc) + STREAM_TOKEN_TTL,
        },
        settings.JWT_SECRET, algorithm=settings.JWT_ALGORITHM,
    )
    return {"url": f"/videos/stream/{token}"}


@router.post("/{video_id}/progress")
async def report_progress(
    video_id: uuid.UUID,
    body: ProgressBody,
    user_id: str = Depends(get_current_user_id),
    open_conn=Depends(get_conn_opener),
):
    # Commit antes de responder: o próximo relato (outra aba, outro worker) já vê este.
    async with open_conn(user_id) as conn:
        video = await _get_my_video(video_id, user_id, conn)
        await conn.execute(
            """INSERT INTO public.internal_video_viewers (video_id, user_id, required)
               VALUES ($1, $2::uuid, false) ON CONFLICT (video_id, user_id) DO NOTHING""",
            video["id"], user_id,
        )
        viewer = await conn.fetchrow(
            """SELECT id, max_watched_s, last_report_at, completed_at FROM public.internal_video_viewers
               WHERE video_id = $1 AND user_id = $2::uuid FOR UPDATE""",
            video["id"], user_id,
        )
        current_max = float(viewer["max_watched_s"])
        if viewer["completed_at"]:
            return {"max_watched_s": current_max, "completed": True}
        now = datetime.now(timezone.utc)
        decision = evaluate_progress(
            current_max, viewer["last_report_at"], now, body.position_s, float(video["duration_seconds"])
        )
        if not decision.accepted:
            return JSONResponse(
                status_code=409,
                content={"detail": "Avanço além do assistido.", "max_watched_s": current_max},
            )
        if not decision.records_report:
            return {"max_watched_s": decision.new_max_s, "completed": decision.completed}
        await conn.execute(
            """UPDATE public.internal_video_viewers
               SET max_watched_s = $2, last_report_at = $3::timestamptz,
                   completed_at = CASE WHEN $4 THEN $3::timestamptz END
               WHERE id = $1""",
            viewer["id"], decision.new_max_s, now, decision.completed,
        )
    return {"max_watched_s": decision.new_max_s, "completed": decision.completed}
