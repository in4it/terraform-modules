resource "aws_s3_bucket" "this" {
  bucket = var.name

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = var.public_access_block.block_public_acls
  block_public_policy     = var.public_access_block.block_public_policy
  ignore_public_acls      = var.public_access_block.ignore_public_acls
  restrict_public_buckets = var.public_access_block.restrict_public_buckets
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.versioning ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  policy_id = "s3-bucket-policy"

  dynamic "statement" {
    for_each = var.cloudfront_origins != null ? var.cloudfront_origins : []
    content {
      sid = "PolicyForCouldFrontPrivateContent${statement.key}"
      principals {
        identifiers = [
          statement.value.oai_arn
        ]
        type = "AWS"
      }
      effect    = "Allow"
      actions   = statement.value.oai_iam_actions
      resources = statement.value.allow_path == "" ? [
        "arn:aws:s3:::${aws_s3_bucket.this.id}",
        "arn:aws:s3:::${aws_s3_bucket.this.id}/*",
      ] : ["${aws_s3_bucket.this.arn}/${statement.value.allow_path}/*"]
    }
  }
  statement {
    sid = "allowSSLRequestsOnly"
    principals {
      identifiers = ["*"]
      type        = "*"
    }
    effect  = "Deny"
    actions = [
      "s3:*"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.this.id}",
      "arn:aws:s3:::${aws_s3_bucket.this.id}/*",
    ]
    condition {
      test     = "Bool"
      values   = ["false"]
      variable = "aws:secureTransport"
    }
  }
  dynamic "statement" {
    for_each = var.additional_policy_statements
    content {
      sid = try(statement.value.sid, "AdditionS3Policy${statement.key}")
      principals {
        identifiers = statement.value.principals.identifiers
        type        = statement.value.principals.type
      }
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources
      dynamic "condition" {
        for_each = statement.value.conditions == null ? [] : statement.value.conditions
        content {
          test     = condition.value.test
          values   = condition.value.values
          variable = condition.value.variable
        }
      }
    }
  }
}

# Lifecycle rules
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count = length(var.lifecycle_rules) > 0 ? 1 : 0
  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id
      status = rule.value.status

      dynamic "filter" {
        for_each = rule.value.filter == null ? [] : [rule.value.filter]
        content {
          prefix                   = lookup(filter.value, "prefix", null)
          object_size_greater_than = lookup(filter.value, "object_size_greater_than", null)
          object_size_less_than    = lookup(filter.value, "object_size_less_than", null)
          dynamic "and" {
            for_each = filter.value.and == null ? [] : [filter.value.and]
            content {
              prefix                   = lookup(and.value, "prefix", null)
              object_size_greater_than = lookup(and.value, "object_size_greater_than", null)
              object_size_less_than    = lookup(and.value, "object_size_less_than", null)
              tags                     = lookup(and.value, "tags", null)
            }
          }
        }
      }

      dynamic "transition" {
        for_each = rule.value.transition == null ? [] : [rule.value.transition]
        content {
          storage_class = transition.value.storage_class
          date          = lookup(transition.value, "date", null)
          days          = lookup(transition.value, "days", null)
        }
      }

      dynamic "expiration" {
        for_each = rule.value.expiration == null ? [] : [rule.value.expiration]
        content {
          days = expiration.value.days
        }
      }
    }
  }
}
