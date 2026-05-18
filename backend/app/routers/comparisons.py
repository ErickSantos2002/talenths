from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from typing import Optional
import asyncpg
import json

from app.dependencies import get_db, get_current_user_id

router = APIRouter(prefix="/comparisons", tags=["comparisons"])


class ComparisonCreate(BaseModel):
    user1_id: str
    user2_id: str
    comparison_type: str = "peer_to_peer"


@router.get("")
async def list_comparisons(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    rows = await conn.fetch(
        """
        SELECT * FROM public.profile_comparisons
        WHERE user1_id = $1 OR user2_id = $1
        ORDER BY created_at DESC
        """,
        user_id,
    )
    return [dict(r) for r in rows]


@router.post("", status_code=status.HTTP_201_CREATED)
async def create_comparison(
    body: ComparisonCreate,
    conn: asyncpg.Connection = Depends(get_db),
):
    r1 = await conn.fetchrow(
        "SELECT disc_natural, big_five FROM public.test_results WHERE user_id = $1 ORDER BY completed_at DESC LIMIT 1",
        body.user1_id,
    )
    r2 = await conn.fetchrow(
        "SELECT disc_natural, big_five FROM public.test_results WHERE user_id = $1 ORDER BY completed_at DESC LIMIT 1",
        body.user2_id,
    )

    if not r1 or not r2:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Ambos os usuários precisam ter resultados de teste",
        )

    score = _calculate_compatibility(r1, r2)

    row = await conn.fetchrow(
        """
        INSERT INTO public.profile_comparisons (user1_id, user2_id, compatibility_score, comparison_type)
        VALUES ($1, $2, $3, $4) RETURNING *
        """,
        body.user1_id, body.user2_id, score, body.comparison_type,
    )
    return dict(row)


@router.delete("/{comparison_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_comparison(comparison_id: str, conn: asyncpg.Connection = Depends(get_db)):
    result = await conn.execute(
        "DELETE FROM public.profile_comparisons WHERE id = $1", comparison_id
    )
    if result == "DELETE 0":
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Comparação não encontrada")


def _calculate_compatibility(r1, r2) -> int:
    disc1 = r1["disc_natural"] if isinstance(r1["disc_natural"], dict) else json.loads(r1["disc_natural"])
    disc2 = r2["disc_natural"] if isinstance(r2["disc_natural"], dict) else json.loads(r2["disc_natural"])

    total_diff = sum(abs(disc1.get(k, 0) - disc2.get(k, 0)) for k in ["D", "I", "S", "C"])
    max_diff = 4 * 36  # máximo teórico por dimensão × 4 dimensões
    score = max(0, 100 - int((total_diff / max_diff) * 100))
    return score
