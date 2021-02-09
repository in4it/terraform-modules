#
# ecs lb
#
# lb main definition
resource "aws_lb" "lb" {
  name                       = var.lb_name
  internal                   = var.internal
  security_groups            = [aws_security_group.lb.id]
  subnets                    = var.vpc_subnets
  idle_timeout               = var.idle_timeout
  enable_deletion_protection = false

  dynamic "access_logs" {
    for_each = length(keys(var.access_logs)) == 0 ? [] : [var.access_logs]
    content {
      bucket  = lookup(access_logs.value, "bucket", "${var.lb_name}-lb-logs")
      enabled = lookup(access_logs.value, "enabled", true)
    }
  }
}

# certificate
data "aws_acm_certificate" "certificate" {
  count    = var.domain != "" ? 1 : 0
  domain   = var.domain
  statuses = ["ISSUED", "PENDING_VALIDATION"]
}

# lb listener (https)
locals {
  fixed_response = [
    {
      type             = "fixed-response"
      content_type     = "text/plain"
      message_body     = "No service configured at this address"
      status_code      = 404
      target_group_arn = null
    }
  ]
  forward_response = [
    {
      type             = "forward"
      target_group_arn = var.default_target_arn
    }
  ]
}
resource "aws_lb_listener" "lb-https" {
  count             = var.tls ? 1 : 0
  load_balancer_arn = aws_lb.lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.tls_policy
  certificate_arn   = data.aws_acm_certificate.certificate[0].arn

  dynamic "default_action" {
    for_each = var.default_target_arn == "" ? local.fixed_response : local.forward_response
    content {
      target_group_arn = default_action.value.target_group_arn
      type             = default_action.value.type
      dynamic "fixed_response" {
        for_each = default_action.value.type == "fixed-response" ? [1] : []
        content {
          content_type = default_action.value.content_type
          message_body = default_action.value.message_body
          status_code  = default_action.value.status_code
        }
      }
    }
  }
}

# lb listener (http)
resource "aws_lb_listener" "lb-http" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  dynamic "default_action" {
    for_each = var.default_target_arn == "" ? local.fixed_response : local.forward_response
    content {
      target_group_arn = default_action.value.target_group_arn
      type             = default_action.value.type
      dynamic "fixed_response" {
        for_each = default_action.value.type == "fixed-response" ? [1] : []
        content {
          content_type = default_action.value.content_type
          message_body = default_action.value.message_body
          status_code  = default_action.value.status_code
        }
      }
    }
  }
}

