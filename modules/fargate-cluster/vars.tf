variable "log_group" {
}

variable "cluster_name" {
}

variable "ecs_insights" {
  default = "disabled"
}

variable "execution_role_policy" {
  type    = object({ policy_document = string })
  default = null
}

variable "log_retention_days" {
  default = 0
}

variable "enable_execute_command" {
  type    = bool
  default = false
}
