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
| [aws_appautoscaling_policy.service-cpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.service-memory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | AWS Account ID | `any` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the ECS cluster | `any` | n/a | yes |
| <a name="input_cpu_util_target"></a> [cpu\_util\_target](#input\_cpu\_util\_target) | Target CPU utilization threshold | `number` | `80` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment | `any` | n/a | yes |
| <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity) | Maximum number of tasks to run | `number` | `1` | no |
| <a name="input_memory_util_target"></a> [memory\_util\_target](#input\_memory\_util\_target) | Target memory utilization threshold | `number` | `80` | no |
| <a name="input_min_capacity"></a> [min\_capacity](#input\_min\_capacity) | Minimum number of tasks to run | `number` | `1` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Name of the ECS service | `any` | n/a | yes |

## Outputs

No outputs.
