"""Semente fictícia do banco das capturas da Ajuda.

As imagens dos guias (`frontend/public/capturas/*.webp`) são fotografadas
pelo `bun run capturas` contra um banco só delas, com a "Empresa Exemplo" e
pessoas `@exemplo.com.br` — nada de dado real nas imagens.

**Apaga tudo antes de semear** (TRUNCATE em todas as tabelas, inclusive
`auth.users`): rodar duas vezes dá o mesmo conteúdo. Por isso recusa, antes de
abrir conexão, qualquer banco cujo nome não contenha `capturas` — e confere de
novo o `current_database()` depois de conectar.

Precisa do `ffmpeg` (com libx264 e drawtext) para gerar o MP4 do player da
captura `video`, gravado em `CAPTURES_UPLOADS_DIR` (padrão
`/tmp/talenths-uploads-capturas`) — que tem de ser o mesmo `UPLOADS_DIR` do
backend das capturas. Sem ffmpeg a semente roda, mas avisa no stderr.

O banco nasce do `backend/scripts/captures-db.sh`. Uso:

    CAPTURES_DATABASE_URL=postgresql://erick:dev123@localhost:5432/talenths_capturas \\
      backend/.venv/bin/python backend/scripts/seed_captures.py

Contas (senha de todas: `CAPTURES_PASSWORD`, padrão `exemplo123`):
`ana@` colaboradora, `bruno@` colaborador com ponto, `gestor@` manager,
`admin@` master_admin, mais alguns colegas para as listas não ficarem vazias.

As datas são relativas a hoje, para as telas parecerem atuais sempre que as
capturas forem refeitas. A última linha da saída é o JSON dos ids que o
`frontend/scripts/captures.config.ts` usa.
"""
from __future__ import annotations

import asyncio
import json
import os
import random
import shutil
import subprocess
import sys
import uuid
from datetime import date, datetime, time, timedelta, timezone
from urllib.parse import urlparse

import asyncpg
import bcrypt

DEFAULT_URL = "postgresql://erick:dev123@localhost:5432/talenths_capturas"
PASSWORD = os.environ.get("CAPTURES_PASSWORD", "exemplo123")
BRT = timezone(timedelta(hours=-3))
# Os tours de boas-vindas (frontend/src/help/tours/welcome.ts): concluídos para
# as contas de login, senão o modal obrigatório cobre as fotos. Das demais, uma
# para no meio e outra nem começa, para a tela de adoção mostrar as três situações.
WELCOME_TOURS = {"boas-vindas-colaborador": 2, "boas-vindas-gestor": 2}
TOUR_IN_PROGRESS = "felipe"  # parou no passo 4 (índice 3)
TOUR_NOT_STARTED = "igor"  # sem linha em tour_progress
# Tabela que a 001 já semeia (o teste DISC antigo) e que não é dado de pessoa.
KEEP = {"scenario_blocks"}
# O mesmo UPLOADS_DIR do backend das capturas (topo de frontend/scripts/captures.ts).
UPLOADS_DIR = os.environ.get("CAPTURES_UPLOADS_DIR", "/tmp/talenths-uploads-capturas")


def db_name(url: str) -> str:
    return urlparse(url).path.lstrip("/")


def allowed(url: str) -> bool:
    """Só banco com `capturas` no nome, e sem consulta na URL: `?dbname=` ou
    `?host=` levariam a conexão para outro banco com o caminho dizendo outra coisa."""
    parts = urlparse(url)
    return parts.scheme in ("postgresql", "postgres") and not parts.query and "capturas" in db_name(url)


def placeholder_video(path: str, seconds: int, title: str) -> bool:
    """Um MP4 leve (fundo liso com o título, 1 quadro por segundo) para o player da
    captura abrir de verdade. Sem ffmpeg (ou se ele falhar), avisa no stderr e o
    vídeo fica sem arquivo, como os outros — e a captura `video` sai com o player vazio."""
    if not shutil.which("ffmpeg"):
        print("AVISO: ffmpeg não encontrado — o vídeo da captura `video` fica sem arquivo "
              "(player vazio em 0:00). Instale o ffmpeg e refaça a captura.", file=sys.stderr)
        return False
    os.makedirs(os.path.dirname(path), exist_ok=True)
    text = title.replace(":", r"\:").replace("'", "")
    result = subprocess.run(
        ["ffmpeg", "-y", "-loglevel", "error", "-f", "lavfi", "-i", f"color=c=0x0f766e:s=1280x720:r=1:d={seconds}",
         "-vf", f"drawtext=text='{text}':fontcolor=white:fontsize=56:x=(w-tw)/2:y=(h-th)/2",
         "-c:v", "libx264", "-pix_fmt", "yuv420p", "-movflags", "+faststart", path],
        capture_output=True, text=True,
    )
    if result.returncode != 0:
        print(f"AVISO: o ffmpeg falhou ({result.returncode}) ao gerar {path} — a captura `video` "
              f"sai com o player vazio.\n{result.stderr.strip()}", file=sys.stderr)
        return False
    return True


def hash_pw(plain: str) -> str:
    return bcrypt.hashpw(plain.encode(), bcrypt.gensalt(rounds=4)).decode()


