#
# ECS ALB
#
# alb main definition
resource "aws_alb" "alb" {
  name            = var.ALB_NAME
  internal        = var.INTERNAL
  security_groups = [aws_security_group.alb.id]
  subnets         = split(",", var.VPC_SUBNETS)

  enable_deletion_protection = false
}

# certificate
data "aws_acm_certificate" "certificate" {
  domain   = var.DOMAIN
  statuses = ["ISSUED", "PENDING_VALIDATION"]
}

# alb listener (https)
resource "aws_alb_listener" "alb-https" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.certificate.arn

  default_action {
    target_group_arn = var.DEFAULT_TARGET_ARN
    type             = "forward"
  }
}

# alb listener (http)
resource "aws_alb_listener" "alb-http" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = var.DEFAULT_TARGET_ARN
    type             = "forward"
  }
}

