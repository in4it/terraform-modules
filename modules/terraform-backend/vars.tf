variable "env" {
  default     = "dev"
  description = "The environment for the terraform backend"
}

variable "project" {
  type        = string
  description = "The name of the project/product"
}

variable "lock_table_enabled" {
  default = true
  description = "True - to enable locking of the state file with DynamoDB"
}

variable "kms-encryption" {
  default = true
  description = "True - to Create KMS key to use for encrypting the S3 bucket. Otherwise - AES256 will be used"
}

variable "kms-deletion-window" {
  default = 30
  description = "The duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days"
  validation {
    condition = var.kms-deletion-window >= 7 && var.kms-deletion-window <= 30
    error_message = "kms-deletion-window must be between 7 and 30 days"
  }
}

variable "principals" {
  description = "List of principals allowed to use kms key"
  type        = list(object({
    type        = string
    identifiers = list(string)
  }))
  default = []
}
