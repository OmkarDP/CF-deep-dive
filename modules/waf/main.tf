# resource "aws_wafv2_web_acl" "cf" {
#   name  = "${var.prefix}-waf"
#   scope = "CLOUDFRONT"

#   default_action {
#     allow {}
#   }

#   ########################################
#   # Rule 1: Rate Limiting (core learning)
#   ########################################
#   rule {
#     name     = "omkar-rate-limit"
#     priority = 1

#     action {
#       block {}
#     }

#     statement {
#       rate_based_statement {
#         limit              = 200 # keep low for testing
#         aggregate_key_type = "IP"
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "omkar-rate-limit"
#       sampled_requests_enabled   = true
#     }
#   }

#   ########################################
#   # Rule 2: IP Block (optional, cheap)
#   ########################################
#   rule {
#     name     = "omkar-block-ip"
#     priority = 2

#     action {
#       block {}
#     }

#     statement {
#       ip_set_reference_statement {
#         arn = aws_wafv2_ip_set.block_ips.arn
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "omkar-ip-block"
#       sampled_requests_enabled   = true
#     }
#   }
#   rule {
#     name     = "AWSManagedCommonRules"
#     priority = 3

#     override_action {
#       none {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesCommonRuleSet"
#         vendor_name = "AWS"
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "aws-common-rules"
#       sampled_requests_enabled   = true
#     }
#   }
#   ########################################
#   # REQUIRED ROOT VISIBILITY CONFIG
#   ########################################
#   visibility_config {
#     cloudwatch_metrics_enabled = true
#     metric_name                = "${var.prefix}-waf"
#     sampled_requests_enabled   = true
#   }
# }

# ########################################
# # IP Set (for manual blocking test)
# ########################################
# resource "aws_wafv2_ip_set" "block_ips" {
#   name               = "${var.prefix}-blocked-ips"
#   scope              = "CLOUDFRONT"
#   ip_address_version = "IPV4"

#   addresses = [
#     "1.2.3.4/32",
#     #"182.70.113.210/32" # replace with your IP later for testing
#   ]
# }
