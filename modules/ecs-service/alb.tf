#
# target
#
resource "aws_alb_target_group" "ecs-service" {
  name                 = "ecs-service"
  port                 = "${var.APPLICATION_PORT}"
  protocol             = "HTTP"
  vpc_id               = "${var.VPC_ID}"
  deregistration_delay = "${var.DEREGISTRATION_DELAY}"

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    protocol            = "HTTP"
    path                = "/"
    interval            = 60
    matcher             = "${var.HEALTHCHECK_MATCHER}"
  }
}
