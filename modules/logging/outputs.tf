output "bucket_name" {
  description = "Centralized logging S3 bucket name"
  value       = aws_s3_bucket.logs.bucket
}

output "bucket_arn" {
  description = "Centralized logging S3 bucket ARN"
  value       = aws_s3_bucket.logs.arn
}

output "realtime_log_config_arn" {
  description = "CloudFront realtime log config ARN"
  value       = aws_cloudfront_realtime_log_config.cf_logs.arn
}