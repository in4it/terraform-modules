variable "log_group" {
}

variable "cluster_name" {
}

variable "ecs_insights"  {
  default = "disabled"
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