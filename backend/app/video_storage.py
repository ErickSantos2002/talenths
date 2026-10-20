import os
import shutil
import uuid
from datetime import timedelta

import asyncpg

from app.config import settings
from app.video_logic import (
    MAX_FILE_SIZE,
    PART_SIZE,
    is_mp4_header,
    read_mp4_duration,
    validate_duration,
)

MIN_FREE_MARGIN = 1024**3
STALE_AFTER = timedelta(hours=24)


def video_dir(company_id: str) -> str:
    return f"{settings.UPLOADS_DIR}/{company_id}/videos"


def tmp_path(company_id: str, upload_id: str) -> str:
    return f"{video_dir(company_id)}/tmp/{upload_id}.part"


def expected_parts(total_size: int) -> int:
    return -(-total_size // PART_SIZE)


def write_part(path: str, part_number: int, data: bytes, total_size: int) -> None:
    parts = expected_parts(total_size)
    if not 0 <= part_number < parts:
        raise ValueError("Número de parte inválido.")
    expected = total_size - part_number * PART_SIZE if part_number == parts - 1 else PART_SIZE
    if len(data) != expected:
        raise ValueError("Tamanho da parte inválido.")
    os.makedirs(os.path.dirname(path), exist_ok=True)
    fd = os.open(path, os.O_WRONLY | os.O_CREAT, 0o644)
    try:
        os.pwrite(fd, data, part_number * PART_SIZE)
    finally:
        os.close(fd)


def finalize_file(tmp: str, company_id: str) -> tuple[str, int, float]:
    size = os.path.getsize(tmp)
    if size <= 0 or size > MAX_FILE_SIZE:
        raise ValueError("O arquivo excede o limite de 2 GB.")
    with open(tmp, "rb") as f:
        head = f.read(4096)
    if not is_mp4_header(head):
        raise ValueError("O arquivo enviado não é um MP4 válido.")
    duration = validate_duration(read_mp4_duration(tmp))
    directory = video_dir(company_id)
    os.makedirs(directory, exist_ok=True)
    final = f"{directory}/{uuid.uuid4()}.mp4"
    shutil.move(tmp, final)
    return final, size, duration


def ensure_free_space(company_id: str, needed: int) -> None:
    directory = video_dir(company_id)
    os.makedirs(directory, exist_ok=True)
    if shutil.disk_usage(directory).free < needed + MIN_FREE_MARGIN:
        raise ValueError("Sem espaço em disco suficiente para este vídeo.")


async def cleanup_stale_uploads(conn: asyncpg.Connection) -> None:
    rows = await conn.fetch(
        """DELETE FROM public.internal_video_uploads
           WHERE completed_at IS NULL AND created_at < now() - $1::interval
           RETURNING id, company_id""",
        STALE_AFTER,
    )
    for r in rows:
        try:
            os.remove(tmp_path(str(r["company_id"]), str(r["id"])))
        except FileNotFoundError:
            pass
