"""Aplica a migração 033 (conclusão de vídeo registrada pelo RH) no banco de produção do TalentHS.

Quem roda é o Erick, no Konsole (o Claude não roda). O interpretador precisa ter o
psycopg e o cadastro `bancos`; a venv do backend não tem nenhum dos dois, então use a
venv do projeto bancos:

    ~/projetos/bancos/.venv/bin/python ~/github/talenths/backend/scripts/aplicar_033.py

Aplica o SQL numa única transação (tudo ou nada) e confere o resultado: colunas
completed_by e completed_registered_at em internal_video_viewers e a regra que impede
registro do RH sem data de conclusão. Se a coluna já existir, recusa e não toca em nada.

Teste local: --dsn postgresql://erick:dev123@localhost:5432/talenths_test
(sem --dsn usa bancos.conectar("talenths", perfil="admin")).
"""
import argparse
import sys
from pathlib import Path

SQL_PATH = Path(__file__).resolve().parent.parent / "migrations" / "033_video_completion_by_hr.sql"
CHECK = "internal_video_viewers_registered_completed"


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
    columns_sql = ("SELECT count(*) FROM information_schema.columns WHERE table_schema='public' "
                   "AND table_name='internal_video_viewers' AND column_name IN ('completed_by', 'completed_registered_at')")
    with connect(args.dsn) as conn:
        with conn.cursor() as cur:
            if one(cur, columns_sql):
                print("ERRO: internal_video_viewers.completed_by já existe — a 033 parece já aplicada. Nada foi alterado.")
                sys.exit(1)

            cur.execute(sql)

            columns = one(cur, columns_sql)
            check = one(cur, "SELECT count(*) FROM pg_constraint WHERE conname = %s", (CHECK,))
            completed = one(cur, "SELECT count(*) FROM public.internal_video_viewers WHERE completed_at IS NOT NULL")

            faltando = []
            if columns != 2:
                faltando.append("colunas completed_by/completed_registered_at")
            if not check:
                faltando.append(f"regra {CHECK}")
            if faltando:
                conn.rollback()
                print("ERRO: conferência falhou após aplicar — rollback feito:", ", ".join(faltando))
                sys.exit(1)

        conn.commit()

    print("Migração 033 aplicada com sucesso (uma transação).")
    print(f"  Conclusões já existentes: {completed}, todas marcadas como assistidas pelo sistema")
    print("  O RH já pode registrar quem viu os vídeos antes")


if __name__ == "__main__":
    main()
