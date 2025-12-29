#!/bin/bash
# cleanup_old_archives.sh
#
# Deletes archived backup files older than 30 days.
# Designed to run in the archive directory (e.g., ~/bak/arc).
#
# Usage: ./cleanup_old_archives.sh [archive_dir]
#   archive_dir - Directory containing archived backups (default: current directory)
#
# Can be run via cron, e.g.:
#   0 3 * * * /home/ec2-user/src/scripts/cleanup_old_archives.sh /home/ec2-user/bak/arc

set -e

ARCHIVE_DIR="${1:-.}"
DAYS_OLD=30

echo "Deleting archived files older than $DAYS_OLD days in $ARCHIVE_DIR..."

# Find compressed backup files older than 30 days
FILES_DELETED=0
while IFS= read -r -d '' file; do
    filename=$(basename "$file")
    echo "Deleting: $filename"
    rm "$file"
    ((FILES_DELETED++)) || true
done < <(find "$ARCHIVE_DIR" -maxdepth 1 \( -name "*.dump.gz" -o -name "cron.log.*.gz" \) -type f -mtime +$DAYS_OLD -print0)

echo "Cleanup complete. $FILES_DELETED file(s) deleted."

# Rotate cron.log if it exists and is larger than 1MB
BACKUP_DIR=$(dirname "$ARCHIVE_DIR")
CRON_LOG="${BACKUP_DIR}/cron.log"
if [ -f "$CRON_LOG" ]; then
    LOG_SIZE=$(stat -f%z "$CRON_LOG" 2>/dev/null || stat -c%s "$CRON_LOG" 2>/dev/null || echo 0)
    if [ "$LOG_SIZE" -gt 1048576 ]; then
        echo "Rotating cron.log (size: $LOG_SIZE bytes)..."
        gzip -c "$CRON_LOG" > "${ARCHIVE_DIR}/cron.log.$(date +%Y%m%d).gz"
        : > "$CRON_LOG"
        echo "cron.log rotated."
    fi
fi
