from app.middleware.audit import _resolve_action, _should_log

VID = "6f1c2a8e-0000-4000-8000-000000000001"
UID = "6f1c2a8e-0000-4000-8000-000000000002"


def test_high_frequency_video_routes_not_logged():
    assert not _should_log("POST", f"/videos/{VID}/progress")
    assert not _should_log("PUT", f"/videos/uploads/{VID}/parts/3")


def test_other_writes_still_logged():
    assert _should_log("POST", "/videos")
    assert _should_log("POST", f"/videos/{VID}/stream-token")
    assert _should_log("POST", f"/videos/uploads/{VID}/complete")
    assert _should_log("DELETE", f"/videos/{VID}")
    assert not _should_log("GET", "/videos/mine")
    assert not _should_log("POST", "/docs/x")


def test_video_action_labels():
    assert _resolve_action("POST", "/videos") == "Vídeo criado"
    assert _resolve_action("PATCH", f"/videos/{VID}") == "Vídeo atualizado"
    assert _resolve_action("POST", f"/videos/{VID}/replace-file") == "Arquivo de vídeo substituído"
    assert _resolve_action("POST", f"/videos/{VID}/archive") == "Vídeo arquivado"
    assert _resolve_action("POST", f"/videos/{VID}/unarchive") == "Vídeo desarquivado"
    assert _resolve_action("DELETE", f"/videos/{VID}") == "Vídeo removido"
    assert _resolve_action("POST", f"/videos/{VID}/viewers/{UID}/remove") == "Colaborador removido de vídeo"
    assert _resolve_action("DELETE", f"/videos/uploads/{VID}") == "Remoção"


def test_tour_routes_not_logged():
    base = "/tour/progress/boas-vindas-colaborador"
    assert not _should_log("PUT", base)
    for suffix in ("complete", "dismiss", "decline-invite"):
        assert not _should_log("POST", f"{base}/{suffix}")


def test_collaborator_status_labels():
    assert _resolve_action("POST", f"/collaborators/{VID}/deactivate") == "Colaborador desligado"
    assert _resolve_action("POST", f"/collaborators/{VID}/reactivate") == "Colaborador reativado"


def test_video_completion_labels():
    assert _resolve_action("POST", f"/videos/{VID}/viewers/{UID}/complete") == "Conclusão de vídeo registrada"
    assert _resolve_action("POST", f"/videos/{VID}/viewers/{UID}/uncomplete") == "Registro de conclusão desfeito"


def test_rotulos_ancorados_nao_confundem_rotas_parecidas():
    assert _resolve_action("POST", f"/workshops/{VID}/register") == "Inscrição em workshop"
    assert _resolve_action("DELETE", f"/workshops/{VID}/register") == "Cancelamento de inscrição em workshop"
    assert _resolve_action("POST", "/workshops") == "Workshop criado"
    assert _resolve_action("POST", f"/pdi/plans/{VID}/actions") == "Ação de PDI criada"
    assert _resolve_action("POST", "/pdi/plans") == "Plano de PDI criado"
    assert _resolve_action("PUT", f"/goals/{VID}/actuals/3") == "Realizado de meta lançado"
    assert _resolve_action("POST", f"/goals/{VID}/comments") == "Comentário em meta"
    assert _resolve_action("PUT", f"/goals/{VID}") == "Meta atualizada"
    assert _resolve_action("POST", f"/feedbacks/{VID}/respond") == "Feedback respondido"
    assert _resolve_action("POST", f"/timeclock/adjustments/{VID}/approve") == "Ajuste de ponto aprovado"
    assert _resolve_action("PUT", f"/onboarding/checklist-tasks/{VID}/complete") == "Tarefa de onboarding marcada ou desmarcada"
