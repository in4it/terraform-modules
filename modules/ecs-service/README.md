## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecr_repository.ecs-service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecs_service.ecs-service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.ecs-service-taskdef](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_lb_target_group.ecs-service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_security_group.ecs-service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [null_resource.alb_exists](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_ecs_service.ecs-service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecs_service) | data source |
| [aws_ecs_task_definition.ecs-service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecs_task_definition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_ports"></a> [additional\_ports](#input\_additional\_ports) | n/a | `list(string)` | `[]` | no |
| <a name="input_alb_arn"></a> [alb\_arn](#input\_alb\_arn) | n/a | `any` | `null` | no |
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | n/a | `any` | n/a | yes |
| <a name="input_application_port"></a> [application\_port](#input\_application\_port) | n/a | `number` | `80` | no |
| <a name="input_application_version"></a> [application\_version](#input\_application\_version) | n/a | `string` | `""` | no |
| <a name="input_aws_firelens"></a> [aws\_firelens](#input\_aws\_firelens) | n/a | `bool` | `false` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `any` | n/a | yes |
| <a name="input_cluster_arn"></a> [cluster\_arn](#input\_cluster\_arn) | n/a | `any` | n/a | yes |
| <a name="input_command"></a> [command](#input\_command) | n/a | `list` | `[]` | no |
| <a name="input_configure_at_launch"></a> [configure\_at\_launch](#input\_configure\_at\_launch) | n/a | `bool` | `false` | no |
| <a name="input_containers"></a> [containers](#input\_containers) | Containers in container definition | <pre>list(object({<br/>    essential                = optional(bool, true)<br/>    application_name         = string<br/>    host_port                = number<br/>    application_port         = number<br/>    additional_ports         = optional(list(string), [])<br/>    port_protocol            = optional(string, "tcp")<br/>    application_version      = optional(string, "latest")<br/>    ecr_url                  = string<br/>    cpu_reservation          = number<br/>    memory_reservation       = number<br/>    command                  = optional(list(string), [])<br/>    entrypoint               = optional(list(string), [])<br/>    health_check_cmd         = optional(string)<br/>    health_check_interval    = optional(number)<br/>    health_check_timeout     = optional(number)<br/>    health_check_retries     = optional(number)<br/>    health_check_startPeriod = optional(number, null)<br/>    links                    = optional(list(string), [])<br/>    docker_labels            = optional(map(string), {})<br/>    fluent_bit               = optional(bool, false)<br/>    aws_firelens             = optional(bool, false)<br/>    firelens_configuration = optional(object({<br/>      type    = string<br/>      options = map(string)<br/>    }), null)<br/>    dependsOn = optional(list(object({<br/>      containerName = string<br/>      condition     = string<br/>    })), [])<br/>    mountpoints = optional(list(object({<br/>      containerPath = string<br/>      sourceVolume  = string<br/>      readOnly      = optional(bool, false)<br/>    })), [])<br/>    volumes_from = optional(list(object({<br/>      sourceContainer = string<br/>      readOnly        = optional(bool, false)<br/>    })), [])<br/>    system_controls = optional(list(object({<br/>      namespace = string<br/>      value     = string<br/>    })), [])<br/>    user         = optional(string, null)<br/>    secrets      = optional(map(string), {})<br/>    environments = optional(map(string), {})<br/>    environment_files = optional(list(object({<br/>      value = string<br/>      type  = string<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_cpu_reservation"></a> [cpu\_reservation](#input\_cpu\_reservation) | n/a | `any` | n/a | yes |
| <a name="input_create_ecr"></a> [create\_ecr](#input\_create\_ecr) | Controls if ECR repo should be created | `bool` | `true` | no |
| <a name="input_deployment_controller"></a> [deployment\_controller](#input\_deployment\_controller) | n/a | `string` | `""` | no |
| <a name="input_deployment_maximum_percent"></a> [deployment\_maximum\_percent](#input\_deployment\_maximum\_percent) | n/a | `number` | `200` | no |
| <a name="input_deployment_minimum_healthy_percent"></a> [deployment\_minimum\_healthy\_percent](#input\_deployment\_minimum\_healthy\_percent) | n/a | `number` | `100` | no |
| <a name="input_deregistration_delay"></a> [deregistration\_delay](#input\_deregistration\_delay) | n/a | `number` | `30` | no |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | n/a | `any` | n/a | yes |
| <a name="input_ecr_prefix"></a> [ecr\_prefix](#input\_ecr\_prefix) | n/a | `string` | `""` | no |
| <a name="input_enable_blue_green"></a> [enable\_blue\_green](#input\_enable\_blue\_green) | n/a | `bool` | `false` | no |
| <a name="input_enable_execute_command"></a> [enable\_execute\_command](#input\_enable\_execute\_command) | n/a | `bool` | `false` | no |
| <a name="input_enable_internal_lb"></a> [enable\_internal\_lb](#input\_enable\_internal\_lb) | n/a | `bool` | `false` | no |
| <a name="input_entrypoint"></a> [entrypoint](#input\_entrypoint) | n/a | `list` | `[]` | no |
| <a name="input_environment_files"></a> [environment\_files](#input\_environment\_files) | n/a | <pre>list(object({<br/>    value = string<br/>    type  = string<br/>  }))</pre> | `[]` | no |
| <a name="input_environments"></a> [environments](#input\_environments) | environments to set | `map(string)` | `{}` | no |
| <a name="input_ephemeral_storage_size_in_gib"></a> [ephemeral\_storage\_size\_in\_gib](#input\_ephemeral\_storage\_size\_in\_gib) | Size of ephemeral storage in GiB | `number` | `20` | no |
| <a name="input_execution_role_arn"></a> [execution\_role\_arn](#input\_execution\_role\_arn) | n/a | `string` | `""` | no |
| <a name="input_existing_ecr"></a> [existing\_ecr](#input\_existing\_ecr) | n/a | <pre>object({<br/>    repo_url = string<br/>  })</pre> | `null` | no |
| <a name="input_exposed_container_name"></a> [exposed\_container\_name](#input\_exposed\_container\_name) | n/a | `string` | `""` | no |
| <a name="input_exposed_container_port"></a> [exposed\_container\_port](#input\_exposed\_container\_port) | n/a | `string` | `""` | no |
| <a name="input_fargate_service_security_groups"></a> [fargate\_service\_security\_groups](#input\_fargate\_service\_security\_groups) | n/a | `list` | `[]` | no |
| <a name="input_fargate_service_subnetids"></a> [fargate\_service\_subnetids](#input\_fargate\_service\_subnetids) | n/a | `list` | `[]` | no |
| <a name="input_firelens_configuration"></a> [firelens\_configuration](#input\_firelens\_configuration) | n/a | `any` | <pre>{<br/>  "options": {<br/>    "config-file-type": "file",<br/>    "config-file-value": "/fluent.conf"<br/>  },<br/>  "type": "fluentbit"<br/>}</pre> | no |
| <a name="input_fluent_bit"></a> [fluent\_bit](#input\_fluent\_bit) | n/a | `bool` | `false` | no |
| <a name="input_health_check_cmd"></a> [health\_check\_cmd](#input\_health\_check\_cmd) | Container Health Check command to be executed in the default shell | `string` | `null` | no |
| <a name="input_health_check_grace_period_seconds"></a> [health\_check\_grace\_period\_seconds](#input\_health\_check\_grace\_period\_seconds) | n/a | `number` | `0` | no |
| <a name="input_health_check_interval"></a> [health\_check\_interval](#input\_health\_check\_interval) | n/a | `number` | `30` | no |
| <a name="input_health_check_retries"></a> [health\_check\_retries](#input\_health\_check\_retries) | n/a | `number` | `3` | no |
| <a name="input_health_check_startPeriod"></a> [health\_check\_startPeriod](#input\_health\_check\_startPeriod) | n/a | `any` | `null` | no |
| <a name="input_health_check_timeout"></a> [health\_check\_timeout](#input\_health\_check\_timeout) | n/a | `number` | `5` | no |
| <a name="input_healthcheck_healthy_threshold"></a> [healthcheck\_healthy\_threshold](#input\_healthcheck\_healthy\_threshold) | n/a | `string` | `"3"` | no |
| <a name="input_healthcheck_interval"></a> [healthcheck\_interval](#input\_healthcheck\_interval) | n/a | `string` | `"60"` | no |
| <a name="input_healthcheck_matcher"></a> [healthcheck\_matcher](#input\_healthcheck\_matcher) | n/a | `string` | `"200"` | no |
| <a name="input_healthcheck_path"></a> [healthcheck\_path](#input\_healthcheck\_path) | n/a | `string` | `"/"` | no |
| <a name="input_healthcheck_timeout"></a> [healthcheck\_timeout](#input\_healthcheck\_timeout) | n/a | `string` | `"5"` | no |
| <a name="input_healthcheck_unhealthy_threshold"></a> [healthcheck\_unhealthy\_threshold](#input\_healthcheck\_unhealthy\_threshold) | n/a | `string` | `"3"` | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | n/a | <pre>list(object({<br/>    from_port       = number<br/>    to_port         = number<br/>    protocol        = string<br/>    security_groups = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_launch_type"></a> [launch\_type](#input\_launch\_type) | n/a | `string` | `"EC2"` | no |
| <a name="input_log_group"></a> [log\_group](#input\_log\_group) | Log-group name to use. If not set, a log-group will be created with the name /aws/ecs/<application\_name> | `string` | `""` | no |
| <a name="input_logs_retention_days"></a> [logs\_retention\_days](#input\_logs\_retention\_days) | n/a | `number` | `30` | no |
| <a name="input_memory_reservation"></a> [memory\_reservation](#input\_memory\_reservation) | n/a | `any` | n/a | yes |
| <a name="input_mountpoints"></a> [mountpoints](#input\_mountpoints) | mountpoints to in container definition | <pre>list(object({<br/>    containerPath = string<br/>    sourceVolume  = string<br/>  }))</pre> | `[]` | no |
| <a name="input_platform_version"></a> [platform\_version](#input\_platform\_version) | n/a | `string` | `"LATEST"` | no |
| <a name="input_port_protocol"></a> [port\_protocol](#input\_port\_protocol) | n/a | `string` | `"tcp"` | no |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | n/a | `string` | `"HTTP"` | no |
| <a name="input_redeploy_service"></a> [redeploy\_service](#input\_redeploy\_service) | Changes the updated taskdefinition revision which causes ecs service to redeploy | `bool` | `true` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | secrets to set | `map(string)` | `{}` | no |
| <a name="input_service_registries"></a> [service\_registries](#input\_service\_registries) | n/a | <pre>list(object({<br/>    registry_arn   = string<br/>    container_name = string<br/>  }))</pre> | `[]` | no |
| <a name="input_service_role_arn"></a> [service\_role\_arn](#input\_service\_role\_arn) | n/a | `string` | `""` | no |
| <a name="input_task_role_arn"></a> [task\_role\_arn](#input\_task\_role\_arn) | n/a | `string` | `""` | no |
| <a name="input_task_security_groups"></a> [task\_security\_groups](#input\_task\_security\_groups) | extra security groups to add. Expects security group ID | `list` | `[]` | no |
| <a name="input_use_arm"></a> [use\_arm](#input\_use\_arm) | n/a | `bool` | `false` | no |
| <a name="input_user"></a> [user](#input\_user) | User to run the container as | `any` | `null` | no |
| <a name="input_volumes"></a> [volumes](#input\_volumes) | volumes to create in task definition | <pre>list(object({<br/>    name                = string<br/>    configure_at_launch = optional(bool, false)<br/>    efs_volume_configuration = optional(object({<br/>      file_system_id     = string<br/>      transit_encryption = string<br/>      root_directory     = optional(string)<br/>      authorization_config = optional(object({<br/>        access_point_id = string<br/>        iam             = string<br/>      }))<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecr_arn"></a> [ecr\_arn](#output\_ecr\_arn) | n/a |
| <a name="output_ecr_name"></a> [ecr\_name](#output\_ecr\_name) | n/a |
| <a name="output_ecr_url"></a> [ecr\_url](#output\_ecr\_url) | n/a |
| <a name="output_log_group_name"></a> [log\_group\_name](#output\_log\_group\_name) | n/a |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | n/a |
| <a name="output_target_group_arn"></a> [target\_group\_arn](#output\_target\_group\_arn) | n/a |
| <a name="output_target_group_arns"></a> [target\_group\_arns](#output\_target\_group\_arns) | n/a |
| <a name="output_target_group_names"></a> [target\_group\_names](#output\_target\_group\_names) | n/a |
| <a name="output_task_definition_arn"></a> [task\_definition\_arn](#output\_task\_definition\_arn) | n/a |
| <a name="output_task_security_group_id"></a> [task\_security\_group\_id](#output\_task\_security\_group\_id) | n/a |
