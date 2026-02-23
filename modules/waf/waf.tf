resource "aws_wafv2_web_acl" "this" {
  name  = var.env == "" ? var.name : "${var.name}-${var.env}"
  scope = var.scope

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

          dynamic "scope_down_statement" {
            for_each = lookup(rule.value, "exclude_ip_ranges", null) != null ? [1] : []

            content {
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
            for_each = merge(
              { for r in coalesce(rule.value.blocking_rules, []) : r => "block" },
              { for r in coalesce(rule.value.allowing_rules, []) : r => "allow" },
              { for r in coalesce(rule.value.counting_rules, []) : r => "count" }
            )
            content {
              name = rule_action_override.key
              action_to_use {
                dynamic "block" {
                  for_each = rule_action_override.value == "block" ? [1] : []
                  content {
                  }
                }
                dynamic "allow" {
                  for_each = rule_action_override.value == "allow" ? [1] : []
                  content {
                  }
                }
                dynamic "count" {
                  for_each = rule_action_override.value == "count" ? [1] : []
                  content {
                  }
                }
              }
            }
          }
          dynamic "scope_down_statement" {
            for_each = lookup(rule.value, "exclude_ip_ranges", null) != null ? [1] : []

            content {
              not_statement {
                statement {
                  ip_set_reference_statement {
                    arn = aws_wafv2_ip_set.managed_rule_ipset[rule.value.name].arn
                  }
                }
              }
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "managedrules-${rule.value.name}"
        sampled_requests_enabled   = true
      }
    }
  }
  dynamic "rule" {
    for_each = { for r in var.regex_match_rules : r.name => r }
    content {
      name     = rule.value.name
      priority = rule.value.priority
      action {
        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {
          }
        }
        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {
          }
        }
        dynamic "allow" {
          for_each = rule.value.action == "allow" ? [1] : []
          content {
          }
        }
      }
      statement {
        dynamic "regex_match_statement" {
          for_each = lookup(rule.value, "statement", null) != null ? [rule.value.statement] : []

          content {
            regex_string = regex_match_statement.value.regex_string

            dynamic "field_to_match" {
              for_each = lookup(rule.value.statement, "field_to_match", null) != null ? [rule.value.statement.field_to_match] : []

              content {
                dynamic "all_query_arguments" {
                  for_each = lookup(field_to_match.value, "all_query_arguments", null) != null ? [1] : []
                  content {}
                }
                dynamic "body" {
                  for_each = lookup(field_to_match.value, "body", null) != null ? [1] : []
                  content {}
                }
                dynamic "method" {
                  for_each = lookup(field_to_match.value, "method", null) != null ? [1] : []

                  content {}
                }
                dynamic "query_string" {
                  for_each = lookup(field_to_match.value, "query_string", null) != null ? [1] : []

                  content {}
                }
                dynamic "single_header" {
                  for_each = lookup(field_to_match.value, "single_header", null) != null ? [field_to_match.value.single_header] : []

                  content {
                    name = single_header.value.name
                  }
                }
                dynamic "single_query_argument" {
                  for_each = lookup(field_to_match.value, "single_query_argument", null) != null ? [field_to_match.value.single_query_argument] : []
                  content {
                    name = single_query_argument.value.name
                  }
                }
                dynamic "uri_path" {
                  for_each = lookup(field_to_match.value, "uri_path", null) != null ? [1] : []
                  content {}
                }
              }
            }
            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "regex-${rule.value.name}"
        sampled_requests_enabled   = true
      }
    }
  }

  dynamic "rule" {
    for_each = { for r in var.geo_match_rules : r.name => r }

    content {
      name     = rule.value.name
      priority = rule.value.priority

      action {
        dynamic "allow" {
          for_each = rule.value.action == "allow" ? [1] : []
          content {}
        }
        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {}
        }
        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }
        dynamic "captcha" {
          for_each = rule.value.action == "captcha" ? [1] : []
          content {}
        }
      }

      statement {
        dynamic "geo_match_statement" {
          for_each = lookup(rule.value, "statement", null) != null ? [rule.value.statement] : []

          content {
            country_codes = geo_match_statement.value.country_codes

            dynamic "forwarded_ip_config" {
              for_each = lookup(geo_match_statement.value, "forwarded_ip_config", null) != null ? [geo_match_statement.value.forwarded_ip_config] : []

              content {
                fallback_behavior = forwarded_ip_config.value.fallback_behavior
                header_name       = forwarded_ip_config.value.header_name
              }
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "geomatchrules-${rule.value.name}"
        sampled_requests_enabled   = true
      }
    }
  }
  dynamic "rule" {
    for_each = { for r in var.rule_group_reference_rules : r.name => r }

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
        dynamic "rule_group_reference_statement" {
          for_each = lookup(rule.value, "statement", null) != null ? [rule.value.statement] : []

          content {
            arn = rule_group_reference_statement.value.arn

            dynamic "rule_action_override" {
              for_each = lookup(rule_group_reference_statement.value, "rule_action_override", null) != null ? rule_group_reference_statement.value.rule_action_override : {}

              content {
                name = rule_action_override.key

                action_to_use {
                  dynamic "allow" {
                    for_each = rule_action_override.value.action == "allow" ? [1] : []
                    content {
                      dynamic "custom_request_handling" {
                        for_each = lookup(rule_action_override.value, "custom_request_handling", null) != null ? [1] : []
                        content {
                          insert_header {
                            name  = rule_action_override.value.custom_request_handling.insert_header.name
                            value = rule_action_override.value.custom_request_handling.insert_header.value
                          }
                        }
                      }
                    }
                  }
                  dynamic "block" {
                    for_each = rule_action_override.value.action == "block" ? [1] : []
                    content {
                      dynamic "custom_response" {
                        for_each = lookup(rule_action_override.value, "custom_response", null) != null ? [1] : []
                        content {
                          response_code            = rule_action_override.value.custom_response.response_code
                          custom_response_body_key = lookup(rule_action_override.value.custom_response, "custom_response_body_key", null)
                          dynamic "response_header" {
                            for_each = lookup(rule_action_override.value.custom_response, "response_header", null) != null ? [1] : []
                            content {
                              name  = rule_action_override.value.custom_response.response_header.name
                              value = rule_action_override.value.custom_response.response_header.value
                            }
                          }
                        }
                      }
                    }
                  }
                  dynamic "count" {
                    for_each = rule_action_override.value.action == "count" ? [1] : []
                    content {
                      dynamic "custom_request_handling" {
                        for_each = lookup(rule_action_override.value, "custom_request_handling", null) != null ? [1] : []
                        content {
                          insert_header {
                            name  = rule_action_override.value.custom_request_handling.insert_header.name
                            value = rule_action_override.value.custom_request_handling.insert_header.value
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "rulegroup-${rule.value.name}"
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
  for_each = {
    for r in var.ratelimit_rules :
    r.name => r
    if lookup(r, "exclude_ip_ranges", null) != null
  }

  name               = "${each.value.name}-ratelimit-ipset"
  description        = "Rate limit exclusion IP set"
  scope              = var.scope
  ip_address_version = "IPV4"
  addresses          = each.value.exclude_ip_ranges
}

resource "aws_wafv2_ip_set" "managed_rule_ipset" {
  for_each = {
    for r in var.managed_rules :
    r.name => r
    if lookup(r, "exclude_ip_ranges", null) != null
  }

  name               = "${each.value.name}-managed-ipset"
  description        = "Managed rule exclusion IP set"
  scope              = var.scope
  ip_address_version = "IPV4"
  addresses          = each.value.exclude_ip_ranges
}