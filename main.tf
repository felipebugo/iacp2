# PROVIDER
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# BUCKET S3
resource "aws_s3_bucket" "frmeira" {
  bucket = "frmeira"
}

# POLICY S3
resource "aws_s3_bucket_policy" "policys3" {
  bucket = aws_s3_bucket.frmeira.id

  policy      = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "arn:aws:s3:::frmeira/*",
      }
    ]
	})
}

# VERSIONING S3 BUCKET
resource "aws_s3_bucket_versioning" "versionings3" {
  bucket = aws_s3_bucket.frmeira.id
  versioning_configuration {
    status = "Enabled"
  }
}

# STATIC SITE
resource "aws_s3_bucket_website_configuration" "sites3" {
  bucket = aws_s3_bucket.frmeira.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# S3 BUCKET OBJECTS
resource "aws_s3_bucket_object" "frmeira" {
    bucket   = aws_s3_bucket.frmeira.id
    for_each = fileset("data/", "*")
    key      = each.value
    source   = "data/${each.value}"
    content_type = "text/html"
	}
