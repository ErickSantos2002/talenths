from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
import asyncpg
import secrets
import json

from app.dependencies import get_db, get_current_user_id, require_manager
from app import bingo_logic

router = APIRouter(prefix="/bingo", tags=["bingo"])

VALID_POOLS = {30, 60, 90}


async def _get_company_id(user_id: str, conn: asyncpg.Connection) -> str:
    row = await conn.fetchrow("SELECT company_id FROM public.profiles WHERE id = $1", user_id)
    if not row or not row["company_id"]:
        raise HTTPException(status_code=400, detail="Usuário sem empresa")
    return str(row["company_id"])


def _serialize_game(row) -> dict:
    d = dict(row)
    for k in ("id", "company_id", "created_by"):
        if d.get(k) is not None:
            d[k] = str(d[k])
    for k in ("created_at", "started_at", "finished_at"):
        if d.get(k):
            d[k] = d[k].isoformat()
    d.pop("pending_tiebreak", None)
    return d


def _serialize_card(row) -> dict:
    d = dict(row)
    for k in ("id", "game_id", "company_id", "user_id"):
        if d.get(k) is not None:
            d[k] = str(d[k])
    if d.get("created_at"):
        d["created_at"] = d["created_at"].isoformat()
    d["numbers"] = list(d.get("numbers") or [])
    layout = d.get("layout")
    if isinstance(layout, str):
        d["layout"] = json.loads(layout)
    return d


def _new_code(used: set) -> str:
    while True:
        c = "".join(secrets.choice("0123456789ABCDEF") for _ in range(4))
        if c not in used:
            used.add(c)
            return c


def _serialize_winner(w) -> dict:
    return {
        "id": str(w["id"]), "card_id": str(w["card_id"]), "user_id": str(w["user_id"]),
        "user_name": w["user_name"], "code": w["code"], "place": w["place"],
        "won_on_draw": w["won_on_draw"], "by_tiebreak": w["by_tiebreak"],
        "won_at": w["won_at"].isoformat() if w["won_at"] else None,
    }


class GameCreate(BaseModel):
    name: str
    number_pool: int
    winners_target: int
    near_threshold: int = 2
    participant_user_ids: list[str]


@router.post("/games", status_code=status.HTTP_201_CREATED)
async def create_game(body: GameCreate, user_id: str = Depends(get_current_user_id),
                      conn: asyncpg.Connection = Depends(get_db)):
    await require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)

    if body.number_pool not in VALID_POOLS:
        raise HTTPException(status_code=400, detail="Monte inválido (use 30, 60 ou 90)")
    parts = list(dict.fromkeys(body.participant_user_ids))
    if not parts:
        raise HTTPException(status_code=400, detail="Selecione ao menos um participante")
    if body.winners_target < 1 or body.winners_target > len(parts):
        raise HTTPException(status_code=400, detail="Nº de ganhadores deve ser entre 1 e o total de participantes")
    if body.near_threshold not in (1, 2):
        raise HTTPException(status_code=400, detail="Aviso 'quase lá' deve ser 1 ou 2")

    if not body.name.strip():
        raise HTTPException(status_code=400, detail="Informe o nome do jogo")

    try:
        cards = bingo_logic.generate_unique_cards(body.number_pool, len(parts))
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

    async with conn.transaction():
        game = await conn.fetchrow(
            """INSERT INTO public.bingo_games
               (company_id, name, number_pool, winners_target, near_threshold, status, created_by)
               VALUES ($1,$2,$3,$4,$5,'draft',$6) RETURNING *""",
            company_id, body.name.strip(), body.number_pool, body.winners_target, body.near_threshold, user_id,
        )
        used_codes: set = set()
        for uid, card in zip(parts, cards):
            await conn.execute(
                """INSERT INTO public.bingo_cards (game_id, company_id, user_id, code, numbers, layout)
                   VALUES ($1,$2,$3,$4,$5,$6)""",
                game["id"], company_id, uid, _new_code(used_codes), card["numbers"], json.dumps(card["layout"]),
            )
    return _serialize_game(game)


@router.get("/games")
async def list_games(user_id: str = Depends(get_current_user_id), conn: asyncpg.Connection = Depends(get_db)):
    await require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    rows = await conn.fetch(
        """SELECT g.*,
                  (SELECT count(*) FROM public.bingo_cards c WHERE c.game_id = g.id) AS participants,
                  (SELECT count(*) FROM public.bingo_draws d WHERE d.game_id = g.id) AS draws,
                  (SELECT count(*) FROM public.bingo_winners w WHERE w.game_id = g.id) AS winners
           FROM public.bingo_games g WHERE g.company_id = $1 ORDER BY g.created_at DESC""",
        company_id,
    )
    return [_serialize_game(r) for r in rows]


@router.get("/games/{game_id}")
async def get_game(game_id: str, user_id: str = Depends(get_current_user_id),
                   conn: asyncpg.Connection = Depends(get_db)):
    await require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    game = await conn.fetchrow(
        "SELECT * FROM public.bingo_games WHERE id = $1 AND company_id = $2", game_id, company_id)
    if not game:
        raise HTTPException(status_code=404, detail="Jogo não encontrado")

    cards = await conn.fetch(
        """SELECT c.*, p.name AS user_name
           FROM public.bingo_cards c
           LEFT JOIN public.profiles p ON p.id = c.user_id
           WHERE c.game_id = $1 ORDER BY p.name""", game_id)
    draws = await conn.fetch(
        "SELECT number, draw_order FROM public.bingo_draws WHERE game_id = $1 ORDER BY draw_order", game_id)
    winners = await conn.fetch(
        """SELECT w.*, p.name AS user_name, c.code
           FROM public.bingo_winners w
           LEFT JOIN public.profiles p ON p.id = w.user_id
           LEFT JOIN public.bingo_cards c ON c.id = w.card_id
           WHERE w.game_id = $1 ORDER BY w.place""", game_id)

    drawn = {d["number"] for d in draws}
    winner_card_ids = {str(w["card_id"]) for w in winners}
    near = []
    for c in cards:
        cid = str(c["id"])
        if cid in winner_card_ids:
            continue
        miss = bingo_logic.missing_count(list(c["numbers"]), drawn)
        if miss <= (game["near_threshold"] or 2):
            near.append({"card_id": cid, "user_name": c["user_name"], "missing": miss})
    near.sort(key=lambda x: x["missing"])

    def _ser_card(c):
        d = _serialize_card(c)
        d["user_name"] = c["user_name"]
        d["marked"] = [n for n in d["numbers"] if n in drawn]
        return d

    return {
        "game": _serialize_game(game),
        "cards": [_ser_card(c) for c in cards],
        "draws": [{"number": d["number"], "draw_order": d["draw_order"]} for d in draws],
        "winners": [_serialize_winner(w) for w in winners],
        "near": near,
    }
