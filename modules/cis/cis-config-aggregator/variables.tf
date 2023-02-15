variable "company_name" {
  type = string
}
variable "env" {
  description = "Environment"
  type        = string
}
variable "tags" {
  default = {}
}