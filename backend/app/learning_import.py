"""Leitura do CSV exportado pela plataforma de cursos (uma linha por pessoa em cada trilha)."""
import csv
import io
from dataclasses import dataclass
from datetime import datetime

COL_EMAIL = "E-mail"
COL_CPF = "CPF"
COL_NAME = "Nome do Colaborador"
COL_GROUP = "Grupo"
COL_TRACK_ID = "Id da Trilha"
COL_TRACK = "Nome da Trilha"
COL_COURSES = "Cursos da Trilha"
COL_STARTED = "Data que Iniciou a Trilha"
COL_FINISHED = "Data que Finalizou a Trilha"
COL_PROGRESS = "Progresso na Trilha em %"
COL_SCORE = "Aproveitamento na Trilha em %"
_REQUIRED = {COL_EMAIL, COL_TRACK_ID, COL_TRACK, COL_FINISHED, COL_PROGRESS}


@dataclass
class PlatformRow:
    line: int
    email: str = ""
    cpf_digits: str = ""
    name: str = ""
    group: str = ""
    external_track_id: str = ""
    track_name: str = ""
    courses: str = ""
    started_at: datetime | None = None
    finished_at: datetime | None = None
    progress_pct: float = 0.0
    score_pct: float | None = None
    error: str | None = None


def decode(content: bytes) -> str:
    # A plataforma exporta em Windows-1252; o padrão antigo costuma vir em UTF-8.
    try:
        return content.decode("utf-8-sig")
    except UnicodeDecodeError:
        return content.decode("cp1252")


def is_platform(header: list[str]) -> bool:
    return _REQUIRED <= {h.strip() for h in header}


def _date(raw: str) -> datetime | None:
    raw = raw.strip()
    if not raw:
        return None
    for fmt in ("%Y-%m-%d %H:%M:%S", "%Y-%m-%d %H:%M", "%Y-%m-%d", "%d/%m/%Y %H:%M:%S", "%d/%m/%Y %H:%M", "%d/%m/%Y"):
        try:
            return datetime.strptime(raw, fmt)
        except ValueError:
            continue
    raise ValueError(f"data inválida '{raw}'")


def _pct(raw: str) -> float | None:
    raw = raw.strip().replace("%", "").replace(",", ".")
    if not raw:
        return None
    value = float(raw)
    if not 0 <= value <= 100:
        raise ValueError(f"percentual fora de 0 a 100 '{raw}'")
    return value


def parse_platform(text: str) -> list[PlatformRow]:
    reader = csv.DictReader(io.StringIO(text), delimiter=";")
    rows = []
    for line, raw in enumerate(reader, start=2):
        get = lambda col: (raw.get(col) or "").strip()  # noqa: E731
        row = PlatformRow(
            line=line,
            email=get(COL_EMAIL).lower(),
            cpf_digits="".join(ch for ch in get(COL_CPF) if ch.isdigit()),
            name=get(COL_NAME),
            group=get(COL_GROUP),
            external_track_id=get(COL_TRACK_ID),
            track_name=get(COL_TRACK),
            # Nome de curso pode ter vírgula; não dá para separar a lista com segurança.
            courses=get(COL_COURSES),
        )
        try:
            if not row.external_track_id or not row.track_name:
                raise ValueError("trilha sem identificação")
            row.started_at = _date(get(COL_STARTED))
            row.finished_at = _date(get(COL_FINISHED))
            row.progress_pct = _pct(get(COL_PROGRESS)) or 0.0
            row.score_pct = _pct(get(COL_SCORE))
        except ValueError as e:
            row.error = str(e)
        rows.append(row)
    return rows
