# Event trigger
resource "aws_cloudwatch_event_rule" "trigger_every" {
  name                = "${var.name_prefix}-${var.env}-trigger"
  description         = "Trigger lambda function to generate custom ECS scaling metric"
  schedule_expression = "rate(${var.lambda_trigger_period})"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.trigger_every.name
  target_id = "${var.name_prefix}-${var.env}-trigger-lambda"
  arn       = aws_lambda_function.ecs_sqs_scaling.arn
}

resource "aws_lambda_permission" "allow_triggering_function" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ecs_sqs_scaling.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.trigger_every.arn
}

# Lambda function
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src/lambda/"
  output_path = "${path.module}/src/tmp/lambda.zip"
}

resource "aws_lambda_function" "ecs_sqs_scaling" {
  function_name    = "${var.name_prefix}-${var.env}-custom-metric-lambda"
  role             = aws_iam_role.ecs_sqs_scaling.arn
  handler          = "index.handler"
  filename         = "${path.module}/src/tmp/lambda.zip"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "nodejs20.x"
  timeout          = 120

  environment {
    variables = {
      CONFIG                  = jsonencode(var.config)
      ENV                     = var.env
      CUSTOM_METRIC_NAMESPACE = var.custom_metric_namespace
      CUSTOM_METRIC_NAME      = var.custom_metric_name
      DEBUG                   = var.debug_mode
    }
  }
  tracing_config {
    mode = "Active"
  }
}

# IAM for lambda function
resource "aws_iam_role" "ecs_sqs_scaling" {
  name               = "${var.name_prefix}-${var.env}-custom-metric-lambda"
  assume_role_policy = data.aws_iam_policy_document.ecs_sqs_scaling_sts.json
}

data "aws_iam_policy_document" "ecs_sqs_scaling_sts" {

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

data "aws_iam_policy_document" "ecs_sqs_scaling" {
  statement {
    sid = "LogsAccess"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
  statement {
    sid = "CloudwatchAccess"
    actions = [
      "cloudwatch:PutMetricData",
      "cloudwatch:List*",
      "cloudwatch:Get*"
    ]
    resources = ["*"]
  }
  statement {
    sid = "SQSAccess"
    actions = [
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ListQueues",
      "sqs:Describe*"
    ]
    resources = ["*"]
  }
  statement {
    sid = "ECSAccess"
    actions = [
      "ecs:Describe*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecs_sqs_scaling" {
  name   = "${var.name_prefix}-${var.env}-custom-metric-lambda"
  policy = data.aws_iam_policy_document.ecs_sqs_scaling.json
}

resource "aws_iam_role_policy_attachment" "ecs_sqs_scaling" {
  role       = aws_iam_role.ecs_sqs_scaling.name
  policy_arn = aws_iam_policy.ecs_sqs_scaling.arn
}
