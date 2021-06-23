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

variable "transfer_server_user_names" {
  description = "User name(s) for SFTP server"
  type        = list(string)
}

variable "transfer_server_ssh_keys" {
  description = "SSH Key(s) for transfer server user(s)"
  type        = list(string)
}
