#!/bin/bash
# backup_db.sh
# 
# This script performs a pg_dump backup of a PostgreSQL database, using environment
# variables to configure the database user, database name, and backup directory.
# environment variables set via .env file or exported in the shell before running this script.

DB_USER="${DB_USER}"          
DB_NAME="${DB_NAME}"  
BACKUP_DIR="${BACKUP_DIR}" 

TIMESTAMP=$(date +%Y%m%d_%H%M%S)

BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_${TIMESTAMP}.dump"

pg_dump -U "${DB_USER}" -d "${DB_NAME}" -F c -b -v -f "${BACKUP_FILE}"

echo "Backup of database '${DB_NAME}' completed. File saved to: ${BACKUP_FILE}"
