#
# ecr 
#

resource "aws_ecr_repository" "ecs-service" {
  count = length(var.containers) == 0 ? 1 : 0

  name = var.ecr_prefix == "" ? var.application_name : "${var.ecr_prefix}/{var.application_name}"

  image_scanning_configuration {
    scan_on_push = true
  }
}

#
# get latest active revision
#
data "aws_ecs_task_definition" "ecs-service" {
  task_definition = aws_ecs_task_definition.ecs-service-taskdef.arn != "" ? aws_ecs_task_definition.ecs-service-taskdef.family : ""
}

#
# task definition variables
#

locals {
  template-vars = {
    aws_region = var.aws_region
    log_group  = var.log_group
    containers = length(var.containers) > 0 ? var.containers : [{
      application_name    = var.application_name
      host_port           = var.launch_type == "FARGATE" ? var.application_port : 0
      application_port    = var.application_port
      additional_ports    = var.additional_ports
      application_version = var.application_version
      ecr_url             = aws_ecr_repository.ecs-service.0.repository_url
      cpu_reservation     = var.cpu_reservation
      memory_reservation  = var.memory_reservation
      command             = var.command
      links               = []
      dependsOn           = []
      mountpoints         = var.mountpoints
      secrets             = var.secrets
      environments        = var.environments
      environment_files   = var.environment_files
      docker_labels       = {}
    }]
  }
}

#
# task definition
#

resource "aws_ecs_task_definition" "ecs-service-taskdef" {
  family                   = var.application_name
  container_definitions    = templatefile("${path.module}/ecs-service.json.tpl", local.template-vars)
  task_role_arn            = var.task_role_arn
  execution_role_arn       = var.execution_role_arn
  requires_compatibilities = [var.launch_type]
  network_mode             = var.launch_type == "FARGATE" ? "awsvpc" : "bridge"
  cpu                      = var.launch_type == "FARGATE" ? var.cpu_reservation : null
  memory                   = var.launch_type == "FARGATE" ? var.memory_reservation : null
  dynamic "volume" {
    for_each = var.volumes
    content {
      name = volume.value.name
      dynamic "efs_volume_configuration" {
        for_each = length(volume.value.efs_volume_configuration) > 0 ? [volume.value.efs_volume_configuration] : []
        content {
          file_system_id     = efs_volume_configuration.value.file_system_id
          transit_encryption = efs_volume_configuration.value.transit_encryption
          dynamic "authorization_config" {
            for_each = length(efs_volume_configuration.value.authorization_config) > 0 ? [efs_volume_configuration.value.authorization_config] : []
            content {
              access_point_id = authorization_config.value.access_point_id
              iam             = authorization_config.value.iam
            }
          }
        }
      }
    }
  }
}

#
# ecs service
#

resource "aws_ecs_service" "ecs-service" {
  name    = var.application_name
  cluster = var.cluster_arn
  task_definition = "${aws_ecs_task_definition.ecs-service-taskdef.family}:${max(
    aws_ecs_task_definition.ecs-service-taskdef.revision,
    data.aws_ecs_task_definition.ecs-service.revision,
  )}"
  iam_role                           = var.launch_type != "FARGATE" ? var.service_role_arn : null
  desired_count                      = var.desired_count
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent
  launch_type                        = var.launch_type
  platform_version                   = var.launch_type == "FARGATE" ? var.platform_version : null
  enable_execute_command             = var.enable_execute_command

  load_balancer {
    target_group_arn = element([for ecs-service in aws_lb_target_group.ecs-service : ecs-service.arn], 0)
    container_name   = length(var.containers) == 0 ? var.application_name : var.exposed_container_name
    container_port   = length(var.containers) == 0 ? var.application_port : var.exposed_container_port
  }

  dynamic "network_configuration" {
    for_each = var.launch_type == "FARGATE" ? tolist([var.launch_type]) : []
    content {
      security_groups = concat([aws_security_group.ecs-service.id], var.task_security_groups)
      subnets         = var.fargate_service_subnetids
    }
  }

  dynamic "deployment_controller" {
    for_each = var.deployment_controller == "" ? [] : [1]
    content {
      type = var.deployment_controller
    }
  }

  dynamic "service_registries" {
    for_each = var.service_registries
    content {
      registry_arn   = service_registries.value.registry_arn
      container_name = service_registries.value.container_name
    }
  }

  depends_on = [null_resource.alb_exists]
}



resource "null_resource" "alb_exists" {
  triggers = {
    alb_name = var.alb_arn
  }
}

