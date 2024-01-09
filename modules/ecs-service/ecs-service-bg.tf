
resource "aws_ecs_service" "ecs-service-bg" {
  count = var.enable_blue_green ? 1 : 0

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
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds

  dynamic "load_balancer" {
    for_each = length(aws_lb_target_group.ecs-service) == 0 ? [] : [values(aws_lb_target_group.ecs-service)[0]] // only get firsts element from the target groups. TODO: read whether it should be blue / green (currently we'll always go for blue)
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
  lifecycle {
    ignore_changes = [
      # Attempt to not getting conflicts with Blue/Green deployments which updates the target group
      "desired_count",
      "task_definition",
      "load_balancer",
    ]
  }
}
