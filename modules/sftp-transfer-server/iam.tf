data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "transfer_server_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["transfer.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "transfer_server_assume_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:ListBucket",
      "s3:PutObject",
    ]

    resources = [
      var.bucket_arn,
      "${var.bucket_arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "transfer_server_to_cloudwatch_assume_policy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/transfer/*"]
  }
}

resource "aws_iam_role" "transfer_server_role" {
  name               = "${var.transfer_server_name}-transfer_server_role"
  assume_role_policy = data.aws_iam_policy_document.transfer_server_assume_role.json
}

resource "aws_iam_role_policy" "transfer_server_policy" {
  name   = "${var.transfer_server_name}-transfer_server_policy"
  role   = aws_iam_role.transfer_server_role.name
  policy = data.aws_iam_policy_document.transfer_server_assume_policy.json
}

resource "aws_iam_role_policy" "transfer_server_to_cloudwatch_policy" {
  name   = "${var.transfer_server_name}-transfer_server_to_cloudwatch_policy"
  role   = aws_iam_role.transfer_server_role.name
  policy = data.aws_iam_policy_document.transfer_server_to_cloudwatch_assume_policy.json
}