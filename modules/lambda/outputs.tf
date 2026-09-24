output "lambda_invoke_arn" {
  description = "Invoke ARN for backend API Lambda"
  value       = aws_lambda_function.api.invoke_arn
}

output "lambda_name" {
  description = "Function name for backend API Lambda"
  value       = aws_lambda_function.api.function_name
}

output "edge_lambda_arn" {
  description = "Qualified ARN for Edge Auth Lambda@Edge"
  value       = aws_lambda_function.edge_auth.qualified_arn
}

output "geo_router_arn" {
  description = "Qualified ARN for Geo Router Lambda@Edge"
  value       = aws_lambda_function.geo_router.qualified_arn
}

