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
| [aws_cloudfront_distribution.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aliases"></a> [aliases](#input\_aliases) | List of aliases for the CloudFront distribution | `list(string)` | `[]` | no |
| <a name="input_default_root_object"></a> [default\_root\_object](#input\_default\_root\_object) | Object that you want CloudFront to return (for example, index.html) when an end user requests the root URL. | `string` | `null` | no |
| <a name="input_function_associations"></a> [function\_associations](#input\_function\_associations) | Function associations for the CloudFront distribution | <pre>list(object({<br>    event_type   = string<br>    function_arn = string<br>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `any` | n/a | yes |
| <a name="input_s3_origins"></a> [s3\_origins](#input\_s3\_origins) | n/a | <pre>list(object({<br>    domain_name = string<br>    origin_id   = string<br>  }))</pre> | `[]` | no |
| <a name="input_target_origin_id"></a> [target\_origin\_id](#input\_target\_origin\_id) | n/a | `any` | n/a | yes |
| <a name="input_viewer_certificate"></a> [viewer\_certificate](#input\_viewer\_certificate) | The SSL configuration for this distribution | <pre>object({<br>    acm_certificate_arn            = optional(string)<br>    cloudfront_default_certificate = optional(bool)<br>    iam_certificate_id             = optional(string)<br>    minimum_protocol_version       = optional(string)<br>    ssl_support_method             = optional(string)<br>  })</pre> | <pre>{<br>  "cloudfront_default_certificate": true<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_origin_access_identity_arn"></a> [cloudfront\_origin\_access\_identity\_arn](#output\_cloudfront\_origin\_access\_identity\_arn) | n/a |
