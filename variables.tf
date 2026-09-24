variable "aws_region" {
  description = "Primary AWS region for regional services (S3, API Gateway, backend Lambda)"
  type        = string
  default     = "ap-south-1"
}

variable "env" {
  description = "Deployment environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}