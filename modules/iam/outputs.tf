output "lambda_role_arn" {
  description = "IAM execution role ARN for Lambda and Lambda@Edge"
  value       = aws_iam_role.lambda_exec.arn
}

output "lambda_role_name" {
  description = "IAM execution role name for Lambda and Lambda@Edge"
  value       = aws_iam_role.lambda_exec.name
}

