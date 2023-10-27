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
| [aws_s3_bucket_lifecycle_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_policy_statements"></a> [additional\_policy\_statements](#input\_additional\_policy\_statements) | additional policy statements to add to the s3 bucket policy | <pre>list(object({<br>    sid = optional(string)<br>    principals = object({<br>      identifiers = list(string)<br>      type        = string<br>    })<br>    effect    = string<br>    actions   = list(string)<br>    resources = list(string)<br>    condition = optional(object({<br>      test     = string<br>      values   = list(string)<br>      variable = string<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_cloudfront_allow_path"></a> [cloudfront\_allow\_path](#input\_cloudfront\_allow\_path) | S3 path to allow cloudfront access to. Default allows access to the entire bucket. | `string` | `""` | no |
| <a name="input_cloudfront_origin_access_identity_arn"></a> [cloudfront\_origin\_access\_identity\_arn](#input\_cloudfront\_origin\_access\_identity\_arn) | CloudFront Origin Access ARN | `string` | `""` | no |
| <a name="input_cloudfront_origin_access_identity_iam_actions"></a> [cloudfront\_origin\_access\_identity\_iam\_actions](#input\_cloudfront\_origin\_access\_identity\_iam\_actions) | iam actions to give cloudfront access to | `list(string)` | <pre>[<br>  "s3:Get*"<br>]</pre> | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | lifecycle rules to add to the bucket | <pre>list(object({<br>    id     = string<br>    status = string # "Enabled" or "Disabled"<br>    transition = object({<br>      date          = optional(string)<br>      days          = optional(number)<br>      storage_class = string<br>    })<br>    expiration = object({<br>      days = number<br>    })<br>    filter = object({<br>      prefix                   = optional(string)<br>      object_size_less_than    = optional(number)<br>      object_size_greater_than = optional(number)<br>      and                      = optional(any)<br>      tag = optional(object({<br>        key   = string<br>        value = string<br>      }))<br>    })<br>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | name of the s3 bucket | `any` | n/a | yes |
| <a name="input_public_access_block"></a> [public\_access\_block](#input\_public\_access\_block) | values for the public access block | <pre>object({<br>    block_public_acls       = bool<br>    block_public_policy     = bool<br>    ignore_public_acls      = bool<br>    restrict_public_buckets = bool<br>  })</pre> | <pre>{<br>  "block_public_acls": true,<br>  "block_public_policy": true,<br>  "ignore_public_acls": true,<br>  "restrict_public_buckets": true<br>}</pre> | no |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | enable s3 versioning | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | s3 bucket arn |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | s3 bucket name |
| <a name="output_bucket_regional_domain_name"></a> [bucket\_regional\_domain\_name](#output\_bucket\_regional\_domain\_name) | s3 regional domain name |
