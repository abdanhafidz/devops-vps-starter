#!/bin/bash

BACKUP_DIR="./backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
mkdir -p $BACKUP_DIR
CONFIG_DIR="./cmd/config"

# Load essential vars just for script usage (optional, if needed for pg_dump args)
source $CONFIG_DIR/app.env

echo "📦 Starting backup..."

# Backup Postgres
# Note: We execute inside the container, so we use the internal user/env
docker compose exec -t postgres_main pg_dumpall -c -U $POSTGRES_USER > $BACKUP_DIR/db_dump_$TIMESTAMP.sql

# Archive Data Volumes
tar -czf $BACKUP_DIR/uptimekuma_$TIMESTAMP.tar.gz app/sysadmin/uptimekuma

# Backup Configs (Important!)
tar -czf $BACKUP_DIR/config_$TIMESTAMP.tar.gz $CONFIG_DIR

echo "✅ Backup saved to $BACKUP_DIR"
