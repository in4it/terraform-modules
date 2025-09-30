<!-- BEGIN_TF_DOCS -->
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
| [aws_cloudwatch_event_rule.schedule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.schedule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_ecr_repository.ecs-task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecs_task_definition.ecs-task-taskdef](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_ecs_task_definition.ecs-task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecs_task_definition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_APPLICATION_NAME"></a> [APPLICATION\_NAME](#input\_APPLICATION\_NAME) | n/a | `any` | n/a | yes |
| <a name="input_APPLICATION_VERSION"></a> [APPLICATION\_VERSION](#input\_APPLICATION\_VERSION) | n/a | `any` | n/a | yes |
| <a name="input_AWS_REGION"></a> [AWS\_REGION](#input\_AWS\_REGION) | n/a | `any` | n/a | yes |
| <a name="input_CLUSTER_ARN"></a> [CLUSTER\_ARN](#input\_CLUSTER\_ARN) | n/a | `any` | n/a | yes |
| <a name="input_CPU_RESERVATION"></a> [CPU\_RESERVATION](#input\_CPU\_RESERVATION) | n/a | `any` | n/a | yes |
| <a name="input_DESIRED_COUNT"></a> [DESIRED\_COUNT](#input\_DESIRED\_COUNT) | n/a | `any` | n/a | yes |
| <a name="input_ECR_PREFIX"></a> [ECR\_PREFIX](#input\_ECR\_PREFIX) | n/a | `string` | `""` | no |
| <a name="input_EVENTS_ROLE_ARN"></a> [EVENTS\_ROLE\_ARN](#input\_EVENTS\_ROLE\_ARN) | n/a | `any` | n/a | yes |
| <a name="input_LOG_GROUP"></a> [LOG\_GROUP](#input\_LOG\_GROUP) | n/a | `any` | n/a | yes |
| <a name="input_MEMORY_RESERVATION"></a> [MEMORY\_RESERVATION](#input\_MEMORY\_RESERVATION) | n/a | `any` | n/a | yes |
| <a name="input_SCHEDULE"></a> [SCHEDULE](#input\_SCHEDULE) | n/a | `any` | n/a | yes |
| <a name="input_TASK_DEF_TEMPLATE"></a> [TASK\_DEF\_TEMPLATE](#input\_TASK\_DEF\_TEMPLATE) | n/a | `any` | n/a | yes |
| <a name="input_TASK_ROLE_ARN"></a> [TASK\_ROLE\_ARN](#input\_TASK\_ROLE\_ARN) | n/a | `string` | `""` | no |
| <a name="input_ecr_encryption_type"></a> [ecr\_encryption\_type](#input\_ecr\_encryption\_type) | n/a | `string` | `"AES256"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->