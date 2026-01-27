#!/bin/bash
set -e

LOG="/var/log/cloud-backup.log"
BACKUP_DIR="/mnt/backup-hdd/cloud"
SOURCE_DIR="/srv/cloud/files"
DATE="$(date +%Y-%m-%d_%H-%M-%S)"
ARCHIVE_NAME="backup-${DATE}.tar.gz"
CLOUD_DOCKER_COMPOSE_DIR="/opt/git/Utils/homelab/cloud/"

echo "==== Backup started: $(date) ====" >> "$LOG"

if ! mountpoint -q /mnt/backup-hdd; then
  echo "Backup disk not mounted!" >> "$LOG"
  exit 1
fi

mkdir -p "$BACKUP_DIR"

docker compose -f "${CLOUD_DOCKER_COMPOSE_DIR}/docker-compose.yml" down

tar -czf "${BACKUP_DIR}/${ARCHIVE_NAME}" \
  -C "$SOURCE_DIR" . >> "$LOG" 2>&1

docker compose -f "${CLOUD_DOCKER_COMPOSE_DIR}/docker-compose.yml" up -d

find "$BACKUP_DIR" -name "backup-*.tar.gz" -mtime +14 -delete

echo "Backup created: ${ARCHIVE_NAME}" >> "$LOG"
echo "==== Backup finished: $(date) ====" >> "$LOG"

