## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_lb.lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.lb-http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.lb-https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_certificate.alb_https_extra_certificates](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_certificate) | resource |
| [aws_s3_bucket.lb_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.lb_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.lb-logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.lb_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.lb_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_security_group.lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.cluster-allow-lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_acm_certificate.certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_acm_certificate.extra_certificates](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_elb_service_account.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elb_service_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_logs"></a> [access\_logs](#input\_access\_logs) | An access logs block | `map(string)` | `{}` | no |
| <a name="input_allow_additional_sg"></a> [allow\_additional\_sg](#input\_allow\_additional\_sg) | n/a | <pre>map(object({<br>    security_groups = list(string)<br>    from_port       = string<br>    to_port         = string<br>    protocol        = string<br>  }))</pre> | `{}` | no |
| <a name="input_default_target_arn"></a> [default\_target\_arn](#input\_default\_target\_arn) | n/a | `string` | `""` | no |
| <a name="input_desync_mitigation_mode"></a> [desync\_mitigation\_mode](#input\_desync\_mitigation\_mode) | n/a | `string` | `"defensive"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `any` | n/a | yes |
| <a name="input_drop_invalid_header_fields"></a> [drop\_invalid\_header\_fields](#input\_drop\_invalid\_header\_fields) | n/a | `bool` | `false` | no |
| <a name="input_ecs_sg"></a> [ecs\_sg](#input\_ecs\_sg) | n/a | `list` | `[]` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | Enable Deletion Protection | `bool` | `true` | no |
| <a name="input_extra_domains"></a> [extra\_domains](#input\_extra\_domains) | n/a | `list` | `[]` | no |
| <a name="input_idle_timeout"></a> [idle\_timeout](#input\_idle\_timeout) | n/a | `number` | `60` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | n/a | `any` | n/a | yes |
| <a name="input_lb_name"></a> [lb\_name](#input\_lb\_name) | n/a | `any` | n/a | yes |
| <a name="input_tcp_ingress"></a> [tcp\_ingress](#input\_tcp\_ingress) | n/a | `map(list(string))` | <pre>{<br>  "443": [<br>    "0.0.0.0/0"<br>  ],<br>  "80": [<br>    "0.0.0.0/0"<br>  ]<br>}</pre> | no |
| <a name="input_tls"></a> [tls](#input\_tls) | n/a | `bool` | `true` | no |
| <a name="input_tls_policy"></a> [tls\_policy](#input\_tls\_policy) | n/a | `string` | `"ELBSecurityPolicy-TLS13-1-2-2021-06"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `any` | n/a | yes |
| <a name="input_vpc_subnets"></a> [vpc\_subnets](#input\_vpc\_subnets) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | n/a |
| <a name="output_http_listener_arn"></a> [http\_listener\_arn](#output\_http\_listener\_arn) | n/a |
| <a name="output_https_listener_arn"></a> [https\_listener\_arn](#output\_https\_listener\_arn) | n/a |
| <a name="output_lb_arn"></a> [lb\_arn](#output\_lb\_arn) | n/a |
| <a name="output_security-group-id"></a> [security-group-id](#output\_security-group-id) | n/a |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | n/a |
