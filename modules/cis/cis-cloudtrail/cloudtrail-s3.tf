
resource "aws_s3_bucket" "global-trail-bucket" {
  bucket = "${var.company_name}-global-trail-bucket"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "global-trail-bucket" {

  bucket = aws_s3_bucket.global-trail-bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.global-trail.id
    }
  }
}

resource "aws_s3_bucket_public_access_block" "global-trail-bucket" {
  bucket = aws_s3_bucket.global-trail-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "global-trail-bucket" {

  bucket = aws_s3_bucket.global-trail-bucket.id
  policy = data.aws_iam_policy_document.global-trail-bucket-policy.json
}

resource "aws_s3_bucket_versioning" "global-trail-bucket" {

  bucket = aws_s3_bucket.global-trail-bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_acl" "global-trail-bucket" {

  bucket = aws_s3_bucket.global-trail-bucket.id
  acl    = "private"
}

data "aws_iam_policy_document" "global-trail-bucket-policy" {

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
      "arn:aws:s3:::${aws_s3_bucket.global-trail-bucket.id}/*",
      "arn:aws:s3:::${aws_s3_bucket.global-trail-bucket.id}"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}
resource "aws_s3_bucket_logging" "global-trail-bucket" {
  bucket        = aws_s3_bucket.global-trail-bucket.id
  target_bucket = aws_s3_bucket.global-trail-bucket-access-logs.id
  target_prefix = "log/"
}
