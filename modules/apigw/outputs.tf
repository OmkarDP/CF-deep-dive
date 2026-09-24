output "api_endpoint" {
  description = "API Gateway HTTP API endpoint URL"
  value       = aws_apigatewayv2_api.api.api_endpoint
}

output "api_id" {
  description = "API Gateway HTTP API ID"
  value       = aws_apigatewayv2_api.api.id
}

output "api_execution_arn" {
  description = "API Gateway execution ARN"
  value       = aws_apigatewayv2_api.api.execution_arn
}