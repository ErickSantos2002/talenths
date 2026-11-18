from datetime import date

import pytest

from app.evaluation_rules import (
    BEHAVIOR_KEYS, compose_scores, effective_status, nine_box, validate_stage_dates,
)


def _cycle(**kw):
    base = {"status": "draft", "stage_by_dates": True,
            "eval_start": date(2026, 11, 10), "eval_end": date(2026, 11, 20),
            "calibration_start": date(2026, 11, 25), "calibration_end": date(2026, 11, 30),
            "feedback_start": None, "feedback_end": None, "pdi_start": None, "pdi_end": None}
    base.update(kw)
    return base


@pytest.mark.parametrize("today,expected", [
    (date(2026, 11, 9), "draft"),
    (date(2026, 11, 10), "evaluation"),
    (date(2026, 11, 20), "evaluation"),
    (date(2026, 11, 22), "calibration"),  # intervalo: a avaliação já fechou
    (date(2026, 11, 30), "calibration"),
    (date(2026, 12, 1), "closed"),
])
def test_effective_status_follows_dates(today, expected):
    assert effective_status(_cycle(), today) == expected


def test_manual_stage_ignores_dates():
    assert effective_status(_cycle(stage_by_dates=False, status="feedback"), date(2026, 11, 12)) == "feedback"


def test_stage_by_dates_without_dates_keeps_stored_status():
    c = _cycle(eval_start=None, eval_end=None, calibration_start=None, calibration_end=None, status="evaluation")
    assert effective_status(c, date(2026, 11, 12)) == "evaluation"


@pytest.mark.parametrize("changes,fragment", [
    ({"eval_end": None}, "início e o fim de Avaliação"),
    ({"eval_end": date(2026, 11, 1)}, "não pode ser antes"),
    ({"calibration_start": date(2026, 11, 20)}, "Calibragem precisa começar depois"),
])
def test_validate_stage_dates_errors(changes, fragment):
    assert fragment in validate_stage_dates(_cycle(**changes))


def test_validate_stage_dates_ok():
    assert validate_stage_dates(_cycle()) is None


def _all(score):
    return {k: score for k in BEHAVIOR_KEYS}


def test_compose_is_weighted_average_90_10():
    out = compose_scores(_all(4), _all(5))
    assert out["final"] == pytest.approx(4.1)
    assert out["manager"] == 4 and out["self"] == 5


def test_compose_without_self_uses_manager_only():
    out = compose_scores(_all(3), None)
    assert out["final"] == 3 and out["self"] is None


def test_compose_without_manager_has_no_score():
    assert compose_scores(None, _all(5)) is None


def test_pillar_weights_40_30_30():
    scores = _all(5)
    scores.update(cultura_visivel=1, cultura_genuino=1)
    assert compose_scores(scores, None)["final"] == pytest.approx(0.4 * 1 + 0.6 * 5)


@pytest.mark.parametrize("score,pct,quadrant", [
    (2.9, 90, "Insuficiente"), (3.0, 91, "Essenciais"), (4.5, 105, "Essenciais"),
    (4.6, 106, "Super Talento"), (4.7, 50, "Alta Competência"),
])
def test_nine_box_bands(score, pct, quadrant):
    assert nine_box(score, pct)[2] == quadrant
