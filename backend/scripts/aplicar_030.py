"""Aplica a migração 030 (progresso do tour guiado) no banco de produção do TalentHS.

Quem roda é o Erick, no Konsole (o Claude não roda). O interpretador precisa ter o
psycopg e o cadastro `bancos`; a venv do backend não tem nenhum dos dois, então use a
venv do projeto bancos:

    ~/projetos/bancos/.venv/bin/python backend/scripts/aplicar_030.py

Aplica o SQL numa única transação (tudo ou nada) e confere o resultado. Se
tour_progress já existir, recusa e não toca em nada.

Teste local: --dsn postgresql://erick:dev123@localhost:5432/talenths_test
(sem --dsn usa bancos.conectar("talenths", perfil="admin")).
"""
import argparse
import sys
from pathlib import Path

SQL_PATH = Path(__file__).resolve().parent.parent / "migrations" / "030_tour_progress.sql"

TABLE = "tour_progress"
CHECKS = [
    "tour_progress_tour_format",
    "tour_progress_version_range",
    "tour_progress_step_range",
    "tour_progress_invites_declined_nonneg",
]
UNIQUE = "tour_progress_user_tour_key"


def connect(dsn):
    if dsn:
        import psycopg

        return psycopg.connect(dsn)
    sys.path.insert(0, str(Path.home() / "projetos" / "bancos"))
    import bancos

    return bancos.conectar("talenths", perfil="admin")


def names(cur, query, params):
    cur.execute(query, params)
    return {r[0] for r in cur.fetchall()}


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--dsn", help="conexão alternativa (só para teste local)")
    args = ap.parse_args()

    sql = SQL_PATH.read_text(encoding="utf-8")
    with connect(args.dsn) as conn:
        with conn.cursor() as cur:
            if names(cur, "SELECT to_regclass('public.tour_progress')::text", ()) - {None}:
                print("ERRO: public.tour_progress já existe — a 030 parece já aplicada. Nada foi alterado.")
                sys.exit(1)

            cur.execute(sql)

            tables = names(cur, "SELECT table_name FROM information_schema.tables "
                                "WHERE table_schema='public' AND table_name = %s", (TABLE,))
            checks = names(cur, "SELECT conname FROM pg_constraint WHERE contype='c' "
                                "AND conrelid = 'public.tour_progress'::regclass AND conname = ANY(%s)", (CHECKS,))
            uniques = names(cur, "SELECT conname FROM pg_constraint WHERE contype='u' "
                                 "AND conrelid = 'public.tour_progress'::regclass AND conname = %s", (UNIQUE,))

            faltando = [] if tables else [f"tabela {TABLE}"]
            faltando += [f"check {x}" for x in CHECKS if x not in checks]
            faltando += [] if uniques else [f"unique {UNIQUE} (user_id, tour)"]
            if faltando:
                conn.rollback()
                print("ERRO: itens não encontrados após aplicar — rollback feito:", ", ".join(faltando))
                sys.exit(1)

        conn.commit()

    print("Migração 030 aplicada com sucesso (uma transação).")
    print(f"  Tabela: public.{TABLE}")
    print(f"  CHECKs ({len(checks)}/{len(CHECKS)}): {', '.join(sorted(checks))}")
    print(f"  UNIQUE (user_id, tour): {UNIQUE}")


if __name__ == "__main__":
    main()
