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
      "essential": true,
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
      "secrets": ${jsonencode([for secret in container.secrets : secret])},
      "environment":${jsonencode([for environment in container.environments : environment])},
      "environmentFiles":[
        %{ for envFileKey, envFile in container.environment_files ~}
        {
            "value":"${envFile.value}",
            "type": "${envFile.type}"
        }${envFileKey+1 == length(container.environment_files)? "" : ","}
        %{ endfor ~}
      ],
      "mountpoints": ${jsonencode([for mountpoint in container.mountpoints : mountpoint])},
      "links": ${jsonencode([for link in container.links : link])},
      "dependsOn": ${jsonencode([for dependsOn in container.dependsOn : dependsOn])},
      "logconfiguration": {
            "logdriver": "awslogs",
            "options": {
                "awslogs-group": "${log_group}",
                "awslogs-region": "${aws_region}",
                "awslogs-stream-prefix": "${container.application_name}"
            }
      }
    }${key+1 == length(containers)? "" : ","}
  %{ endfor ~}
]
