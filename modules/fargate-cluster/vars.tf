variable "log_group" {
}

variable "cluster_name" {
}

variable "execution_role_policy" {
  default = ""
}

variable "log_retention_days" {
  default = 0
}

variable "enable_execute_command" {
  type    = bool
  default = false
}