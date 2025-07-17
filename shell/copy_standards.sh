#!/bin/bash

# Script to copy standards documents to each service directory

# Standards documents
STANDARDS=(
  "docs/ERROR_HANDLING_STANDARDS.md"
  "docs/DATA_MODELS.md"
  "docs/GOVUK_DESIGN_SYSTEM_GUIDE.md"
  "docs/SERVICE_IMPLEMENTATION_CHECKLIST_V2.md"
  "docs/STANDARDS_IMPLEMENTATION_GUIDE.md"
)

# Service directories
SERVICES=(
  "api-registry"
  "solid-pds"
  "DRO"
  "vc-verifier"
  "FEP"
)

# Copy standards to each service directory
for service in "${SERVICES[@]}"; do
  echo "Copying standards to $service..."
  
  # Create docs directory in service if it doesn't exist
  mkdir -p "$service/docs"
  
  # Copy each standard document
  for standard in "${STANDARDS[@]}"; do
    filename=$(basename "$standard")
    cp "$standard" "$service/docs/$filename"
    echo "  Copied $filename"
  done
  
  echo "Done copying standards to $service"
done

echo "All standards have been copied to service directories"
