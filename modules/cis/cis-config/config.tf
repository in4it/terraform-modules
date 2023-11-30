# on this module, We should to changed it the put-retention-configuration manually  because there isn't any way to do this on terraform yet
# See on this link: https://github.com/hashicorp/terraform-provider-aws/issues/13305
module "aws_config" {
  source  = "trussworks/config/aws"
  version = "5.3.0"

  config_name          = "${var.company_name}-config-${var.env}"
  config_logs_bucket   = var.use_existing_bucket ? var.existing_bucket_id : aws_s3_bucket.awsconfig-s3.0.id
  config_sns_topic_arn = var.sns_arn

  config_delivery_frequency = "Six_Hours"

  check_iam_root_access_key                        = var.configs_check_iam_root_access_key
  check_iam_password_policy                        = var.configs_check_iam_password_policy 
  check_root_account_mfa_enabled                   = var.configs_check_root_account_mfa_enabled                  
  check_access_keys_rotated                        = var.configs_check_access_keys_rotated                        
  check_mfa_enabled_for_iam_console_access         = var.configs_check_mfa_enabled_for_iam_console_access        
  check_multi_region_cloud_trail                   = var.configs_check_multi_region_cloud_trail                 
  check_cloud_trail_encryption                     = var.configs_check_cloud_trail_encryption                    
  check_cloudtrail_enabled                         = var.configs_check_cloudtrail_enabled                        
  check_cloud_trail_log_file_validation            = var.configs_check_cloud_trail_log_file_validation           
  cloud_trail_cloud_watch_logs_enabled             = var.configs_check_cloud_trail_cloud_watch_logs_enabled
  check_s3_bucket_level_public_access_prohibited   = var.configs_check_s3_bucket_level_public_access_prohibited  
  check_s3_bucket_ssl_requests_only                = var.configs_check_s3_bucket_ssl_requests_only               
  check_s3_bucket_server_side_encryption_enabled   = var.configs_check_s3_bucket_server_side_encryption_enabled  
  check_ec2_encrypted_volumes                      = var.configs_check_ec2_encrypted_volumes                     
  check_rds_public_access                          = var.configs_check_rds_public_access                         
  check_rds_storage_encrypted                      = var.configs_check_rds_storage_encrypted                     
  enable_efs_encrypted_check                       = var.configs_enable_efs_encrypted_check                      
  check_iam_policy_no_statements_with_admin_access = var.configs_check_iam_policy_no_statements_with_admin_access
  check_iam_policy_no_statements_with_full_access  = var.configs_check_iam_policy_no_statements_with_full_access 
  check_nacl_no_unrestricted_ssh_rdp               = var.configs_check_nacl_no_unrestricted_ssh_rdp              
  check_vpc_default_security_group_closed          = var.configs_check_vpc_default_security_group_closed         
  access_key_max_age                               = 90

  include_global_resource_types                    = var.configs_include_global_resource_types
  resource_types                                   = var.configs_resource_types
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

resource "aws_s3_bucket_ownership_controls" "awsconfig-s3" {
  count  = var.use_existing_bucket ? 0 : 1
  bucket = aws_s3_bucket.awsconfig-s3.0.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
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
