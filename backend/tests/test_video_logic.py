from datetime import datetime, timedelta, timezone

import pytest
from app.video_logic import (
    evaluate_progress, is_completed, viewer_status, due_at,
    is_mp4_header, validate_duration, read_mp4_duration,
)

T0 = datetime(2026, 10, 20, 12, 0, tzinfo=timezone.utc)


def test_first_report_allows_15s_slack():
    d = evaluate_progress(0, None, T0, 15, 600)
    assert d.accepted and d.new_max_s == 15
    assert not evaluate_progress(0, None, T0, 16, 600).accepted


def test_report_after_10s_allows_elapsed_plus_2_times_1_1():
    # limite = max + min(elapsed + 2, 30) * 1.1 = 100 + 12 * 1.1
    d = evaluate_progress(100, T0, T0 + timedelta(seconds=10), 113.2, 600)
    assert d.accepted and d.new_max_s == 113.2 and d.records_report
    assert not evaluate_progress(100, T0, T0 + timedelta(seconds=10), 113.3, 600).accepted


def test_elapsed_capped_at_30s():
    # parado 10 min: limite = 100 + 30 * 1.1 = 133
    assert evaluate_progress(100, T0, T0 + timedelta(minutes=10), 133, 600).accepted
    assert not evaluate_progress(100, T0, T0 + timedelta(minutes=10), 133.5, 600).accepted


def test_report_under_5s_that_advances_is_noop():
    d = evaluate_progress(100, T0, T0 + timedelta(seconds=4.9), 103, 600)
    assert d.accepted and d.new_max_s == 100 and not d.completed
    assert not d.records_report


def test_end_of_video_report_3s_after_tick_completes():
    # O vídeo acaba 3 s depois do último tick: o flush do ended precisa concluir,
    # senão nenhum relato posterior acontece (player parado).
    d = evaluate_progress(597, T0, T0 + timedelta(seconds=3), 600, 600)
    assert d.accepted and d.new_max_s == 600 and d.completed and d.records_report


def test_completion_under_5s_still_bounded_by_elapsed():
    # limite = 500 + 5 * 1.1 = 505.5: pular até o fim continua sem efeito.
    d = evaluate_progress(500, T0, T0 + timedelta(seconds=3), 600, 600)
    assert d.accepted and d.new_max_s == 500 and not d.completed
    assert not d.records_report


def test_report_at_5s_is_evaluated_normally():
    # limite = 100 + 7 * 1.1 = 107.7
    d = evaluate_progress(100, T0, T0 + timedelta(seconds=5), 107.7, 600)
    assert d.accepted and d.new_max_s == 107.7 and d.records_report
    assert not evaluate_progress(100, T0, T0 + timedelta(seconds=5), 108, 600).accepted


def test_rewind_under_5s_still_accepted():
    d = evaluate_progress(300, T0, T0 + timedelta(seconds=1), 20, 600)
    assert d.accepted and d.new_max_s == 300 and d.records_report


def _simulate(max_s, last, now, position, duration):
    d = evaluate_progress(max_s, last, now, position, duration)
    if d.accepted and d.records_report:
        return d.new_max_s, now, d.completed
    return max_s, last, d.completed


def test_greedy_1hz_reporter_capped():
    # Script que relata todo segundo a maior posição possível: o teto real é
    # (5 + 2) * 1.1 / 5 = 1.54x, longe dos ~2.1x da regra antiga.
    duration, m, last, completed_at = 600.0, 0.0, None, None
    for second in range(0, 2000):
        now = T0 + timedelta(seconds=second)
        if last is None:
            greedy = m + 15
        else:
            elapsed = (now - last).total_seconds()
            greedy = m + min(elapsed + 2, 30) * 1.1
        m, last, completed = _simulate(m, last, now, greedy, duration)
        if completed:
            completed_at = second
            break
    assert completed_at is not None
    assert completed_at >= duration / 1.6


