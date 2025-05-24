#!/bin/bash
set -e

# Micropaye Infrastructure Apply Script
# This script applies a plan for the specified environment (staging or production)

# Default to staging if no environment is specified
ENV=${1:-staging}

# Validate environment parameter
if [[ "$ENV" != "staging" && "$ENV" != "production" ]]; then
  echo "Error: Environment must be either 'staging' or 'production'"
  echo "Usage: $0 [environment]"
  exit 1
fi

PLAN_FILE="environments/$ENV/$ENV.tfplan"

# Check if plan file exists
if [ ! -f "$PLAN_FILE" ]; then
  echo "Error: Plan file $PLAN_FILE does not exist"
  echo "Please run ./generate_plan.sh $ENV first to create a plan"
  exit 1
fi

echo "=== Micropaye $ENV Infrastructure Deployment ==="
echo "This script will apply the OpenTofu plan for the $ENV environment."
echo

# Check if AWS profile exists
if ! aws configure list-profiles 2>/dev/null | grep -q "micropaye"; then
  echo "Error: AWS profile 'micropaye' not found."
  echo "Please set up the AWS profile with: aws configure --profile micropaye"
  exit 1
fi

echo "Using AWS profile: micropaye"
export AWS_PROFILE=micropaye
echo

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

# Ask for confirmation
read -p "Are you sure you want to apply the $ENV plan? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Operation cancelled."
  exit 0
fi

# Change to the environment directory
cd "environments/$ENV"

# Quick initialization to ensure plugins are available
echo "Ensuring plugins are initialized..."
$TOFU_CMD init -input=false
echo

# Apply the plan
echo "Applying infrastructure plan for $ENV environment..."
$TOFU_CMD apply "$ENV.tfplan"

# Summary
echo
echo "=== Deployment Summary ==="
echo "The $ENV infrastructure has been deployed successfully."
echo
echo "To view the outputs, run: cd environments/$ENV && $TOFU_CMD output" 