-- Controle das migrações aplicadas. O backend aplica sozinho, ao subir, as que
-- ainda não estão aqui (app/migrate.py); o test-db.sh registra as que aplica.
-- Idempotente: o backend roda este arquivo a cada subida, antes de ler a tabela.

CREATE TABLE IF NOT EXISTS public.schema_migrations (
    version integer PRIMARY KEY,
    name text NOT NULL,
    applied_at timestamptz NOT NULL DEFAULT now()
);
