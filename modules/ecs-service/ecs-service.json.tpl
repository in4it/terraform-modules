[
  %{ for key, container in containers ~}
  {
      "name": "${container.application_name}",
      "image": "${container.ecr_url}:${container.application_version}",
      "cpu": ${container.cpu_reservation},
      "memoryreservation": ${container.memory_reservation},
      "dockerLabels": ${jsonencode(container.docker_labels)},
      %{if container.command != null}
        "command": ${jsonencode([for command in container.command : command])},
      %{endif}
      %{if container.entrypoint != null}
        "entryPoint": ${jsonencode([for entrypoint in container.entrypoint : entrypoint])},
      %{endif}
      %{if container.health_check_cmd != null}
        "healthCheck": {
          "command": ["CMD-SHELL", "${container.health_check_cmd}"],
          "interval": ${container.health_check_interval},
          "timeout": ${container.health_check_timeout},
          %{if container.health_check_startPeriod != null}
            "startPeriod": ${container.health_check_startPeriod},
          %{endif}
          "retries": ${container.health_check_retries}

        },
      %{endif}
      "essential": ${container.essential},
      "portmappings" : [
        {
          %{if container.host_port != null}
            "hostport": ${container.host_port},
          %{endif}
          "containerport": ${container.application_port}
        }
        %{ for key, additional_port in container.additional_ports ~}
        ,{
          "hostport": ${additional_port},
          "containerport": ${additional_port}
        }
        %{ endfor ~}
      ],
      "secrets": ${jsonencode([for k, v in container.secrets : { name = k, valueFrom = v }])},
      "environment":${jsonencode([for k, v in container.environments : { name = k, value = v }])},
      "environmentFiles":[
        %{ for envFileKey, envFile in container.environment_files ~}
        {
            "value":"${envFile.value}",
            "type": "${envFile.type}"
        }${envFileKey+1 == length(container.environment_files)? "" : ","}
        %{ endfor ~}
      ],
      "mountpoints":[
      %{ for mountKey, mountpoint in container.mountpoints ~}
      {
            "containerPath":"${mountpoint.containerPath}",
            "sourceVolume": "${mountpoint.sourceVolume}",
            "readOnly": ${tobool(try(mountpoint.readOnly, false))}
      }${mountKey+1 == length(container.mountpoints)? "" : ","}
      %{ endfor ~}
      ],
      "links": ${jsonencode([for link in container.links : link])},
      "dependsOn": ${jsonencode([for dependsOn in container.dependsOn : dependsOn])},
      %{if container.fluent_bit == true}
        "firelensConfiguration": ${jsonencode(container.firelens_configuration)},
      %{endif}
      %{if container.aws_firelens == false}
        "logconfiguration": {
              "logdriver": "awslogs",
              "options": {
                  "awslogs-group": "${log_group}",
                  "awslogs-region": "${aws_region}",
                  "awslogs-stream-prefix": "${container.application_name}"
              }
        }
      %{endif}
      %{if container.aws_firelens == true}
        "logconfiguration": {
              "logdriver": "awsfirelens"
        }
      %{endif}
    }${key+1 == length(containers)? "" : ","}
  %{ endfor ~}
]
