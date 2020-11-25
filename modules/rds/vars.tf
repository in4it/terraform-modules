variable "name" {
  description = "RDS name"
  default     = "mydb"
}
variable "username" {
  description = "RDS username"
}
variable "database_name" {
  description = "RDS database name"
}
variable "at_rest_encryption" {
  description = "enable at rest encryption with KMS"
  default     = true
}
variable "storage" {
  description = "RDS storage in GB"
  default     = 100
}
variable "storage_type" {
  description = "RDS storage type"
  default     = "gp2"
}
variable "instance_type" {
  description = "RDS instance type"
}
variable "engine" {
  description = "RDS engine"
}
variable "engine_version" {
  description = "RDS engine version"
}
variable "engine_family" {
  description = "RDS engine family"
}
variable "vpc_id" {
  description = " vpc id"
}
variable "subnet_ids" {
  description = "subnet ids to launch RDS in"
  default     = []
}
variable "subnet_group" {
  description = "subnet group to launch RDS in"
  default     = []
}
variable "ingress_security_groups" {
  description = "Security groups to allow"
  default     = []
}
variable "parameters" {
  description = "rds parameters to set"
  default     = []
  type = list(object({
    name  = string
    value = string
  }))
}
variable "multi_az" {
  default = false
}
variable "backup_retention_period" {
  description = "RDS backup retention period"
  default     = 30
}
variable "iam_database_authentication_enabled" {
  description = "enable iam auth"
  default     = true
}
