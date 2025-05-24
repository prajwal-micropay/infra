#!/bin/bash
set -e

# Simple script to visualize Terraform plans for Micropaye infrastructure

# Default to staging if no environment is specified
ENV=${1:-staging}

# Validate environment parameter
if [[ "$ENV" != "staging" && "$ENV" != "production" ]]; then
  echo "Error: Environment must be either 'staging' or 'production'"
  echo "Usage: $0 [environment]"
  exit 1
fi

echo "=== Visualizing $ENV Terraform Plan ==="

# Determine which command to use (tofu or terraform)
if command -v tofu &> /dev/null; then
  TOFU_CMD="tofu"
elif command -v terraform &> /dev/null; then
  TOFU_CMD="terraform"
  echo "Note: Using terraform command instead of tofu."
else
  echo "Error: Neither OpenTofu (tofu) nor Terraform (terraform) is installed."
  echo "Please install OpenTofu or Terraform and try again."
  exit 1
fi

# Check if plan file exists
if [ ! -f "environments/$ENV/$ENV.tfplan" ]; then
  echo "Error: Plan file not found at environments/$ENV/$ENV.tfplan"
  echo "Run ./generate_plan.sh $ENV first to create a plan."
  exit 1
fi

# Show the plan
cd "environments/$ENV"
$TOFU_CMD show "$ENV.tfplan"

echo
echo "=== Plan visualization complete ===" 