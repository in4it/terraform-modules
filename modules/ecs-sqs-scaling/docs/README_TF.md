## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.trigger_every](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.lambda_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_policy.ecs_sqs_scaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.ecs_sqs_scaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecs_sqs_scaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.ecs_sqs_scaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_triggering_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [archive_file.lambda_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_iam_policy_document.ecs_sqs_scaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_sqs_scaling_sts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_config"></a> [config](#input\_config) | Configuration for the custom metric generation. Add a new object for each ECS worker service you want to scale based on the SQS queue size. | <pre>map(object({<br>    ecs_cluster               = string<br>    ecs_service               = string<br>    tracking_sqs_queue        = string<br>    tracking_sqs_queue_metric = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_custom_metric_name"></a> [custom\_metric\_name](#input\_custom\_metric\_name) | The name of the custom metric to be generated | `string` | `"ECSWorkerBacklog"` | no |
| <a name="input_custom_metric_namespace"></a> [custom\_metric\_namespace](#input\_custom\_metric\_namespace) | The namespace for the custom metric to be generated | `string` | `"ECS/CustomerMetrics"` | no |
| <a name="input_debug_mode"></a> [debug\_mode](#input\_debug\_mode) | Enable debug mode for the lambda function | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | The environment this module is being deployed to | `any` | n/a | yes |
| <a name="input_lambda_trigger_period"></a> [lambda\_trigger\_period](#input\_lambda\_trigger\_period) | The period to trigger the custom metric generation | `string` | `"1 minute"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | The prefix to use for all resources created by this module | `string` | `"ecs-sqs-scaling"` | no |

## Outputs

No outputs.
