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
variable "max_allocated_storage" {
  description = "If greater than storage it will enable storage autoscaling"
  default     = 0
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
variable "vpc_id" {
  description = " vpc id"
}
variable "subnet_ids" {
  description = "subnet ids to launch RDS in"
  default     = []
}
variable "subnet_group" {
  description = "subnet group to launch RDS in"
  default     = ""
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
    pending_reboot = optional(bool)
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
variable "performance_insight_enabled" {
  description = "Enable Performance Insight"
  default     = false
}
variable "deletion_protection" {
  description = "Enable Deletion Protection"
  default     = true
}
variable "set_password" {
  description = "if true, set a random password"
  default     = true
}
variable "create_secret" {
  description = "if true, create a Secret Manager secret with db credentials"
  default     = false
}
variable "allow_self" {
  description = "if true, allows traffic from self"
  default     = false
}

variable "password_override_special" {
  description = "override special characters used for rds password"
  default     = "!#$%&*()-_=+[]{}<>:?"
}
variable "allow_major_version_upgrade" {
  description = "When upgrading the major version of an engine, allow_major_version_upgrade must be set to true."
  default     = false
}

variable "initial_snapshot_id" {
  type = string
  description = "Initial (Decrypted) snapshot DB to restore from (useful for restoring from a different region or account)"
  default     = ""
}
