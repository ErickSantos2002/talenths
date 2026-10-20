#!/usr/bin/env bash
# Cria (ou recria) o banco das capturas da Ajuda no Postgres local de teste
# (container pg-teste) e o deixa com o mesmo formato da produção.
#
# 1. aplica backend/migrations/ em ordem, como o test-db.sh;
# 2. aplica o que existe em produção mas não está nas migrações numeradas
#    (conferido com information_schema da produção pelo usuário de leitura):
#    - testes configuráveis (custom_tests, test_questions, test_question_options,
#      test_assignments, test_attempts e o test_responses novo), que só estão em
#      backend/supabase/migrations/20260520000002_custom_tests.sql. O
#      test_responses antigo (teste DISC, da 001) não existe mais em produção e
#      tem o mesmo nome, então sai antes;
#    - profiles.job_title (cadastro de colaboradores grava nela).
#
# Nada disto vira migração numerada: em produção essas tabelas já existem.
#
# Uso: bash backend/scripts/captures-db.sh   (CAPTURES_DB_NAME para outro nome,
# que precisa conter "capturas" — a semente recusa qualquer outro banco).
set -euo pipefail

DB_NAME="${CAPTURES_DB_NAME:-talenths_capturas}"
if [[ "${DB_NAME}" != *capturas* ]]; then
  echo "Recusado: o banco das capturas precisa ter 'capturas' no nome (veio '${DB_NAME}')." >&2
  exit 2
fi

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LEGACY_TESTS="${SCRIPTS_DIR}/../supabase/migrations/20260520000002_custom_tests.sql"

TEST_DB_NAME="${DB_NAME}" bash "${SCRIPTS_DIR}/test-db.sh" >/dev/null

PGHOST="${PGHOST:-localhost}"
PGPORT="${PGPORT:-5432}"
PGUSER="${PGUSER:-erick}"
PGPASSWORD="${PGPASSWORD:-dev123}"
PGOPTIONS="-c client_min_messages=warning"
export PGHOST PGPORT PGUSER PGPASSWORD PGOPTIONS

echo "aplicando o DDL que só existe em produção"
psql -v ON_ERROR_STOP=1 -q -X -d "${DB_NAME}" -1 \
  -c "DROP TABLE public.test_responses" \
  -f "${LEGACY_TESTS}" \
  -c "ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS job_title text" >/dev/null

echo "banco ${DB_NAME} pronto: postgresql://${PGUSER}:${PGPASSWORD}@${PGHOST}:${PGPORT}/${DB_NAME}"
