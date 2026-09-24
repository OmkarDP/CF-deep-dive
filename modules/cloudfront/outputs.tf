output "domain_name" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.cf.domain_name
}

output "distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.cf.id
}

output "distribution_arn" {
  description = "CloudFront distribution ARN"
  value       = aws_cloudfront_distribution.cf.arn
}

output "key_group_id" {
  description = "CloudFront trusted key group ID for signed URLs"
  value       = aws_cloudfront_key_group.private.id
}
