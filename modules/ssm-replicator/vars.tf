variable "backup_region" {
  type = string
  description = "Where to replicate SSM Params"
}

variable "kms_keys" {
  type = list(string)
  description = "What kms keys to use to decrypt ssm"
}
