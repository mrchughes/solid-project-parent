#!/bin/bash
# Script to create GitHub repositories and push existing local repositories

# Set up color codes for better output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Replace with your GitHub username (no need to edit if using gh CLI)
GITHUB_USERNAME=$(gh api user | jq -r .login)
if [ -z "$GITHUB_USERNAME" ]; then
  echo -e "${RED}Error: Could not retrieve GitHub username. Make sure you're logged in with GitHub CLI.${NC}"
  echo -e "${YELLOW}Run 'gh auth login' to authenticate.${NC}"
  exit 1
fi

echo -e "${GREEN}Using GitHub username: ${BLUE}$GITHUB_USERNAME${NC}"

# Parent directory containing all service directories
PARENT_DIR="/Users/chrishughes/Projects/PDS"

# List of all service directories with descriptions
declare -A SERVICES=(
  ["solid-microservices"]="Orchestration for Solid-based microservices system"
  ["solid-pds"]="Solid Personal Data Store Service"
  ["did-registry"]="Decentralized Identifier Registry Service"
  ["test-vc-creator"]="Test Verifiable Credential Creator Service"
  ["vc-verifier"]="Verifiable Credential Verification Service"
  ["vc-issuer"]="Verifiable Credential Issuance Service"
  ["api-registry"]="API Registry Service"
  ["react-ui"]="React UI for Solid microservices"
  ["mern-app"]="MERN App with Solid integration"
)

# First, verify all directories exist
echo -e "${BLUE}Verifying all local repositories exist...${NC}"
MISSING_DIRS=0
for SERVICE in "${!SERVICES[@]}"; do
  if [ ! -d "$PARENT_DIR/$SERVICE" ]; then
    echo -e "${RED}Directory for $SERVICE does not exist at $PARENT_DIR/$SERVICE${NC}"
    MISSING_DIRS=$((MISSING_DIRS+1))
  fi
done

if [ $MISSING_DIRS -gt 0 ]; then
  echo -e "${RED}Error: $MISSING_DIRS directories are missing. Please check the paths.${NC}"
  exit 1
fi

echo -e "${GREEN}All directories verified!${NC}"

# Function to create GitHub repo and push content
create_and_push_repo() {
  local service=$1
  local description=$2
  local service_dir="$PARENT_DIR/$service"
  
  echo -e "\n${BLUE}========== Processing $service ==========${NC}"
  cd "$service_dir" || return
  
  # Check if the repository is already initialized with Git
  if [ -d .git ]; then
    echo -e "${GREEN}Git repository already initialized for $service${NC}"
  else
    echo -e "${YELLOW}Initializing Git repository for $service${NC}"
    git init
    git add .
    git commit -m "Initial commit"
  fi
  
  # Create the repository on GitHub
  echo -e "${YELLOW}Creating GitHub repository for $service...${NC}"
  gh repo create "$service" --public --description "$description" --source=. --remote=origin
  
  if [ $? -ne 0 ]; then
    # If repo creation failed, check if it already exists and try to add as remote
    echo -e "${YELLOW}Repository might already exist. Trying to add as remote...${NC}"
    if ! git remote | grep -q "origin"; then
      git remote add origin "https://github.com/$GITHUB_USERNAME/$service.git"
    fi
  fi
  
  # Push to GitHub
  echo -e "${YELLOW}Pushing $service to GitHub...${NC}"
  git branch -M main
  git push -u origin main
  
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}$service pushed to GitHub successfully!${NC}"
  else
    echo -e "${RED}Failed to push $service to GitHub.${NC}"
    return 1
  fi
  
  # Open the repository in the browser
  echo -e "${YELLOW}Opening repository in browser...${NC}"
  gh repo view --web
  
  return 0
}

# Main execution
echo -e "${BLUE}Starting GitHub repository creation and push...${NC}"
echo -e "${YELLOW}This will create ${#SERVICES[@]} public repositories and push your local code.${NC}"
echo -e "${RED}Press Ctrl+C now to abort, or any key to continue...${NC}"
read -n 1 -s

# Process each repository
SUCCESS_COUNT=0
FAILURE_COUNT=0

for SERVICE in "${!SERVICES[@]}"; do
  DESCRIPTION="${SERVICES[$SERVICE]}"
  
  if create_and_push_repo "$SERVICE" "$DESCRIPTION"; then
    SUCCESS_COUNT=$((SUCCESS_COUNT+1))
  else
    FAILURE_COUNT=$((FAILURE_COUNT+1))
  fi
  
  echo -e "${BLUE}------------------------------------------${NC}"
done

# Summary
echo -e "\n${BLUE}=============== SUMMARY ===============${NC}"
echo -e "${GREEN}Successfully processed: $SUCCESS_COUNT repositories${NC}"
if [ $FAILURE_COUNT -gt 0 ]; then
  echo -e "${RED}Failed: $FAILURE_COUNT repositories${NC}"
  echo -e "${YELLOW}Please check the logs above for details on failures.${NC}"
fi

echo -e "\n${GREEN}All done! Your repositories are now on GitHub at https://github.com/$GITHUB_USERNAME${NC}"
