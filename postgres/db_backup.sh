#!/bin/bash
## use: sh db_backup.sh
. ./.env

date=$(date "+%Y.%m.%d-%H.%M.%S")

# PostgreSQL database connection details

# Output file for the backup
BACKUP_FILE="backup-${date}.sql"

export PGPASSWORD="$DB_PASSWORD"

if [ -d $(pwd)/backups ];then
  continue 
  else 
    mkdir backups
fi
  

# Run pg_dump with the specified options
/usr/bin/pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -w > $(pwd)/backups/$BACKUP_FILE

# Unset the PGPASSWORD environment variable
unset PGPASSWORD

# Verificar se o Backup foi executado
if [ $? -eq 0 ]; then
  echo "Backup Completo! Nome do Backup: $BACKUP_FILE"
else
  echo "Backup Falhou."
fi