#!/bin/bash

# Check if the script is run by the root user
if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as the root user."
    exit 1
fi

## SSH Info
REMOTE_USER="root"
REMOTE_SERVER="homeserver.lan"
## Nextcloud Info
NC_CONTAINER_NAME="nextcloud"
NC_DB_CONTAINER_NAME="ncdb"
NC_DB_NAME="nextclouddb"
NC_DB_USER="nextcloud"
NC_DB_PASSWORD="DATABASE_PASSWORD"
## Backup Paths
BACKUP_FROM="/storage/"
BACKUP_TO="/backup/homeserver/storage/"
NC_DB_BACKUP_PATH="/backup/homeserver/NCDB/"

# Set the script to exit on any error
set -e

# Task Started
echo "Backup Task Started"

# Set Nextcloud to maintenance mode
ssh "$REMOTE_USER@$REMOTE_SERVER" "docker exec -u www-data $NC_CONTAINER_NAME php occ maintenance:mode --on"
# Minimum 60s delay required
sleep 60

# Perform the backup using rsync
rsync -AaXxHh --progress --delete --partial --append "$REMOTE_USER@$REMOTE_SERVER:$BACKUP_FROM" "$BACKUP_TO"
echo "Sync complete."

sleep 2

# Backup Nextcloud database using mysqldump
ssh "$REMOTE_USER@$REMOTE_SERVER" "docker exec $NC_DB_CONTAINER_NAME mariadb-dump --single-transaction -u $NC_DB_USER -p$NC_DB_PASSWORD $NC_DB_NAME" > "$NC_DB_BACKUP_PATH/nextcloud_database.sql"
echo "Nextcloud Database Dumped"

sleep 2

# Turn off Nextcloud maintenance mode
ssh "$REMOTE_USER@$REMOTE_SERVER" "docker exec -u www-data $NC_CONTAINER_NAME php occ maintenance:mode --off"


# Task Completed
echo "Backup Task Completed"
