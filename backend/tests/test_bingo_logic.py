import pytest
from app.bingo_logic import (
    column_ranges, generate_one_card, generate_unique_cards,
    missing_count, is_complete, rank_tiebreak,
)


def test_column_ranges_30():
    assert column_ranges(30) == [(1, 3), (4, 6), (7, 9), (10, 12), (13, 15), (16, 18), (19, 21), (22, 24), (25, 27), (28, 30)]


def test_column_ranges_90():
    r = column_ranges(90)
    assert r[0] == (1, 9) and r[9] == (82, 90) and len(r) == 10


def test_generate_one_card_shape():
    card = generate_one_card(30)
    assert len(card['numbers']) == 20
    assert len(set(card['numbers'])) == 20                 # sem repetição
    assert card['numbers'] == sorted(card['numbers'])
    flat = [c for row in card['layout'] for c in row]
    assert len(flat) == 30
    assert sum(1 for c in flat if c is not None) == 20
    assert sum(1 for c in flat if c is None) == 10
    for col, (lo, hi) in enumerate(column_ranges(30)):
        colvals = [card['layout'][r][col] for r in range(3)]
        filled = [v for v in colvals if v is not None]
        assert len(filled) == 2
        assert all(lo <= v <= hi for v in filled)
    assert card['numbers'] == sorted(v for v in flat if v is not None)


def test_generate_unique_cards_all_distinct():
    cards = generate_unique_cards(30, 50)
    keys = [tuple(c['numbers']) for c in cards]
    assert len(keys) == 50
    assert len(set(keys)) == 50


def test_generate_unique_cards_raises_when_impossible():
    with pytest.raises(ValueError):
        generate_unique_cards(30, 60000)


def test_missing_and_complete():
    nums = list(range(1, 21))
    assert missing_count(nums, set(range(1, 19))) == 2
    assert not is_complete(nums, set(range(1, 19)))
    assert is_complete(nums, set(range(1, 21)))
    assert missing_count(nums, set(range(1, 21))) == 0


def test_rank_tiebreak_orders_desc():
    seq = iter([14, 8])
    ordered, records = rank_tiebreak(["ana", "bruno"], lambda: next(seq))
    assert ordered == ["ana", "bruno"]
    assert {r['card_id']: r['roll'] for r in records if r['round'] == 1} == {"ana": 14, "bruno": 8}


def test_rank_tiebreak_rerolls_on_equal():
    seq = iter([10, 10, 5, 12])
    ordered, records = rank_tiebreak(["a", "b"], lambda: next(seq))
    assert ordered == ["b", "a"]
    assert max(r['round'] for r in records) == 2
