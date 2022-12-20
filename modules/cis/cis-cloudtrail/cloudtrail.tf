
resource "aws_cloudtrail" "global-trail" {
  name           = "${var.company_name}-global-trail"
  s3_bucket_name = var.use_existing_bucket ? var.existing_bucket_id : aws_s3_bucket.global-trail-bucket.0.id

  include_global_service_events = true
  is_organization_trail         = true
  is_multi_region_trail         = true

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.global-trail.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.global-trail-cw-logs-role.arn

  enable_log_file_validation = true

  kms_key_id = aws_kms_key.global-trail.arn
}

resource "aws_kms_key" "global-trail" {
  deletion_window_in_days = 30
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.global-trail-bucket-kms.json

  lifecycle {
    prevent_destroy = true
  }
}

data "aws_iam_policy_document" "global-trail-bucket-kms" {
  statement {
    actions = [
      "kms:*",
    ]
    principals {
      identifiers = [
        "arn:aws:iam::${var.aws_account_id}:root",
      ]
      type = "AWS"
    }
    resources = [
      "*",
    ]
    sid = "Enable IAM User Permissions"
  }

  statement {
    actions = [
      "kms:GenerateDataKey*",
    ]
    condition {
      test = "StringLike"
      values = [
        "arn:aws:cloudtrail:*:${var.aws_account_id}:trail/*",
      ]
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
    }
    principals {
      identifiers = [
        "cloudtrail.amazonaws.com",
      ]
      type = "Service"
    }
    resources = [
      "*",
    ]
    sid = "Allow CloudTrail to encrypt logs"
  }

  statement {
    actions = [
      "kms:DescribeKey",
    ]
    principals {
      identifiers = [
        "cloudtrail.amazonaws.com",
      ]
      type = "Service"
    }
    resources = [
      "*",
    ]
    sid = "Allow CloudTrail to describe key"
  }


  statement {
    sid = "Allow principals in the account to decrypt log files"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "kms:Decrypt",
      "kms:ReEncryptFrom"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [var.aws_account_id]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = ["arn:aws:cloudtrail:*:${var.aws_account_id}:trail/*"]
    }
  }

  statement {
    sid = "Enable cross account log decryption"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "kms:Decrypt",
      "kms:ReEncryptFrom"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [var.aws_account_id]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = ["arn:aws:cloudtrail:*:${var.aws_account_id}:trail/*"]
    }
  }
}
