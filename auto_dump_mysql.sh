#!/bin/bash

# MySQL connection
DB_USER="root"
DB_PASSWORD="your_password"
DB_NAME="your_database"

# Dir for dumps
BACKUP_DIR="/root/mysql_dumps/dumps"

# Actual date
DATE=$(date +'%Y-%m-%d')

# Dump name
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_backup_${DATE}.sql"

# Creation of dump
mysqldump -u${DB_USER} -p${DB_PASSWORD} ${DB_NAME} > ${BACKUP_FILE}

# Check correctness of execution
if [ $? -eq 0 ]; then
  echo "Backup successful: ${BACKUP_FILE}"
else
  echo "Backup failed for database: ${DB_NAME}"
fi

# Найти и сохранить список старых дампов
OLD_BACKUPS=$(find ${BACKUP_DIR} -type f -name "*.sql" -mtime +7)

# Удаление старых дампов
if [ -n "$OLD_BACKUPS" ]; then
  echo "Removing old backups:"
  echo "$OLD_BACKUPS" | tee -a /var/log/mysql_backup.log | xargs rm -f
  echo "Old backups removed."
else
  echo "No old backups to remove."
fi
