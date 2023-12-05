## Sync Nextcloud data from homeserver to PC:

#!/bin/bash

## Check if the script is run by the root user
if [ "$EUID" -ne 0 ]; then
   echo "Error: This script must be run as the root user."
   exit 1
fi

## Set your server and paths
REMOTE_USER="root"
REMOTE_SERVER="homeserveraddress.lan"
DOCKER_CONTAINER_NAME="nextcloud"
DB_CONTAINER_NAME="ncdb"
DB_NAME="nextclouddb"
DB_USER="nextcloud"
DB_PASSWORD="DATABASE_PASSWORD"
NEXTCLOUD_DATA_PATH="/storage/data/docker/nextcloud/"
NEXTCLOUD_LOCAL_BACKUP_PATH="/backup/homeserver/Nextcloud/nextcloud"
DATABASE_LOCAL_BACKUP_PATH="/backup/homeserver/Nextcloud/Database"

## Set the script to exit on any error
set -e

## Task Started
echo "Task Started"

## Set Nextcloud to maintenance mode
ssh "$REMOTE_USER@$REMOTE_SERVER" "docker exec -u www-data $DOCKER_CONTAINER_NAME php occ maintenance:mode --on"

## Minimum 60s delay required
sleep 60

## Perform the backup using rsync
rsync -AaXxHh --delete --partial --append "$REMOTE_USER@$REMOTE_SERVER:$NEXTCLOUD_DATA_PATH" "$NEXTCLOUD_LOCAL_BACKUP_PATH"
echo "Sync complete."

sleep 2

## Backup Nextcloud database using mysqldump
ssh "$REMOTE_USER@$REMOTE_SERVER" "docker exec $DB_CONTAINER_NAME mariadb-dump --single-transaction -u $DB_USER -p$DB_PASSWORD $DB_NAME" > "$DATABASE_LOCAL_BACKUP_PATH/nextcloud_database.sq
l"
echo "Database Dumped"

sleep 2

## Turn off maintenance mode
ssh "$REMOTE_USER@$REMOTE_SERVER" "docker exec -u www-data $DOCKER_CONTAINER_NAME php occ maintenance:mode --off"

## Task Completed
echo "Task Completed"
