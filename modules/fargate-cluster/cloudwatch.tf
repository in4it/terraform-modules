#
# Cloudwatch logs
#

resource "aws_cloudwatch_log_group" "cluster" {
  name = var.log_group
}
