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
    row = await conn.fetchrow("SELECT company_id FROM public.profiles WHERE user_id = $1", user_id)
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
           LEFT JOIN public.profiles p ON p.user_id = c.user_id
           WHERE c.game_id = $1 ORDER BY p.name""", game_id)
    draws = await conn.fetch(
        "SELECT number, draw_order FROM public.bingo_draws WHERE game_id = $1 ORDER BY draw_order", game_id)
    winners = await conn.fetch(
        """SELECT w.*, p.name AS user_name, c.code
           FROM public.bingo_winners w
           LEFT JOIN public.profiles p ON p.user_id = w.user_id
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


async def _load_game_locked(game_id, company_id, conn):
    game = await conn.fetchrow(
        "SELECT * FROM public.bingo_games WHERE id=$1 AND company_id=$2 FOR UPDATE", game_id, company_id)
    if not game:
        raise HTTPException(status_code=404, detail="Jogo não encontrado")
    return game


async def _finish_if_done(game, conn) -> bool:
    won = await conn.fetchval("SELECT count(*) FROM public.bingo_winners WHERE game_id=$1", game["id"])
    drawn = await conn.fetchval("SELECT count(*) FROM public.bingo_draws WHERE game_id=$1", game["id"])
    if won >= game["winners_target"] or drawn >= game["number_pool"]:
        await conn.execute(
            "UPDATE public.bingo_games SET status='finished', finished_at=now() WHERE id=$1", game["id"])
        return True
    return False


@router.post("/games/{game_id}/start")
async def start_game(game_id: str, user_id: str = Depends(get_current_user_id),
                     conn: asyncpg.Connection = Depends(get_db)):
    await require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    async with conn.transaction():
        game = await _load_game_locked(game_id, company_id, conn)
        if game["status"] != "draft":
            raise HTTPException(status_code=400, detail="O jogo já foi iniciado")
        await conn.execute(
            "UPDATE public.bingo_games SET status='running', started_at=now() WHERE id=$1", game_id)
    return {"ok": True}


@router.post("/games/{game_id}/draw")
async def draw_number(game_id: str, user_id: str = Depends(get_current_user_id),
                      conn: asyncpg.Connection = Depends(get_db)):
    await require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    async with conn.transaction():
        game = await _load_game_locked(game_id, company_id, conn)
        if game["status"] != "running":
            raise HTTPException(status_code=400, detail="O jogo não está em andamento")
        if game["pending_tiebreak"]:
            raise HTTPException(status_code=409, detail="Resolva o desempate antes de sortear")

        draws = await conn.fetch("SELECT number FROM public.bingo_draws WHERE game_id=$1", game_id)
        drawn = {d["number"] for d in draws}
        remaining = [n for n in range(1, game["number_pool"] + 1) if n not in drawn]
        if not remaining:
            await _finish_if_done(game, conn)
            raise HTTPException(status_code=400, detail="Não há mais números para sortear")

        pick = secrets.choice(remaining)
        await conn.execute(
            """INSERT INTO public.bingo_draws (game_id, company_id, number, draw_order, drawn_by)
               VALUES ($1,$2,$3,$4,$5)""",
            game_id, company_id, pick, len(drawn) + 1, user_id)
        new_drawn = drawn | {pick}

        cards = await conn.fetch("SELECT id, user_id, numbers FROM public.bingo_cards WHERE game_id=$1", game_id)
        winner_ids = {str(r["card_id"]) for r in
                      await conn.fetch("SELECT card_id FROM public.bingo_winners WHERE game_id=$1", game_id)}
        newly = [c for c in cards
                 if str(c["id"]) not in winner_ids
                 and pick in c["numbers"]
                 and bingo_logic.is_complete(list(c["numbers"]), new_drawn)]

        tiebreak = None
        if len(newly) == 1:
            place = len(winner_ids) + 1
            c = newly[0]
            await conn.execute(
                """INSERT INTO public.bingo_winners (game_id, company_id, card_id, user_id, place, won_on_draw)
                   VALUES ($1,$2,$3,$4,$5,$6)""",
                game_id, company_id, c["id"], c["user_id"], place, pick)
            await _finish_if_done(game, conn)
        elif len(newly) >= 2:
            tiebreak = {"card_ids": [str(c["id"]) for c in newly], "won_on_draw": pick}
            await conn.execute(
                "UPDATE public.bingo_games SET pending_tiebreak=$2 WHERE id=$1",
                game_id, json.dumps(tiebreak))
    return {"number": pick, "tiebreak": tiebreak}


