## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_elasticache_parameter_group.valkey](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.valkey](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.valkey](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_security_group.valkey](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.existing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | n/a | `bool` | `false` | no |
| <a name="input_auth_token"></a> [auth\_token](#input\_auth\_token) | The password used to access a password protected server. Can be specified only if transit\_encryption\_enabled = true | `string` | `null` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Specifies whether minor version engine upgrades will be applied automatically to the underlying Cache Cluster instances during the maintenance window | `bool` | `true` | no |
| <a name="input_cluster_mode_enabled"></a> [cluster\_mode\_enabled](#input\_cluster\_mode\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The version number of the Valkey engine | `string` | `"8.0"` | no |
| <a name="input_env"></a> [env](#input\_env) | Deployment environment : dev \| stg \| prod  etc.. | `any` | n/a | yes |
| <a name="input_existing_parameter_group"></a> [existing\_parameter\_group](#input\_existing\_parameter\_group) | Use existing parameter group (for resources import) | `string` | `""` | no |
| <a name="input_existing_security_group"></a> [existing\_security\_group](#input\_existing\_security\_group) | Use existing security group id (for resources import) | `string` | `""` | no |
| <a name="input_existing_subnet_group"></a> [existing\_subnet\_group](#input\_existing\_subnet\_group) | Use existing subnet group name (for resources import) | `string` | `""` | no |
| <a name="input_family"></a> [family](#input\_family) | The family of the ElastiCache parameter group. For Valkey, use 'valkey8' | `string` | `"valkey8"` | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | n/a | <pre>list(object({<br/>    from_port        = number<br/>    to_port          = number<br/>    protocol         = string<br/>    security_groups  = optional(list(string))<br/>    cidr_blocks      = optional(list(string))<br/>    ipv6_cidr_blocks = optional(list(string))<br/>    description      = optional(string)<br/>    prefix_list_ids  = optional(list(string))<br/>    self             = optional(bool)<br/>  }))</pre> | n/a | yes |
| <a name="input_log_delivery_configurations"></a> [log\_delivery\_configurations](#input\_log\_delivery\_configurations) | List of log delivery configurations | <pre>list(object({<br/>    destination      = string<br/>    destination_type = string<br/>    log_format       = string<br/>    log_type         = string<br/>  }))</pre> | `[]` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | n/a | `string` | `"sun:05:00-sun:06:00"` | no |
| <a name="input_multi_az_enabled"></a> [multi\_az\_enabled](#input\_multi\_az\_enabled) | Enable Multi-AZ Support | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name prefix for the ElastiCache Valkey cluster | `any` | n/a | yes |
| <a name="input_name_suffix"></a> [name\_suffix](#input\_name\_suffix) | Suffix for the ElastiCache Valkey cluster name | `string` | `"valkey"` | no |
| <a name="input_notification_topic_arn"></a> [notification\_topic\_arn](#input\_notification\_topic\_arn) | An Amazon Resource Name (ARN) of an SNS topic to send ElastiCache notifications to | `string` | `""` | no |
| <a name="input_override_name"></a> [override\_name](#input\_override\_name) | Override name for existing clusters to not recreate the cluster | `bool` | `false` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | Values for the parameters in the parameter group | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "name": "maxmemory-policy",<br/>    "value": "volatile-lru"<br/>  },<br/>  {<br/>    "name": "maxmemory-samples",<br/>    "value": "10"<br/>  },<br/>  {<br/>    "name": "timeout",<br/>    "value": "0"<br/>  }<br/>]</pre> | no |
| <a name="input_port"></a> [port](#input\_port) | Valkey Cluster port | `number` | `6379` | no |
| <a name="input_replicas_per_node_group"></a> [replicas\_per\_node\_group](#input\_replicas\_per\_node\_group) | Number of replica nodes in each node group. Valid values are 0 to 5. | `number` | `0` | no |
| <a name="input_rest_encryption_enabled"></a> [rest\_encryption\_enabled](#input\_rest\_encryption\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_snapshot_retention_limit"></a> [snapshot\_retention\_limit](#input\_snapshot\_retention\_limit) | The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. Set to 0 to disable backups | `number` | `5` | no |
| <a name="input_snapshot_window"></a> [snapshot\_window](#input\_snapshot\_window) | The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster | `string` | `"03:00-05:00"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of Subnet IDs to deploy the new cluster | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for all resources | `map(string)` | `{}` | no |
| <a name="input_transit_encryption_enabled"></a> [transit\_encryption\_enabled](#input\_transit\_encryption\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_valkey_node_type"></a> [valkey\_node\_type](#input\_valkey\_node\_type) | The compute and memory capacity of the nodes. For Valkey, supported node types include cache.t4g.micro, cache.t4g.small, cache.t4g.medium, cache.r6g.large, cache.r6g.xlarge, cache.r6g.2xlarge, cache.r6g.4xlarge, cache.r6g.8xlarge, cache.r6g.12xlarge, cache.r6g.16xlarge, cache.r6g.24xlarge, cache.r7g.large, cache.r7g.xlarge, cache.r7g.2xlarge, cache.r7g.4xlarge, cache.r7g.8xlarge, cache.r7g.12xlarge, cache.r7g.16xlarge, cache.r7g.24xlarge | `string` | `"cache.t4g.micro"` | no |
| <a name="input_valkey_shard_number"></a> [valkey\_shard\_number](#input\_valkey\_shard\_number) | Number of shards (node groups) in the cluster | `number` | `1` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC to deploy the new cluster | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | n/a |
| <a name="output_valkey_security_group_id"></a> [valkey\_security\_group\_id](#output\_valkey\_security\_group\_id) | n/a |
