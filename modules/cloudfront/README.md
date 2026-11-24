<!-- BEGIN_TF_DOCS -->
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
| [aws_cloudfront_origin_access_control.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource |
| [aws_cloudfront_origin_access_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aliases"></a> [aliases](#input\_aliases) | List of aliases for the CloudFront distribution | `list(string)` | `[]` | no |
| <a name="input_custom_error_responses"></a> [custom\_error\_responses](#input\_custom\_error\_responses) | The custom error response configuration for this distribution | <pre>list(object({<br>    error_code         = number<br>    response_code      = number<br>    response_page_path = string<br>  }))</pre> | `null` | no |
| <a name="input_default_cache_behavior"></a> [default\_cache\_behavior](#input\_default\_cache\_behavior) | n/a | <pre>object({<br>    target_origin_id           = string<br>    allowed_methods            = optional(list(string))<br>    cached_methods             = optional(list(string))<br>    viewer_protocol_policy     = optional(string)<br>    compress                   = optional(bool)<br>    cache_policy_id            = optional(string)<br>    response_headers_policy_id = optional(string)<br>    origin_request_policy_id   = optional(string)<br>    min_ttl                    = optional(number)<br>    default_ttl                = optional(number)<br>    max_ttl                    = optional(number)<br>    function_associations = optional(list(object({<br>      event_type   = string<br>      function_arn = string<br>    })))<br>    lambda_function_associations = optional(list(object({<br>      event_type   = string<br>      lambda_arn   = string<br>      include_body = bool<br>    })))<br>    forwarded_values = optional(object({<br>      query_string = bool<br>      cookies = object({<br>        forward = string<br>      })<br>      headers = optional(list(string))<br>    }))<br>  })</pre> | <pre>{<br>  "allowed_methods": [<br>    "GET",<br>    "HEAD",<br>    "OPTIONS"<br>  ],<br>  "cached_methods": [<br>    "GET",<br>    "HEAD"<br>  ],<br>  "target_origin_id": "test",<br>  "viewer_protocol_policy": "redirect-to-https"<br>}</pre> | no |
| <a name="input_default_root_object"></a> [default\_root\_object](#input\_default\_root\_object) | Object that you want CloudFront to return (for example, index.html) when an end user requests the root URL. | `string` | `null` | no |
| <a name="input_geo_restriction"></a> [geo\_restriction](#input\_geo\_restriction) | The restriction configuration for this distribution | <pre>object({<br>    restriction_type = string<br>    locations        = optional(list(string))<br>  })</pre> | <pre>{<br>  "restriction_type": "none"<br>}</pre> | no |
| <a name="input_logging_config"></a> [logging\_config](#input\_logging\_config) | The logging configuration for this distribution | <pre>object({<br>    include_cookies = optional(bool)<br>    bucket          = optional(string)<br>    prefix          = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `any` | n/a | yes |
| <a name="input_ordered_cache_behaviors"></a> [ordered\_cache\_behaviors](#input\_ordered\_cache\_behaviors) | n/a | <pre>list(object({<br>    path_pattern               = string<br>    target_origin_id           = string<br>    allowed_methods            = optional(list(string))<br>    cached_methods             = optional(list(string))<br>    viewer_protocol_policy     = optional(string)<br>    compress                   = optional(bool)<br>    cache_policy_id            = optional(string)<br>    response_headers_policy_id = optional(string)<br>    origin_request_policy_id   = optional(string)<br>    min_ttl                    = optional(number)<br>    default_ttl                = optional(number)<br>    max_ttl                    = optional(number)<br>    function_associations = optional(list(object({<br>      event_type   = string<br>      function_arn = string<br>    })))<br>    lambda_function_associations = optional(list(object({<br>      event_type   = string<br>      lambda_arn   = string<br>      include_body = bool<br>    })))<br>    forwarded_values = optional(object({<br>      query_string = bool<br>      cookies = object({<br>        forward = string<br>      })<br>      headers = optional(list(string))<br>    }))<br>  }))</pre> | `null` | no |
| <a name="input_s3_origins"></a> [s3\_origins](#input\_s3\_origins) | n/a | <pre>list(object({<br>    domain_name = string<br>    origin_id   = string<br>    origin_path = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_use_origin_access_control"></a> [use\_origin\_access\_control](#input\_use\_origin\_access\_control) | Use Origin Access Control (OAC) for S3 origins instead of the legacy Origin Access Identity (OAI) | `bool` | `false` | no |
| <a name="input_viewer_certificate"></a> [viewer\_certificate](#input\_viewer\_certificate) | The SSL configuration for this distribution | <pre>object({<br>    acm_certificate_arn            = optional(string)<br>    cloudfront_default_certificate = optional(bool)<br>    iam_certificate_id             = optional(string)<br>    minimum_protocol_version       = optional(string)<br>    ssl_support_method             = optional(string)<br>  })</pre> | <pre>{<br>  "cloudfront_default_certificate": true<br>}</pre> | no |
| <a name="input_vpc_origins"></a> [vpc\_origins](#input\_vpc\_origins) | List of VPC origins (internal ALB/NLB) for CloudFront | <pre>list(object({<br>    domain_name            = string<br>    origin_id              = string<br>    vpc_origin_id          = string<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_arn"></a> [cloudfront\_arn](#output\_cloudfront\_arn) | n/a |
| <a name="output_cloudfront_domain_name"></a> [cloudfront\_domain\_name](#output\_cloudfront\_domain\_name) | n/a |
| <a name="output_cloudfront_hosted_zone_id"></a> [cloudfront\_hosted\_zone\_id](#output\_cloudfront\_hosted\_zone\_id) | n/a |
| <a name="output_cloudfront_id"></a> [cloudfront\_id](#output\_cloudfront\_id) | n/a |
| <a name="output_cloudfront_origin_access_control_id"></a> [cloudfront\_origin\_access\_control\_id](#output\_cloudfront\_origin\_access\_control\_id) | n/a |
| <a name="output_cloudfront_origin_access_identity_arn"></a> [cloudfront\_origin\_access\_identity\_arn](#output\_cloudfront\_origin\_access\_identity\_arn) | n/a |
<!-- END_TF_DOCS -->