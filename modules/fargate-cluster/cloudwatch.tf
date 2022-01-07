#
# Cloudwatch logs
#

resource "aws_cloudwatch_log_group" "cluster" {
  name              = var.log_group
  retention_in_days = var.log_retention_days
}


resource "aws_cloudwatch_log_group" "execute_command_logs" {
  count = var.enable_execute_command ? 1 : 0

  name              = "${var.log_group}-execute-commands"
  retention_in_days = var.log_retention_days
}
