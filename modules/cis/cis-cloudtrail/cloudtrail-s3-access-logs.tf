resource "aws_s3_bucket" "global-trail-bucket-access-logs" {
  count  = var.use_existing_bucket ? 0 : 1
  bucket = "${var.company_name}-global-trail-bucket-access-logs-access-log"
}

resource "aws_s3_bucket_public_access_block" "global-trail-bucket-access-logs" {
  count  = var.use_existing_bucket ? 0 : 1
  bucket = aws_s3_bucket.global-trail-bucket-access-logs.0.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "global-trail-bucket-access-logs" {
  count  = var.use_existing_bucket ? 0 : 1
  bucket = aws_s3_bucket.global-trail-bucket-access-logs.0.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "global-trail-bucket-access-logs" {
  count  = var.use_existing_bucket ? 0 : 1
  bucket = aws_s3_bucket.global-trail-bucket-access-logs.0.id

  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_acl" "global-trail-bucket-access-logs" {
  count  = var.use_existing_bucket ? 0 : 1
  bucket = aws_s3_bucket.global-trail-bucket-access-logs.0.id

  acl = "private"
}

resource "aws_s3_bucket_policy" "global-trail-bucket-access-logs" {
  count  = var.use_existing_bucket ? 0 : 1
  bucket = aws_s3_bucket.global-trail-bucket-access-logs.0.id

  policy = data.aws_iam_policy_document.global-trail-bucket-access-logs-policy.0.json
}

data "aws_iam_policy_document" "global-trail-bucket-access-logs-policy" {
  count = var.use_existing_bucket ? 0 : 1

  statement {
    sid = "AllowSSLRequestsOnly"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.global-trail-bucket-access-logs.0.id}/*",
      "arn:aws:s3:::${aws_s3_bucket.global-trail-bucket-access-logs.0.id}"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}
