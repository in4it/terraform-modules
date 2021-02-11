variable "environment" {
  description = "AWS environment type i.e. prod"
  default     = ""
}

variable "kinesis_stream_name" {
  description = "Kinesis stream name"
  default     = "kinesis-stream"
}

variable "kinesis_stream_encryption" {
  description = "Encryption for kinesis stream"
  default     = false
}

variable "shard_count" {
  description = "Kinesis stream shards number"
  default     = 1

}

variable "retention_period" {
  description = "Kinesis stream retention period"
  default     = 24
}

variable "kms_kinesis_key_description" {
  description = "Kinesis description for kms key"
  default     = "Default kms kinesis key"
}

variable "deletion_window_in_days" {
  description = "Deletion window in_days"
  default     = 30
}

variable "kinesis_enable_key_rotation" {
  description = "Kinesis enable key rotation"
  default     = true
}

variable "s3_enable_key_rotation" {
  description = "S3 enable key rotation"
  default     = true
}


variable "kinesis_firehose_name" {
  description = "Kinesis firehose name"
  default     = "kinesis-firehose"
}

variable "enable_kinesis_firehose" {
  description = "Enable kinesis firehose"
  default     = false
}

# currently only s3 destination is supported
variable "kinesis_firehose_destination" {
  description = "Kinesis firehose destination"
  default     = "s3"
}

variable "kms_s3_key_description" {
  description = "S3 description for kms key"
  default     = "Default kms S3 key"
}

variable "bucket_name" {
  description = "S3 bucket namme"
  default     = "s3-bucket-for-firehose-delivery-stream"
}

variable "iam_firehose_role" {
  description = "IAM role for firehose delivery stream"
  default     = "iam-firehose-role"
}

variable "s3_bucket_sse" {
  description = "S3 server-side encryption"
  default     = false
}

variable "s3_bucket_policy_id" {
  description = "S3 bucket policy id"
  default     = "s3-id"
}

variable "vpcs_restriction_list" {
  description = "vpc list for s3 policy restricion"
  default     = ""
}

variable "s3_vpc_restriction" {
  description = "s3 vpc policy restriction"
  default     = false
}

variable "s3_deletion_protection" {
  description = "s3 deletion protection policy"
  default     = false
}

variable "s3_vpc_restriction_role_whitelist" {
  description = "s3 role whitelist restriction"
  default     = false
}

variable "s3_bucket_arn" {
  description = "s3 bucket arn"
  default     = ""
}

variable "s3_vpc_restriction_exception_roles" {
  description = "s3 vpc restriction exception roles"
  default     = ""
}

variable "policy_role_name_encrypt_decrypt" {
  description = "policy role name for s3 encrypt and kinesis decrypt objects"
  default     = "service-keys-role-policy"
}