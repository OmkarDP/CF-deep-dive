resource "aws_lambda_function" "api" {
  function_name = "${var.prefix}-api"
  role          = var.role_arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  filename = var.lambda_path

  tags = var.tags
}
resource "aws_lambda_function" "edge_auth" {

  provider = aws.edge

  filename = "${path.module}/edge-auth/edge-auth.zip"

  function_name = "${var.prefix}-edge-auth"

  role = var.role_arn

  handler = "index.handler"

  runtime = "nodejs18.x"

  publish = true

  source_code_hash = filebase64sha256(
    "${path.module}/edge-auth/edge-auth.zip"
  )
}

resource "aws_lambda_function" "geo_router" {

  provider = aws.edge

  filename = "${path.module}/geo-router/geo-router.zip"

  function_name = "${var.prefix}-geo-router"

  role = var.role_arn

  handler = "index.handler"

  runtime = "nodejs18.x"

  publish = true

  source_code_hash = filebase64sha256(
    "${path.module}/geo-router/geo-router.zip"
  )

  tags = var.tags
}
