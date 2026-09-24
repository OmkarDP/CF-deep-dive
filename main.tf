module "s3" {
  source = "./modules/s3"
  prefix = local.prefix
  tags   = local.common_tags
}

module "iam" {
  source = "./modules/iam"
  prefix = local.prefix
  tags   = local.common_tags
}

module "logging" {
  source = "./modules/logging"
  prefix = local.prefix
}

module "lambda" {
  source = "./modules/lambda"

  providers = {
    aws.edge = aws.us_east_1
  }

  prefix      = local.prefix
  role_arn    = module.iam.lambda_role_arn
  lambda_path = "${path.module}/modules/lambda/api/lambda.zip"
  tags        = local.common_tags
}

module "apigw" {
  source            = "./modules/apigw"
  prefix            = local.prefix
  lambda_invoke_arn = module.lambda.lambda_invoke_arn
  lambda_name       = module.lambda.lambda_name
}

module "cloudfront" {
  source = "./modules/cloudfront"

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }

  prefix                  = local.prefix
  s3_domain_name          = module.s3.bucket_domain_name
  api_endpoint            = module.apigw.api_endpoint
  logging_bucket          = module.logging.bucket_name
  edge_lambda_arn         = module.lambda.edge_lambda_arn
  realtime_log_config_arn = module.logging.realtime_log_config_arn
  # waf_arn               = module.waf.waf_arn # Uncomment when enabling WAF module
}

# Optional AWS WAF v2 Module
# To enable WAF, uncomment the block below and pass waf_arn to module.cloudfront:
# module "waf" {
#   source = "./modules/waf"
#   prefix = local.prefix
#   providers = {
#     aws = aws.us_east_1
#   }
# }
