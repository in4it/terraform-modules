data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_region = data.aws_region.current.id
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  for_each = toset(var.log_groups)
  action       = "lambda:InvokeFunction"
  function_name= aws_lambda_function.alerter.function_name
  principal    = "logs.${local.aws_region}.amazonaws.com"
  source_arn = format("arn:aws:logs:%s:%s:log-group:%s:*", local.aws_region, local.aws_account_id, each.value)

  statement_id = "AllowExecutionFromCloudWatch"
}

resource "aws_iam_role" "lambda_to_sns" {
  name = "AlertLambdaRole-${var.env}"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_to_sns_basic_execution" {
  role       = aws_iam_role.lambda_to_sns.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_to_sns" {
  name = "AlertLambdaPolicy-${var.env}"
  role = aws_iam_role.lambda_to_sns.id

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "sns:Publish"
        ],
        Resource = [
          aws_sns_topic.alert_topic.arn
        ]
      }
    ]
  })
}

