resource "aws_sns_topic" "alert_topic" {
  name = "${var.env}-app-alert-topic"
  tags = {
    "Environment" : var.env
  }
}

resource "aws_lambda_function" "alerter" {
  function_name    = "in4it-logs-to-sns-${var.env}"
  handler          = "alerter.handler"
  role             = aws_iam_role.lambda_to_sns.arn
  runtime          = "python3.11"
  filename         = data.archive_file.code.output_path
  source_code_hash = data.archive_file.code.output_base64sha256

  environment {
    variables = {
      ENV             = var.env
      SNS_ALERT_TOPIC = aws_sns_topic.alert_topic.arn
      SUBJECT         = join(" - ", ["[${var.env}] ", var.subject_prefix])
    }
  }

  tags = {
    "Environment" : var.env
  }
}

resource "aws_cloudwatch_log_subscription_filter" "logs_subscription" {
  for_each        = toset(var.log_groups)
  name            = "${var.env}-app-alerts-subscription"
  log_group_name  = each.value
  filter_pattern  = var.logs_filter
  destination_arn = aws_lambda_function.alerter.arn
}
