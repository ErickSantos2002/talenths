from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from typing import Optional
import asyncpg

from app.dependencies import get_db, get_current_user_id, require_manager

router = APIRouter(prefix="/feedbacks", tags=["feedbacks"])


class FeedbackRequestCreate(BaseModel):
    title: str
    question: str
    target_type: str
    target_department_id: Optional[str] = None
    target_user_id: Optional[str] = None


class FeedbackRespond(BaseModel):
    rating: int
    comment: Optional[str] = None


# ── Static routes first ───────────────────────────────────────────────────────

@router.get("")
async def list_feedbacks(
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
            fr.id,
            fr.title,
            fr.question,
            fr.target_type,
            fr.target_department_id,
            fr.target_user_id,
            fr.created_at,
            p.name AS created_by_name,
            COUNT(resp.id) AS response_count,
            CASE
                WHEN fr.target_type = 'department' THEN d.name
                WHEN fr.target_type = 'individual' THEN tp.name
                ELSE NULL
            END AS target_name
        FROM public.feedback_requests fr
        LEFT JOIN public.profiles p ON p.user_id = fr.created_by
        LEFT JOIN public.feedback_responses resp ON resp.feedback_request_id = fr.id
        LEFT JOIN public.departments d ON d.id = fr.target_department_id
        LEFT JOIN public.profiles tp ON tp.user_id = fr.target_user_id
        WHERE fr.company_id = $1
        GROUP BY fr.id, p.name, d.name, tp.name
        ORDER BY fr.created_at DESC
        """,
        profile["company_id"],
    )
    return [dict(r) for r in rows]


@router.post("", status_code=status.HTTP_201_CREATED)
async def create_feedback(
    body: FeedbackRequestCreate,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)

    if body.target_type not in ("all", "department", "individual"):
        raise HTTPException(status_code=400, detail="target_type inválido")

    profile = await conn.fetchrow(
        "SELECT company_id FROM public.profiles WHERE user_id = $1", user_id
    )
    if not profile:
        raise HTTPException(status_code=404, detail="Perfil não encontrado")

    row = await conn.fetchrow(
        """
        INSERT INTO public.feedback_requests
            (company_id, created_by, title, question, target_type, target_department_id, target_user_id)
        VALUES ($1, $2, $3, $4, $5, $6, $7)
        RETURNING *
        """,
        profile["company_id"],
        user_id,
        body.title,
        body.question,
        body.target_type,
        body.target_department_id,
        body.target_user_id,
    )
    return dict(row)


@router.get("/my")
async def list_my_feedbacks(
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
            fr.id,
            fr.title,
            fr.question,
            fr.target_type,
            fr.target_department_id,
            fr.target_user_id,
            fr.created_at,
            p.name AS created_by_name,
            CASE WHEN resp.id IS NOT NULL THEN TRUE ELSE FALSE END AS has_responded,
            resp.rating AS my_rating,
            resp.comment AS my_comment
        FROM public.feedback_requests fr
        LEFT JOIN public.profiles p ON p.user_id = fr.created_by
        LEFT JOIN public.feedback_responses resp
            ON resp.feedback_request_id = fr.id AND resp.user_id = $1
        WHERE fr.company_id = $2
          AND (
            fr.target_type = 'all'
            OR (fr.target_type = 'department' AND fr.target_department_id = $3)
            OR (fr.target_type = 'individual' AND fr.target_user_id = $1)
          )
        ORDER BY fr.created_at DESC
        """,
        user_id,
        profile["company_id"],
        profile["department_id"],
    )
    return [dict(r) for r in rows]


# ── Parameterized routes last ─────────────────────────────────────────────────

@router.get("/{feedback_id}/responses")
async def get_feedback_responses(
    feedback_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)

    rows = await conn.fetch(
        """
        SELECT
            resp.id,
            resp.user_id,
            p.name AS user_name,
            resp.rating,
            resp.comment,
            resp.created_at
        FROM public.feedback_responses resp
        LEFT JOIN public.profiles p ON p.user_id = resp.user_id
        WHERE resp.feedback_request_id = $1
        ORDER BY resp.created_at DESC
        """,
        feedback_id,
    )
    return [dict(r) for r in rows]


@router.post("/{feedback_id}/respond", status_code=status.HTTP_201_CREATED)
async def respond_to_feedback(
    feedback_id: str,
    body: FeedbackRespond,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    if body.rating < 1 or body.rating > 5:
        raise HTTPException(status_code=400, detail="rating deve ser entre 1 e 5")

    row = await conn.fetchrow(
        """
        INSERT INTO public.feedback_responses (feedback_request_id, user_id, rating, comment)
        VALUES ($1, $2, $3, $4)
        ON CONFLICT (feedback_request_id, user_id)
        DO UPDATE SET rating = EXCLUDED.rating, comment = EXCLUDED.comment
        RETURNING *
        """,
        feedback_id,
        user_id,
        body.rating,
        body.comment,
    )
    return dict(row)
