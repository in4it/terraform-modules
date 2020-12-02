variable "name" {
}
variable "deployment_config_name" {
  default = "CodeDeployDefault.ECSAllAtOnce"
}
variable "execution_role_arn" {
}
variable "task_role_arn" {
}

variable "ecs_cluster_name" {
}
variable "ecs_service_name" {
}

variable "listener_arns" {
  type = list(string)
}

variable "target_group_names" {
  type = list(string)
}

variable "deployment_type" {
  default = "BLUE_GREEN"
}
variable "deployment_option" {
  default = "WITH_TRAFFIC_CONTROL"
}
