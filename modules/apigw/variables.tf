variable "prefix" {
  description = "Prefix for API Gateway resource names"
  type        = string
}

variable "lambda_invoke_arn" {
  description = "Invoke ARN for backend Lambda function"
  type        = string
}

variable "lambda_name" {
  description = "Name of backend Lambda function for permission attachment"
  type        = string
}