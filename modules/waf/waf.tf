resource "aws_wafv2_web_acl" "this" {
  name  = var.env == "" ? var.name : "${var.name}-${var.env}"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  dynamic "rule" {
    for_each = { for r in var.ratelimit_rules : r.name => r }
    content {
      name     = rule.value.name
      priority = rule.value.priority

      action {
        dynamic "block" {
          for_each = rule.value.block ? [1] : []
          content {
          }
        }
        dynamic "count" {
          for_each = !rule.value.block ? [1] : []
          content {
          }
        }
      }
      statement {
        rate_based_statement {
          limit              = rule.value.limit
          aggregate_key_type = "IP"

          scope_down_statement {
            not_statement {
              statement {
                ip_set_reference_statement {
                  arn = aws_wafv2_ip_set.ratelimit_ipset[rule.value.name].arn
                }
              }
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "ratelimit-${rule.value.name}"
        sampled_requests_enabled   = true
      }
    }
  }

  dynamic "rule" {
    for_each = { for r in var.managed_rules : r.name => r }
    content {
      name     = rule.value.name
      priority = rule.value.priority

      override_action {
        dynamic "none" {
          for_each = rule.value.block ? [1] : []
          content {
          }
        }
        dynamic "count" {
          for_each = !rule.value.block ? [1] : []
          content {
          }
        }
      }
      statement {
        managed_rule_group_statement {
          name        = rule.value.managed_rule_name
          vendor_name = rule.value.managed_rule_vendor_name
          dynamic "rule_action_override" {
            for_each = { for r in rule.value.rules_to_enable: r => true }
            content {
              name = rule_action_override.key
              action_to_use {
                dynamic "block" {
                  for_each = rule.value.block ? [1] : []
                  content {
                  }
                }
                dynamic "count" {
                  for_each = !rule.value.block ? [1] : []
                  content {
                  }
                }
              }
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "ratelimit-${rule.value.name}"
        sampled_requests_enabled   = true
      }
    }
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = var.env == "" ? var.name : "${var.name}-${var.env}"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_ip_set" "ratelimit_ipset" {
  for_each = { for r in var.ratelimit_rules : r.name => r }

  name               = "${each.value.name}-ipset"
  description        = "Ratelimit IP exclusion"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = each.value.exclude_ip_ranges
}
