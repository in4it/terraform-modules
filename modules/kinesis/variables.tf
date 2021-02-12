variable "environment" {
  description = "AWS environment type i.e. prod"
  default     = ""
}

variable "name" {
  description = "Default prefix name"
}

variable "kms_description" {
  description = "default description"
  default     = "default"
}

variable "kinesis_stream_encryption" {
  description = "Encryption for kinesis stream"
  default     = false
}

variable "kinesis_shard_count" {
  description = "Kinesis stream shards number"
  default     = 1
}

variable "kinesis_retention_period" {
  description = "Kinesis stream retention period"
  default     = 24
}

variable "kms_deletion_window_in_days" {
  description = "Deletion window in_days"
  default     = 30
}

variable "kms_enable_key_rotation" {
  description = "kms enable key rotation"
  default     = true
}

variable "firehose_s3_compression_format" {
  description = "S3 compression format type"
  default     = "UNCOMPRESSED"
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

variable "s3_bucket_sse" {
  description = "S3 server-side encryption"
  default     = false
}

variable "vpcs_restriction_list" {
  description = "vpc list for s3 policy restricion"
  default     = []
}

variable "s3_deletion_protection" {
  description = "s3 deletion protection policy"
  default     = false
}

variable "s3_vpc_restriction_exception_roles" {
  description = "s3 vpc restriction exception roles"
  default     = []
}

variable "policy_role_name_encrypt_decrypt" {
  description = "policy role name for s3 encrypt and kinesis decrypt objects"
  default     = "service-keys-role-policy"
}

variable "policy_name_id" {
  description = "policy role name for s3 encrypt and kinesis decrypt objects"
  default     = "default-id"
}