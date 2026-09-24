output "cloudfront_distribution_id" {
  description = "CloudFront Distribution ID"
  value       = module.cloudfront.distribution_id
}

output "cloudfront_domain_name" {
  description = "CloudFront Distribution Domain Name (use this to access the application)"
  value       = module.cloudfront.domain_name
}

output "s3_bucket_name" {
  description = "Frontend S3 bucket name"
  value       = module.s3.bucket_name
}

output "api_gateway_endpoint" {
  description = "API Gateway direct HTTP endpoint URL"
  value       = module.apigw.api_endpoint
}

output "logging_bucket_name" {
  description = "Centralized logging S3 bucket name"
  value       = module.logging.bucket_name
}

output "cloudfront_key_group_id" {
  description = "CloudFront Trusted Key Group ID (used for generating Signed URLs)"
  value       = module.cloudfront.key_group_id
}
