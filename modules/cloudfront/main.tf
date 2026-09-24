########################################
# CACHE POLICIES
########################################

resource "aws_cloudfront_cache_policy" "static" {
  name        = "${var.prefix}-static-cache"
  comment     = "Cache policy for static frontend assets"
  default_ttl = 3600
  max_ttl     = 86400
  min_ttl     = 0

  parameters_in_cache_key_and_forwarded_to_origin {
    headers_config {
      header_behavior = "none"
    }

    cookies_config {
      cookie_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "whitelist"

      query_strings {
        items = ["id"]
      }
    }
  }
}

resource "aws_cloudfront_cache_policy" "api" {
  name        = "${var.prefix}-api-cache"
  comment     = "Cache policy for dynamic API requests"
  default_ttl = 0
  max_ttl     = 3600
  min_ttl     = 0

  parameters_in_cache_key_and_forwarded_to_origin {
    headers_config {
      header_behavior = "whitelist"
      headers {
        items = ["Accept-Language"]
      }
    }

    cookies_config {
      cookie_behavior = "all"
    }

    query_strings_config {
      query_string_behavior = "all"
    }
  }
}

########################################
# ORIGIN REQUEST POLICIES
########################################

resource "aws_cloudfront_origin_request_policy" "api" {
  name    = "${var.prefix}-api-origin-policy"
  comment = "Origin request policy forwarding headers, cookies, and query strings"

  headers_config {
    header_behavior = "whitelist"
    headers {
      items = ["Accept-Language"]
    }
  }

  cookies_config {
    cookie_behavior = "all"
  }

  query_strings_config {
    query_string_behavior = "all"
  }
}

########################################
# ORIGIN ACCESS CONTROL (OAC)
########################################

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${var.prefix}-oac"
  description                       = "OAC for CloudFront SigV4 authentication to S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

########################################
# EDGE COMPUTING & SIGNED URLS
########################################

resource "aws_cloudfront_key_value_store" "greetings" {
  provider = aws.us_east_1
  name     = "${var.prefix}-greetings-kvs"
  comment  = "CloudFront KeyValueStore for edge greeting lookups"
}

resource "aws_cloudfront_function" "kvs_function" {
  provider = aws.us_east_1
  name     = "${var.prefix}-kvs-function"
  runtime  = "cloudfront-js-2.0"
  publish  = true

  key_value_store_associations = [
    aws_cloudfront_key_value_store.greetings.arn
  ]

  code = file("${path.module}/functions/kvs-greetings.js")
}

resource "aws_cloudfront_public_key" "private" {
  name        = "${var.prefix}-public-key"
  comment     = "Public key for CloudFront Signed URLs"
  encoded_key = file("${path.module}/public_key.pem")
}

resource "aws_cloudfront_key_group" "private" {
  name    = "${var.prefix}-key-group"
  comment = "Key group for private content authorization"
  items   = [aws_cloudfront_public_key.private.id]
}

########################################
# CLOUDFRONT DISTRIBUTION
########################################

resource "aws_cloudfront_distribution" "cf" {
  enabled             = true
  default_root_object = "index.html"
  comment             = "${var.prefix}-distribution"
  price_class         = "PriceClass_100"

  web_acl_id = var.waf_arn

  logging_config {
    bucket          = "${var.logging_bucket}.s3.amazonaws.com"
    prefix          = "cloudfront/"
    include_cookies = false
  }

  # S3 Origin (Static Assets)
  origin {
    domain_name              = var.s3_domain_name
    origin_id                = "s3-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  # API Gateway Origin (Dynamic Backend)
  origin {
    domain_name = replace(replace(var.api_endpoint, "https://", ""), "/", "")
    origin_id   = "api-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # Origin Group for High Availability / Failover
  origin_group {
    origin_id = "main-origin-group"

    failover_criteria {
      status_codes = [500, 502, 503, 504, 404]
    }

    member {
      origin_id = "s3-origin"
    }

    member {
      origin_id = "api-origin"
    }
  }

  # Default Cache Behavior (Origin Group with Edge Function & Lambda@Edge)
  default_cache_behavior {
    target_origin_id       = "main-origin-group"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true

    cache_policy_id          = aws_cloudfront_cache_policy.static.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.api.id

    realtime_log_config_arn = var.realtime_log_config_arn

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.kvs_function.arn
    }

    lambda_function_association {
      event_type   = "origin-request"
      lambda_arn   = var.edge_lambda_arn
      include_body = false
    }
  }

  # API Cache Behavior
  ordered_cache_behavior {
    path_pattern           = "/api/*"
    target_origin_id       = "api-origin"
    viewer_protocol_policy = "https-only"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true

    cache_policy_id          = aws_cloudfront_cache_policy.api.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.api.id
  }

  # Private Content Cache Behavior (Protected via Signed URLs / Key Groups)
  ordered_cache_behavior {
    path_pattern           = "/private/*"
    target_origin_id       = "s3-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true

    cache_policy_id = aws_cloudfront_cache_policy.static.id

    trusted_key_groups = [
      aws_cloudfront_key_group.private.id
    ]
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
