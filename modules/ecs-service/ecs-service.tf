locals {
  create_ecr = var.create_ecr || (length(var.containers) == 0 && var.existing_ecr == null)
  ecr_name   = var.ecr_prefix == "" ? var.application_name : "${var.ecr_prefix}/{var.application_name}"

  task_revision = var.redeploy_service ? "${aws_ecs_task_definition.ecs-service-taskdef.family}:${max(
    aws_ecs_task_definition.ecs-service-taskdef.revision,
    data.aws_ecs_task_definition.ecs-service.revision,
  )}" : split("/", data.aws_ecs_service.ecs-service[0].task_definition)[1]
}

data "aws_ecs_service" "ecs-service" {
  count        = var.redeploy_service ? 0 : 1
  cluster_arn  = var.cluster_arn
  service_name = var.application_name
}

#
# ecr 
#

resource "aws_ecr_repository" "ecs-service" {
  count = local.create_ecr ? 1 : 0

  name = local.ecr_name

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
}

resource "aws_cloudwatch_log_group" "logs" {
  count             = var.log_group != "" ? 0 : 1
  name              = "/aws/ecs/${var.application_name}"
  retention_in_days = var.logs_retention_days
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
    log_group  = var.log_group != "" ? var.log_group : aws_cloudwatch_log_group.logs[0].name
    containers = length(var.containers) > 0 ? var.containers : [
      {
        application_name         = var.application_name
        essential                = true
        host_port                = var.launch_type == "FARGATE" ? var.application_port : 0
        application_port         = var.application_port
        additional_ports         = var.additional_ports
        port_protocol            = var.port_protocol
        application_version      = var.application_version
        ecr_url                  = var.existing_ecr == null ? aws_ecr_repository.ecs-service.0.repository_url : var.existing_ecr.repo_url
        cpu_reservation          = var.cpu_reservation
        memory_reservation       = var.memory_reservation
        command                  = var.command
        entrypoint               = var.entrypoint
        health_check_cmd         = var.health_check_cmd
        health_check_interval    = var.health_check_interval
        health_check_timeout     = var.health_check_timeout
        health_check_retries     = var.health_check_retries
        health_check_startPeriod = var.health_check_startPeriod
        user                     = var.user
        system_controls          = []
        volumes_from             = []
        links                    = []
        dependsOn                = []
        mountpoints              = var.mountpoints
        secrets                  = var.secrets
        environments             = var.environments
        environment_files        = var.environment_files
        docker_labels            = {}
        fluent_bit               = var.fluent_bit
        aws_firelens             = var.aws_firelens
        firelens_configuration   = var.firelens_configuration
      }
    ]
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

  runtime_platform {
    cpu_architecture        = var.use_arm ? "ARM64" : "X86_64"
    operating_system_family = "LINUX"
  }

  dynamic "volume" {
    for_each = var.volumes
    content {
      name                = volume.value.name
      configure_at_launch = volume.value.configure_at_launch
      dynamic "efs_volume_configuration" {
        for_each = volume.value.efs_volume_configuration != null ? [volume.value.efs_volume_configuration] : []
        content {
          file_system_id     = efs_volume_configuration.value.file_system_id
          transit_encryption = efs_volume_configuration.value.transit_encryption
          root_directory     = efs_volume_configuration.value.root_directory
          dynamic "authorization_config" {
            for_each = efs_volume_configuration.value.authorization_config != null ? (length(efs_volume_configuration.value.authorization_config) > 0 ? [
              efs_volume_configuration.value.authorization_config
            ] : []) : []
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
  name                               = var.application_name
  cluster                            = var.cluster_arn
  task_definition                    = local.task_revision
  iam_role                           = var.launch_type != "FARGATE" ? var.service_role_arn : null
  desired_count                      = var.desired_count
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent
  launch_type                        = var.launch_type
  platform_version                   = var.launch_type == "FARGATE" ? var.platform_version : null
  enable_execute_command             = var.enable_execute_command
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds

  dynamic "load_balancer" {
    for_each = length(aws_lb_target_group.ecs-service) == 0 ? [] : [values(aws_lb_target_group.ecs-service)[0]]
    // only get firsts element from the target groups. TODO: read whether it should be blue / green (currently we'll always go for blue)
    content {
      target_group_arn = load_balancer.value.arn
      container_name   = length(var.containers) == 0 ? var.application_name : var.exposed_container_name
      container_port   = length(var.containers) == 0 ? var.application_port : var.exposed_container_port
    }
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

