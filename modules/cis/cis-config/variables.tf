variable "company_name" {
  type = string
}
variable "env" {
  description = "Environment"
  type        = string
}
variable "sns_arn" {
  type = string
}
variable "tags" {
  default = {}
}

variable "use_existing_bucket" {
  type    = bool
  default = false
}
variable "existing_bucket_id" {
  type    = string
  default = ""
}

variable "configs_check_iam_root_access_key" {
  type    = bool
  default = false
}
  
variable "configs_check_iam_password_policy" {
  type    = bool
  default = false
}

variable "configs_check_root_account_mfa_enabled" {
  type    = bool
  default = false
}

variable "configs_check_access_keys_rotated" {
  type    = bool
  default = false
}

variable "configs_check_mfa_enabled_for_iam_console_access" {
  type    = bool
  default = false
}

variable "configs_check_multi_region_cloud_trail" {
  type    = bool
  default = false
}

variable "configs_check_cloud_trail_encryption" {
  type    = bool
  default = false
}

variable "configs_check_cloudtrail_enabled" {
  type    = bool
  default = false
}

variable "configs_check_cloud_trail_log_file_validation" {
  type    = bool
  default = false
}

variable "configs_check_cloud_trail_cloud_watch_logs_enabled" {
  type    = bool
  default = false
}

variable "configs_check_s3_bucket_level_public_access_prohibited" {
  type    = bool
  default = false
}

variable "configs_check_s3_bucket_ssl_requests_only" {
  type    = bool
  default = false
}

variable "configs_check_s3_bucket_server_side_encryption_enabled" {
  type    = bool
  default = false
}

variable "configs_check_ec2_encrypted_volumes" {
  type    = bool
  default = false
}


variable "configs_check_rds_public_access" {
  type    = bool
  default = false
}

variable "configs_check_rds_instance_public_access" {
  type    = bool
  default = false
}

variable "configs_check_rds_storage_encrypted" {
  type    = bool
  default = false
}

variable "configs_enable_efs_encrypted_check" {
  type    = bool
  default = false
}

variable "configs_check_iam_policy_no_statements_with_admin_access" {
  type    = bool
  default = false
}

variable "configs_check_iam_policy_no_statements_with_full_access" {
  type    = bool
  default = false
}

variable "configs_check_nacl_no_unrestricted_ssh_rdp" {
  type    = bool
  default = false
}

variable "configs_check_vpc_default_security_group_closed"  {
  type    = bool
  default = false
}
variable "configs_include_global_resource_types" {
  type = bool
  default = true
}

variable "configs_resource_types" {
  type  = list(string)
  default = []
}