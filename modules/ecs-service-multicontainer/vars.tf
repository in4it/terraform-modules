variable "vpc_id" {
}

variable "aws_region" {
}

variable "launch_type" {
  default = "EC2"
}

variable "cluster_arn" {
}

variable "service_role_arn" {
  default = ""
}

variable "desired_count" {
}

variable "deployment_minimum_healthy_percent" {
  default = 100
}

variable "deployment_maximum_percent" {
  default = 200
}

variable "deregistration_delay" {
  default = 30
}

variable "healthcheck_matcher" {
  default = "200"
}
variable "healthcheck_path" {
  default = "/"
}

variable "cpu_reservation" {
}

variable "memory_reservation" {
}

variable "log_group" {
}

variable "task_role_arn" {
  default = ""
}

variable "execution_role_arn" {
  default = ""
}

variable "alb_arn" {
}

variable "fargate_service_security_groups" {
  default = []
}

variable "fargate_service_subnetids" {
  default = []
}

variable "ingress_rules" {
  default = []
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    security_groups = list(string)
  }))
}

variable "enable_blue_green" {
  default = false
}

variable "deployment_controller" {
  default = ""
}

variable "platform_version" {
  default = "LATEST"
}

variable "task_security_groups" {
  description = "extra security groups to add. Expects security group ID"
  default     = []
}

variable "containers" {
  description = "Containers in container definition"
  default     = []
  type = list(object({
    application_name    = string
    host_port           = number
    application_port    = number
    application_version = string
    ecr_url             = string
    cpu_reservation     = number
    memory_reservation  = number
    links               = list(string)
    mountpoints = list(object({
      containerPath = string
      sourceVolume  = string
      readOnly      = bool
    }))
    secrets = list(object({
      name      = string
      valueFrom = string
    }))
    environments = list(object({
      name  = string
      value = string
    }))
  }))
}

variable "volumes" {
  description = "volumes to create in task definition"
  default     = []
  type = list(object({
    name = string
    efs_volume_configuration = optional(object({
      file_system_id     = string
      transit_encryption = string
      authorization_config = object({
        access_point_id = string
        iam             = string
      })
    }))
  }))
}

variable "exposed_port" {
  type = number
}
variable "service_name" {
  type = string
}
variable "exposed_container_name" {
  type = string
}