class Seeder:
    def __init__(self, conn: asyncpg.Connection):
        self.conn = conn
        self.today = datetime.now(BRT).date()
        self.now = datetime.now(timezone.utc)

    async def ins(self, table: str, **cols) -> str:
        names = ", ".join(cols)
        params = ", ".join(f"${i}" for i in range(1, len(cols) + 1))
        sql = f"INSERT INTO public.{table} ({names}) VALUES ({params}) RETURNING id"
        return str(await self.conn.fetchval(sql, *cols.values()))

    def days(self, n: int) -> date:
        return self.today + timedelta(days=n)

    def at(self, d: date, hh: int, mm: int = 0) -> datetime:
        return datetime.combine(d, time(hh, mm), BRT)

    def this_month(self, day: int) -> date:
        return self.today.replace(day=min(day, 28))

    # ── base ────────────────────────────────────────────────────────────────

    async def reset(self) -> None:
        tables = await self.conn.fetch(
            "SELECT tablename FROM pg_tables WHERE schemaname = 'public' ORDER BY tablename"
        )
        names = [f"public.{t['tablename']}" for t in tables if t["tablename"] not in KEEP]
        await self.conn.execute(f"TRUNCATE auth.users, {', '.join(names)} RESTART IDENTITY CASCADE")

    async def company(self) -> None:
        values = [
            {"title": "Cuidar de gente", "description": "Segurança e bem-estar vêm antes de qualquer meta."},
            {"title": "Fazer junto", "description": "Resultado bom é resultado da equipe inteira."},
            {"title": "Aprender sempre", "description": "Cada erro vira uma lição compartilhada."},
            {"title": "Palavra cumprida", "description": "O combinado com o cliente e com o colega se cumpre."},
        ]
        rules = [
            {"title": "Horário de trabalho", "content": "O expediente é das 8h às 17h30, com 1 hora de almoço. Atrasos devem ser avisados ao gestor pelo chat da equipe."},
            {"title": "Uso de equipamentos", "content": "Notebooks e celulares da empresa são para uso profissional. Em caso de defeito, abra um chamado com a TI."},
            {"title": "Home office", "content": "Até dois dias por semana, combinados com o gestor com uma semana de antecedência."},
            {"title": "Vestimenta", "content": "Roupa confortável no dia a dia; nas visitas a clientes, use o uniforme da Empresa Exemplo."},
        ]
        self.company_id = await self.ins(
            "companies",
            name="Empresa Exemplo",
            cnpj="12.345.678/0001-90",
            presentation_mission="Tornar o ambiente de trabalho dos nossos clientes mais seguro, todos os dias.",
            presentation_vision="Ser a referência em segurança do trabalho na nossa região até 2030.",
            presentation_history=(
                "A Empresa Exemplo nasceu em 2012 numa sala pequena, com três pessoas e um carro. "
                "Hoje atendemos mais de 300 clientes com uma equipe que cresce a cada ano — "
                "sem perder o jeito próximo de trabalhar."
            ),
            presentation_values=json.dumps(values),
            internal_rules=json.dumps(rules),
        )
        self.depts = {}
        for name in ("Comercial", "Operações", "Recursos Humanos", "Tecnologia", "Financeiro"):
            self.depts[name] = await self.ins("departments", company_id=self.company_id, name=name)

    async def people(self) -> None:
        pw = hash_pw(PASSWORD)
        t = self.today
        # chave, nome, e-mail, papel, departamento, cargo, família, senioridade, salário,
        # aniversário, admissão, ponto
        people = [
            ("ana", "Ana Ribeiro", "ana@exemplo.com.br", "user", "Comercial", "Analista Comercial",
             "Comercial", "Pleno", 5200, date(1994, t.month, 12), date(t.year - 3, t.month, 3), False),
            ("bruno", "Bruno Carvalho", "bruno@exemplo.com.br", "user", "Operações", "Técnico de Segurança",
             "Operações", "Júnior", 3800, date(1998, 3, 22), date(t.year - 1, 2, 14), True),
            ("gestor", "Gabriela Martins", "gestor@exemplo.com.br", "manager", "Recursos Humanos",
             "Coordenadora de RH", "Recursos Humanos", "Sênior", 9800, date(1987, 7, 9), date(t.year - 6, 5, 2), False),
            ("admin", "Rafael Admin", "admin@exemplo.com.br", "master_admin", "Tecnologia",
             "Administrador do sistema", "Tecnologia", "Sênior", 11000, date(1985, 11, 30), date(t.year - 8, 1, 10), False),
            ("carla", "Carla Mendes", "carla@exemplo.com.br", "user", "Comercial", "Executiva de Vendas",
             "Comercial", "Sênior", 7600, date(1990, t.month, 25), date(t.year - 5, 8, 18), False),
            ("diego", "Diego Souza", "diego@exemplo.com.br", "user", "Operações", "Técnico de Segurança",
             "Operações", "Pleno", 4700, date(1992, 4, 4), date(t.year - 2, t.month, 21), True),
            ("eduarda", "Eduarda Lima", "eduarda@exemplo.com.br", "user", "Financeiro", "Analista Financeira",
             "Financeiro", "Pleno", 5400, date(1995, 9, 15), date(t.year - 4, 3, 7), False),
            ("felipe", "Felipe Rocha", "felipe@exemplo.com.br", "user", "Tecnologia", "Desenvolvedor",
             "Tecnologia", "Júnior", 4300, date(1999, 1, 28), date(t.year, 2, 1), False),
            ("helena", "Helena Costa", "helena@exemplo.com.br", "user", "Operações", "Supervisora de Campo",
             "Operações", "Sênior", 6900, date(1988, 6, 2), date(t.year - 7, 6, 11), True),
            ("igor", "Igor Almeida", "igor@exemplo.com.br", "user", "Comercial", "Assistente Comercial",
             "Comercial", "Júnior", 3100, date(2000, 12, 19), (t - timedelta(days=20)), False),
        ]
        self.users: dict[str, str] = {}
        self.names: dict[str, str] = {}
        self.dept_of: dict[str, str] = {}
        for i, (key, name, email, role, dept, title, family, senior, salary, birth, hire, clock) in enumerate(people, 1):
            uid = str(await self.conn.fetchval(
                """INSERT INTO auth.users (email, encrypted_password, email_confirmed_at, raw_user_meta_data)
                   VALUES ($1, $2, now(), jsonb_build_object('name', $3::text)) RETURNING id""",
                email, pw, name,
            ))
            # O trigger de signup criou perfil e papel "user"; completa como o cadastro faz.
            await self.conn.execute(
                """UPDATE public.profiles SET company_id = $2, department_id = $3, cpf = $4, phone = $5,
                          birth_date = $6, hire_date = $7, job_title = $8, job_family = $9, seniority = $10,
                          current_salary = $11, timeclock_enabled = $12
                   WHERE user_id = $1""",
                uid, self.company_id, self.depts[dept], f"000.000.{i:03d}-00", f"(11) 90000-{i:04d}",
                birth, hire, title, family, senior, salary, clock,
            )
            await self.conn.execute(
                "UPDATE public.user_roles SET role = $2, company_id = $3 WHERE user_id = $1",
                uid, role, self.company_id,
            )
            self.users[key] = uid
            self.names[key] = name
            self.dept_of[key] = dept
        self.collaborators = [k for k in self.users if k not in ("gestor", "admin")]
        for key in self.collaborators:
            await self.ins("user_managers", user_id=self.users[key], manager_id=self.users["gestor"])
        for key, uid in self.users.items():
            if key == TOUR_NOT_STARTED:
                continue
            if key == TOUR_IN_PROGRESS:
                await self.ins(
                    "tour_progress", user_id=uid, company_id=self.company_id, tour="boas-vindas-colaborador",
                    version=WELCOME_TOURS["boas-vindas-colaborador"], step=3,
                    started_at=self.now - timedelta(days=2),
                )
                continue
            for tour, version in WELCOME_TOURS.items():
                await self.ins(
                    "tour_progress", user_id=uid, company_id=self.company_id, tour=tour, version=version,
                    step=0, started_at=self.now - timedelta(days=30), completed_at=self.now - timedelta(days=30),
                )

    # ── meu espaço ──────────────────────────────────────────────────────────

    async def culture(self) -> None:
        await self.ins(
            "company_culture", company_id=self.company_id, updated_by=self.users["gestor"],
            purpose="Proteger quem trabalha, para que cada pessoa volte para casa bem no fim do dia.",
            manifesto=(
                "Acreditamos que segurança se constrói em conversa, não em cartaz. "
                "Por isso ouvimos quem está no campo, explicamos o porquê de cada regra "
                "e comemoramos cada dia sem acidente como uma conquista de todos."
            ),
        )
        for pos, (title, desc) in enumerate([
            ("Cuidar de gente", "Segurança e bem-estar vêm antes de qualquer meta."),
            ("Fazer junto", "Resultado bom é resultado da equipe inteira."),
            ("Aprender sempre", "Cada erro vira uma lição compartilhada."),
            ("Palavra cumprida", "O combinado com o cliente e com o colega se cumpre."),
        ]):
            await self.ins("culture_values", company_id=self.company_id, title=title, description=desc, position=pos)

    async def calendar(self) -> None:
        events = [
            ("Reunião geral do mês", "meeting", "#6366f1", 3, 3),
            ("Prazo da autoavaliação", "deadline", "#ef4444", 9, 9),
            ("Feriado municipal", "holiday", "#f59e0b", 15, 15),
            ("Semana de segurança (SIPAT)", "event", "#10b981", 22, 26),
            ("Integração de novos colaboradores", "training", "#0ea5e9", 6, 6),
        ]
        for title, kind, color, d1, d2 in events:
            await self.ins(
                "calendar_events", company_id=self.company_id, title=title, event_type=kind, color=color,
                description=f"{title} — Empresa Exemplo.", start_date=self.this_month(d1),
                end_date=self.this_month(d2), all_day=True, created_by=self.users["gestor"],
            )

    # ── desempenho ──────────────────────────────────────────────────────────

    async def goals(self) -> None:
        y = self.today.year
        self.mgmt_cycle = await self.ins(
            "management_cycles", company_id=self.company_id, name=f"Metas {y}", start_date=date(y, 1, 1),
            end_date=date(y, 12, 31), status="active", created_by=self.users["gestor"],
        )
        goals = [
            ("Comercial", "Faturamento de novos contratos", "currency", "sum", 1_200_000, 50),
            ("Comercial", "Taxa de renovação de contratos", "percentage", "average", 90, 50),
            ("Operações", "Visitas técnicas realizadas", "value", "sum", 960, 60),
            ("Operações", "Relatórios entregues no prazo", "percentage", "average", 95, 40),
            ("Recursos Humanos", "Horas de capacitação por pessoa", "value", "sum", 40, 100),
            ("Tecnologia", "Chamados resolvidos em até 24 h", "percentage", "average", 85, 100),
            ("Financeiro", "Inadimplência", "percentage", "average", 3, 100),
        ]
        rng = random.Random(7)
        self.goal_ids = []
        last_month = max(self.today.month - 1, 1)
        for pos, (dept, title, rtype, calc, target, weight) in enumerate(goals):
            objective = "decrease" if title == "Inadimplência" else "increase"
            gid = await self.ins(
                "goals", cycle_id=self.mgmt_cycle, department_id=self.depts[dept], company_id=self.company_id,
                responsible_user_id=self.users["gestor"], title=title, objective=objective,
                calculation_type=calc, result_type=rtype, weight=weight, target_value=target, position=pos,
            )
            self.goal_ids.append(gid)
            monthly = target / 12 if calc == "sum" else target
            for m in range(1, 13):
                await self.ins("goal_monthly_plans", goal_id=gid, month=m, planned_value=round(monthly, 2))
            for m in range(1, last_month + 1):
                actual = round(monthly * rng.uniform(0.85, 1.12), 2)
                await self.ins(
                    "goal_monthly_actuals", goal_id=gid, month=m, actual_value=actual,
                    is_closed=True, updated_by=self.users["gestor"],
                )
        await self.ins(
            "goal_comments", goal_id=self.goal_ids[0], company_id=self.company_id, author_id=self.users["gestor"],
            body="Setembro ficou acima do plano graças aos dois contratos novos da região sul.",
        )

    async def evaluations(self) -> None:
        y = self.today.year
        past = await self.ins(
            "evaluation_cycles", company_id=self.company_id, management_cycle_id=self.mgmt_cycle,
            name=f"Avaliação 1º semestre {y}", eval_start=date(y, 6, 1), eval_end=date(y, 6, 20),
            calibration_start=date(y, 6, 21), calibration_end=date(y, 6, 30), feedback_start=date(y, 7, 1),
            feedback_end=date(y, 7, 15), pdi_start=date(y, 7, 16), pdi_end=date(y, 7, 31), status="closed",
            created_by=self.users["gestor"],
        )
        self.eval_cycle = await self.ins(
            "evaluation_cycles", company_id=self.company_id, management_cycle_id=self.mgmt_cycle,
            name=f"Avaliação 2º semestre {y}", eval_start=self.days(-10), eval_end=self.days(15),
            calibration_start=self.days(16), calibration_end=self.days(25), feedback_start=self.days(26),
            feedback_end=self.days(40), pdi_start=self.days(41), pdi_end=self.days(55), status="evaluation",
            created_by=self.users["gestor"],
        )
        keys = ["cultura_visivel", "cultura_genuino", "entregas", "organizacao",
                "colaboracao", "feedback", "autonomia", "protagonismo"]
        # 9Box: (x = metas, y = avaliação) por pessoa, espalhados pela grade.
        boxes = {"ana": (2, 3), "bruno": (2, 2), "carla": (3, 3), "diego": (1, 2), "eduarda": (3, 2),
                 "felipe": (2, 1), "helena": (3, 3), "igor": (1, 1)}
        quadrants = {
            (1, 1): "Insuficiente", (1, 2): "Contribuidor", (1, 3): "Alcança Resultados",
            (2, 1): "Competência Consistente", (2, 2): "Essenciais", (2, 3): "Futuro Talento",
            (3, 1): "Alta Competência", (3, 2): "Forte Talento", (3, 3): "Super Talento",
        }
        rng = random.Random(11)
        for cycle in (past, self.eval_cycle):
            for key in self.collaborators:
                x, yb = boxes[key]
                base = {1: 2, 2: 4, 3: 5}[yb]
                kinds = ["self", "manager"]
                if cycle == self.eval_cycle and key == "ana":
                    # A autoavaliação dela está aberta na tela; só a gestora avaliou, e a nota
                    # consolidada vem só dessa avaliação (como o "Calcular Notas" faz).
                    kinds = ["manager"]
                for kind in kinds:
                    evaluator = self.users[key] if kind == "self" else self.users["gestor"]
                    eid = await self.ins(
                        "evaluations", eval_cycle_id=cycle, company_id=self.company_id,
                        evaluated_user_id=self.users[key], evaluator_user_id=evaluator, eval_type=kind,
                        submitted_at=self.now - timedelta(days=3),
                    )
                    for k in keys:
                        score = max(1, min(5, base + rng.choice((-1, 0, 0, 1))))
                        await self.ins("evaluation_scores", evaluation_id=eid, behavior_key=k, score=score)
                final = {1: 2.6, 2: 3.8, 3: 4.7}[yb] + rng.uniform(-0.2, 0.2)
                await self.ins(
                    "consolidated_scores", eval_cycle_id=cycle, user_id=self.users[key], company_id=self.company_id,
                    score_cultura=round(final + 0.1, 2), score_entregas=round(final - 0.1, 2),
                    score_desenvolvimento=round(final, 2), score_final=round(final, 2),
                    nine_box_x=x, nine_box_y=yb, nine_box_quadrant=quadrants[(yb, x)],
                )

    async def custom_tests(self) -> None:
        gestor = self.users["gestor"]
        self.test_id = await self.ins(
            "custom_tests", company_id=self.company_id, created_by=gestor,
            title="Normas de segurança no trabalho",
            description="Confira o que você sabe sobre as normas que usamos no dia a dia.",
            instructions="Leia cada pergunta com calma. Você tem 20 minutos e duas tentativas.",
            scoring_mode="auto", is_public=True, max_attempts=2, time_limit_min=20, pass_score=70,
            total_points=100, status="published",
        )
        questions = [
            ("single_choice", "Qual equipamento protege a cabeça contra impactos?",
             [("Capacete", True), ("Luva", False), ("Protetor auricular", False)]),
            ("true_false", "O uso do cinto de segurança é obrigatório em trabalho em altura.", None),
            ("multiple_choice", "Quais itens fazem parte de um EPI?",
             [("Óculos de proteção", True), ("Botina", True), ("Crachá", False)]),
            ("single_choice", "Quem deve ser avisado primeiro num acidente?",
             [("O técnico de segurança", True), ("O cliente", False), ("Ninguém", False)]),
        ]
        qids = []
        for pos, (kind, text, options) in enumerate(questions):
            qid = await self.ins("test_questions", test_id=self.test_id, order_index=pos,
                                 question_type=kind, text=text, points=25)
            opts = []
            for oi, (otext, correct) in enumerate(options or []):
                opts.append(await self.ins("test_question_options", question_id=qid, order_index=oi,
                                           text=otext, is_correct=correct, point_value=25 if correct else 0))
            qids.append((qid, kind, opts))
        second = await self.ins(
            "custom_tests", company_id=self.company_id, created_by=gestor,
            title="Atendimento ao cliente", description="Situações do dia a dia com clientes.",
            instructions="Responda com as suas palavras.", scoring_mode="manual", is_public=False,
            total_points=2, status="published",
        )
        for pos, text in enumerate(["Como você conduz uma visita com um cliente insatisfeito?",
                                    "Conte um atendimento do qual você se orgulha."]):
            await self.ins("test_questions", test_id=second, order_index=pos, question_type="open_text",
                           text=text, points=1)
        await self.ins("test_assignments", test_id=second, department_id=self.depts["Comercial"])
        # O rascunho é o da captura do editor: perguntas, configurações e uma atribuição.
        self.draft_test_id = await self.ins(
            "custom_tests", company_id=self.company_id, created_by=gestor,
            title="Integração — primeiros dias", description="Rascunho em preparação.",
            instructions="Responda depois da primeira semana.", scoring_mode="auto", is_public=False,
            max_attempts=1, time_limit_min=15, pass_score=7, total_points=10, status="draft",
        )
        for pos, (text, options) in enumerate([
            ("Em que horário começa o expediente?", [("8h", True), ("9h", False), ("10h", False)]),
            ("Onde ficam as regras internas da empresa?",
             [("No TalentHS, em Regras Internas", True), ("No mural da recepção", False)]),
        ]):
            qid = await self.ins("test_questions", test_id=self.draft_test_id, order_index=pos,
                                 question_type="single_choice", text=text, points=5)
            for oi, (otext, correct) in enumerate(options):
                await self.ins("test_question_options", question_id=qid, order_index=oi, text=otext,
                               is_correct=correct, point_value=5 if correct else 0)
        await self.ins("test_assignments", test_id=self.draft_test_id, user_id=self.users["igor"])
        # Tentativa avaliada da Ana (Meus Testes > resultado) e de colegas (Tentativas).
        self.attempt_id = None
        for key, score, passed in (("ana", 75, True), ("carla", 100, True), ("igor", 50, False)):
            aid = await self.ins(
                "test_attempts", test_id=self.test_id, user_id=self.users[key], attempt_number=1,
                status="evaluated", started_at=self.now - timedelta(days=5, minutes=14),
                submitted_at=self.now - timedelta(days=5), evaluated_at=self.now - timedelta(days=5),
                auto_score=score, final_score=score, passed=passed,
            )
            if key == "ana":
                self.attempt_id = aid
                (q1, _, o1), (q2, _, _), (q3, _, o3), (q4, _, o4) = qids
                await self.ins("test_responses", attempt_id=aid, question_id=q1, selected_option_ids=[uuid.UUID(o1[0])], auto_points=25)
                await self.ins("test_responses", attempt_id=aid, question_id=q2, boolean_response=True, auto_points=25)
                await self.ins("test_responses", attempt_id=aid, question_id=q3, selected_option_ids=[uuid.UUID(o3[0])], auto_points=0)
                await self.ins("test_responses", attempt_id=aid, question_id=q4, selected_option_ids=[uuid.UUID(o4[0])], auto_points=25)

    # ── desenvolvimento ─────────────────────────────────────────────────────

    async def career(self) -> None:
        tracks = {
            "Comercial": ["Assistente Comercial", "Analista Comercial", "Executivo de Vendas", "Gerente Comercial"],
            "Operações": ["Técnico Júnior", "Técnico Pleno", "Supervisor de Campo"],
        }
        levels: dict[str, list[str]] = {}
        for name, steps in tracks.items():
            tid = await self.ins("career_tracks", company_id=self.company_id, name=f"Trilha {name}",
                                 description=f"Caminho de crescimento da área de {name}.",
                                 created_by=self.users["gestor"])
            levels[name] = [tid]
            for pos, lvl in enumerate(steps, 1):
                levels[name].append(await self.ins(
                    "career_levels", track_id=tid, name=lvl, position=pos,
                    description=f"{lvl}: responsabilidades e entregas esperadas no nível.",
                    min_score_final=3 + pos * 0.3, required_9box_quadrants=["Futuro Talento", "Super Talento", "Forte Talento"],
                    min_months_in_level=12,
                ))
        placements = [("ana", "Comercial", 2, 26), ("igor", "Comercial", 1, 1), ("carla", "Comercial", 3, 30),
                      ("bruno", "Operações", 1, 14), ("diego", "Operações", 2, 20), ("helena", "Operações", 3, 40)]
        for key, track, pos, months in placements:
            await self.ins("employee_career", user_id=self.users[key], company_id=self.company_id,
                           track_id=levels[track][0], level_id=levels[track][pos],
                           started_at=self.today - timedelta(days=months * 30),
                           promoted_by=self.users["gestor"], notes="Combinado na conversa de feedback.")

    async def pdi(self) -> None:
        plans = {
            "ana": [("Fazer o curso de negociação avançada", "done"),
                    ("Conduzir duas apresentações para clientes novos", "in_progress"),
                    ("Acompanhar a Carla em três visitas de renovação", "pending")],
            "bruno": [("Concluir a NR-35 (trabalho em altura)", "done"),
                      ("Revisar o checklist de visitas técnicas", "in_progress")],
            "diego": [("Tirar a certificação de brigadista", "pending")],
        }
        for key, actions in plans.items():
            pid = await self.ins("pdi_plans", company_id=self.company_id, user_id=self.users[key],
                                 eval_cycle_id=self.eval_cycle, title=f"PDI {self.today.year} — {self.names[key]}",
                                 description="Plano combinado na conversa de feedback.", created_by=self.users["gestor"])
            for pos, (title, st) in enumerate(actions):
                await self.ins("pdi_actions", plan_id=pid, title=title, position=pos, status=st,
                               how="Com apoio da gestora e horário reservado na agenda.",
                               due_date=self.days(30 * (pos + 1)),
                               completed_at=self.now - timedelta(days=10) if st == "done" else None)

    async def learning(self) -> None:
        courses = [("Negociação avançada", "Comercial", 16), ("NR-35 — trabalho em altura", "Segurança", 8),
                   ("Excel para o dia a dia", "Ferramentas", 12), ("Comunicação não violenta", "Comportamental", 6)]
        ids = []
        for title, area, hours in courses:
            ids.append((await self.ins("course_catalog", company_id=self.company_id, title=title, area=area,
                                       description=f"Curso de {title.lower()}.", duration_hours=hours,
                                       created_by=self.users["gestor"]), title, area, hours))
        done = {"ana": [0, 2, 3], "bruno": [1], "carla": [0], "diego": [1, 2], "helena": [1, 3]}
        for key, idxs in done.items():
            for n, i in enumerate(idxs):
                cid, title, area, hours = ids[i]
                await self.ins("employee_courses", company_id=self.company_id, user_id=self.users[key],
                               catalog_id=cid, course_title=title, area=area, hours=hours,
                               completed_at=self.days(-20 - 35 * n))

    async def workshops(self) -> None:
        rows = [("Primeiros socorros na prática", "Segurança", 7, "open", 20),
                ("Oratória para apresentações", "Comportamental", 14, "open", 15),
                ("Planilhas que economizam tempo", "Ferramentas", -12, "done", 12)]
        self.workshop_ids = []
        for title, area, offset, st, seats in rows:
            start = self.at(self.days(offset), 14)
            wid = await self.ins("workshops", company_id=self.company_id, title=title, area=area,
                                 description=f"Workshop de {title.lower()}.", location="Auditório",
                                 starts_at=start, ends_at=start + timedelta(hours=3), max_seats=seats,
                                 status=st, created_by=self.users["gestor"])
            self.workshop_ids.append(wid)
        regs = [(0, "bruno", "registered"), (0, "diego", "registered"), (1, "ana", "registered"),
                (1, "carla", "registered"), (2, "ana", "attended"), (2, "eduarda", "attended"), (2, "igor", "absent")]
        for i, key, st in regs:
            await self.ins("workshop_registrations", workshop_id=self.workshop_ids[i], user_id=self.users[key],
                           company_id=self.company_id, status=st)

    # ── comunicação ─────────────────────────────────────────────────────────

    async def announcements(self) -> None:
        rows = [
            ("Semana de segurança começa dia 22", "Evento",
             "Palestras, oficinas e um café especial na quinta. Confira a programação no Calendário.", 2),
            ("Novo convênio com academia", "Benefícios",
             "A partir deste mês, todos têm desconto na rede de academias parceira. Veja em Meus Benefícios.", 6),
            ("Autoavaliação aberta", "RH",
             "O ciclo de avaliação do semestre começou. Faça a sua autoavaliação até o fim do prazo.", 9),
            ("Bem-vindo, Igor!", "Geral", "O Igor chegou ao time Comercial. Dê as boas-vindas!", 18),
        ]
        for title, cat, content, ago in rows:
            when = self.now - timedelta(days=ago)
            await self.ins("announcements", company_id=self.company_id, title=title, content=content,
                           category=cat, status="published", published_at=when, created_by=self.users["gestor"],
                           created_at=when, updated_at=when)
        await self.ins("announcements", company_id=self.company_id, title="Confraternização de fim de ano",
                       content="Rascunho: local e data a confirmar.", category="Evento", status="draft",
                       created_by=self.users["gestor"])

    async def onboarding(self) -> None:
        tid = await self.ins("onboarding_templates", company_id=self.company_id, name="Integração padrão",
                             description="Primeiras semanas de quem chega.", created_by=self.users["gestor"])
        tasks = [("Assinar o contrato e entregar documentos", "user", 1),
                 ("Receber notebook e acessos", "manager", 2),
                 ("Fazer o tour de boas-vindas do TalentHS", "user", 3),
                 ("Almoço com o time", "manager", 5),
                 ("Concluir o curso de NR-35", "user", 15)]
        for pos, (title, role, due) in enumerate(tasks):
            await self.ins("onboarding_template_tasks", template_id=tid, title=title, responsible_role=role,
                           due_days=due, position=pos)
        for key, started, done in (("igor", self.days(-20), 3), ("ana", self.days(-8), 3)):
            cid = await self.ins("onboarding_checklists", company_id=self.company_id, user_id=self.users[key],
                                 template_id=tid, template_name="Integração padrão", started_at=started,
                                 created_by=self.users["gestor"])
            for pos, (title, role, due) in enumerate(tasks):
                finished = pos < done
                await self.ins("onboarding_checklist_tasks", checklist_id=cid, title=title, responsible_role=role,
                               due_date=started + timedelta(days=due), position=pos,
                               completed_at=self.at(started + timedelta(days=pos), 10) if finished else None,
                               completed_by=self.users[key] if finished else None)

    async def surveys(self) -> None:
        self.survey_id = await self.ins(
            "engagement_surveys", company_id=self.company_id, title="Clima do segundo semestre",
            description="Leva 3 minutos. As respostas são anônimas.", anonymous=True, status="active",
            starts_at=self.days(-5), ends_at=self.days(10), created_by=self.users["gestor"],
        )
        qs = [("Como você avalia o seu bem-estar no trabalho?", "scale", None),
              ("Qual tema você gostaria de ver nos próximos workshops?", "choice",
               json.dumps(["Segurança", "Comunicação", "Ferramentas", "Liderança"])),
              ("O que podemos melhorar?", "text", None)]
        qids = []
        for pos, (text, kind, opts) in enumerate(qs):
            qids.append(await self.ins("survey_questions", survey_id=self.survey_id, text=text, type=kind,
                                       options=opts, position=pos))
        closed = await self.ins(
            "engagement_surveys", company_id=self.company_id, title="Pesquisa de benefícios",
            description="Quais benefícios fazem mais diferença para você?", anonymous=True, status="closed",
            starts_at=self.days(-60), ends_at=self.days(-45), created_by=self.users["gestor"],
        )
        cq = await self.ins("survey_questions", survey_id=closed, text="Quanto você está satisfeito com os benefícios?",
                            type="scale", position=0)
        rng = random.Random(3)
        for key in ("bruno", "carla", "diego", "eduarda", "helena"):
            rid = await self.ins("survey_responses", survey_id=self.survey_id, user_id=self.users[key],
                                 company_id=self.company_id)
            await self.ins("survey_answers", response_id=rid, question_id=qids[0], scale_value=rng.randint(3, 5))
            await self.ins("survey_answers", response_id=rid, question_id=qids[1],
                           choice_value=rng.choice(["Segurança", "Comunicação", "Liderança"]))
            await self.ins("survey_answers", response_id=rid, question_id=qids[2],
                           text_value="Mais momentos de integração entre as áreas.")
        for key in self.collaborators:
            rid = await self.ins("survey_responses", survey_id=closed, user_id=self.users[key], company_id=self.company_id)
            await self.ins("survey_answers", response_id=rid, question_id=cq, scale_value=rng.randint(2, 5))

    async def feedbacks(self) -> None:
        g = self.users["gestor"]
        rows = [
            ("Integração da Semana de Segurança", "Como foi a organização da SIPAT do ano passado?", "all", None, None),
            ("Rotina do time Comercial", "O novo fluxo de propostas ajudou no seu dia a dia?", "department",
             self.depts["Comercial"], None),
            ("Seu primeiro mês", "Como está sendo a sua adaptação?", "individual", None, self.users["igor"]),
        ]
        ids = []
        for title, question, ttype, dept, user in rows:
            ids.append(await self.ins("feedback_requests", company_id=self.company_id, created_by=g, title=title,
                                      question=question, target_type=ttype, target_department_id=dept,
                                      target_user_id=user))
        for key, idx, rating, comment in (("ana", 0, 5, "Muito bem organizada, gostei das oficinas."),
                                          ("bruno", 0, 4, "Boa, mas poderia ter mais horários."),
                                          ("carla", 1, 4, "Ajudou bastante a reduzir retrabalho."),
                                          ("igor", 2, 5, "O time me recebeu muito bem!")):
            await self.ins("feedback_responses", feedback_request_id=ids[idx], user_id=self.users[key],
                           rating=rating, comment=comment)

    async def documents(self) -> None:
        rows = [("Código de conduta", "codigo-de-conduta.pdf", "general", None, None),
                ("Manual do colaborador", "manual-do-colaborador.pdf", "general", None, None),
                ("Tabela de comissões — Comercial", "comissoes-comercial.pdf", "department", self.depts["Comercial"], None),
                ("Informe de rendimentos", "informe-rendimentos-ana.pdf", "individual", None, self.users["ana"])]
        for n, (title, fname, ttype, dept, user) in enumerate(rows):
            await self.ins("documents", company_id=self.company_id, uploaded_by=self.users["gestor"], title=title,
                           original_name=fname, file_path=f"/nao-existe/capturas/{fname}",
                           file_size=180_000 + n * 45_000, mime_type="application/pdf", target_type=ttype,
                           target_department_id=dept, target_user_id=user)

    async def videos(self) -> None:
        rows = [("Boas-vindas à Empresa Exemplo", "Um passeio pela empresa e pelo nosso jeito de trabalhar.", 420, 7, "all"),
                ("Uso correto dos EPIs", "Como vestir, conferir e guardar cada equipamento.", 600, 15, "all"),
                ("Técnicas de negociação", "Exemplos de conversas com clientes difíceis.", 900, 30, "Comercial"),
                ("Novidades do sistema de propostas", "O que mudou na tela de propostas.", 300, None, None)]
        self.video_ids = []
        for n, (title, desc, dur, due, target) in enumerate(rows):
            path = f"/nao-existe/capturas/video-{n + 1}.mp4"
            # O "Uso correto dos EPIs" é o da captura do player: esse ganha arquivo.
            real = f"{UPLOADS_DIR}/{self.company_id}/videos/capturas-{n + 1}.mp4"
            if n == 1 and placeholder_video(real, dur, title):
                path = real
            vid = await self.ins("internal_videos", company_id=self.company_id, title=title, description=desc,
                                 file_path=path, file_size=50_000_000 + n,
                                 duration_seconds=dur, due_days=due, created_by=self.users["gestor"],
                                 created_at=self.now - timedelta(days=20 - n * 4))
            self.video_ids.append(vid)
            if target == "all":
                await self.ins("internal_video_rules", video_id=vid, target_type="all")
            elif target:
                await self.ins("internal_video_rules", video_id=vid, target_type="department",
                               department_id=self.depts[target])
            await self.conn.execute("SELECT public.internal_video_apply_rules($1::uuid)", vid)
        # Progresso: concluído, em andamento, atrasado.
        await self.conn.execute(
            """UPDATE public.internal_video_viewers SET assigned_at = now() - interval '20 days',
                      max_watched_s = 420, completed_at = now() - interval '18 days', last_report_at = now()
               WHERE video_id = $1 AND user_id = ANY($2::uuid[])""",
            self.video_ids[0], [self.users[k] for k in ("ana", "bruno", "carla", "diego", "eduarda")],
        )
        await self.conn.execute(
            """UPDATE public.internal_video_viewers SET assigned_at = now() - interval '4 days',
                      max_watched_s = 260, last_report_at = now()
               WHERE video_id = $1 AND user_id = ANY($2::uuid[])""",
            self.video_ids[1], [self.users[k] for k in ("ana", "helena")],
        )
        await self.conn.execute(
            """UPDATE public.internal_video_viewers SET assigned_at = now() - interval '40 days'
               WHERE video_id = $1 AND user_id = ANY($2::uuid[])""",
            self.video_ids[2], [self.users[k] for k in ("igor",)],
        )

    async def bingo(self) -> None:
        rng = random.Random(42)
        pool = 90
        per = pool // 10
        self.bingo_game = await self.ins(
            "bingo_games", company_id=self.company_id, name="Bingo da Semana de Segurança", number_pool=pool,
            winners_target=3, near_threshold=2, status="running", created_by=self.users["gestor"],
            started_at=self.now - timedelta(hours=1),
        )
        for n, key in enumerate(self.collaborators):
            grid = [[None] * 10 for _ in range(3)]
            for col in range(10):
                low, high = sorted(rng.sample(range(col * per + 1, col * per + per + 1), 2))
                empty = rng.randrange(3)
                rows = [r for r in range(3) if r != empty]
                grid[rows[0]][col], grid[rows[1]][col] = low, high
            numbers = sorted(v for row in grid for v in row if v is not None)
            await self.ins("bingo_cards", game_id=self.bingo_game, company_id=self.company_id,
                           user_id=self.users[key], code=f"EX{n + 1:03d}", numbers=numbers, layout=json.dumps(grid))
        for order, number in enumerate(rng.sample(range(1, pool + 1), 24), 1):
            await self.ins("bingo_draws", game_id=self.bingo_game, company_id=self.company_id, number=number,
                           draw_order=order, drawn_by=self.users["gestor"])

    # ── RH ──────────────────────────────────────────────────────────────────

    async def absences(self) -> None:
        types = {}
        for name, color, approval in (("Férias", "#10b981", True), ("Folga", "#6366f1", True),
                                      ("Atestado médico", "#ef4444", False)):
            types[name] = await self.ins("absence_types", company_id=self.company_id, name=name, color=color,
                                         requires_approval=approval)
        rows = [("ana", "Férias", 30, 14, "approved", "Viagem em família."),
                ("ana", "Folga", 8, 1, "pending", "Banco de horas."),
                ("ana", "Atestado médico", -25, 1, "approved", "Consulta."),
                ("bruno", "Folga", 4, 1, "pending", "Mudança de casa."),
                ("carla", "Férias", -3, 10, "approved", None),
                ("diego", "Férias", 45, 20, "pending", None)]
        for key, tname, offset, n, st, reason in rows:
            reviewed = st != "pending"
            await self.ins("absence_requests", company_id=self.company_id, user_id=self.users[key],
                           type_id=types[tname], start_date=self.days(offset), end_date=self.days(offset + n - 1),
                           days=n, reason=reason, status=st,
                           reviewed_by=self.users["gestor"] if reviewed else None,
                           reviewed_at=self.now - timedelta(days=2) if reviewed else None)

    async def benefits(self) -> None:
        rows = [("Plano de saúde", "saude", "Cobertura nacional com coparticipação.", "Saúde Exemplo", "info", None),
                ("Vale-refeição", "alimentacao", "Crédito mensal no cartão.", "Cartão Exemplo", "fixed", 880),
                ("Vale-transporte", "transporte", "Passagens do trajeto casa-trabalho.", None, "variable", None),
                ("Auxílio academia", "bem_estar", "Desconto na rede de academias parceira.", "Academia Exemplo", "percentage", 50)]
        ids = []
        for name, cat, desc, provider, vtype, value in rows:
            ids.append(await self.ins("benefit_catalog", company_id=self.company_id, name=name, category=cat,
                                      description=desc, provider=provider, value_type=vtype, value=value))
        for key in self.collaborators + ["gestor"]:
            for i in (0, 1, 3):
                await self.ins("employee_benefits", company_id=self.company_id, user_id=self.users[key],
                               benefit_id=ids[i], start_date=self.days(-300))
        for key in ("ana", "bruno", "igor"):
            await self.ins("employee_benefits", company_id=self.company_id, user_id=self.users[key], benefit_id=ids[2],
                           start_date=self.days(-200), ticket_price=5.20, tickets_per_day=2)

    async def timeclock(self) -> None:
        rng = random.Random(5)
        for key in ("bruno", "diego", "helena"):
            d = self.today.replace(day=1)
            while d < self.today:
                if d.weekday() < 5:
                    jitter = rng.randint(-4, 4)
                    for hh, mm, kind in ((8, 2, "in"), (12, 0, "out"), (13, 1, "in"), (17, 32, "out")):
                        await self.ins("timeclock_punches", company_id=self.company_id, user_id=self.users[key],
                                       punched_at=self.at(d, hh, max(0, mm + jitter)), work_date=d, kind=kind,
                                       source="self")
                d += timedelta(days=1)
            if self.today.weekday() < 5:
                await self.ins("timeclock_punches", company_id=self.company_id, user_id=self.users[key],
                               punched_at=self.at(self.today, 8, 3), work_date=self.today, kind="in", source="self")
        # Um ajuste pendente do Bruno (a saída de um dia útil recente).
        punch = await self.conn.fetchrow(
            """SELECT id, punched_at FROM public.timeclock_punches
               WHERE user_id = $1 AND kind = 'out' ORDER BY punched_at DESC LIMIT 1""",
            self.users["bruno"],
        )
        if punch:
            await self.ins("timeclock_adjustment_requests", company_id=self.company_id, punch_id=str(punch["id"]),
                           user_id=self.users["bruno"], previous_punched_at=punch["punched_at"],
                           requested_punched_at=punch["punched_at"] + timedelta(minutes=48),
                           reason="Fiquei até mais tarde na visita ao cliente e esqueci de bater a saída.")

    async def salary(self) -> None:
        ref = await self.ins("salary_market_references", company_id=self.company_id, name="Pesquisa salarial Exemplo",
                             market="Serviços", region="Sudeste", reference_year=self.today.year)
        bands = {"Júnior": 3500, "Pleno": 5000, "Sênior": 7500}
        for family in ("Comercial", "Operações", "Recursos Humanos", "Tecnologia", "Financeiro"):
            for senior, base in bands.items():
                await self.ins("salary_table_entries", reference_id=ref, company_id=self.company_id,
                               job_family=family, seniority=senior, band_90=base * 0.9, band_95=base * 0.95,
                               band_100=base, band_105=base * 1.05, band_110=base * 1.1)

    async def misc(self) -> None:
        # Só tipos e títulos que o sistema cria (routers/videos.py e routers/custom_tests.py); os
        # "Novo vídeo para assistir" já saem de internal_video_apply_rules, em videos().
        for key, kind, title, msg in (
            ("ana", "video", "Vídeo atualizado: assista novamente", "Uso correto dos EPIs"),
            ("ana", "test_evaluated", "Resultado disponível",
             'Seu resultado em "Normas de segurança no trabalho" está disponível.'),
        ):
            await self.ins("notifications", user_id=self.users[key], type=kind, title=title, message=msg)
        # Linhas como as que app/middleware/audit.py grava: rótulo de _ACTION_MAP, caminho real
        # (com o id) e o status da resposta — a exclusão de benefício em uso responde 409.
        absence = await self.conn.fetchval(
            "SELECT id FROM public.absence_requests WHERE status = 'approved' ORDER BY start_date LIMIT 1")
        catalog = await self.conn.fetchval(
            "SELECT id FROM public.benefit_catalog WHERE company_id = $1 ORDER BY name LIMIT 1", self.company_id)
        feedback = await self.conn.fetchval(
            "SELECT id FROM public.feedback_requests WHERE company_id = $1 ORDER BY title LIMIT 1", self.company_id)
        actions = [
            ("gestor", "PUT", f"/absences/{absence}/approve", "Ausência aprovada", 200),
            ("gestor", "POST", "/videos", "Vídeo criado", 201),
            ("gestor", "POST", "/communications/announcements", "Comunicado publicado", 201),
            ("admin", "PUT", f"/collaborators/{self.users['igor']}", "Colaborador atualizado", 200),
            ("gestor", "POST", "/benefits/assign", "Benefício atribuído a colaborador", 201),
            ("gestor", "DELETE", f"/benefits/catalog/{catalog}", "Benefício removido do catálogo", 409),
            ("ana", "POST", "/absences/request", "Solicitação de ausência criada", 201),
            ("bruno", "POST", f"/feedbacks/{feedback}/respond", "Criação", 201),
            ("gestor", "POST", "/workshops", "Workshop criado", 201),
            ("admin", "POST", "/departments", "Departamento criado", 201),
        ]
        for n, (who, method, path, action, status) in enumerate(actions):
            await self.conn.execute(
                """INSERT INTO public.audit_logs (user_id, user_name, company_id, method, path, action, status_code,
                                                  ip_address, created_at)
                   VALUES ($1, $2, $3, $4, $5, $6, $7, '192.0.2.10', now() - make_interval(hours => $8))""",
                self.users[who], self.names[who], self.company_id, method, path, action, status, n * 5 + 1,
            )

    async def run(self) -> dict:
        await self.reset()
        await self.company()
        await self.people()
        await self.culture()
        await self.calendar()
        await self.goals()
        await self.evaluations()
        await self.custom_tests()
        await self.career()
        await self.pdi()
        await self.learning()
        await self.workshops()
        await self.announcements()
        await self.onboarding()
        await self.surveys()
        await self.feedbacks()
        await self.documents()
        await self.videos()
        await self.bingo()
        await self.absences()
        await self.benefits()
        await self.timeclock()
        await self.salary()
        await self.misc()
        return {
            "company": self.company_id,
            "users": self.users,
            "video": self.video_ids[1],
            "test": self.test_id,
            "draft_test": self.draft_test_id,
            "attempt": self.attempt_id,
            "bingo_game": self.bingo_game,
            "survey": self.survey_id,
            "eval_cycle": self.eval_cycle,
            "goals_cycle": self.mgmt_cycle,
        }


async def main() -> int:
    url = os.environ.get("CAPTURES_DATABASE_URL", DEFAULT_URL)
    if not allowed(url):
        print(f"Recusado: a semente apaga o banco inteiro e só roda num banco com 'capturas' no nome "
              f"(veio '{db_name(url)}').", file=sys.stderr)
        return 2
    conn = await asyncpg.connect(url)
    try:
        actual = await conn.fetchval("SELECT current_database()")
        if "capturas" not in actual:
            print(f"Recusado: a conexão caiu no banco '{actual}'.", file=sys.stderr)
            return 2
        async with conn.transaction():
            ids = await Seeder(conn).run()
    finally:
        await conn.close()
    print(f"Semente aplicada em {actual}.")
    print(json.dumps(ids))
    return 0


if __name__ == "__main__":
    sys.exit(asyncio.run(main()))
