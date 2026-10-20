"""Aplica a migração 029 (vídeos internos) no banco de produção do TalentHS.

Quem roda é o Erick, no Konsole (o Claude não roda). O interpretador precisa ter o
psycopg e o cadastro `bancos`; a venv do backend não tem nenhum dos dois, então use a
venv do projeto bancos:

    ~/projetos/bancos/.venv/bin/python backend/scripts/aplicar_029.py

Aplica o SQL numa única transação (tudo ou nada) e confere o resultado. Se
internal_videos já existir, recusa e não toca em nada.

Teste local: --dsn postgresql://erick:dev123@localhost:5432/talenths_test
(sem --dsn usa bancos.conectar("talenths", perfil="admin")).
"""
import argparse
import sys
from pathlib import Path

SQL_PATH = Path(__file__).resolve().parent.parent / "migrations" / "029_internal_videos.sql"

TABLES = ["internal_videos", "internal_video_rules", "internal_video_viewers", "internal_video_uploads"]
TRIGGERS = ["trg_profiles_internal_videos", "trg_profiles_internal_videos_snapshot"]
FUNCTIONS = [
    "internal_video_assign",
    "internal_video_apply_rules",
    "internal_videos_on_profile_change",
    "internal_videos_snapshot_profile",
]


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
            if names(cur, "SELECT to_regclass('public.internal_videos')::text", ()) - {None}:
                print("ERRO: public.internal_videos já existe — a 029 parece já aplicada. Nada foi alterado.")
                sys.exit(1)

            cur.execute(sql)

            tables = names(cur, "SELECT table_name FROM information_schema.tables "
                                "WHERE table_schema='public' AND table_name = ANY(%s)", (TABLES,))
            triggers = names(cur, "SELECT t.tgname FROM pg_trigger t WHERE NOT t.tgisinternal "
                                  "AND t.tgrelid = 'public.profiles'::regclass AND t.tgname = ANY(%s)", (TRIGGERS,))
            functions = names(cur, "SELECT p.proname FROM pg_proc p JOIN pg_namespace n ON n.oid=p.pronamespace "
                                   "WHERE n.nspname='public' AND p.proname = ANY(%s)", (FUNCTIONS,))

            faltando = [f"tabela {x}" for x in TABLES if x not in tables]
            faltando += [f"trigger {x}" for x in TRIGGERS if x not in triggers]
            faltando += [f"função {x}" for x in FUNCTIONS if x not in functions]
            if faltando:
                conn.rollback()
                print("ERRO: itens não encontrados após aplicar — rollback feito:", ", ".join(faltando))
                sys.exit(1)

        conn.commit()

    print("Migração 029 aplicada com sucesso (uma transação).")
    print(f"  Tabelas ({len(tables)}/{len(TABLES)}): {', '.join(sorted(tables))}")
    print(f"  Triggers em public.profiles ({len(triggers)}/{len(TRIGGERS)}): {', '.join(sorted(triggers))}")
    print(f"  Funções ({len(functions)}/{len(FUNCTIONS)}): {', '.join(sorted(functions))}")


if __name__ == "__main__":
    main()
