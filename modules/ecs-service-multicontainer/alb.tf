locals {
  single_target_group = toset([
    var.application_name
  ])
  blue_green_target_group = toset([
    "${var.application_name}-blue",
    "${var.application_name}-green"
  ])
}

#
# target
#

resource "aws_lb_target_group" "ecs-service" {
  for_each             = var.enable_blue_green ? local.blue_green_target_group : local.single_target_group
  name                 = each.value
  port                 = var.application_port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = var.deregistration_delay
  target_type          = var.launch_type == "FARGATE" ? "ip" : "instance"

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    protocol            = "HTTP"
    path                = var.healthcheck_path
    interval            = 60
    matcher             = var.healthcheck_matcher
  }
}

