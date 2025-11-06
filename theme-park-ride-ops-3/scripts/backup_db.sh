/theme-park-ride-ops/theme-park-ride-ops/scripts/backup_db.sh
#!/bin/bash

# Load environment variables from .env file
set -a
source ../.env
set +a

# Define backup file name with timestamp
BACKUP_FILE="backup_${DB_NAME}_$(date +'%Y%m%d_%H%M%S').sql"

# Perform the database backup
mysqldump -h $DB_HOST -P $DB_PORT -u $DB_USER -p$DB_PASS $DB_NAME > $BACKUP_FILE

# Check if the backup was successful
if [ $? -eq 0 ]; then
    echo "Backup successful: $BACKUP_FILE"
else
    echo "Backup failed"
    exit 1
fi