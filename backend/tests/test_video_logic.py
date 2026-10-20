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


def test_report_after_10s_allows_elapsed_times_1_1_plus_slack():
    # limite = max + min(elapsed,30)*1.1 + min(5, elapsed)
    d = evaluate_progress(100, T0, T0 + timedelta(seconds=10), 116, 600)
    assert d.accepted and d.new_max_s == 116
    assert not evaluate_progress(100, T0, T0 + timedelta(seconds=10), 116.5, 600).accepted


def test_elapsed_capped_at_30s():
    # parado 10 min: limite = 100 + 30*1.1 + 5 = 138
    assert evaluate_progress(100, T0, T0 + timedelta(minutes=10), 138, 600).accepted
    assert not evaluate_progress(100, T0, T0 + timedelta(minutes=10), 139, 600).accepted


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
