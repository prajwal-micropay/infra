/**
 * Storage module - Uploads
 * Creates S3 bucket for chat file uploads with proper security configurations
 */

# S3 Bucket for file uploads
resource "aws_s3_bucket" "uploads" {
  bucket = "${var.environment}-${var.uploads_bucket_name}"

  tags = {
    Name        = "${var.environment}-${var.uploads_bucket_name}"
    Environment = var.environment
  }
}

# Enable versioning on the S3 bucket
resource "aws_s3_bucket_versioning" "uploads" {
  bucket = aws_s3_bucket.uploads.id
  versioning_configuration {
    status = "Disabled" 
  }
}

# Server-side encryption for S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "uploads" {
  bucket = aws_s3_bucket.uploads.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access for S3 bucket
resource "aws_s3_bucket_public_access_block" "uploads" {
  bucket = aws_s3_bucket.uploads.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

# Bucket policy to make apps folder publicly readable
resource "aws_s3_bucket_policy" "uploads_public_apps" {
  bucket = aws_s3_bucket.uploads.id
  depends_on = [aws_s3_bucket_public_access_block.uploads]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.uploads.arn}/apps/*"
      }
    ]
  })
}

# CORS configuration for browser uploads
resource "aws_s3_bucket_cors_configuration" "uploads" {
  bucket = aws_s3_bucket.uploads.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST"]
    allowed_origins = var.cors_allowed_origins
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

# Lifecycle rules to manage storage costs
resource "aws_s3_bucket_lifecycle_configuration" "uploads" {
  bucket = aws_s3_bucket.uploads.id

  rule {
    id     = "expire-old-uploads"
    status = "Enabled"

    filter {
      prefix = ""  # Apply to all objects
    }

    expiration {
      days = var.expired_object_delete_days
    }
  }
} 