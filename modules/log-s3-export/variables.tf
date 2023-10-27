variable "name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "log_groups_list" {
  type = list(string)
}

variable "bucket_prefix" {
  type = string
  validation {
    condition     = substr(var.bucket_prefix, -1, 1) != "/" && substr(var.bucket_prefix, 0, 1) != "/"
    error_message = "The bucket_prefix must not end or begin with a '/'."
  }
}
variable "archive_class" {
  type    = string
  default = "GLACIER"
}
variable "export_days_before" {
  type        = number
  description = "Number of days to export logs from"
  default     = 1
}
variable "days_to_archive" {
  type        = number
  default     = 180
  description = "Number of days to keep logs in S3 before moving to Glacier"
}
variable "days_to_expire" {
  type        = number
  default     = 365
  description = "Number of days to keep logs in S3 before expiring/deleting"
}
variable "check_retry_timeout" {
  type        = number
  default     = 5000
  description = "Number of milli-seconds to wait before retrying checking status of an export task"
}
variable "check_retry_attempts" {
  type        = number
  default     = 5
  description = "Number of times to retry checking status of an export task"
}
