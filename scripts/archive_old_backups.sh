#!/bin/bash
# archive_old_backups.sh
#
# Compresses backup files older than 7 days and moves them to an arc/ subdirectory.
# Designed to run in the backup directory (e.g., ~/bak).
#
# Usage: ./archive_old_backups.sh [backup_dir]
#   backup_dir - Directory containing backups (default: current directory)
#
# Can be run via cron, e.g.:
#   0 2 * * * /home/ec2-user/src/scripts/archive_old_backups.sh /home/ec2-user/bak

set -e

BACKUP_DIR="${1:-.}"
ARCHIVE_DIR="${BACKUP_DIR}/arc"
DAYS_OLD=7

# Ensure archive directory exists
mkdir -p "$ARCHIVE_DIR"

echo "Archiving backup files older than $DAYS_OLD days in $BACKUP_DIR..."

# Find .dump files older than 7 days
FILES_ARCHIVED=0
while IFS= read -r -d '' file; do
    filename=$(basename "$file")
    echo "Compressing: $filename"

    # Compress the file
    gzip -c "$file" > "${ARCHIVE_DIR}/${filename}.gz"

    # Verify compression succeeded before deleting original
    if [ -s "${ARCHIVE_DIR}/${filename}.gz" ]; then
        rm "$file"
        echo "  -> Archived to ${ARCHIVE_DIR}/${filename}.gz"
        ((FILES_ARCHIVED++)) || true
    else
        echo "  -> ERROR: Compression failed, keeping original"
        rm -f "${ARCHIVE_DIR}/${filename}.gz"
    fi
done < <(find "$BACKUP_DIR" -maxdepth 1 -name "*.dump" -type f -mtime +$DAYS_OLD -print0)

echo "Archive complete. $FILES_ARCHIVED file(s) archived."
