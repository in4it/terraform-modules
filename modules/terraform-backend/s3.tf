resource "aws_s3_bucket" "infrastructure" {
  bucket = "${var.project}-terraform-${var.env}"

  tags = {
    Name        = "${var.project} ${var.env} infrastructure bucket"
    Project     = var.project
    Environment = var.env
  }
}

data "aws_iam_policy_document" "terraform-state-storage" {
  policy_id = "terraform-s3-${var.env}-state-policy"
  statement {
    sid = "AllowSSLRequestsOnly"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = [
      "arn:aws:s3:::${var.project}-terraform-${var.env}/*",
      "arn:aws:s3:::${var.project}-terraform-${var.env}"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "infrastructure" {
  bucket = aws_s3_bucket.infrastructure.id
  policy = data.aws_iam_policy_document.terraform-state-storage.json
}

resource "aws_s3_bucket_versioning" "infrastructure" {
  bucket = aws_s3_bucket.infrastructure.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "infrastructure" {
  bucket = aws_s3_bucket.infrastructure.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "infrastructure" {
  bucket = aws_s3_bucket.infrastructure.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = length(aws_kms_key.terraform-state) > 0 ? "aws:kms" : "AES256"
      kms_master_key_id = length(aws_kms_key.terraform-state) > 0 ? aws_kms_key.terraform-state[0].id : null
    }
  }
}
