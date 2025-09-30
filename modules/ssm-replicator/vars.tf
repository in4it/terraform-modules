variable "backup_region" {
  type = string
  description = "Where to replicate SSM Params"
}

variable "kms_keys" {
  type = list(string)
  description = "What kms keys to use to decrypt ssm"
}

variable "sqs_kms_master_key_id" {
  description = "KMS key arn to encrypt SQS queue"
  default     = ""
}