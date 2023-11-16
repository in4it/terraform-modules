variable "password_length" {
  default = 16
}
variable "password_override_special" {
  description = "override special characters used for rds password"
  default     = "!#$%&*()-_=+[]{}<>:?"
}

variable "name" {
  type = string
}
variable "description" {
  default = ""
}

variable "username" {
  type = string
}
variable "engine" {
  type = string

  validation {
    condition     = can(regex("^(mysql|postgres|mariadb|oracle|sqlserver|mongo|redshift)$", var.engine))
    error_message = "Engine must be one of mysql, postgres, mariadb, oracle, sqlserver, mongo, redshift"
  }
}
variable "host" {
  type = string
}
variable "port" {
  type = number
}
variable "dbname" {
  type = string
}
variable "dbInstanceIdentifier" {
  default     = ""
  type        = string
  description = "Usually the prefix of the RDS host. Identifier inside AWS region of DB."
}
variable "password" {
  type        = string
  default     = null
  description = "If not set, a random password will be generated."
}
