data "aws_iam_policy_document" "lambda_exec" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "basic_lambda_execution" {
  name = "AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy" "sqs_lambda_execution" {
  name = "AWSLambdaSQSQueueExecutionRole"
}

resource "aws_iam_role" "continuous_replica" {
  name               = "ContinuousReplicationLambdaExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.lambda_exec.json

  managed_policy_arns = [
    data.aws_iam_policy.sqs_lambda_execution.arn
  ]

  inline_policy {
    name   = "SSMAccess"
    policy = jsonencode({
      Version   = "2012-10-17"
      Statement = [
        {
          Sid    = "ReadSSMInSourceRegion"
          Effect = "Allow"
          Action = [
            "ssm:GetParameter",
            "ssm:GetParameters",
            "ssm:ListTagsForResource"
          ]
          Resource = [
            "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/*"
          ]
        },
        {
          Sid    = "REditSSMInBackupRegion"
          Effect = "Allow"
          Action = [
            "ssm:GetParameter",
            "ssm:PutParameter",
            "ssm:DeleteParameter",
            "ssm:AddTagsToResource"
          ]
          Resource = [
            "arn:aws:ssm:${var.backup_region}:${data.aws_caller_identity.current.account_id}:parameter/*"
          ]
        },
        {
          Sid    = "DecryptSSM"
          Effect = "Allow"
          Action = [
            "kms:Decrypt",
            "kms:Encrypt"
          ]
          Resource = var.kms_keys
        }
      ]
    })
  }
}

resource "aws_iam_role" "events_to_lambda" {
  name               = "SSMEventsToContinuousReplicationLambdaRole"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "events.amazonaws.com"
        }
      }
    ]
  })
  inline_policy {
    name   = "CallLambda"
    policy = jsonencode({
      Version   = "2012-10-17"
      Statement = [
        {
          Action   = "lambda:InvokeFunction"
          Effect   = "Allow"
          Resource = [aws_lambda_function.continuous_replica.arn, aws_lambda_function.full_replica.arn]
        }
      ]
    })
  }
}

resource "aws_iam_role" "full_replica" {
  name               = "FullReplicationLambdaExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.lambda_exec.json

  managed_policy_arns = [
    data.aws_iam_policy.basic_lambda_execution.arn
  ]

  inline_policy {
    name   = "SQSSend"
    policy = jsonencode({
      Version   = "2012-10-17"
      Statement = [
        {
          Sid    = "SQSPermissions"
          Effect = "Allow"
          Action = [
            "sqs:SendMessage"
          ]
          Resource = aws_sqs_queue.replication.arn
        },
        {
          Sid = "ReadSSM"
          Effect = "Allow"
          Action = [
            "ssm:DescribeParameters"
          ]
          Resource = ["arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
        }
      ]
    })
  }
}
