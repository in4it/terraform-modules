locals {
  single_target_group = toset([
    var.application_name
  ])
  internal_lb_target_group = toset([
    "${var.application_name}-internal"
  ])
  blue_green_target_group = toset([
    "${var.application_name}-blue",
    "${var.application_name}-green"
  ])

  is_private    = var.alb_arn == null
  target_groups = local.is_private ? [] : (var.enable_blue_green ? local.blue_green_target_group : var.enable_internal_lb ? setunion(local.single_target_group, local.internal_lb_target_group) : local.single_target_group)
}

#
# target
#

resource "aws_lb_target_group" "ecs-service" {
  for_each             = local.target_groups
  name                 = each.value
  port                 = var.application_port
  protocol             = var.protocol
  vpc_id               = var.vpc_id
  deregistration_delay = var.deregistration_delay
  target_type          = var.launch_type == "FARGATE" ? "ip" : "instance"

  dynamic "health_check" {
    for_each = var.protocol == "HTTP" ? [1] : []
    content {
      healthy_threshold   = var.healthcheck_healthy_threshold
      unhealthy_threshold = var.healthcheck_unhealthy_threshold
      protocol            = var.protocol
      path                = var.healthcheck_path
      timeout             = var.healthcheck_timeout
      interval            = var.healthcheck_interval
      matcher             = var.healthcheck_matcher
    }
  }

  dynamic "health_check" {
    for_each = var.protocol == "HTTPS" ? [1] : []
    content {
      healthy_threshold   = var.healthcheck_healthy_threshold
      unhealthy_threshold = var.healthcheck_unhealthy_threshold
      protocol            = var.protocol
      path                = var.healthcheck_path
      timeout             = var.healthcheck_timeout
      interval            = var.healthcheck_interval
      matcher             = var.healthcheck_matcher
    }
  }

  dynamic "health_check" {
    for_each = var.protocol == "TCP" ? [1] : []
    content {
      healthy_threshold   = var.healthcheck_healthy_threshold
      unhealthy_threshold = var.healthcheck_unhealthy_threshold
      protocol            = var.protocol
      interval            = var.healthcheck_interval
    }
  }
}

