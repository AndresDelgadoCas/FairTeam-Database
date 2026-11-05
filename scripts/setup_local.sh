#!/usr/bin/env bash
# Builds a local FairTeam database: base schema, then every migration in order.
# Usage: scripts/setup_local.sh [database_name]   (uses the usual PG* environment variables)
set -euo pipefail

DB="${1:-fairteam_db}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

dropdb --if-exists "$DB"
createdb "$DB"

apply() {
  echo "-> $(basename "$1")"
  psql -q -v ON_ERROR_STOP=1 -d "$DB" -f "$1" >/dev/null
}

apply "$ROOT/schema.sql"
for file in "$ROOT"/migrations/[0-9][0-9][0-9]_*.sql; do
  apply "$file"
done
apply "$ROOT/migrations/R__ensure_teacher_data_isolation.sql"

echo "Base de datos $DB lista."
