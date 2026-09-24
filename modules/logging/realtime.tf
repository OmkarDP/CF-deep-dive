resource "aws_kinesis_stream" "cf_realtime" {
  name = "${var.prefix}-cf-realtime"
  stream_mode_details {
    stream_mode = "ON_DEMAND"
  }
}

resource "aws_iam_role" "cf_realtime_role" {
  name = "${var.prefix}-cf-realtime-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "cloudfront.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "cf_realtime_policy" {

  role = aws_iam_role.cf_realtime_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Action = [
        "kinesis:PutRecord",
        "kinesis:PutRecords"
      ]

      Resource = aws_kinesis_stream.cf_realtime.arn
    }]
  })
}

resource "aws_cloudfront_realtime_log_config" "cf_logs" {

  name          = "${var.prefix}-realtime"
  sampling_rate = 100

  fields = [
    "timestamp",
    "c-ip",
    "cs-method",
    "cs-uri-stem",
    "sc-status",
    "x-edge-location",
    "time-to-first-byte",
    "x-edge-result-type",
    "cs-protocol",
    "x-host-header"
  ]

  endpoint {
    stream_type = "Kinesis"

    kinesis_stream_config {

      role_arn   = aws_iam_role.cf_realtime_role.arn
      stream_arn = aws_kinesis_stream.cf_realtime.arn
    }
  }
}
