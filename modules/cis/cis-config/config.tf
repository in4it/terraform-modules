
module "aws_config" {
  source  = "trussworks/config/aws"
  version = "4.5.0"

  config_name          = "${var.company_name}-config-${var.env}"
  config_logs_bucket   = aws_s3_bucket.awsconfig-s3.id
  config_sns_topic_arn = var.sns_arn

  config_delivery_frequency = "Six_Hours"

  check_approved_amis_by_tag               = false
  check_cloud_trail_encryption             = true
  check_cloudtrail_enabled                 = true
  check_ec2_imdsv2                         = true
  check_eip_attached                       = true
  check_guard_duty                         = true
  check_mfa_enabled_for_iam_console_access = true
  check_rds_public_access                  = true
  check_root_account_mfa_enabled           = true
}

resource "aws_s3_bucket" "awsconfig-s3" {
  bucket = "${var.company_name}-awsconfig-s3-${var.env}"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "${var.company_name}-awsconfig"
  }
}

resource "aws_s3_bucket_public_access_block" "awsconfig-s3" {

  bucket = aws_s3_bucket.awsconfig-s3.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "awsconfig-s3" {

  bucket = aws_s3_bucket.awsconfig-s3.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "awsconfig-s3" {

  bucket = aws_s3_bucket.awsconfig-s3.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_acl" "awsconfig-s3" {

  bucket = aws_s3_bucket.awsconfig-s3.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "awsconfig-s3" {
  bucket = aws_s3_bucket.awsconfig-s3.id
  policy = data.aws_iam_policy_document.awsconfig-s3-policy.json
}

data "aws_iam_policy_document" "awsconfig-s3-policy" {

  statement {
    sid = "AllowSSLRequestsOnly"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.awsconfig-s3.id}/*",
      "arn:aws:s3:::${aws_s3_bucket.awsconfig-s3.id}"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}
