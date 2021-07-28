[
  %{ for extra_container in extra_containers ~}
  {
      "name": "${extra_container.application_name}",
      "image": "${extra_container.ecr_url}:${extra_container.application_version}",
      "cpu": ${extra_container.cpu_reservation},
      "memoryreservation": ${extra_container.memory_reservation},
      "essential": true,
      "portmappings" : [
        {
          "containerport": ${application_port},
          "hostport": ${host_port}
        }
      ],
      "secrets": ${extra_container.secrets},
      "environment": ${extra_container.environments},
      "mountpoints": ${extra_container.mountpoints},
      "logconfiguration": {
            "logdriver": "awslogs",
            "options": {
                "awslogs-group": "${log_group}",
                "awslogs-region": "${aws_region}",
                "awslogs-stream-prefix": "${extra_container.application_name}"
            }
      }
    },
  %{ endfor ~}
  {
    "name": "${application_name}",
    "image": "${ecr_url}:${application_version}",
    "cpu": ${cpu_reservation},
    "memoryreservation": ${memory_reservation},
    "essential": true,
    "portmappings" : [
      {
        "containerport": ${application_port},
        "hostport": ${host_port}
      }
    ],
    "secrets": ${secrets},
    "environment": ${environments},
    "mountpoints": ${mountpoints},
    "logconfiguration": {
          "logdriver": "awslogs",
          "options": {
              "awslogs-group": "${log_group}",
              "awslogs-region": "${aws_region}",
              "awslogs-stream-prefix": "${application_name}"
          }
    }
  }
]
