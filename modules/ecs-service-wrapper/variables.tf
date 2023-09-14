variable "service_name" {
  description = "Service name for the ECS service"
  type        = string
}
variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}
variable "execution_role_arn" {
  description = "ARN of the ECS cluster execution role"
  type        = string
}

# Global
variable "aws_account_id" {}
variable "aws_region" {}
variable "env" {}

# Networking
variable "vpc_id" {}
variable "private_subnets" {}
variable "private_subnets_cidr" {}

# ECS
variable "alb_arn" {}
variable "ecs_capacity" {
  type = object({
    min                = number
    max                = number
    cpu_reservation    = string
    memory_reservation = string
  })
}

variable "alb_rule" {
  description = "Adds rules to listener. More info github.com:in4it/terraform-modules.git//modules/alb-rule for input details"
  type = object({
    listener_arn     = string
    priority         = number
    condition_field  = string
    condition_values = list(string)
  })
}
variable "application_port" {
  description = "Port on which the application is listening"
  type        = number
}
variable "existing_ecr" {
  description = "Existing ECR repository arn"
  type        = string
}
variable "healthcheck_path" {
  description = "Healthcheck path for the application"
  type        = string
}
variable "healthcheck_matcher" {
  default = "200,404"
  type    = string
}
variable "healthcheck_interval" {
  default = 30
  type    = number
}

variable "ingress_rules" {
  description = "Ingress rules for the application (security group)"
type = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    security_groups  = optional(list(string))
    cidr_blocks      = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    description      = optional(string)
    prefix_list_ids  = optional(list(string))
    self             = optional(bool)
  }))
}
variable "task_role_policy_json" {
  description = "JSON string of the task policy"
  type        = string
}
variable "environments" {
  description = "Environment variables to set"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

# Optional vars
variable "platform_version" {
  type        = string
  default     = "LATEST"
  description = "https://docs.aws.amazon.com/AmazonECS/latest/developerguide/platform-linux-fargate.html"
}
