#!/usr/bin/env bash
# Copies a whole FairTeam database (schema, data and Flyway history) into a new, empty one.
# Usage: scripts/copy_database.sh "$OLD_DATABASE_URL" "$NEW_DATABASE_URL"
#
# Use the External Database URLs from Render (postgresql://user:password@host/db). Do this
# BEFORE starting the backend against the new database, or Flyway will create empty tables first.
#
# Why the extra steps: the tables use FORCE ROW LEVEL SECURITY, so even their owner only sees the
# rows of the teacher in the session and a plain pg_dump fails. The script lifts FORCE on the source
# only while dumping, puts it back on both databases, and verifies isolation on the target.
set -euo pipefail

SOURCE="${1:?Falta la URL de la base origen}"
TARGET="${2:?Falta la URL de la base destino}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

existing=$(psql "$TARGET" -tAc "SELECT count(*) FROM pg_tables WHERE schemaname = 'public'")
if [ "$existing" != "0" ]; then
  echo "La base destino ya tiene $existing tablas. Usa una base vacía." >&2
  exit 1
fi

forced_tables=$(psql "$SOURCE" -tAc "
  SELECT string_agg(quote_ident(c.relname), ' ')
  FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace AND n.nspname = 'public'
  WHERE c.relkind = 'r' AND c.relforcerowsecurity")

set_force() {  # $1 = url, $2 = FORCE | NO FORCE
  [ -z "$forced_tables" ] && return 0
  local sql=""
  for table in $forced_tables; do sql+="ALTER TABLE public.$table $2 ROW LEVEL SECURITY; "; done
  psql "$1" -q -v ON_ERROR_STOP=1 -c "$sql"
}

restore_source() { set_force "$SOURCE" "FORCE"; }
trap restore_source EXIT

echo "-> Copiando datos..."
set_force "$SOURCE" "NO FORCE"
pg_dump --no-owner --no-acl --format=custom "$SOURCE" \
  | pg_restore --no-owner --no-acl --exit-on-error --dbname="$TARGET"
restore_source
trap - EXIT

echo "-> Restaurando el aislamiento en la base destino..."
set_force "$TARGET" "FORCE"
psql "$TARGET" -q -v ON_ERROR_STOP=1 -f "$ROOT/scripts/verify_rls.sql" >/dev/null

echo "Copia terminada. Ahora apunta SPRING_DATASOURCE_* del backend a la base nueva."
