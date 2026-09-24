resource "aws_s3_bucket" "logs" {
  bucket = "${var.prefix}-central-logs"
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    id     = "expire-old-logs"
    status = "Enabled"

    expiration {
      days = 30
    }
  }
}
resource "aws_s3_bucket_policy" "logs" {
  bucket = aws_s3_bucket.logs.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AWSCloudFrontLogging"
        Effect = "Allow"

        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }

        Action = [
          "s3:PutObject"
        ]

        Resource = "${aws_s3_bucket.logs.arn}/*"
      }
    ]
  })
}
resource "aws_s3_bucket_ownership_controls" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_acl" "logs" {
  depends_on = [
    aws_s3_bucket_ownership_controls.logs,
    aws_s3_bucket_public_access_block.logs
  ]

  bucket = aws_s3_bucket.logs.id
  acl    = "log-delivery-write"
}
