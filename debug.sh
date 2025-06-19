#!/bin/bash
# terraform-debug.sh
# Script to debug Terraform bootstrap locally
# Run with: ./terraform-debug.sh

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Terraform Bootstrap Debug Script ===${NC}"
echo ""

# Check if we're in the right directory
if [ ! -d "terraform" ]; then
    echo -e "${RED}Error: 'terraform' directory not found!${NC}"
    echo "Make sure you're running this from the repository root"
    exit 1
fi

# Variables - set these to match your environment
echo -e "${YELLOW}Setting up variables...${NC}"
echo "Enter your values (press Enter for defaults):"
echo ""

read -p "Buildkite org slug [bootstrap-example]: " ORG_SLUG
ORG_SLUG=${ORG_SLUG:-bootstrap-example}

read -p "Registry name [bootstrap-example]: " REGISTRY_NAME
REGISTRY_NAME=${REGISTRY_NAME:-bootstrap-example}

read -p "Queue shape [LINUX_AMD64_2X4]: " QUEUE_SHAPE
QUEUE_SHAPE=${QUEUE_SHAPE:-LINUX_AMD64_2X4}

read -sp "Buildkite API token: " API_TOKEN
echo ""

if [ -z "$API_TOKEN" ]; then
    echo -e "${RED}Error: API token is required!${NC}"
    exit 1
fi

# Export variables for Terraform
export TF_VAR_org_slug="$ORG_SLUG"
export TF_VAR_registry_name="$REGISTRY_NAME"
export TF_VAR_queue_shape="$QUEUE_SHAPE"
export TF_VAR_buildkite_api_token="$API_TOKEN"

echo ""
echo -e "${GREEN}Variables set:${NC}"
echo "  Org slug: $ORG_SLUG"
echo "  Registry: $REGISTRY_NAME"
echo "  Queue shape: $QUEUE_SHAPE"
echo "  API token: ***hidden***"
echo ""

# Function to run with Docker
run_with_docker() {
    echo -e "${YELLOW}Running Terraform with Docker...${NC}"
    
    # Check if Docker is running
    if ! docker info >/dev/null 2>&1; then
        echo -e "${RED}Error: Docker is not running!${NC}"
        echo "Make sure Docker Desktop is running and WSL integration is enabled"
        exit 1
    fi
    
    # Create artifacts directory
    mkdir -p artifacts
    
    # Run Terraform plan
    echo -e "${YELLOW}Running terraform plan...${NC}"
    docker run --rm \
        --volume "$PWD:/workdir" \
        --workdir /workdir \
        --env TF_VAR_org_slug \
        --env TF_VAR_registry_name \
        --env TF_VAR_queue_shape \
        --env TF_VAR_buildkite_api_token \
        --entrypoint /bin/sh \
        hashicorp/terraform:1.5.7 \
        -c '
        set -e
        echo "Installing dependencies..."
        apk add --no-cache curl jq >/dev/null 2>&1
        
        cd terraform
        echo "Initializing Terraform..."
        terraform init -input=false
        
        echo "Creating plan..."
        terraform plan -input=false -out=../artifacts/terraform.tfplan
        
        echo "Plan created successfully!"
        '
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}Plan failed!${NC}"
        exit 1
    fi
    
    echo ""
    echo -e "${YELLOW}Review the plan above. Apply changes? (yes/no)${NC}"
    read -p "> " CONFIRM
    
    if [ "$CONFIRM" != "yes" ]; then
        echo "Aborted."
        exit 0
    fi
    
    # Run Terraform apply
    echo -e "${YELLOW}Running terraform apply...${NC}"
    docker run --rm \
        --volume "$PWD:/workdir" \
        --workdir /workdir \
        --env TF_VAR_org_slug \
        --env TF_VAR_registry_name \
        --env TF_VAR_queue_shape \
        --env TF_VAR_buildkite_api_token \
        --entrypoint /bin/sh \
        hashicorp/terraform:1.5.7 \
        -c '
        set -e
        apk add --no-cache curl jq >/dev/null 2>&1
        
        cd terraform
        terraform init -input=false
        terraform apply -input=false -auto-approve ../artifacts/terraform.tfplan
        
        echo "Saving outputs..."
        terraform output -json > ../artifacts/terraform-outputs.json
        '
        
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Success! Infrastructure deployed.${NC}"
    else
        echo -e "${RED}Apply failed!${NC}"
        exit 1
    fi
}

# Function to fix Terraform syntax
fix_terraform_syntax() {
    echo -e "${YELLOW}Checking Terraform syntax...${NC}"
    
    # Check for semicolons in .tf files
    echo "Checking for semicolons in Terraform files..."
    find terraform -name "*.tf" -exec grep -Hn ";" {} \; | while read line; do
        echo -e "${YELLOW}Found semicolon: $line${NC}"
    done
    
    # Run terraform fmt to check formatting
    echo ""
    echo "Checking Terraform formatting..."
    docker run --rm \
        --volume "$PWD:/workdir" \
        --workdir /workdir \
        --entrypoint /bin/sh \
        hashicorp/terraform:1.5.7 \
        -c 'cd terraform && terraform fmt -check -diff' || true
    
    echo ""
    echo -e "${YELLOW}Fix formatting issues? (yes/no)${NC}"
    read -p "> " FIX_FMT
    
    if [ "$FIX_FMT" = "yes" ]; then
        docker run --rm \
            --volume "$PWD:/workdir" \
            --workdir /workdir \
            --entrypoint /bin/sh \
            hashicorp/terraform:1.5.7 \
            -c 'cd terraform && terraform fmt'
        echo -e "${GREEN}Formatting fixed!${NC}"
    fi
}

# Function for debug mode
debug_mode() {
    echo -e "${YELLOW}Debug mode - testing Docker commands:${NC}"
    echo ""
    
    echo "1. Testing basic Docker..."
    docker run --rm alpine echo "Docker works!"
    
    echo ""
    echo "2. Testing Terraform image..."
    docker run --rm hashicorp/terraform:1.5.7 version
    
    echo ""
    echo "3. Testing volume mounts..."
    docker run --rm \
        --volume "$PWD:/workdir" \
        --workdir /workdir \
        alpine ls -la
    
    echo ""
    echo "4. Testing Terraform init..."
    docker run --rm \
        --volume "$PWD:/workdir" \
        --workdir /workdir \
        --entrypoint /bin/sh \
        hashicorp/terraform:1.5.7 \
        -c 'cd terraform && terraform init -backend=false' || true
}

# Interactive menu
echo -e "${YELLOW}What would you like to do?${NC}"
echo "1) Run Terraform with Docker"
echo "2) Fix Terraform syntax issues"
echo "3) Debug mode (test Docker commands)"
echo "4) Exit"
echo ""
read -p "Choice [1-4]: " CHOICE

case $CHOICE in
    1)
        run_with_docker
        ;;
    2)
        fix_terraform_syntax
        ;;
    3)
        debug_mode
        ;;
    4)
        echo "Exiting."
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid choice!${NC}"
        exit 1
        ;;
esac
