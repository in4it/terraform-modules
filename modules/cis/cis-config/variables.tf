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