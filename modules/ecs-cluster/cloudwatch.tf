#
# Cloudwatch logs
#
resource "aws_cloudwatch_log_group" "cluster" {
  name              = var.log_group
  retention_in_days = var.log_retention_days
}

