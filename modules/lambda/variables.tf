variable "prefix" {
  description = "Prefix for Lambda resource names"
  type        = string
}

variable "role_arn" {
  description = "IAM execution role ARN"
  type        = string
}

variable "lambda_path" {
  description = "Path to backend API Lambda zip archive"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}

