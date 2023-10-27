## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_logs_export_bucket"></a> [logs\_export\_bucket](#module\_logs\_export\_bucket) | ../../modules/s3 | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.once_a_day](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.lambda_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_policy.log_exporter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.log_exporter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.log_exporter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.log_exporter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_triggering_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [random_string.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [archive_file.lambda_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_iam_policy_document.log_exporter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.log_exporter_sts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_archive_class"></a> [archive\_class](#input\_archive\_class) | n/a | `string` | `"GLACIER"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | n/a | yes |
| <a name="input_bucket_prefix"></a> [bucket\_prefix](#input\_bucket\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_check_retry_attempts"></a> [check\_retry\_attempts](#input\_check\_retry\_attempts) | Number of times to retry checking status of an export task | `number` | `5` | no |
| <a name="input_check_retry_timeout"></a> [check\_retry\_timeout](#input\_check\_retry\_timeout) | Number of milli-seconds to wait before retrying checking status of an export task | `number` | `5000` | no |
| <a name="input_days_to_archive"></a> [days\_to\_archive](#input\_days\_to\_archive) | Number of days to keep logs in S3 before moving to Glacier | `number` | `180` | no |
| <a name="input_days_to_expire"></a> [days\_to\_expire](#input\_days\_to\_expire) | Number of days to keep logs in S3 before expiring/deleting | `number` | `365` | no |
| <a name="input_export_days_before"></a> [export\_days\_before](#input\_export\_days\_before) | Number of days to export logs from | `number` | `1` | no |
| <a name="input_log_groups_list"></a> [log\_groups\_list](#input\_log\_groups\_list) | n/a | `list(string)` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | n/a |
| <a name="output_lambda_arn"></a> [lambda\_arn](#output\_lambda\_arn) | n/a |
| <a name="output_lambda_role_arn"></a> [lambda\_role\_arn](#output\_lambda\_role\_arn) | n/a |
