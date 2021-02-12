data "aws_caller_identity" "current" {}

locals {
  s3_server_side_encryption_configuration_rules = var.s3_bucket_sse ? [
    {
      kms_master_key_id = var.enable_kinesis_firehose == true ? aws_kms_key.s3-kms[0].arn : ""
      sse_algorithm     = "aws:kms"
    }
  ] : []

  bucket_name = var.environment == "" ? "${var.name}-s3" : "${var.name}-s3-${var.environment}"

}

resource "aws_s3_bucket" "s3-bucket" {
  count  = var.enable_kinesis_firehose == true ? 1 : 0
  bucket = local.bucket_name
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

  policy = data.aws_iam_policy_document.bucket-policy[0].json
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
  count  = var.enable_kinesis_firehose == true ? 1 : 0
  policy_id = var.environment == "" ? "${var.policy_name_id}-${var.kinesis_firehose_destination}-public-policy" : "${var.policy_name_id}-${var.kinesis_firehose_destination}-${var.environment}-public-policy"
  dynamic "statement" {
    for_each = length(var.vpcs_restriction_list) > 0 ? ["Access-to-specific-VPC-only"] : []
    content {
      sid = "Access-to-specific-VPC-only"
      principals {
        type        = "*"
        identifiers = ["*"]
      }
      actions = ["s3:*"]
      effect  = "Deny"
      resources = [
        "arn:aws:s3:::${local.bucket_name}",
        "arn:aws:s3:::${local.bucket_name}/*"
      ]
      condition {
        test     = "StringNotEquals"
        variable = "aws:sourceVpc"

        values = var.vpcs_restriction_list
      }
      dynamic "condition" {
        for_each = length(var.s3_vpc_restriction_exception_roles) > 0 ? ["exception-roles"] : []
        content {
            test     = "ArnNotLike"
            variable = "aws:PrincipalArn"
       
            values = var.s3_vpc_restriction_exception_roles
        }
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
      sid = "${var.policy_name_id}-deny-delete-policy"
      principals {
        type        = "AWS"
        identifiers = ["*"]
      }
      effect  = "Deny"
      actions = ["s3:DeleteBucket"]
      resources = [
        "arn:aws:s3:::${local.bucket_name}"
      ]
    }
  }
  statement {
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
        "arn:aws:s3:::${local.bucket_name}",
        "arn:aws:s3:::${local.bucket_name}/*"
      ]
  }
}