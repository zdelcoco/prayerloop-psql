#!/bin/bash
# backup_db.sh
#
# This script performs a pg_dump backup of a PostgreSQL database, using environment
# variables to configure the database user, database name, and backup directory.
# Environment variables set via .env file or exported in the shell before running this script.
#
# Required environment variables:
#   DB_USER     - Database username
#   DB_NAME     - Database name
#   PGPASSWORD  - Database password
#   PGHOST      - Database host
#   BACKUP_DIR  - Directory to store backups
#
# Optional:
#   USE_DOCKER  - Set to "true" to use Docker for pg_dump (needed for version mismatches)

set -e

DB_USER="${DB_USER}"
DB_NAME="${DB_NAME}"
BACKUP_DIR="${BACKUP_DIR}"
USE_DOCKER="${USE_DOCKER:-false}"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_${TIMESTAMP}.dump"

echo "Starting backup of database '${DB_NAME}'..."

if [ "$USE_DOCKER" = "true" ]; then
    echo "Using Docker (postgres:17) for pg_dump..."
    docker run --rm \
        -e PGPASSWORD="${PGPASSWORD}" \
        -v "${BACKUP_DIR}:${BACKUP_DIR}" \
        postgres:17 \
        pg_dump -h "${PGHOST}" -U "${DB_USER}" -d "${DB_NAME}" -F c -b -v -f "${BACKUP_FILE}"
else
    pg_dump -h "${PGHOST}" -U "${DB_USER}" -d "${DB_NAME}" -F c -b -v -f "${BACKUP_FILE}"
fi

# Verify backup was created and has content
if [ -s "${BACKUP_FILE}" ]; then
    echo "Backup of database '${DB_NAME}' completed successfully."
    echo "File saved to: ${BACKUP_FILE}"
    echo "Size: $(ls -lh "${BACKUP_FILE}" | awk '{print $5}')"
else
    echo "ERROR: Backup file is empty or was not created!"
    exit 1
fi
