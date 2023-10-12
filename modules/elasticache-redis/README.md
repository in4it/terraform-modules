## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_elasticache_parameter_group.redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_security_group.redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.existing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | n/a | `bool` | `false` | no |
| <a name="input_cluster_mode_enabled"></a> [cluster\_mode\_enabled](#input\_cluster\_mode\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | n/a | `string` | `"7.0"` | no |
| <a name="input_env"></a> [env](#input\_env) | Deployment environment : dev \| stg \| prod  etc.. | `any` | n/a | yes |
| <a name="input_existing_parameter_group"></a> [existing\_parameter\_group](#input\_existing\_parameter\_group) | Use existing parameter group (for resources import) | `string` | `""` | no |
| <a name="input_existing_security_group"></a> [existing\_security\_group](#input\_existing\_security\_group) | Use existing security group id (for resources import) | `string` | `""` | no |
| <a name="input_existing_subnet_group"></a> [existing\_subnet\_group](#input\_existing\_subnet\_group) | Use existing subnet group name (for resources import) | `string` | `""` | no |
| <a name="input_family"></a> [family](#input\_family) | n/a | `string` | `"redis7"` | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | n/a | <pre>list(object({<br>    from_port        = number<br>    to_port          = number<br>    protocol         = string<br>    security_groups  = optional(list(string))<br>    cidr_blocks      = optional(list(string))<br>    ipv6_cidr_blocks = optional(list(string))<br>    description      = optional(string)<br>    prefix_list_ids  = optional(list(string))<br>    self             = optional(bool)<br>  }))</pre> | n/a | yes |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | n/a | `string` | `"sun:05:00-sun:06:00"` | no |
| <a name="input_multi_az_enabled"></a> [multi\_az\_enabled](#input\_multi\_az\_enabled) | Enable Multi-AZ Support | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name prefix for the Elasticache cluster | `any` | n/a | yes |
| <a name="input_name_suffix"></a> [name\_suffix](#input\_name\_suffix) | Suffix for the Elasticache cluster name | `string` | `"redis"` | no |
| <a name="input_override_name"></a> [override\_name](#input\_override\_name) | Override name for existing clusters to not recreate the cluster | `bool` | `false` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | values for the parameters in the parameter group | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_port"></a> [port](#input\_port) | Redis Cluster port | `number` | `6379` | no |
| <a name="input_redis_node_type"></a> [redis\_node\_type](#input\_redis\_node\_type) | [supported node types](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/CacheNodes.SupportedTypes.html) and [guidance on selecting node types](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/nodes-select-size.html). | `string` | `"cache.t4g.micro"` | no |
| <a name="input_redis_shard_number"></a> [redis\_shard\_number](#input\_redis\_shard\_number) | aka num\_node\_groups | `number` | `1` | no |
| <a name="input_replicas_per_node_group"></a> [replicas\_per\_node\_group](#input\_replicas\_per\_node\_group) | Number of replica nodes in each node group. Valid values are 0 to 5. | `number` | `0` | no |
| <a name="input_rest_encryption_enabled"></a> [rest\_encryption\_enabled](#input\_rest\_encryption\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of Subnet IDs to deploy the new cluster | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for all resources | `map(string)` | `{}` | no |
| <a name="input_transit_encryption_enabled"></a> [transit\_encryption\_enabled](#input\_transit\_encryption\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC to deploy the new cluster | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | n/a |
| <a name="output_redis_security_group_id"></a> [redis\_security\_group\_id](#output\_redis\_security\_group\_id) | n/a |
