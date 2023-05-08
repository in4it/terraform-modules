This terraform module includes partial code from the `terraform-aws-oidc-github` library (https://github.com/unfunco/terraform-aws-oidc-github) which is licensed under the Apache License 2.0.


<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_openid_connect_provider.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_openid_connect_provider) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [tls_certificate.github](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| github\_repositories | List of GitHub organization/repository names authorized to assume the role. | `list(string)` | n/a | yes |
| iam\_role\_inline\_policies | Inline policies map with policy name as key and json as value. | `map(string)` | `{}` | no |
| iam\_role\_name | Name of the IAM role to be created. This will be assumable by GitHub. | `string` | `"github"` | no |
| iam\_role\_policy\_arns | List of IAM policy ARNs to attach to the IAM role. | `list(string)` | `[]` | no |
| max\_session\_duration | Maximum session duration in seconds. | `number` | `3600` | no |
| tags | Map of tags to be applied to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| iam\_role\_arn | ARN of the IAM role. |
<!-- END_TF_DOCS -->