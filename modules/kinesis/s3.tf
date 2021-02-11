data "aws_caller_identity" "current" {}

locals {
  s3_server_side_encryption_configuration_rules = var.s3_bucket_sse ? [
    {
      kms_master_key_id = var.enable_kinesis_firehose == true ? aws_kms_key.s3-kms[0].arn : ""
      sse_algorithm     = "aws:kms"
    }
  ] : []

}

resource "aws_s3_bucket" "s3-bucket" {
  count  = var.enable_kinesis_firehose == true ? 1 : 0
  bucket = var.environment == "" ? var.bucket_name : "${var.bucket_name}-${var.environment}"
  acl    = "private"

  versioning {
    enabled = true
  }

  dynamic "server_side_encryption_configuration" {
    for_each = local.s3_server_side_encryption_configuration_rules
    content {
      rule {
        apply_server_side_encryption_by_default {
          kms_master_key_id = server_side_encryption_configuration.value.kms_master_key_id
          sse_algorithm     = server_side_encryption_configuration.value.sse_algorithm
        }
      }
    }
  }

  policy = var.s3_vpc_restriction == true || var.s3_deletion_protection == true || var.s3_vpc_restriction_role_whitelist == true ? data.aws_iam_policy_document.bucket-policy.json : ""
}


resource "aws_s3_bucket_public_access_block" "s3-public-access-block" {
  count  = var.enable_kinesis_firehose == true ? 1 : 0
  bucket = aws_s3_bucket.s3-bucket[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}

data "aws_iam_policy_document" "bucket-policy" {
  policy_id = var.environment == "" ? "${var.s3_bucket_policy_id}-public-policy" : "${var.s3_bucket_policy_id}-${var.environment}-public-policy"
  dynamic "statement" {
    for_each = var.s3_vpc_restriction ? ["Access-to-specific-VPC-only"] : []
    content {
      sid = "Access-to-specific-VPC-only"
      principals {
        type        = "*"
        identifiers = ["*"]
      }
      actions = ["s3:*"]
      effect  = "Deny"
      resources = [
        var.s3_bucket_arn,
        "${var.s3_bucket_arn}/*"
        #aws_s3_bucket.s3-bucket[0].arn,
        #"${aws_s3_bucket.s3-bucket[0].arn}/*"
      ]
      condition {
        test     = "StringNotEquals"
        variable = "aws:sourceVpc"

        values = var.vpcs_restriction_list
      }
      condition {
        test     = "ArnNotLike"
        variable = "aws:PrincipalArn"

        values = [
          var.s3_vpc_restriction_exception_roles == "" ? "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/glue-*" : var.s3_vpc_restriction_exception_roles
        ]
      }
      condition {
        test     = "ArnNotEquals"
        variable = "aws:PrincipalArn"

        values = [
          var.enable_kinesis_firehose == true ? aws_iam_role.iam-firehose-role[0].arn : ""
        ]
      }
    }
  }
  dynamic "statement" {
    for_each = var.s3_deletion_protection ? ["deny-delete-policy"] : []
    content {
      sid = "deny-delete-policy"
      principals {
        type        = "AWS"
        identifiers = ["*"]
      }
      effect  = "Deny"
      actions = ["s3:DeleteBucket"]
      resources = [
        var.s3_bucket_arn
      ]
    }
  }
  dynamic "statement" {
    for_each = var.s3_vpc_restriction_role_whitelist ? ["allow-whitelist-role"] : []
    content {
      sid    = "1"
      effect = "Allow"
      principals {
        type        = "AWS"
        identifiers = [var.enable_kinesis_firehose == true ? aws_iam_role.iam-firehose-role[0].arn : ""]
      }
      actions = [
        "s3:AbortMultipartUpload",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:PutObject"
      ]
      resources = [
        var.s3_bucket_arn,
        "${var.s3_bucket_arn}/*"
      ]
    }
  }
}