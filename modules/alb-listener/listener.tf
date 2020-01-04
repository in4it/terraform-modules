# certificate
data "aws_acm_certificate" "certificate" {
  domain   = var.DOMAIN
  statuses = ["ISSUED", "PENDING_VALIDATION"]
}

# alb listener (https)
resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = var.ALB_ARN
  port              = var.ALB_PORT
  protocol          = var.ALB_PROTOCOL
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.certificate.arn

  default_action {
    target_group_arn = var.TARGET_GROUP_ARN
    type             = "forward"
  }
}

