#
# ECS Fargate cluster
#

resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name

  dynamic "configuration" {
    for_each = var.enable_execute_command ? [""] : []
    content {
      execute_command_configuration {
        logging = "OVERRIDE"

        log_configuration {
          cloud_watch_log_group_name = aws_cloudwatch_log_group.execute_command_logs[0].name
        }
      }
    }
  }
}
