output "waf_arn" {
  description = "ARN of the CloudFront Web ACL (when active)"
  value       = null # Uncomment below and replace when WAF resource is enabled:
  # value     = aws_wafv2_web_acl.cf.arn
}
