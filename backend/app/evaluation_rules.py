"""Regras da Avaliação de Desempenho (material da consultoria de RH, nov/2026). Funções
puras: sem banco e sem relógio — quem chama passa o dia de hoje."""
from datetime import date
from typing import Optional

BEHAVIORS = [
    {"key": "cultura_visivel", "pillar": "cultura",
     "label": "Alinhamento Cultural Visível (comportamento em público)",
     "description": "Demonstra, no dia a dia e na frente das pessoas, comportamentos alinhados à "
                    "Cultura H&S, atuando com foco na proteção da vida, no cuidado com o cliente, na "
                    "colaboração com o time, na responsabilidade com as entregas e no respeito à "
                    "ética, à segurança e às normas da empresa."},
    {"key": "cultura_genuino", "pillar": "cultura",
     "label": "Alinhamento Cultural Genuíno (postura consistente)",
     "description": "Mantém uma postura coerente com a Cultura H&S mesmo fora do ambiente formal, "
                    "demonstrando integridade, respeito, responsabilidade e compromisso real com a "
                    "segurança, com as pessoas e com a empresa, sem atitudes ou discursos que "
                    "enfraqueçam o time, a confiança ou a cultura."},
    {"key": "entregas", "pillar": "entregas",
     "label": "Entregas (qualidade, prazo e impacto)",
     "description": "Entrega o que foi combinado, com qualidade, dentro do prazo e gerando impacto "
                    "positivo para a área e para o negócio."},
    {"key": "organizacao", "pillar": "entregas",
     "label": "Organização e priorização",
     "description": "Organiza suas atividades, define prioridades corretamente e gerencia bem o "
                    "tempo e as demandas do dia a dia."},
    {"key": "colaboracao", "pillar": "entregas",
     "label": "Colaboração entre as pessoas do time e outras áreas",
     "description": "Colabora ativamente com o time e com outras áreas, compartilhando informações "
                    "e contribuindo para objetivos comuns."},
    {"key": "feedback", "pillar": "desenvolvimento",
     "label": "Abertura a feedback",
     "description": "Recebe feedbacks com maturidade, escuta com atenção e demonstra disposição "
                    "para ajustar comportamentos e melhorar."},
    {"key": "autonomia", "pillar": "desenvolvimento",
     "label": "Autonomia e aprendizado",
     "description": "Atua com autonomia nas suas responsabilidades e busca aprender continuamente "
                    "para evoluir no desempenho."},
    {"key": "protagonismo", "pillar": "desenvolvimento",
     "label": "Protagonismo com o próprio desenvolvimento",
     "description": "Assume responsabilidade pelo próprio desenvolvimento, busca oportunidades de "
                    "crescimento e aplica aprendizados no dia a dia."},
]
BEHAVIOR_KEYS = frozenset(b["key"] for b in BEHAVIORS)
PILLARS = ("cultura", "entregas", "desenvolvimento")
PILLAR_WEIGHTS = {"cultura": 0.40, "entregas": 0.30, "desenvolvimento": 0.30}
MANAGER_WEIGHT = 0.9
SELF_WEIGHT = 0.1

SCORE_LABELS = {1: "Precisa Melhorar", 2: "Tá no Caminho", 3: "Atende às Expectativas",
                4: "Tá Mandando Bem", 5: "É Referência"}

NINE_BOX_QUADRANTS = {
    (1, 1): "Insuficiente", (1, 2): "Contribuidor", (1, 3): "Alcança Resultados",
    (2, 1): "Competência Consistente", (2, 2): "Essenciais", (2, 3): "Futuro Talento",
    (3, 1): "Alta Competência", (3, 2): "Forte Talento", (3, 3): "Super Talento",
}

# Etapas que têm datas, na ordem do ciclo: (status, coluna de início, coluna de fim, rótulo)
STAGES = (
    ("evaluation", "eval_start", "eval_end", "Avaliação"),
    ("calibration", "calibration_start", "calibration_end", "Calibragem"),
    ("feedback", "feedback_start", "feedback_end", "Feedback"),
    ("pdi", "pdi_start", "pdi_end", "PDI"),
)
STATUSES = ("draft", "evaluation", "calibration", "feedback", "pdi", "closed")


def validate_stage_dates(cycle: dict) -> Optional[str]:
    """Mensagem de erro para o RH, ou None se as datas fazem sentido."""
    previous = None
    for _, start_col, end_col, label in STAGES:
        start, end = cycle.get(start_col), cycle.get(end_col)
        if (start is None) != (end is None):
            return f"Preencha o início e o fim de {label}, ou deixe os dois em branco."
        if start is None:
            continue
        if end < start:
            return f"O fim de {label} não pode ser antes do início."
        if previous and start <= previous[1]:
            return f"{label} precisa começar depois do fim de {previous[0]}."
        previous = (label, end)
    return None


def effective_status(cycle: dict, today: date) -> str:
    """Etapa em que o ciclo está hoje. Com `stage_by_dates`, a etapa sai das datas: antes da
    primeira é rascunho, no intervalo entre duas já vale a seguinte (a anterior fechou) e
    depois da última o ciclo está encerrado. Sem isso, vale a etapa escolhida à mão."""
    if not cycle.get("stage_by_dates"):
        return cycle["status"]
    dated = [(s, cycle[a], cycle[b]) for s, a, b, _ in STAGES if cycle.get(a) and cycle.get(b)]
    if not dated:
        return cycle["status"]
    for stage, _, end in dated:
        if today <= end:
            return stage if today >= dated[0][1] else "draft"
    return "closed"


def pillar_scores(scores: dict) -> dict:
    """{behavior_key: nota} completo -> notas por pilar e nota final (pesos 40/30/30)."""
    result = {}
    for pillar in PILLARS:
        vals = [scores[b["key"]] for b in BEHAVIORS if b["pillar"] == pillar]
        result[pillar] = sum(vals) / len(vals)
    result["final"] = sum(result[p] * PILLAR_WEIGHTS[p] for p in PILLARS)
    return result


def compose_scores(manager: Optional[dict], self_: Optional[dict]) -> Optional[dict]:
    """Média ponderada gestor 90% + autoavaliação 10%, pilar a pilar e na nota final. Sem a
    avaliação do gestor não há nota (a autoavaliação sozinha não posiciona ninguém); sem a
    autoavaliação, vale só a do gestor."""
    if not manager:
        return None
    m = pillar_scores(manager)
    s = pillar_scores(self_) if self_ else None
    out = {k: round(m[k] * MANAGER_WEIGHT + s[k] * SELF_WEIGHT, 4) if s else round(m[k], 4)
           for k in (*PILLARS, "final")}
    out["manager"] = round(m["final"], 4)
    out["self"] = round(s["final"], 4) if s else None
    return out


def nine_box(score_final: Optional[float], goals_pct: Optional[float]) -> tuple:
    """(x, y, quadrante). y = faixa da avaliação (1,0–2,9 / 3,0–4,5 / 4,6–5,0), x = faixa das
    metas (0–90% / 91–105% / 106%+)."""
    if score_final is None or goals_pct is None:
        return None, None, None
    y = 1 if score_final < 3.0 else (2 if score_final <= 4.5 else 3)
    x = 1 if goals_pct < 91 else (2 if goals_pct <= 105 else 3)
    return x, y, NINE_BOX_QUADRANTS[(y, x)]
