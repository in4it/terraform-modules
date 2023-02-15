
module "aws_config" {
  source  = "trussworks/config/aws"
  version = "5.3.0"

  config_name          = "${var.company_name}-config-${var.env}"
  config_logs_bucket   = var.use_existing_bucket ? var.existing_bucket_id : aws_s3_bucket.awsconfig-s3.0.id
  config_sns_topic_arn = var.sns_arn

  config_delivery_frequency = "Six_Hours"

  check_iam_root_access_key                = true
  check_iam_password_policy                = true
  check_root_account_mfa_enabled           = true
  check_access_keys_rotated                = true
  access_key_max_age                       = 90
  check_mfa_enabled_for_iam_console_access = true

  check_multi_region_cloud_trail        = true
  check_cloud_trail_encryption          = true
  check_cloudtrail_enabled              = true
  check_cloud_trail_log_file_validation = true
  cloud_trail_cloud_watch_logs_enabled  = true

  check_s3_bucket_level_public_access_prohibited = true
  check_s3_bucket_ssl_requests_only              = true
  check_s3_bucket_server_side_encryption_enabled = true

  check_ec2_encrypted_volumes = true

  check_rds_public_access     = true
  check_rds_storage_encrypted = true

  enable_efs_encrypted_check = true

  check_iam_policy_no_statements_with_admin_access = true
  check_iam_policy_no_statements_with_full_access  = true
  check_nacl_no_unrestricted_ssh_rdp               = true
  check_vpc_default_security_group_closed          = true
}

resource "aws_s3_bucket" "awsconfig-s3" {
  count  = var.use_existing_bucket ? 0 : 1
  bucket = "${var.company_name}-awsconfig-s3-${var.env}"

  tags = {
    Name = "${var.company_name}-awsconfig"
  }
}

resource "aws_s3_bucket_public_access_block" "awsconfig-s3" {
  count  = var.use_existing_bucket ? 0 : 1
  bucket = aws_s3_bucket.awsconfig-s3.0.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "awsconfig-s3" {
  count  = var.use_existing_bucket ? 0 : 1
  bucket = aws_s3_bucket.awsconfig-s3.0.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "awsconfig-s3" {
  count  = var.use_existing_bucket ? 0 : 1
  bucket = aws_s3_bucket.awsconfig-s3.0.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "awsconfig-s3" {
  count  = var.use_existing_bucket ? 0 : 1
  bucket = aws_s3_bucket.awsconfig-s3.0.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "awsconfig-s3" {
  count  = var.use_existing_bucket ? 0 : 1
  bucket = aws_s3_bucket.awsconfig-s3.0.id
  policy = data.aws_iam_policy_document.awsconfig-s3-policy.0.json
}

data "aws_iam_policy_document" "awsconfig-s3-policy" {
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
      "arn:aws:s3:::${aws_s3_bucket.awsconfig-s3.0.id}/*",
      "arn:aws:s3:::${aws_s3_bucket.awsconfig-s3.0.id}"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}
