/scripts/backup_db.sh # This script is for backing up the database

#!/bin/bash

# Load environment variables from .env file
set -o allexport
source ../.env
set +o allexport

# Define backup file name with timestamp
BACKUP_FILE="backup_${DB_NAME}_$(date +%Y%m%d%H%M%S).sql"

# Create a backup of the MariaDB database
docker exec mariadb_container_name /usr/bin/mysqldump -u ${DB_USER} -p${DB_PASS} ${DB_NAME} > ${BACKUP_FILE}

# Check if the backup was successful
if [ $? -eq 0 ]; then
  echo "Backup successful! Backup file: ${BACKUP_FILE}"
else
  echo "Backup failed!"
  exit 1
fi