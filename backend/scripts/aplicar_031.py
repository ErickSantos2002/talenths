"""Aplica a migração 031 (ordem dos vídeos internos) no banco de produção do TalentHS.

Quem roda é o Erick, no Konsole (o Claude não roda). O interpretador precisa ter o
psycopg e o cadastro `bancos`; a venv do backend não tem nenhum dos dois, então use a
venv do projeto bancos:

    ~/projetos/bancos/.venv/bin/python backend/scripts/aplicar_031.py

Aplica o SQL numa única transação (tudo ou nada) e confere o resultado: coluna
position preenchida e NOT NULL, gatilho que põe vídeo novo no fim e nenhuma posição
repetida na mesma empresa. Se a coluna já existir, recusa e não toca em nada.

Teste local: --dsn postgresql://erick:dev123@localhost:5432/talenths_test
(sem --dsn usa bancos.conectar("talenths", perfil="admin")).
"""
import argparse
import sys
from pathlib import Path

SQL_PATH = Path(__file__).resolve().parent.parent / "migrations" / "031_internal_video_position.sql"
TRIGGER = "trg_internal_video_default_position"


def connect(dsn):
    if dsn:
        import psycopg

        return psycopg.connect(dsn)
    sys.path.insert(0, str(Path.home() / "projetos" / "bancos"))
    import bancos

    return bancos.conectar("talenths", perfil="admin")


def one(cur, query, params=()):
    cur.execute(query, params)
    return cur.fetchone()[0]


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--dsn", help="conexão alternativa (só para teste local)")
    args = ap.parse_args()

    sql = SQL_PATH.read_text(encoding="utf-8")
    with connect(args.dsn) as conn:
        with conn.cursor() as cur:
            exists = one(cur, "SELECT count(*) FROM information_schema.columns WHERE table_schema='public' "
                              "AND table_name='internal_videos' AND column_name='position'")
            if exists:
                print("ERRO: internal_videos.position já existe — a 031 parece já aplicada. Nada foi alterado.")
                sys.exit(1)

            cur.execute(sql)

            nullable = one(cur, "SELECT is_nullable FROM information_schema.columns WHERE table_schema='public' "
                                "AND table_name='internal_videos' AND column_name='position'")
            trigger = one(cur, "SELECT count(*) FROM pg_trigger WHERE tgname = %s "
                               "AND tgrelid = 'public.internal_videos'::regclass", (TRIGGER,))
            repeated = one(cur, "SELECT count(*) FROM (SELECT company_id, position FROM public.internal_videos "
                                "GROUP BY 1, 2 HAVING count(*) > 1) r")
            total = one(cur, "SELECT count(*) FROM public.internal_videos")

            faltando = []
            if nullable != "NO":
                faltando.append("position NOT NULL")
            if not trigger:
                faltando.append(f"gatilho {TRIGGER}")
            if repeated:
                faltando.append(f"{repeated} posição(ões) repetida(s)")
            if faltando:
                conn.rollback()
                print("ERRO: conferência falhou após aplicar — rollback feito:", ", ".join(faltando))
                sys.exit(1)

            cur.execute(
                "SELECT position, title FROM public.internal_videos ORDER BY company_id, position"
            )
            ordem = cur.fetchall()

        conn.commit()

    print("Migração 031 aplicada com sucesso (uma transação).")
    print(f"  Vídeos numerados: {total} (o mais novo ficou em 1º, como aparecia antes)")
    for position, title in ordem:
        print(f"    {position}º  {title}")
    print(f"  Gatilho: {TRIGGER} (vídeo novo entra no fim)")


if __name__ == "__main__":
    main()
