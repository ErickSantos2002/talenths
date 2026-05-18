from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from typing import Optional
import asyncpg
import json

from app.dependencies import get_db, get_db_public, get_current_user_id

router = APIRouter(prefix="/tests", tags=["tests"])


class TestResponse(BaseModel):
    block_number: int
    most_option: str
    least_option: str


class SubmitResponsesRequest(BaseModel):
    responses: list[TestResponse]


# ── Cenários ──────────────────────────────────────────────────────────────────

@router.get("/scenarios")
async def list_scenarios(conn: asyncpg.Connection = Depends(get_db_public)):
    rows = await conn.fetch(
        """
        SELECT id, block_number, scenario, option_a, option_b, option_c, option_d
        FROM public.scenario_blocks
        ORDER BY block_number
        """
    )
    return [dict(r) for r in rows]


# ── Respostas ─────────────────────────────────────────────────────────────────

@router.post("/responses", status_code=status.HTTP_201_CREATED)
async def submit_responses(
    body: SubmitResponsesRequest,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    async with conn.transaction():
        await conn.execute(
            "DELETE FROM public.test_responses WHERE user_id = $1", user_id
        )
        await conn.executemany(
            """
            INSERT INTO public.test_responses (user_id, block_number, most_option, least_option)
            VALUES ($1, $2, $3, $4)
            """,
            [(user_id, r.block_number, r.most_option, r.least_option) for r in body.responses],
        )
    return {"message": "Respostas salvas com sucesso"}


# ── Cálculo de resultados ─────────────────────────────────────────────────────

@router.post("/calculate")
async def calculate_results(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    responses = await conn.fetch(
        "SELECT * FROM public.test_responses WHERE user_id = $1 ORDER BY block_number",
        user_id,
    )
    if not responses:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Nenhuma resposta encontrada")

    blocks = await conn.fetch(
        "SELECT * FROM public.scenario_blocks ORDER BY block_number"
    )
    blocks_map = {b["block_number"]: b for b in blocks}

    disc_natural = {"D": 0, "I": 0, "S": 0, "C": 0}
    disc_adapted = {"D": 0, "I": 0, "S": 0, "C": 0}
    ocean = {"O": 0, "C": 0, "E": 0, "A": 0, "N": 0}

    for resp in responses:
        block = blocks_map.get(resp["block_number"])
        if not block:
            continue

        most = resp["most_option"].lower()
        least = resp["least_option"].lower()

        most_weights = json.loads(block[f"weights_{most}"]) if isinstance(block[f"weights_{most}"], str) else block[f"weights_{most}"]
        least_weights = json.loads(block[f"weights_{least}"]) if isinstance(block[f"weights_{least}"], str) else block[f"weights_{least}"]
        most_ocean = json.loads(block[f"ocean_weights_{most}"]) if isinstance(block[f"ocean_weights_{most}"], str) else block[f"ocean_weights_{most}"]

        for k in disc_natural:
            disc_natural[k] += most_weights.get(k, 0)
        for k in disc_adapted:
            disc_adapted[k] += most_weights.get(k, 0) - least_weights.get(k, 0)
        for k in ocean:
            ocean[k] += most_ocean.get(k, 0)

    # IEM simples: média dos traços positivos OCEAN
    iem = int((ocean.get("C", 0) + ocean.get("A", 0) + (10 - ocean.get("N", 0))) / 3)

    existing = await conn.fetchrow(
        "SELECT id FROM public.test_results WHERE user_id = $1 ORDER BY completed_at DESC LIMIT 1",
        user_id,
    )

    if existing:
        row = await conn.fetchrow(
            """
            UPDATE public.test_results
            SET disc_natural = $2, disc_adapted = $3, big_five = $4, iem = $5, completed_at = now()
            WHERE id = $1 RETURNING *
            """,
            existing["id"],
            json.dumps(disc_natural),
            json.dumps(disc_adapted),
            json.dumps(ocean),
            iem,
        )
    else:
        row = await conn.fetchrow(
            """
            INSERT INTO public.test_results (user_id, disc_natural, disc_adapted, big_five, iem)
            VALUES ($1, $2, $3, $4, $5) RETURNING *
            """,
            user_id,
            json.dumps(disc_natural),
            json.dumps(disc_adapted),
            json.dumps(ocean),
            iem,
        )

    return dict(row)


# ── Resultados ────────────────────────────────────────────────────────────────

@router.get("/results")
async def list_results(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    rows = await conn.fetch(
        "SELECT * FROM public.test_results WHERE user_id = $1 ORDER BY completed_at DESC",
        user_id,
    )
    return [dict(r) for r in rows]


@router.get("/results/shared/{share_token}")
async def get_shared_result(share_token: str, conn: asyncpg.Connection = Depends(get_db_public)):
    row = await conn.fetchrow(
        "SELECT * FROM public.test_results WHERE share_token = $1", share_token
    )
    if not row:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Resultado não encontrado")
    return dict(row)


@router.get("/results/{result_id}")
async def get_result(result_id: str, conn: asyncpg.Connection = Depends(get_db)):
    row = await conn.fetchrow(
        "SELECT * FROM public.test_results WHERE id = $1", result_id
    )
    if not row:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Resultado não encontrado")
    return dict(row)


@router.delete("/results/{result_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_result(result_id: str, conn: asyncpg.Connection = Depends(get_db)):
    result = await conn.execute(
        "DELETE FROM public.test_results WHERE id = $1", result_id
    )
    if result == "DELETE 0":
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Resultado não encontrado")


@router.post("/results/{result_id}/reprocess")
async def reprocess_result(
    result_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    result = await conn.fetchrow(
        "SELECT user_id FROM public.test_results WHERE id = $1", result_id
    )
    if not result:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Resultado não encontrado")

    # Reprocessa usando as respostas salvas do usuário do resultado
    target_user_id = str(result["user_id"])
    responses = await conn.fetch(
        "SELECT * FROM public.test_responses WHERE user_id = $1 ORDER BY block_number",
        target_user_id,
    )
    if not responses:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Sem respostas para reprocessar")

    blocks = await conn.fetch("SELECT * FROM public.scenario_blocks ORDER BY block_number")
    blocks_map = {b["block_number"]: b for b in blocks}

    disc_natural = {"D": 0, "I": 0, "S": 0, "C": 0}
    disc_adapted = {"D": 0, "I": 0, "S": 0, "C": 0}
    ocean = {"O": 0, "C": 0, "E": 0, "A": 0, "N": 0}

    for resp in responses:
        block = blocks_map.get(resp["block_number"])
        if not block:
            continue
        most = resp["most_option"].lower()
        least = resp["least_option"].lower()
        mw = block[f"weights_{most}"]
        lw = block[f"weights_{least}"]
        mo = block[f"ocean_weights_{most}"]
        mw = json.loads(mw) if isinstance(mw, str) else mw
        lw = json.loads(lw) if isinstance(lw, str) else lw
        mo = json.loads(mo) if isinstance(mo, str) else mo

        for k in disc_natural:
            disc_natural[k] += mw.get(k, 0)
        for k in disc_adapted:
            disc_adapted[k] += mw.get(k, 0) - lw.get(k, 0)
        for k in ocean:
            ocean[k] += mo.get(k, 0)

    iem = int((ocean.get("C", 0) + ocean.get("A", 0) + (10 - ocean.get("N", 0))) / 3)

    row = await conn.fetchrow(
        """
        UPDATE public.test_results
        SET disc_natural = $2, disc_adapted = $3, big_five = $4, iem = $5, completed_at = now()
        WHERE id = $1 RETURNING *
        """,
        result_id,
        json.dumps(disc_natural),
        json.dumps(disc_adapted),
        json.dumps(ocean),
        iem,
    )
    return dict(row)
