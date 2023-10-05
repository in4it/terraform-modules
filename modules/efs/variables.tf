variable "name" {
  description = "Name of the EFS"
  type        = string
}
variable "ingress_security_groups" {
  description = "List of security groups to allow ingress from to the EFS"
  type        = list(string)
}
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}
variable "lifecycle_policies" {
  type    = any
  default = {}
}
variable "performance_mode" {
  description = "'generalPurpose' or 'maxIO'"
  type        = string
  default     = "generalPurpose"
}
variable "encrypted" {
  description = "Whether to enable encryption at rest"
  type        = bool
  default     = true
}
