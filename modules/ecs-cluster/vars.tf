variable "aws_account_id" {
}

variable "aws_region" {
}

variable "log_group" {
}

variable "vpc_id" {
}

variable "cluster_name" {
}

variable "instance_type" {
}

variable "ssh_key_name" {
}

variable "vpc_subnets" {
}

variable "ecs_termination_policies" {
  default = "OldestLaunchConfiguration,Default"
}

variable "ecs_minsize" {
  default = 1
}

variable "ecs_maxsize" {
  default = 1
}

variable "ecs_desired_capacity" {
  default = 1
}

variable "enable_ssh" {
  default = false
}

variable "ssh_sg" {
  default = ""
}

variable "log_retention_days" {
  default = 0
}
