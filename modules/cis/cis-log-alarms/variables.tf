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
variable "alarm_namespace" {
  type = string
}
variable "existing_log_group_name" {
  type = string
}
variable "tags" {
  default = {}
}