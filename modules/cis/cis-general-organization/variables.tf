variable "company_name" {
  type = string
}
variable "env" {
  description = "Environment"
  type        = string
}
variable "aws_account_id" {
  type = string
}
variable "tags" {
  default = {}
}
variable "security_hub_members" {
  type    = map(string)
  default = {}
}

