variable "company_name" {
  type = string
}
variable "env" {
  description = "Environment"
  type        = string
}
variable "organization_id" {
  type = string
}
variable "aws_account_id" {
  type = string
}
variable "tags" {
  default = {}
}