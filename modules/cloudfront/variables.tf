variable "prefix" {
  description = "Prefix for CloudFront resources"
  type        = string
}

variable "s3_domain_name" {
  description = "Regional domain name of the S3 bucket"
  type        = string
}

variable "api_endpoint" {
  description = "API Gateway endpoint URL"
  type        = string
}

variable "logging_bucket" {
  description = "Name of the S3 logging bucket"
  type        = string
}

variable "edge_lambda_arn" {
  description = "Qualified ARN for edge auth Lambda@Edge"
  type        = string
}

variable "realtime_log_config_arn" {
  description = "CloudFront realtime log configuration ARN"
  type        = string
}

variable "waf_arn" {
  description = "Optional ARN for AWS WAFv2 Web ACL"
  type        = string
  default     = null
}

variable "cf_function_arn" {
  description = "Optional ARN for viewer-request CloudFront function"
  type        = string
  default     = null
}

