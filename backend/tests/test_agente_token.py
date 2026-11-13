import time

import jwt
import pytest
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric.ed25519 import Ed25519PrivateKey

from app.auth.agente import (
    ROTAS_DO_AGENTE,
    TokenDeAgenteInvalido,
    eh_token_de_agente,
    rota_liberada_ao_agente,
    validar_token_de_agente,
)


def _par():
    priv = Ed25519PrivateKey.generate()
    pub = priv.public_key().public_bytes(
        serialization.Encoding.PEM, serialization.PublicFormat.SubjectPublicKeyInfo
    ).decode()
    return priv, pub


PRIV, PUB = _par()


def emitir(priv=PRIV, **extra):
    claims = {
        "iss": "hsos", "aud": "talenths", "sub": "Pessoa@HS.com",
        "act": {"sub": "erick-bot"}, "exp": int(time.time()) + 300,
    }
    claims.update(extra)
    claims = {k: v for k, v in claims.items() if v is not None}
    return jwt.encode(claims, priv, algorithm="EdDSA")


def test_token_valido_devolve_email_minusculo_e_bot():
    assert validar_token_de_agente(emitir(), PUB) == ("pessoa@hs.com", "erick-bot")


def test_pem_com_barra_n_literal_do_easypanel():
    assert validar_token_de_agente(emitir(), PUB.replace("\n", "\\n"))[1] == "erick-bot"


@pytest.mark.parametrize("token,chave", [
    (emitir(aud="datacore"), PUB),
    (emitir(exp=int(time.time()) - 10), PUB),
    (emitir(exp=int(time.time()) + 3600), PUB),
    (emitir(exp=None), PUB),
    (emitir(act=None), PUB),
    (emitir(sub=None), PUB),
    (emitir(priv=_par()[0]), PUB),
    (emitir(), ""),
])
def test_token_recusado(token, chave):
    with pytest.raises(TokenDeAgenteInvalido):
        validar_token_de_agente(token, chave)


def test_login_normal_nao_e_agente():
    login = jwt.encode({"sub": "x", "exp": int(time.time()) + 60}, "segredo-com-tamanho-suficiente-para-hs256", algorithm="HS256")
    assert not eh_token_de_agente(login)
    assert not eh_token_de_agente("lixo")
    assert eh_token_de_agente(emitir())


def test_so_get_e_so_rota_da_lista():
    assert rota_liberada_ao_agente("GET", "/absences/my")
    assert not rota_liberada_ao_agente("POST", "/absences/my")
    assert not rota_liberada_ao_agente("GET", "/absences/my/extra")
    assert not rota_liberada_ao_agente("GET", None)
    for proibida in (
        "/tests/{test_id}", "/tests/{test_id}/take", "/tests/attempts/{attempt_id}",
        "/documents/{document_id}/download", "/goals/comments/attachments/{attachment_id}/download",
        "/videos/{video_id}", "/videos/admin", "/invitations", "/auth/microsoft", "/logs",
        "/bingo/my", "/tour/progress",
    ):
        assert not rota_liberada_ao_agente("GET", proibida), proibida


def test_toda_rota_da_lista_existe_como_get_no_app(monkeypatch):
    from app.main import app

    gets = {p for p, ops in app.openapi()["paths"].items() if "get" in ops}
    assert ROTAS_DO_AGENTE - gets == set()
