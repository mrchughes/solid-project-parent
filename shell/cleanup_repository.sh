#!/bin/bash

# Repository Cleanup Script
# This script performs the cleanup actions outlined in the REPOSITORY_CLEANUP_PLAN.md document

echo "Starting repository cleanup..."

# 1. Remove unnecessary modules
echo "Removing unnecessary modules..."

# Remove react-ui submodule
if [ -d "react-ui" ]; then
    echo "Removing react-ui submodule..."
    git submodule deinit -f react-ui
    git rm -f react-ui
    rm -rf .git/modules/react-ui
fi

# Remove solid-microservices submodule
if [ -d "solid-microservices" ]; then
    echo "Removing solid-microservices submodule..."
    git submodule deinit -f solid-microservices
    git rm -f solid-microservices
    rm -rf .git/modules/solid-microservices
fi

# Remove vc-issuer submodule
if [ -d "vc-issuer" ]; then
    echo "Removing vc-issuer submodule..."
    git submodule deinit -f vc-issuer
    git rm -f vc-issuer
    rm -rf .git/modules/vc-issuer
fi

# 2. Remove unnecessary files
echo "Removing unnecessary files..."
rm -f .DS_Store
rm -f SERVICE_CLEANUP_PLAN.md
rm -f SPECIFICATION_UPDATE_PLAN.md
rm -rf backup

# 3. Create data directories for all services
echo "Creating data directories for all services..."
mkdir -p data/api-registry
mkdir -p data/solid-pds
mkdir -p data/DRO
mkdir -p data/vc-verifier
mkdir -p data/FEP

# 4. Commit changes
echo "Committing changes..."
git add .
git commit -m "Cleanup repository: Remove unnecessary modules and files"

echo "Repository cleanup complete."
echo "Required microservices:"
echo "  ✅ api-registry"
echo "  ✅ solid-pds"
echo "  ✅ DRO"
echo "  ✅ vc-verifier"
echo "  ✅ FEP"
echo ""
echo "The repository now contains only the discrete microservices required for the PDS system."
echo "Each service can be built independently according to its implementation guide."
