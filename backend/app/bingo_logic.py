import secrets
from collections import defaultdict


def column_ranges(number_pool: int) -> list[tuple[int, int]]:
    per = number_pool // 10
    return [(c * per + 1, c * per + per) for c in range(10)]


def generate_one_card(number_pool: int) -> dict:
    """Uma cartela: 2 números por coluna (1 linha vazia). Retorna numbers[20] e layout 3x10."""
    grid: list[list[int | None]] = [[None] * 10 for _ in range(3)]
    for col, (lo, hi) in enumerate(column_ranges(number_pool)):
        pool = list(range(lo, hi + 1))
        a = pool.pop(secrets.randbelow(len(pool)))
        b = pool.pop(secrets.randbelow(len(pool)))
        low, high = sorted((a, b))
        empty_row = secrets.randbelow(3)
        rows = [r for r in range(3) if r != empty_row]
        grid[rows[0]][col] = low
        grid[rows[1]][col] = high
    numbers = sorted(v for row in grid for v in row if v is not None)
    return {"numbers": numbers, "layout": grid}


def generate_unique_cards(number_pool: int, count: int, max_attempts_per_card: int = 500) -> list[dict]:
    """Gera `count` cartelas com conjuntos de números distintos entre si."""
    seen: set[tuple[int, ...]] = set()
    cards: list[dict] = []
    for _ in range(count):
        for _attempt in range(max_attempts_per_card):
            card = generate_one_card(number_pool)
            key = tuple(card["numbers"])
            if key not in seen:
                seen.add(key)
                cards.append(card)
                break
        else:
            raise ValueError(
                "Monte de números pequeno demais para gerar cartelas únicas para todos os participantes."
            )
    return cards


def missing_count(card_numbers, drawn: set) -> int:
    return sum(1 for n in card_numbers if n not in drawn)


def is_complete(card_numbers, drawn: set) -> bool:
    return all(n in drawn for n in card_numbers)


def rank_tiebreak(card_ids: list, roll_fn):
    """Ordena card_ids do melhor p/ pior por rolagem d20 (maior vence).
    Re-rola apenas entre empatados. Retorna (ordenados, registros)."""
    records: list[dict] = []

    def resolve(group: list, rnd: int) -> list:
        rolls = {cid: roll_fn() for cid in group}
        for cid, r in rolls.items():
            records.append({"card_id": cid, "round": rnd, "roll": r})
        buckets = defaultdict(list)
        for cid, r in rolls.items():
            buckets[r].append(cid)
        ordered: list = []
        for val in sorted(buckets.keys(), reverse=True):
            tied = buckets[val]
            ordered.extend([tied[0]] if len(tied) == 1 else resolve(tied, rnd + 1))
        return ordered

    return resolve(list(card_ids), 1), records


def roll_d20() -> int:
    return secrets.randbelow(20) + 1
