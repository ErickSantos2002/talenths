import math
from dataclasses import dataclass
from datetime import datetime, timedelta
from typing import Literal

MAX_FILE_SIZE = 2 * 1024**3
PART_SIZE = 16 * 1024**2
COMPLETION_TOLERANCE_S = 2.0
MIN_DURATION_S = 3.0

_FIRST_REPORT_SLACK_S = 15.0
_MAX_ELAPSED_S = 30.0
_PLAYBACK_RATE = 1.1
_REPORT_SLACK_S = 5.0

# Alinhada a docshs/backend/app/services/video_formato.py. QuickTime ("qt  ") fica de fora.
_MP4_BRANDS = frozenset({
    b"isom", b"iso2", b"iso3", b"iso4", b"iso5", b"iso6", b"iso7", b"iso8", b"iso9",
    b"mp41", b"mp42", b"avc1", b"M4V ", b"M4VH", b"M4VP", b"dash", b"mmp4", b"MSNV", b"f4v ",
})


@dataclass(frozen=True)
class ProgressDecision:
    accepted: bool
    new_max_s: float
    completed: bool


def is_completed(max_watched_s: float, duration_s: float) -> bool:
    return max_watched_s >= duration_s - COMPLETION_TOLERANCE_S


def evaluate_progress(
    max_watched_s: float,
    last_report_at: datetime | None,
    now: datetime,
    position_s: float,
    duration_s: float,
) -> ProgressDecision:
    """Aceita o relato só se o avanço cabe no tempo real decorrido (anti-pulo)."""
    if not all(math.isfinite(v) for v in (position_s, max_watched_s, duration_s)):
        # NaN/inf escapariam das comparações abaixo e envenenariam o máximo salvo.
        safe_max = max_watched_s if math.isfinite(max_watched_s) else 0.0
        return ProgressDecision(False, safe_max, False)
    position = min(max(position_s, 0.0), duration_s)
    if position <= max_watched_s:
        # Voltar o vídeo é legítimo e nunca reduz o máximo já assistido.
        return ProgressDecision(True, max_watched_s, is_completed(max_watched_s, duration_s))

    if last_report_at is None:
        limit = max_watched_s + _FIRST_REPORT_SLACK_S
    else:
        elapsed = max((now - last_report_at).total_seconds(), 0.0)
        limit = (
            max_watched_s
            + min(elapsed, _MAX_ELAPSED_S) * _PLAYBACK_RATE
            + min(_REPORT_SLACK_S, elapsed)
        )

    if position > limit:
        return ProgressDecision(False, max_watched_s, is_completed(max_watched_s, duration_s))
    return ProgressDecision(True, position, is_completed(position, duration_s))


def due_at(assigned_at: datetime, due_days: int | None) -> datetime | None:
    if due_days is None:
        return None
    return assigned_at + timedelta(days=due_days)


def viewer_status(
    completed_at: datetime | None,
    max_watched_s: float,
    assigned_at: datetime,
    due_days: int | None,
    now: datetime,
) -> Literal["concluido", "atrasado", "em_andamento", "pendente"]:
    if completed_at is not None:
        return "concluido"
    due = due_at(assigned_at, due_days)
    if due is not None and now > due:
        return "atrasado"
    if max_watched_s > 0:
        return "em_andamento"
    return "pendente"


def is_mp4_header(head: bytes) -> bool:
    """`head` = primeiros 4096 bytes do arquivo. Confere a marca principal do `ftyp`."""
    return len(head) >= 12 and head[4:8] == b"ftyp" and head[8:12] in _MP4_BRANDS


def read_mp4_duration(path: str) -> float | None:
    try:
        from mutagen.mp4 import MP4
        return float(MP4(path).info.length)
    except Exception:
        return None


def validate_duration(duration: float | None) -> float:
    if duration is None or not math.isfinite(duration) or duration < MIN_DURATION_S:
        raise ValueError("Não foi possível ler a duração do vídeo. Envie um MP4 válido.")
    return duration
