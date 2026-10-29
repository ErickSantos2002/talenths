import os
from datetime import datetime

from app.learning_import import decode, is_platform, parse_platform

FIXTURE = os.path.join(os.path.dirname(__file__), "fixtures", "trilha-plataforma.csv")
HEADER = (
    "Id do Colaborador;Matrícula Interna;Nome do Colaborador;CPF;Cargo;E-mail;Celular;Grupo;Id da Trilha;"
    "Nome da Trilha;Cursos da Trilha;Data que Iniciou a Trilha;Data que Finalizou a Trilha;"
    "Progresso na Trilha em %;Aproveitamento na Trilha em %"
)


def fixture_bytes() -> bytes:
    with open(FIXTURE, "rb") as f:
        return f.read()


def test_decode_latin1_and_utf8_bom_give_same_text():
    latin = decode(fixture_bytes())
    utf8 = decode(b"\xef\xbb\xbf" + latin.encode("utf-8"))
    assert latin == utf8
    assert "Redação Publicitária" in latin


def test_is_platform():
    assert is_platform(HEADER.split(";"))
    assert not is_platform(["email", "titulo", "area", "horas", "data"])


def test_parse_real_layout():
    rows = parse_platform(decode(fixture_bytes()))
    assert [r.line for r in rows] == [2, 3]
    ana, bruno = rows
    assert (ana.email, ana.cpf_digits, ana.name, ana.group) == ("ana@exemplo.com.br", "00000000191", "Ana Exemplo", "MARKETING")
    assert (ana.external_track_id, ana.track_name) == ("14427", "MARKETING")
    # Nomes de curso podem ter vírgula: o texto fica como a plataforma mandou.
    assert ana.courses == (
        "ChatGPT Marketing: Crie Campanhas com ChatGPT, Copywriting e Redação Publicitária, Fotografia e Vídeo com Celular"
    )
    assert ana.started_at == datetime(2026, 7, 9, 10, 8, 41)
    assert (ana.finished_at, ana.progress_pct, ana.score_pct, ana.error) == (None, 6.0, 100.0, None)
    assert bruno.finished_at == datetime(2026, 8, 20, 17, 30)
    assert bruno.progress_pct == 100.0


def _one(line: str):
    [row] = parse_platform(HEADER + "\r\n" + line + "\r\n")
    return row


def test_decimal_comma_and_empty_numbers():
    row = _one("1;;X;;;x@e.com;;G;9;T;A;2026-01-01 08:00:00;;6,5;")
    assert (row.progress_pct, row.score_pct, row.error) == (6.5, None, None)
    row = _one("1;;X;;;x@e.com;;G;9;T;A;2026-01-01 08:00:00;;;")
    assert row.progress_pct == 0.0


def test_invalid_date_becomes_line_error():
    row = _one("1;;X;;;x@e.com;;G;9;T;A;ontem;;10;")
    assert row.error is not None and "data" in row.error.lower()


def test_missing_track_id_is_error():
    row = _one("1;;X;;;x@e.com;;G;;T;A;2026-01-01 08:00:00;;10;")
    assert row.error is not None
