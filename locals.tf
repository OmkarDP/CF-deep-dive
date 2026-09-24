locals {
  prefix = "omkar-cf-deep-dive-${var.env}"

  common_tags = {
    Project     = "CloudFront Deep Dive"
    Environment = var.env
    Owner       = "Omkar"
    ManagedBy   = "Terraform"
  }
}