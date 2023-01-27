variable "tags" {
  default = {}
}
variable "bucket_name" {
  description = "The S3 bucket name"
  type        = string
}

variable "bucket_arn" {
  description = "The S3 bucket arn"
  type        = string
}

variable "transfer_server_name" {
  description = "Transfer Server name"
  type        = string
}

variable "transfer_server_users" {
  description = "Transfer server user(s)"
  type = list(object({
    name    = string
    key     = string
    homedir = string
  }))
}
