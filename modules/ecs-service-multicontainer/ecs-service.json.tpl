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
      "secrets": ${container.secrets},
      "environment": ${container.environments},
      "mountpoints": ${container.mountpoints},
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
