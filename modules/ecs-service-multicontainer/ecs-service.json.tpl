[
  %{ for container in containers ~}
  {
      "name": "${container.application_name}",
      "image": "${container.ecr_url}:${container.application_version}",
      "cpu": ${container.cpu_reservation},
      "memoryreservation": ${container.memory_reservation},
      "essential": true,
      "portmappings" : [
        {
          "containerport": ${application_port},
          "hostport": ${host_port}
        }
      ],
      "secrets": ${jsonencode([for secret in container.secrets : secret])},
      "environment":${jsonencode([for environment in container.environments : environment])},
      "mountpoints": ${jsonencode([for mountpoint in container.mountpoints : mountpoint])},
      "links": ${jsonencode([for link in container.links : link])},
      "logconfiguration": {
            "logdriver": "awslogs",
            "options": {
                "awslogs-group": "${log_group}",
                "awslogs-region": "${aws_region}",
                "awslogs-stream-prefix": "${container.application_name}"
            }
      }
    },
  %{ endfor ~}
]
