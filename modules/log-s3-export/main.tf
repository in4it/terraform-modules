resource "random_string" "suffix" {
  length  = 5
  upper   = false
  lower   = true
  numeric = false
  special = false
}

# Event trigger once a day
resource "aws_cloudwatch_event_rule" "once_a_day" {
  name                = "${var.name}-log-export-run-lambda-${random_string.suffix.result}"
  description         = "Trigger lambda function that grabs yesterdays Cloudwatch logs and sends them to an S3 bucket with CreateExportTask"
  schedule_expression = "cron(1 0 * * ? *)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.once_a_day.name
  target_id = "${var.name}-ExportLogsLambdaTarget-${random_string.suffix.result}"
  arn       = aws_lambda_function.log_exporter.arn
}

resource "aws_lambda_permission" "allow_triggering_function" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.log_exporter.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.once_a_day.arn
}

# Lambda function
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src/lambda/"
  output_path = "${path.module}/src/tmp/lambda.zip"
}

resource "aws_lambda_function" "log_exporter" {
  function_name    = "${var.name}-ExportLogsLambda-${random_string.suffix.result}"
  role             = aws_iam_role.log_exporter.arn
  handler          = "index.handler"
  filename         = "${path.module}/src/tmp/lambda.zip"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "nodejs16.x"
  timeout          = 300

  environment {
    variables = {
      EXPORT_BUCKET = module.logs_export_bucket.bucket_name
      LOG_GROUPS    = jsonencode(var.log_groups_list)
      BUCKET_PREFIX = var.bucket_prefix
      DAYS_BEFORE   = var.export_days_before
      RETRY         = var.check_retry_attempts
      RETRY_TIMEOUT = var.check_retry_timeout
    }
  }
  tracing_config {
    mode = "Active"
  }
}

# IAM for lambda function
resource "aws_iam_role" "log_exporter" {
  name               = "${var.name}-log-s3-export-${random_string.suffix.result}"
  assume_role_policy = data.aws_iam_policy_document.log_exporter_sts.json
}

data "aws_iam_policy_document" "log_exporter_sts" {

  statement {
    sid = "UseByLambda"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "log_exporter" {

  statement {
    sid = "LogsAccess"
    actions = [
      "logs:CreateExportTask",
      "logs:Describe*",
      "logs:ListTagsLogGroup",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }

  statement {
    sid = "S3BucketAccess"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutBucketAcl",
      "s3:GetBucketAcl"
    ]
    resources = ["${module.logs_export_bucket.bucket_arn}/*"]
  }
  depends_on = [
    module.logs_export_bucket
  ]
}

resource "aws_iam_policy" "log_exporter" {
  name   = "${var.name}-log-exporter-policy-${random_string.suffix.result}"
  policy = data.aws_iam_policy_document.log_exporter.json
}

resource "aws_iam_role_policy_attachment" "log_exporter" {
  role       = aws_iam_role.log_exporter.name
  policy_arn = aws_iam_policy.log_exporter.arn
}

# S3 bucket
module "logs_export_bucket" {
  source = "../../modules/s3"

  name       = "${lower(var.name)}-log-export-${random_string.suffix.result}"
  versioning = false
  additional_policy_statements = [
    {
      sid    = "BucketACL"
      effect = "Allow"
      actions   = ["s3:GetBucketAcl", "s3:PutBucketAcl"]
      resources = [module.logs_export_bucket.bucket_arn]
      principals = {
        type        = "Service"
        identifiers = ["logs.${var.aws_region}.amazonaws.com"]
      }
    },
    {
      sid       = "PutObject"
      effect    = "Allow"
      actions   = ["s3:PutObject", "s3:PutObjectAcl"]
      resources = ["${module.logs_export_bucket.bucket_arn}/*"]
      principals = {
        type        = "Service"
        identifiers = ["logs.${var.aws_region}.amazonaws.com"]
      }

      condition = {
        test     = "StringEquals"
        variable = "s3:x-amz-acl"

        values = [
          "bucket-owner-full-control"
        ]
      }
    }
  ]

  lifecycle_rules = [
    {
      id     = "logs"
      status = "Enabled"

      filter = {
        prefix = "${var.bucket_prefix}/"
      }

      transition = {
        days          = var.days_to_archive
        storage_class = var.archive_class
      }

      expiration = {
        days = var.days_to_expire
      }
    }
  ]
}

data "aws_iam_policy_document" "s3" {

  statement {
    sid       = "BucketACL"
    actions   = ["s3:GetBucketAcl", "s3:PutBucketAcl"]
    resources = [module.logs_export_bucket.bucket_arn]

    principals {
      type        = "Service"
      identifiers = ["logs.${var.aws_region}.amazonaws.com"]
    }
  }

  statement {
    sid       = "PutObject"
    actions   = ["s3:PutObject", "s3:PutObjectAcl"]
    resources = ["${module.logs_export_bucket.bucket_arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["logs.${var.aws_region}.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control"
      ]
    }
  }
}