def test_normal_10s_cadence_at_1x_completes():
    duration, m, last, completed = 600.0, 0.0, None, False
    for second in range(10, 700, 10):
        m, last, completed = _simulate(m, last, T0 + timedelta(seconds=second), float(second), duration)
        assert m == min(float(second), duration)
        if completed:
            break
    assert completed and second == 600


def test_pause_flush_under_5s_credited_on_next_report():
    m, last = 100.0, T0
    # Pausa 3 s depois do relato: o flush do pause vira no-op...
    m, last, _ = _simulate(m, last, T0 + timedelta(seconds=3), 103, 600)
    assert m == 100 and last == T0
    # ...e o próximo relato normal (retoma após 2 min, assiste mais 10 s) leva tudo.
    m, last, _ = _simulate(m, last, T0 + timedelta(seconds=133), 113, 600)
    assert m == 113 and last == T0 + timedelta(seconds=133)


def test_rewind_accepted_keeps_max():
    d = evaluate_progress(300, T0, T0 + timedelta(seconds=10), 20, 600)
    assert d.accepted and d.new_max_s == 300


def test_position_clamped_to_duration_and_completes():
    d = evaluate_progress(590, T0, T0 + timedelta(seconds=10), 605, 600)
    assert d.accepted and d.new_max_s == 600 and d.completed


def test_completion_tolerance_2s():
    assert is_completed(598, 600) and not is_completed(597.9, 600)


def test_interleaved_reports_never_regress():
    # aba A em 200, aba B em 50, alternando a cada 10 s
    m, t = 200.0, T0
    for pos in (50, 210, 60, 220):
        t += timedelta(seconds=10)
        d = evaluate_progress(m, t - timedelta(seconds=10), t, pos, 600)
        assert d.new_max_s >= m
        m = d.new_max_s if d.accepted else m
    assert m == 220


def test_evaluate_progress_rejects_non_finite():
    nan, inf = float("nan"), float("inf")
    for pos in (nan, inf):
        d = evaluate_progress(100, T0, T0 + timedelta(seconds=10), pos, 600)
        assert not d.accepted and d.new_max_s == 100 and not d.completed
    d = evaluate_progress(nan, T0, T0 + timedelta(seconds=10), 10, 600)
    assert not d.accepted and d.new_max_s == 0.0
    assert not evaluate_progress(0, None, T0, 10, nan).accepted


def test_viewer_status():
    a = T0
    assert viewer_status(T0, 0, a, 7, T0 + timedelta(days=30)) == "concluido"
    assert viewer_status(None, 0, a, 7, T0 + timedelta(days=8)) == "atrasado"
    assert viewer_status(None, 10, a, 7, T0 + timedelta(days=1)) == "em_andamento"
    assert viewer_status(None, 0, a, None, T0 + timedelta(days=400)) == "pendente"


def test_due_at():
    assert due_at(T0, 7) == T0 + timedelta(days=7)
    assert due_at(T0, None) is None


def test_is_mp4_header():
    assert is_mp4_header(b"\x00\x00\x00\x20ftypisom" + b"\x00" * 24)
    assert is_mp4_header(b"\x00\x00\x00\x18ftypmp42" + b"\x00" * 16)
    assert not is_mp4_header(b"\x00\x00\x00\x14ftypqt  " + b"\x00" * 12)   # QuickTime
    assert not is_mp4_header(b"\x1a\x45\xdf\xa3" + b"\x00" * 28)          # WebM/MKV
    assert not is_mp4_header(b"")


def test_validate_duration_rejects_tiny_or_missing():
    with pytest.raises(ValueError):
        validate_duration(None)
    with pytest.raises(ValueError):
        validate_duration(2.9)
    with pytest.raises(ValueError):
        validate_duration(float("nan"))
    with pytest.raises(ValueError):
        validate_duration(float("inf"))
    assert validate_duration(3.0) == 3.0


def test_read_mp4_duration_returns_none_on_garbage(tmp_path):
    p = tmp_path / "x.mp4"
    p.write_bytes(b"not a video")
    assert read_mp4_duration(str(p)) is None
    assert read_mp4_duration(str(tmp_path / "missing.mp4")) is None
