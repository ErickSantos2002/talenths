"""Aplica a migração 034 (progresso nas trilhas da plataforma de cursos) no banco de produção do TalentHS.

Quem roda é o Erick, no Konsole (o Claude não roda). O interpretador precisa ter o
psycopg e o cadastro `bancos`; a venv do backend não tem nenhum dos dois, então use a
venv do projeto bancos:

    ~/projetos/bancos/.venv/bin/python ~/github/talenths/backend/scripts/aplicar_034.py

Aplica o SQL numa única transação (tudo ou nada) e confere que a tabela
learning_track_progress existe. Se ela já existir, recusa e não toca em nada.

Teste local: --dsn postgresql://erick:dev123@localhost:5432/talenths_test
(sem --dsn usa bancos.conectar("talenths", perfil="admin")).
"""
import argparse
import sys
from pathlib import Path

SQL_PATH = Path(__file__).resolve().parent.parent / "migrations" / "034_learning_track_progress.sql"


def connect(dsn):
    if dsn:
        import psycopg

        return psycopg.connect(dsn)
    sys.path.insert(0, str(Path.home() / "projetos" / "bancos"))
    import bancos

    return bancos.conectar("talenths", perfil="admin")


def one(cur, query, params=()):
    cur.execute(query, params)
    row = cur.fetchone()
    return row[0] if row else None


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--dsn", help="conexão alternativa (só para teste local)")
    args = ap.parse_args()

    sql = SQL_PATH.read_text(encoding="utf-8")
    exists_sql = "SELECT to_regclass('public.learning_track_progress') IS NOT NULL"
    with connect(args.dsn) as conn:
        with conn.cursor() as cur:
            if one(cur, exists_sql):
                print("ERRO: learning_track_progress já existe — a 034 parece já aplicada. Nada foi alterado.")
                sys.exit(1)

            cur.execute(sql)

            if not one(cur, exists_sql):
                conn.rollback()
                print("ERRO: conferência falhou após aplicar — rollback feito: tabela learning_track_progress")
                sys.exit(1)

        conn.commit()

    print("Migração 034 aplicada com sucesso (uma transação).")
    print("  Tabela learning_track_progress criada")
    print("  A Universidade já aceita o CSV exportado da plataforma de cursos")


if __name__ == "__main__":
    main()
