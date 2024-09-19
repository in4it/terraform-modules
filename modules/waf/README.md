## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_wafv2_ip_set.ratelimit_ipset](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_web_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_association.alb-waf-association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | optional environment | `string` | `""` | no |
| <a name="input_lb_arns"></a> [lb\_arns](#input\_lb\_arns) | ARN of ALBs to associate with WAF | `set(string)` | `[]` | no |
| <a name="input_managed_rules"></a> [managed\_rules](#input\_managed\_rules) | managed rules | <pre>list(object({<br>    name                     = string<br>    priority                 = number<br>    managed_rule_name        = string<br>    managed_rule_vendor_name = string<br>    block                    = bool<br>    blocking_rules           = optional(list(string))<br>    allowing_rules           = optional(list(string))<br>    counting_rules           = optional(list(string))<br>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | name of WAF | `string` | `"alb-waf"` | no |
| <a name="input_ratelimit_rules"></a> [ratelimit\_rules](#input\_ratelimit\_rules) | ratelimiting rules | <pre>list(object({<br>    name              = string<br>    limit             = number<br>    priority          = number<br>    exclude_ip_ranges = list(string)<br>    block             = bool<br>  }))</pre> | `[]` | no |
| <a name="input_regex_match_rules"></a> [regex\_match\_rules](#input\_regex\_match\_rules) | n/a | <pre>list(object({<br>    name       = string<br>    priority   = number<br>    action     = string # "count" or "block"<br>    statement  = any<br>    rule_label = optional(list(string), null)<br>  }))</pre> | `[]` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | scope of WAF, use 'CLOUDFRONT' for CloudFront distributions | `string` | `"REGIONAL"` | no |

## Outputs

No outputs.
