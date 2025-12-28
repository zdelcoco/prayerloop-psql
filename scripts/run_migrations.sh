#!/bin/bash
# run_migrations.sh - Run pending database migrations
# Usage: ./run_migrations.sh
# Requires: PRAYERLOOP_DB_URL environment variable

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MIGRATIONS_DIR="${SCRIPT_DIR}/../migrations"

# Check for required environment variable
if [ -z "$PRAYERLOOP_DB_URL" ]; then
    echo "Error: PRAYERLOOP_DB_URL environment variable is not set"
    echo "Format: postgres://user:password@host:port/dbname?sslmode=require"
    exit 1
fi

echo "=== Running Database Migrations ==="
echo "Migrations directory: $MIGRATIONS_DIR"

# Ensure migrations tracking table exists
echo "Ensuring migrations tracking table exists..."
psql "$PRAYERLOOP_DB_URL" -f "${MIGRATIONS_DIR}/000_create_migrations_table.sql" 2>/dev/null || true

# Get list of applied migrations
echo "Checking for pending migrations..."
APPLIED=$(psql "$PRAYERLOOP_DB_URL" -t -c "SELECT filename FROM _migrations ORDER BY filename;" 2>/dev/null | tr -d ' ')

# Run each migration file in order
MIGRATIONS_RUN=0
for migration in $(ls -1 "${MIGRATIONS_DIR}"/*.sql | sort); do
    filename=$(basename "$migration")

    # Skip the migrations table creation script
    if [ "$filename" = "000_create_migrations_table.sql" ]; then
        continue
    fi

    # Check if migration has already been applied
    if echo "$APPLIED" | grep -q "^${filename}$"; then
        echo "  [SKIP] $filename (already applied)"
        continue
    fi

    # Run the migration
    echo "  [RUN]  $filename"
    if psql "$PRAYERLOOP_DB_URL" -f "$migration"; then
        # Record successful migration
        psql "$PRAYERLOOP_DB_URL" -c "INSERT INTO _migrations (filename) VALUES ('$filename');" > /dev/null
        MIGRATIONS_RUN=$((MIGRATIONS_RUN + 1))
    else
        echo "Error: Migration $filename failed!"
        exit 1
    fi
done

if [ $MIGRATIONS_RUN -eq 0 ]; then
    echo "No pending migrations to run."
else
    echo "Successfully ran $MIGRATIONS_RUN migration(s)."
fi

echo "=== Migrations Complete ==="
