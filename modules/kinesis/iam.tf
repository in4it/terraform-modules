data "aws_region" "current" {}

locals {
  iam_kms_encryption_actions = [
    "kms:Encrypt",
    "kms:ReEncrypt*",
    "kms:GenerateDataKey*",
    "kms:DescribeKey"
  ]
  iam_kms_decryption_actions = [
    "kms:DescribeKey",
    "kms:Decrypt"
  ]

}

resource "aws_iam_role" "iam-firehose-role" {
  count = var.enable_kinesis_firehose == true ? 1 : 0
  name  = var.environment == "" ? var.iam_firehose_role : "${var.iam_firehose_role}-${var.environment}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "iam-role-policy-firehose" {
  count  = var.enable_kinesis_firehose == true ? 1 : 0
  name   = var.environment == "" ? var.iam_firehose_role : "${var.iam_firehose_role}-${var.environment}"
  role   = aws_iam_role.iam-firehose-role[0].id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1463994789000",
            "Effect": "Allow",
            "Action": [
                "kinesis:DescribeStream",
                "kinesis:GetShardIterator",
                "kinesis:GetRecords"
            ],
            "Resource": [
                "arn:aws:kinesis:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:stream/${aws_kinesis_stream.kinesis-stream.name}"
            ]
        }
    ]
}
EOF
}

data "aws_iam_policy_document" "service-keys-policy" {
  statement {
    effect    = "Allow"
    actions   = distinct(concat(local.iam_kms_encryption_actions))
    resources = [var.s3_bucket_sse == true && var.enable_kinesis_firehose == true ? aws_kms_key.s3-kms[0].arn : ""]

  }
  statement {
    effect    = "Allow"
    actions   = distinct(concat(local.iam_kms_decryption_actions))
    resources = [var.kinesis_stream_encryption == true && var.enable_kinesis_firehose == true ? aws_kms_key.kinesis-kms[0].arn : ""]
  }
}

resource "aws_iam_role_policy" "service-keys-role-policy" {
  count  = var.enable_kinesis_firehose == true ? 1 : 0
  name   = var.policy_role_name_encrypt_decrypt
  role   = aws_iam_role.iam-firehose-role[0].id
  policy = data.aws_iam_policy_document.service-keys-policy.json
}