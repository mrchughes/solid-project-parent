#!/bin/bash

# Set your GitHub username here
GITHUB_USERNAME="mrchughes"

# List of all module names
MODULES=(
  "api-registry"
  "did-registry"
  "mern-app"
  "react-ui"
  "solid-microservices"
  "solid-pds"
  "test-vc-creator"
  "vc-issuer"
  "vc-verifier"
)

# Parent directory
PARENT_DIR="/Users/chrishughes/Projects/PDS"
PARENT_REPO_NAME="solid-project-parent"

# Step 0: Create parent repo on GitHub if it doesn't exist
cd "$PARENT_DIR" || exit
if ! gh repo view "$GITHUB_USERNAME/$PARENT_REPO_NAME" > /dev/null 2>&1; then
  echo "Creating parent repository $PARENT_REPO_NAME on GitHub..."
  gh repo create "$GITHUB_USERNAME/$PARENT_REPO_NAME" --public --description "Parent repo for Solid microservices project" --source=. --remote=origin
fi

git remote add origin "https://github.com/$GITHUB_USERNAME/$PARENT_REPO_NAME.git" 2>/dev/null

echo "-----------------------------------------"

# Step 1: For each module, create repo on GitHub if it doesn't exist, then push
for MODULE in "${MODULES[@]}"; do
  echo "Processing $MODULE..."
  cd "$PARENT_DIR/$MODULE" || exit
  # Create repo on GitHub if it doesn't exist
  if ! gh repo view "$GITHUB_USERNAME/$MODULE" > /dev/null 2>&1; then
    echo "Creating $MODULE repository on GitHub..."
    gh repo create "$GITHUB_USERNAME/$MODULE" --public --description "$MODULE module for Solid microservices project" --source=. --remote=origin
  fi
  git init
  git add .
  git commit -m "Initial skeleton commit" 2>/dev/null
  git branch -M main
  git remote add origin "https://github.com/$GITHUB_USERNAME/$MODULE.git" 2>/dev/null
  git pull origin main --allow-unrelated-histories 2>/dev/null
  git push -u origin main
  cd "$PARENT_DIR" || exit
  echo "-----------------------------------------"
done

# Step 2: Add each module as a submodule in the parent repo
cd "$PARENT_DIR" || exit
for MODULE in "${MODULES[@]}"; do
  git submodule add "https://github.com/$GITHUB_USERNAME/$MODULE.git" "$MODULE" 2>/dev/null
  echo "Added $MODULE as submodule."
done

git add .gitmodules
git commit -m "Add all modules as git submodules" 2>/dev/null
git push -u origin main

echo "All modules and parent repo pushed and added as submodules!"