@router.post("/games/{game_id}/tiebreak")
async def resolve_tiebreak(game_id: str, user_id: str = Depends(get_current_user_id),
                           conn: asyncpg.Connection = Depends(get_db)):
    await require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    async with conn.transaction():
        game = await _load_game_locked(game_id, company_id, conn)
        pending = game["pending_tiebreak"]
        if not pending:
            raise HTTPException(status_code=400, detail="Não há desempate pendente")
        pending = pending if isinstance(pending, dict) else json.loads(pending)
        card_ids = pending["card_ids"]
        won_on_draw = pending["won_on_draw"]

        ordered, records = bingo_logic.rank_tiebreak(card_ids, bingo_logic.roll_d20)
        for rec in records:
            await conn.execute(
                """INSERT INTO public.bingo_tiebreak_rolls (game_id, company_id, card_id, round, roll)
                   VALUES ($1,$2,$3,$4,$5)""",
                game_id, company_id, rec["card_id"], rec["round"], rec["roll"])

        next_place = await conn.fetchval(
            "SELECT count(*) FROM public.bingo_winners WHERE game_id=$1", game_id) + 1
        target = game["winners_target"]
        placed = []
        for cid in ordered:
            if next_place > target:
                break
            card = await conn.fetchrow("SELECT user_id FROM public.bingo_cards WHERE id=$1", cid)
            await conn.execute(
                """INSERT INTO public.bingo_winners
                   (game_id, company_id, card_id, user_id, place, won_on_draw, by_tiebreak)
                   VALUES ($1,$2,$3,$4,$5,$6,true)""",
                game_id, company_id, cid, card["user_id"], next_place, won_on_draw)
            placed.append({"card_id": cid, "place": next_place})
            next_place += 1
        await conn.execute("UPDATE public.bingo_games SET pending_tiebreak=NULL WHERE id=$1", game_id)
        await _finish_if_done(game, conn)
    return {"rolls": records, "order": ordered, "placed": placed}


@router.post("/games/{game_id}/cancel")
async def cancel_game(game_id: str, user_id: str = Depends(get_current_user_id),
                      conn: asyncpg.Connection = Depends(get_db)):
    await require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    res = await conn.execute(
        "UPDATE public.bingo_games SET status='cancelled', pending_tiebreak=NULL WHERE id=$1 AND company_id=$2",
        game_id, company_id)
    if res == "UPDATE 0":
        raise HTTPException(status_code=404, detail="Jogo não encontrado")
    return {"ok": True}


@router.delete("/games/{game_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_game(game_id: str, user_id: str = Depends(get_current_user_id),
                      conn: asyncpg.Connection = Depends(get_db)):
    await require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    game = await conn.fetchrow(
        "SELECT status FROM public.bingo_games WHERE id=$1 AND company_id=$2", game_id, company_id)
    if not game:
        raise HTTPException(status_code=404, detail="Jogo não encontrado")
    if game["status"] == "running":
        raise HTTPException(status_code=400, detail="Cancele o jogo antes de excluir")
    await conn.execute("DELETE FROM public.bingo_games WHERE id=$1 AND company_id=$2", game_id, company_id)


@router.get("/my")
async def my_games(user_id: str = Depends(get_current_user_id), conn: asyncpg.Connection = Depends(get_db)):
    rows = await conn.fetch(
        """SELECT g.id, g.name, g.status, g.number_pool, g.winners_target
           FROM public.bingo_games g
           JOIN public.bingo_cards c ON c.game_id = g.id AND c.user_id = $1
           WHERE g.status IN ('running','finished') ORDER BY g.created_at DESC""",
        user_id)
    return [{"id": str(r["id"]), "name": r["name"], "status": r["status"],
             "number_pool": r["number_pool"], "winners_target": r["winners_target"]} for r in rows]


@router.get("/my/{game_id}")
async def my_game(game_id: str, user_id: str = Depends(get_current_user_id),
                  conn: asyncpg.Connection = Depends(get_db)):
    card = await conn.fetchrow(
        "SELECT * FROM public.bingo_cards WHERE game_id=$1 AND user_id=$2", game_id, user_id)
    if not card:
        raise HTTPException(status_code=404, detail="Você não participa deste jogo")
    game = await conn.fetchrow("SELECT * FROM public.bingo_games WHERE id=$1", game_id)
    draws = await conn.fetch(
        "SELECT number, draw_order FROM public.bingo_draws WHERE game_id=$1 ORDER BY draw_order", game_id)
    drawn = {d["number"] for d in draws}
    my_win = await conn.fetchrow(
        "SELECT place FROM public.bingo_winners WHERE game_id=$1 AND card_id=$2", game_id, card["id"])
    numbers = list(card["numbers"])
    layout = card["layout"]
    if isinstance(layout, str):
        layout = json.loads(layout)
    return {
        "game": {"id": str(game["id"]), "name": game["name"], "status": game["status"],
                 "number_pool": game["number_pool"], "winners_target": game["winners_target"]},
        "card": {"code": card["code"], "numbers": numbers, "layout": layout},
        "drawn": sorted(drawn),
        "marked": [n for n in numbers if n in drawn],
        "missing": bingo_logic.missing_count(numbers, drawn),
        "my_place": my_win["place"] if my_win else None,
    }
