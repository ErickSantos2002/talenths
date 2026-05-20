from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form, status
from fastapi.responses import FileResponse
from typing import Optional
import asyncpg
import os
import uuid

from app.dependencies import get_db, get_current_user_id, require_manager

router = APIRouter(prefix="/documents", tags=["documents"])


# ── Static routes first ───────────────────────────────────────────────────────

@router.post("/upload", status_code=status.HTTP_201_CREATED)
async def upload_document(
    title: str = Form(...),
    target_type: str = Form(...),
    target_department_id: Optional[str] = Form(None),
    target_user_id: Optional[str] = Form(None),
    file: UploadFile = File(...),
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)

    if target_type not in ("general", "department", "individual"):
        raise HTTPException(status_code=400, detail="target_type inválido")

    profile = await conn.fetchrow(
        "SELECT company_id FROM public.profiles WHERE user_id = $1", user_id
    )
    if not profile:
        raise HTTPException(status_code=404, detail="Perfil não encontrado")

    company_id = profile["company_id"]
    uploads_dir = f"/app/uploads/{company_id}"
    os.makedirs(uploads_dir, exist_ok=True)

    unique_name = f"{uuid.uuid4()}_{file.filename}"
    file_path = f"{uploads_dir}/{unique_name}"

    with open(file_path, "wb") as f:
        while chunk := await file.read(1024 * 1024):
            f.write(chunk)

    file_size = os.path.getsize(file_path)

    row = await conn.fetchrow(
        """
        INSERT INTO public.documents
            (company_id, uploaded_by, title, original_name, file_path, file_size, mime_type,
             target_type, target_department_id, target_user_id)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
        RETURNING *
        """,
        company_id,
        user_id,
        title,
        file.filename,
        file_path,
        file_size,
        file.content_type or "application/octet-stream",
        target_type,
        target_department_id or None,
        target_user_id or None,
    )
    return dict(row)


@router.get("")
async def list_documents(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)

    profile = await conn.fetchrow(
        "SELECT company_id FROM public.profiles WHERE user_id = $1", user_id
    )
    if not profile:
        raise HTTPException(status_code=404, detail="Perfil não encontrado")

    rows = await conn.fetch(
        """
        SELECT
            d.id,
            d.title,
            d.original_name,
            d.file_size,
            d.mime_type,
            d.target_type,
            d.target_department_id,
            d.target_user_id,
            d.created_at,
            p.name AS uploaded_by_name,
            CASE
                WHEN d.target_type = 'department' THEN dept.name
                WHEN d.target_type = 'individual' THEN tp.name
                ELSE NULL
            END AS target_name
        FROM public.documents d
        LEFT JOIN public.profiles p ON p.user_id = d.uploaded_by
        LEFT JOIN public.departments dept ON dept.id = d.target_department_id
        LEFT JOIN public.profiles tp ON tp.user_id = d.target_user_id
        WHERE d.company_id = $1
        ORDER BY d.created_at DESC
        """,
        profile["company_id"],
    )
    return [dict(r) for r in rows]


@router.get("/my")
async def list_my_documents(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    profile = await conn.fetchrow(
        "SELECT company_id, department_id FROM public.profiles WHERE user_id = $1", user_id
    )
    if not profile:
        raise HTTPException(status_code=404, detail="Perfil não encontrado")

    rows = await conn.fetch(
        """
        SELECT
            d.id,
            d.title,
            d.original_name,
            d.file_size,
            d.mime_type,
            d.target_type,
            d.created_at,
            p.name AS uploaded_by_name
        FROM public.documents d
        LEFT JOIN public.profiles p ON p.user_id = d.uploaded_by
        WHERE d.company_id = $1
          AND (
            d.target_type = 'general'
            OR (d.target_type = 'department' AND d.target_department_id = $2)
            OR (d.target_type = 'individual' AND d.target_user_id = $3)
          )
        ORDER BY d.created_at DESC
        """,
        profile["company_id"],
        profile["department_id"],
        user_id,
    )
    return [dict(r) for r in rows]


# ── Parameterized routes last ─────────────────────────────────────────────────

@router.delete("/{document_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_document(
    document_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)

    row = await conn.fetchrow(
        "SELECT file_path FROM public.documents WHERE id = $1", document_id
    )
    if not row:
        raise HTTPException(status_code=404, detail="Documento não encontrado")

    try:
        os.remove(row["file_path"])
    except FileNotFoundError:
        pass

    await conn.execute("DELETE FROM public.documents WHERE id = $1", document_id)


@router.get("/{document_id}/download")
async def download_document(
    document_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    profile = await conn.fetchrow(
        "SELECT company_id, department_id FROM public.profiles WHERE user_id = $1", user_id
    )
    if not profile:
        raise HTTPException(status_code=404, detail="Perfil não encontrado")

    row = await conn.fetchrow(
        "SELECT * FROM public.documents WHERE id = $1", document_id
    )
    if not row:
        raise HTTPException(status_code=404, detail="Documento não encontrado")

    is_manager = await conn.fetchrow(
        "SELECT 1 FROM public.user_roles WHERE user_id = $1 AND role IN ('manager', 'master_admin')",
        user_id,
    )

    if not is_manager:
        has_access = (
            row["target_type"] == "general"
            or (row["target_type"] == "department" and row["target_department_id"] == profile["department_id"])
            or (row["target_type"] == "individual" and str(row["target_user_id"]) == user_id)
        )
        if not has_access:
            raise HTTPException(status_code=403, detail="Acesso negado")

    return FileResponse(
        path=row["file_path"],
        filename=row["original_name"],
        media_type=row["mime_type"],
    )
