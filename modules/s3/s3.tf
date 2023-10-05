resource "aws_s3_bucket" "this" {
  bucket = var.name

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
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
    for_each = var.cloudfront_origin_access_identity_arn == "" ? [] : [var.cloudfront_origin_access_identity_arn]
    content {
      sid = "PolicyForCouldFrontPrivateContent"
      principals {
        identifiers = [
          var.cloudfront_origin_access_identity_arn
        ]
        type = "AWS"
      }
      effect  = "Allow"
      actions = var.cloudfront_origin_access_identity_iam_actions
      resources = [
        "arn:aws:s3:::${aws_s3_bucket.this.id}",
        "arn:aws:s3:::${aws_s3_bucket.this.id}/*",
      ]
    }
  }
  statement {
    sid = "allowSSLRequestsOnly"
    principals {
      identifiers = ["*"]
      type        = "*"
    }
    effect = "Deny"
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
    for_each = var.additional_policy_statements == "" ? [] : var.additional_policy_statements
    content {
      sid = try(each.value.sid, "AdditionS3Policy${each.key}")
      principals {
        identifiers = each.value.principals.identifiers
        type        = each.value.principals.type
      }
      effect    = each.value.effect
      actions   = each.value.actions
      resources = each.value.resources
      condition {
        test     = each.value.condition.test
        values   = each.value.condition.values
        variable = each.value.condition.variable
      }
    }
  }
}

