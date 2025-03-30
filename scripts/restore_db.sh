#!/bin/bash
# restore_db.sh
# 
# Usage: ./restore_db.sh <backup_file> <target_db>
# Example: ./restore_db.sh /path/to/zdelcoco_test1_backup.dump zdelcoco_test1
#
# Environment variable:
#   DB_USER (optional) - Specifies the database user; defaults to 'postgres' if not set.

if [ $# -ne 2 ]; then
  echo "Usage: $0 <backup_file> <target_db>"
  exit 1
fi

BACKUP_FILE="$1"
TARGET_DB="$2"
DB_USER="${DB_USER:-postgres}"

echo "Restoring database '$TARGET_DB' from file '$BACKUP_FILE' as user '$DB_USER'..."
dropdb -U "$DB_USER" "$TARGET_DB" 2>/dev/null
createdb -U "$DB_USER" "$TARGET_DB"
pg_restore -U "$DB_USER" -d "$TARGET_DB" -v "$BACKUP_FILE"
echo "Restore complete."
