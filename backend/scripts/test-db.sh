#!/usr/bin/env bash
# Cria (ou recria) o banco talenths_test no Postgres local de teste
# (container pg-teste, ~/projetos/postgres-teste) e aplica as migrações em ordem.
set -euo pipefail

PGHOST="${PGHOST:-localhost}"
PGPORT="${PGPORT:-5432}"
PGUSER="${PGUSER:-erick}"
PGPASSWORD="${PGPASSWORD:-dev123}"
DB_NAME="${TEST_DB_NAME:-talenths_test}"
PGOPTIONS="-c client_min_messages=warning"
export PGHOST PGPORT PGUSER PGPASSWORD PGOPTIONS

MIGRATIONS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../migrations" && pwd)"

psql -v ON_ERROR_STOP=1 -q -d postgres -c "DROP DATABASE IF EXISTS ${DB_NAME} WITH (FORCE)"
psql -v ON_ERROR_STOP=1 -q -d postgres -c "CREATE DATABASE ${DB_NAME}"

for f in "${MIGRATIONS_DIR}"/0*.sql; do
  echo "aplicando $(basename "$f")"
  if [[ "$(basename "$f")" == 002_* ]]; then
    # Passo 1 da 002: ADD VALUE não roda dentro da transação da migração, então o
    # runner o executa à parte, antes do arquivo (ver comentário no topo da 002).
    psql -v ON_ERROR_STOP=1 -q -X -d "${DB_NAME}" \
      -c "ALTER TYPE public.app_role ADD VALUE IF NOT EXISTS 'manager'"
  fi
  psql -v ON_ERROR_STOP=1 -q -X -d "${DB_NAME}" -f "$f" >/dev/null
done

# Registra o que foi aplicado, para o backend (app/migrate.py) não aplicar de novo.
values=""
for f in "${MIGRATIONS_DIR}"/0*.sql; do
  name="$(basename "$f")"
  [[ "$name" == 000_* ]] && continue
  values+="${values:+,}($((10#${name:0:3})), '${name}')"
done
psql -v ON_ERROR_STOP=1 -q -X -d "${DB_NAME}" \
  -c "INSERT INTO public.schema_migrations (version, name) VALUES ${values} ON CONFLICT DO NOTHING"

echo
echo "export TEST_DATABASE_URL=postgresql://${PGUSER}:${PGPASSWORD}@${PGHOST}:${PGPORT}/${DB_NAME}"
