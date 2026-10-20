import asyncio
import os
import uuid
from contextlib import asynccontextmanager

import asyncpg
from fastapi import APIRouter, Depends, HTTPException, Request, Response, status
from pydantic import BaseModel

from app import video_storage
from app.database import get_pool
from app.dependencies import get_current_user_id, get_db, require_manager
from app.video_logic import MAX_FILE_SIZE

router = APIRouter(prefix="/videos", tags=["videos"])


class StartUploadBody(BaseModel):
    total_size: int


@asynccontextmanager
async def _open_conn(user_id: str):
    async with get_pool().acquire() as conn:
        async with conn.transaction():
            await conn.execute("SELECT set_config('app.current_user_id', $1, true)", str(user_id))
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
        """SELECT id, total_size, parts_received, completed_at
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
    conn: asyncpg.Connection = Depends(get_db),
):
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
    try:
        await conn.execute(
            "UPDATE public.internal_video_uploads SET file_path = $2, completed_at = now() WHERE id = $1",
            row["id"], final_path,
        )
    except Exception:
        try:
            os.remove(final_path)
        except OSError:
            pass
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
    if row["completed_at"]:
        raise HTTPException(status_code=409, detail="Upload já concluído.")
    try:
        os.remove(video_storage.tmp_path(company_id, str(row["id"])))
    except FileNotFoundError:
        pass
    await conn.execute("DELETE FROM public.internal_video_uploads WHERE id = $1", row["id"])
    return Response(status_code=status.HTTP_204_NO_CONTENT)
