/**
 * Shared module
 * Creates resources shared across environments:
 * - S3 bucket for artifacts
 * - IAM CI/CD user with permissions
 */

# S3 Bucket for artifacts
resource "aws_s3_bucket" "artifacts" {
  bucket = var.artifact_bucket_name

  tags = {
    Name = var.artifact_bucket_name
  }
}

# Enable versioning on the S3 bucket
resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id
  versioning_configuration {
    status = "Disabled"
  }
}

# Server-side encryption for S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access for S3 bucket
resource "aws_s3_bucket_public_access_block" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# IAM user for CI/CD
resource "aws_iam_user" "cicd" {
  name = var.cicd_user_name
  tags = {
    Name = var.cicd_user_name
  }
}

# IAM policy for CI/CD user
resource "aws_iam_policy" "cicd_policy" {
  name        = "${var.cicd_user_name}-policy"
  description = "Policy for CI/CD user to deploy applications"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
        ]
        Resource = [
          "${aws_s3_bucket.artifacts.arn}",
          "${aws_s3_bucket.artifacts.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "autoscaling:StartInstanceRefresh",
          "autoscaling:DescribeInstanceRefreshes",
          "autoscaling:CancelInstanceRefresh",
          "autoscaling:DescribeAutoScalingGroups",
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach policy to IAM user
resource "aws_iam_user_policy_attachment" "cicd_policy_attachment" {
  user       = aws_iam_user.cicd.name
  policy_arn = aws_iam_policy.cicd_policy.arn
}

# Access key for CI/CD user
resource "aws_iam_access_key" "cicd" {
  user = aws_iam_user.cicd.name
} 