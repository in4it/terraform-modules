resource "aws_lb_listener_rule" "alb_rule" {
  listener_arn = var.listener_arn
  priority     = var.priority

  action {
    type             = var.action_type
    target_group_arn = var.target_group_arn

    dynamic fixed_response {
      for_each = var.action_type == "fixed-response" ? [1] : []
      content {
        content_type = var.fixed_response.content_type
        message_body = var.fixed_response.message_body
        status_code  = var.fixed_response.status_code
      }
    }
    dynamic redirect {
      for_each = var.action_type == "redirect" ? [1] : []
      content {
        port        = var.redirect.port
        protocol    = var.redirect.protocol
        status_code = var.redirect.status_code
        host        = var.redirect.host == "" ? "#{host}" : var.redirect.host
        path        = var.redirect.path == "" ? "/#{path}" : var.redirect.path
        query       = var.redirect.query == "" ? "#{query}" : var.redirect.query
      }
    }
  }

  # legacy code
  condition {
    dynamic host_header {
      for_each = var.condition_field == "host-header" ? [1] : []
      content {
        values = var.condition_values
      }
    }
    dynamic path_pattern {
      for_each = var.condition_field == "path-pattern" ? [1] : []
      content {
        values = var.condition_values
      }
    }
  }
  # more flexible approach
  dynamic condition {
    for_each = var.conditions
    content {
      dynamic host_header {
        for_each = condition.value.field == "host-header" ? [1] : []
        content {
          values = condition.value.values
        }
      }
      dynamic path_pattern {
        for_each = condition.value.field == "path-pattern" ? [1] : []
        content {
          values = condition.value.values
        }
      }
      dynamic query_string {
        for_each = condition.value.field == "query-string" ? [1] : []
        content {
          value = condition.value.value
        }
      }
    }
  }
}

