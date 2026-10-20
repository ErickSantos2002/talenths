import os

import pytest

from app import video_storage
from app.video_storage import expected_parts, finalize_file, write_part


@pytest.fixture(autouse=True)
def small_parts(monkeypatch):
    monkeypatch.setattr(video_storage, "PART_SIZE", 1024)


def test_expected_parts():
    assert expected_parts(1024 * 2 + 1) == 3
    assert expected_parts(1024 * 2) == 2


def test_write_part_rejects_wrong_size(tmp_path):
    path = str(tmp_path / "up.tmp")
    with pytest.raises(ValueError):
        write_part(path, 1, b"x" * 1023, 1024 * 3)


def test_write_part_rejects_out_of_range_part(tmp_path):
    path = str(tmp_path / "up.tmp")
    with pytest.raises(ValueError):
        write_part(path, 3, b"x" * 1024, 1024 * 3)
    with pytest.raises(ValueError):
        write_part(path, -1, b"x" * 1024, 1024 * 3)


def test_write_part_last_part_is_remainder(tmp_path):
    path = str(tmp_path / "up.tmp")
    write_part(path, 2, b"x" * 10, 1024 * 2 + 10)
    assert os.path.getsize(path) == 1024 * 2 + 10
    with pytest.raises(ValueError):
        write_part(path, 2, b"x" * 11, 1024 * 2 + 10)


def test_write_part_same_part_twice_is_idempotent(tmp_path):
    path = str(tmp_path / "up.tmp")
    write_part(path, 0, b"a" * 1024, 2048)
    write_part(path, 0, b"a" * 1024, 2048)
    assert open(path, "rb").read() == b"a" * 1024


def test_finalize_rejects_non_mp4(tmp_path, monkeypatch):
    monkeypatch.setattr("app.video_storage.settings.UPLOADS_DIR", str(tmp_path))
    tmp = tmp_path / "up.tmp"
    tmp.write_bytes(b"\x1a\x45\xdf\xa3" + b"\x00" * 200)  # cabeçalho EBML (WebM)
    with pytest.raises(ValueError, match="MP4"):
        finalize_file(str(tmp), "company-1")
    assert tmp.exists()


def test_finalize_rejects_empty_file(tmp_path, monkeypatch):
    monkeypatch.setattr("app.video_storage.settings.UPLOADS_DIR", str(tmp_path))
    tmp = tmp_path / "up.tmp"
    tmp.write_bytes(b"")
    with pytest.raises(ValueError, match="vazio"):
        finalize_file(str(tmp), "company-1")
