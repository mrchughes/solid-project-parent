#!/bin/bash

# Script to clean up unnecessary services according to SERVICE_CLEANUP_PLAN.md

echo "Starting service cleanup process..."

# Create backup directory
mkdir -p ./backup/$(date +%Y%m%d)
BACKUP_DIR=./backup/$(date +%Y%m%d)

# List of services to be removed
SERVICES_TO_REMOVE=(
  "did-registry"
  "vc-verifier"
  "react-ui"
)

# Backup services before removal
for service in "${SERVICES_TO_REMOVE[@]}"; do
  if [ -d "$service" ]; then
    echo "Backing up $service to $BACKUP_DIR/$service"
    cp -r "$service" "$BACKUP_DIR/$service"
  fi
done

# Remove services
for service in "${SERVICES_TO_REMOVE[@]}"; do
  if [ -d "$service" ]; then
    echo "Removing $service directory..."
    rm -rf "$service"
  fi
done

echo "Service directories removed and backed up to $BACKUP_DIR"
echo "Services cleanup completed"
