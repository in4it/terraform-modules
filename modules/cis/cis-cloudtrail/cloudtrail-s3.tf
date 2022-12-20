
resource "aws_s3_bucket" "global-trail-bucket" {
  count  = var.use_existing_bucket ? 0 : 1
  bucket = "${var.company_name}-global-trail-bucket"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "global-trail-bucket" {
  count  = var.use_existing_bucket ? 0 : 1
  bucket = aws_s3_bucket.global-trail-bucket.0.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.global-trail.id
    }
  }
}

resource "aws_s3_bucket_public_access_block" "global-trail-bucket" {
  count  = var.use_existing_bucket ? 0 : 1
  bucket = aws_s3_bucket.global-trail-bucket.0.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "global-trail-bucket" {
  count  = var.use_existing_bucket ? 0 : 1
  bucket = aws_s3_bucket.global-trail-bucket.0.id

  policy = data.aws_iam_policy_document.global-trail-bucket-policy.0.json
}

resource "aws_s3_bucket_versioning" "global-trail-bucket" {
  count  = var.use_existing_bucket ? 0 : 1
  bucket = aws_s3_bucket.global-trail-bucket.0.id

  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_acl" "global-trail-bucket" {

  count  = var.use_existing_bucket ? 0 : 1
  bucket = aws_s3_bucket.global-trail-bucket.0.id

  acl = "private"
}

data "aws_iam_policy_document" "global-trail-bucket-policy" {
  count = var.use_existing_bucket ? 0 : 1

  statement {
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type        = "Service"
    }
    actions = ["s3:GetBucketAcl"]
    effect  = "Allow"
    resources = [
      "arn:aws:s3:::${var.company_name}-global-trail-bucket"
    ]
  }

  statement {
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type        = "Service"
    }
    actions = ["s3:PutObject"]
    effect  = "Allow"
    resources = [
      "arn:aws:s3:::${var.company_name}-global-trail-bucket/AWSLogs/${var.organization_id}/*",
    ]
    condition {
      test     = "StringEquals"
      values   = ["bucket-owner-full-control"]
      variable = "s3:x-amz-acl"
    }
  }

  statement {
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type        = "Service"
    }
    actions = ["s3:PutObject"]
    effect  = "Allow"
    resources = [
      "arn:aws:s3:::${var.company_name}-global-trail-bucket/AWSLogs/${var.aws_account_id}/*",
    ]
    condition {
      test     = "StringEquals"
      values   = ["bucket-owner-full-control"]
      variable = "s3:x-amz-acl"
    }
  }
  statement {
    sid = "AllowSSLRequestsOnly"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.global-trail-bucket.0.id}/*",
      "arn:aws:s3:::${aws_s3_bucket.global-trail-bucket.0.id}"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}
resource "aws_s3_bucket_logging" "global-trail-bucket" {
  count  = var.use_existing_bucket ? 0 : 1
  bucket = aws_s3_bucket.global-trail-bucket.0.id

  target_bucket = aws_s3_bucket.global-trail-bucket-access-logs.0.id
  target_prefix = "log/"
}
