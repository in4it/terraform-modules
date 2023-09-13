variable "name" {
  description = "name of the s3 bucket"
}

variable "prevent_destroy" {
  description = "prevent destruction of the s3 bucket with the prevent_destroy flag"
  default     = true
}

variable "versioning" {
  description = "enable s3 versioning"
  default     = true
}
