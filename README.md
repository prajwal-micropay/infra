# Micropaye Infrastructure

This repository contains OpenTofu infrastructure code for deploying the Micropaye API application.

## Architecture

The infrastructure is designed with isolation between production and staging environments, each with its own VPC.
Resources are organized as follows:

- **Shared Resources**:
  - S3 Bucket for artifacts
  - IAM CICD User

- **Environment-Specific Resources (Production & Staging)**:
  - VPC with public and private subnets across two AZs
  - NAT Gateway for private subnet internet access
  - Application Load Balancer (ALB)
  - Auto Scaling Group (ASG) with Launch Template
  - EC2 instances (t2.micro) for running the Go server
  - PostgreSQL RDS instance in private subnet
  - Security Groups
  - Route53 DNS records
    - Production: api.trymicro.io
- Staging: api.staging.trymicro.io

## Zero-Downtime Deployment

The infrastructure supports zero-downtime deployments through the ASG with rolling updates.

## Directory Structure

```
infra/
├── environments/
│   ├── production/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── staging/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── modules/
│   ├── networking/
│   ├── compute/
│   ├── database/
│   ├── shared/
│   └── dns/
├── .gitignore
└── README.md
```

## Prerequisites

- OpenTofu CLI installed
- AWS CLI configured
- Route53 domain setup for api.trymicro.io

## Usage

1. Initialize OpenTofu:
   ```
   cd environments/[environment]
   tofu init
   ```

2. Plan the changes:
   ```
   tofu plan -out=tfplan
   ```

3. Apply the changes:
   ```
   tofu apply tfplan
   ```

## Deployment

For CI/CD deployment:

1. Build the Go application
2. Upload the artifact to the S3 bucket
3. Trigger an ASG instance refresh for zero-downtime deployment 