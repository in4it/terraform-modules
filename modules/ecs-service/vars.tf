variable "vpc_id" {
}

variable "aws_region" {
}

variable "launch_type" {
  default = "EC2"
}

variable "ecr_prefix" {
  default = ""
}

variable "application_name" {
}

variable "application_port" {
  default = 80
}

variable "protocol" {
  default = "HTTP"
}

variable "application_version" {
  default = ""
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

variable "healthcheck_interval" {
  default = "60"
}

variable "healthcheck_healthy_threshold" {
  default = "3"
}

variable "healthcheck_unhealthy_threshold" {
  default = "3"
}

variable "healthcheck_path" {
  default = "/"
}

variable "cpu_reservation" {
}

variable "memory_reservation" {
}

variable "command" {
  default = []
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

variable "secrets" {
  description = "secrets to set"
  default     = []
  type = list(object({
    name      = string
    valueFrom = string
  }))
}

variable "environments" {
  description = "environments to set"
  default     = []
  type = list(object({
    name  = string
    value = string
  }))
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

variable "volumes" {
  description = "volumes to create in task definition"
  default     = []
  type = list(object({
    name = string
    efs_volume_configuration = object({
      file_system_id     = string
      transit_encryption = string
      authorization_config = object({
        access_point_id = string
        iam             = string
      })
    })
  }))
}

variable "mountpoints" {
  description = "mountpoints to in container definition"
  default     = []
  type = list(object({
    containerPath = string
    sourceVolume  = string
  }))
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
    additional_ports    = list(string)
    application_version = string
    ecr_url             = string
    cpu_reservation     = number
    memory_reservation  = number
    command             = list(string)
    links               = list(string)
    docker_labels       = map(string)
    dependsOn = list(object({
      containerName = string
      condition     = string
    }))
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
    environment_files = list(object({
      value = string
      type  = string
    }))
  }))
}

variable "exposed_container_name" {
  default = ""
}
variable "exposed_container_port" {
  default = ""
}

variable "additional_ports" {
  type    = list(string)
  default = []
}
variable "service_registries" {
  type = list(object({
    registry_arn   = string
    container_name = string
  }))
  default = []
}
variable "environment_files" {
  type = list(object({
    value = string
    type  = string
  }))
  default = []
}
variable "enable_execute_command" {
  type    = bool
  default = false
}
