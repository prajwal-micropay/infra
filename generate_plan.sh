#!/bin/bash
set -e

# Micropaye Infrastructure Plan Generation Script
# This script creates a plan for the specified environment (staging or production)

# Default to staging if no environment is specified
ENV=${1:-staging}

# Check for a -test flag as the second parameter
TEST_MODE=false
if [[ "$2" == "-test" ]]; then
  TEST_MODE=true
fi

# Validate environment parameter
if [[ "$ENV" != "staging" && "$ENV" != "production" ]]; then
  echo "Error: Environment must be either 'staging' or 'production'"
  echo "Usage: $0 [environment] [-test]"
  exit 1
fi

echo "=== Micropaye $ENV Infrastructure Plan Generation ==="
echo "This script will create an OpenTofu plan for the $ENV environment."
if [[ "$TEST_MODE" == "true" ]]; then
  echo "Running in TEST MODE - Will only validate configuration structure."
fi
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

# Change to the environment directory
cd "environments/$ENV"

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

# Always initialize to ensure dependencies are current
echo "Initializing OpenTofu configuration..."
$TOFU_CMD init
echo

# Create a plan
echo "Creating infrastructure plan for $ENV environment..."
if [[ "$TEST_MODE" == "true" ]]; then
  $TOFU_CMD plan -out="$ENV.tfplan" -refresh=false -lock=false -input=false || $TOFU_CMD validate
else
  $TOFU_CMD plan -out="$ENV.tfplan"
fi

# Summary
echo
echo "=== Plan Summary ==="
if [[ "$TEST_MODE" == "true" ]]; then
  echo "TEST MODE: Configuration structure validation completed."
else
  echo "The plan has been created and saved to environments/$ENV/$ENV.tfplan"
  echo
  echo "To apply this plan, run: ./apply_plan.sh $ENV"
  echo
  echo "Review the plan carefully before applying!"
fi 