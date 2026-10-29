"""Aplica a migração 032 (desligamento de colaboradores) no banco de produção do TalentHS.

Quem roda é o Erick, no Konsole (o Claude não roda). O interpretador precisa ter o
psycopg e o cadastro `bancos`; a venv do backend não tem nenhum dos dois, então use a
venv do projeto bancos:

    ~/projetos/bancos/.venv/bin/python backend/scripts/aplicar_032.py

Aplica o SQL numa única transação (tudo ou nada) e confere o resultado: coluna
profiles.deactivated_at, tabela collaborator_terminations com o índice de um
desligamento em aberto por pessoa, e o gatilho de vídeos disparando também na
reativação. Se a coluna já existir, recusa e não toca em nada.

Teste local: --dsn postgresql://erick:dev123@localhost:5432/talenths_test
(sem --dsn usa bancos.conectar("talenths", perfil="admin")).
"""
import argparse
import sys
from pathlib import Path

SQL_PATH = Path(__file__).resolve().parent.parent / "migrations" / "032_collaborator_deactivation.sql"
TRIGGER = "trg_profiles_internal_videos"
INDEX = "uq_collaborator_terminations_open"


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
    with connect(args.dsn) as conn:
        with conn.cursor() as cur:
            exists = one(cur, "SELECT count(*) FROM information_schema.columns WHERE table_schema='public' "
                              "AND table_name='profiles' AND column_name='deactivated_at'")
            if exists:
                print("ERRO: profiles.deactivated_at já existe — a 032 parece já aplicada. Nada foi alterado.")
                sys.exit(1)

            cur.execute(sql)

            table = one(cur, "SELECT to_regclass('public.collaborator_terminations') IS NOT NULL")
            index = one(cur, "SELECT count(*) FROM pg_indexes WHERE schemaname='public' AND indexname = %s",
                        (INDEX,))
            trigger_def = one(cur, "SELECT pg_get_triggerdef(oid) FROM pg_trigger WHERE tgname = %s "
                                   "AND tgrelid = 'public.profiles'::regclass", (TRIGGER,))
            total = one(cur, "SELECT count(*) FROM public.profiles")

            faltando = []
            if not table:
                faltando.append("tabela collaborator_terminations")
            if not index:
                faltando.append(f"índice {INDEX}")
            if not trigger_def or "deactivated_at" not in trigger_def:
                faltando.append(f"gatilho {TRIGGER} com deactivated_at")
            if faltando:
                conn.rollback()
                print("ERRO: conferência falhou após aplicar — rollback feito:", ", ".join(faltando))
                sys.exit(1)

        conn.commit()

    print("Migração 032 aplicada com sucesso (uma transação).")
    print(f"  Perfis: {total}, todos ativos (ninguém desligado ainda)")
    print("  Tabela collaborator_terminations criada")
    print(f"  Gatilho {TRIGGER}: dispara também na reativação")


if __name__ == "__main__":
    main()
