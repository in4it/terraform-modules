data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_lambda_function" "continuous_replica" {
  function_name = "SsmContinuousReplication"
  description = "It continuously replicates SSM actions to backup region ${var.backup_region}"
  role          = aws_iam_role.continuous_replica.arn
  handler       = "continuous.handler"
  runtime       = "python3.12"
  timeout       = 900
  memory_size   = 512
  architectures = ["arm64"]

  filename         = data.archive_file.continuous-replica.output_path
  source_code_hash = data.archive_file.continuous-replica.output_base64sha512

  environment {
    variables = {
      TARGET_REGION = var.backup_region
    }
  }
}

# Real-time replication via SSM events
resource "aws_cloudwatch_event_rule" "continuous_replica" {
  name          = "ContinuousSSMReplica"
  role_arn = aws_iam_role.events_to_lambda.arn

  description   = "Track SSM Config and reflect it in backup region"
  event_pattern = jsonencode({
    source = [
      "aws.ssm"
    ]
    detail-type = [
      "Parameter Store Change"
    ]
  })
}

resource "aws_cloudwatch_event_target" "ssm_event_mapping" {
  arn  = aws_lambda_function.continuous_replica.arn
  rule = aws_cloudwatch_event_rule.continuous_replica.id
}

# Daily replication via batches
resource "aws_sqs_queue" "replication" {
  name                       = "SSM-SQS-replication"
  visibility_timeout_seconds = 1000
}

resource "aws_lambda_event_source_mapping" "sqs_mapping" {
  event_source_arn = aws_sqs_queue.replication.arn
  function_name    = aws_lambda_function.continuous_replica.function_name
  batch_size       = 10
}

resource "aws_lambda_function" "full_replica" {
  function_name = "SsmFullReplication"
  description   = "It executes weekly to copy all params from ${data.aws_region.current.name} to ${var.backup_region}"
  role          = aws_iam_role.full_replica.arn
  handler       = "full.handler"
  runtime       = "python3.12"
  timeout       = 900
  memory_size   = 512
  architectures = ["arm64"]

  filename         = data.archive_file.full-replica.output_path
  source_code_hash = data.archive_file.full-replica.output_base64sha512

  environment {
    variables = {
      TARGET_REGION = var.backup_region
      QUEUE_URL     = aws_sqs_queue.replication.url
    }
  }
}

resource "aws_cloudwatch_event_rule" "weekly_replication" {
  name                = "WeeklySSMReplication"
  description         = "Run full SSM replication every Saturday 9AM"
  schedule_expression = "cron(0 9 ? * 6 *)"
  role_arn = aws_iam_role.events_to_lambda.arn
}

resource "aws_cloudwatch_event_target" "weekly_event_mapping" {
  arn  = aws_lambda_function.full_replica.arn
  rule = aws_cloudwatch_event_rule.weekly_replication.id
}
