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
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudfront_origin_access_identity_arn"></a> [cloudfront\_origin\_access\_identity\_arn](#input\_cloudfront\_origin\_access\_identity\_arn) | CloudFront Origin Access ARN | `string` | `""` | no |
| <a name="input_cloudfront_origin_access_identity_iam_actions"></a> [cloudfront\_origin\_access\_identity\_iam\_actions](#input\_cloudfront\_origin\_access\_identity\_iam\_actions) | iam actions to give cloudfront access to | `list(string)` | <pre>[<br>  "s3:Get*"<br>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | name of the s3 bucket | `any` | n/a | yes |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | enable s3 versioning | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | s3 bucket arn |
| <a name="output_bucket_regional_domain_name"></a> [bucket\_regional\_domain\_name](#output\_bucket\_regional\_domain\_name) | s3 regional domain name |
