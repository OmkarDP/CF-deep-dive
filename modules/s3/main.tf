resource "random_id" "suffix" {
  byte_length = 2
}

resource "aws_s3_bucket" "frontend" {
  bucket = "${var.prefix}-frontend-${random_id.suffix.hex}"

  tags = merge(var.tags, {
    Name = "${var.prefix}-frontend"
  })
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket = aws_s3_bucket.frontend.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipalReadOnly"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.frontend.arn}/*"
      }
    ]
  })
}

# Upload all static site files with appropriate content types
resource "aws_s3_object" "site_files" {
  for_each = fileset("${path.root}/static-site", "**/*")

  bucket = aws_s3_bucket.frontend.id
  key    = each.value
  source = "${path.root}/static-site/${each.value}"

  content_type = lookup({
    "html" = "text/html",
    "js"   = "application/javascript",
    "json" = "application/json",
    "jpg"  = "image/jpeg",
    "jpeg" = "image/jpeg",
    "png"  = "image/png",
    "css"  = "text/css"
  }, regex("[^.]+$", each.value), "binary/octet-stream")

  etag = filemd5("${path.root}/static-site/${each.value}")
}

