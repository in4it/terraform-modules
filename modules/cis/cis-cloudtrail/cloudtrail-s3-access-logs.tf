
resource "aws_s3_bucket" "global-trail-bucket-access-logs" {
  bucket = "${var.company_name}-global-trail-bucket-access-logs-access-log"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "global-trail-bucket-access-logs" {

  bucket = aws_s3_bucket.global-trail-bucket-access-logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "global-trail-bucket-access-logs" {

  bucket = aws_s3_bucket.global-trail-bucket-access-logs.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "global-trail-bucket-access-logs" {

  bucket = aws_s3_bucket.global-trail-bucket-access-logs.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_acl" "global-trail-bucket-access-logs" {

  bucket = aws_s3_bucket.global-trail-bucket-access-logs.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "global-trail-bucket-access-logs" {
  bucket = aws_s3_bucket.global-trail-bucket-access-logs.id
  policy = data.aws_iam_policy_document.global-trail-bucket-access-logs-policy.json
}

data "aws_iam_policy_document" "global-trail-bucket-access-logs-policy" {

  statement {
    sid = "AllowSSLRequestsOnly"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.global-trail-bucket-access-logs.id}/*",
      "arn:aws:s3:::${aws_s3_bucket.global-trail-bucket-access-logs.id}"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}
