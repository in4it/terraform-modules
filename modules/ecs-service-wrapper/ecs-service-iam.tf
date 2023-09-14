resource "aws_iam_role" "ecs-service-task-role" {
  name               = "ecs-${var.service_name}-task-role-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.ecs-service-task-role-assume-policy.json
}

data "aws_iam_policy_document" "ecs-service-task-role-assume-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# Task Policy
resource "aws_iam_role_policy" "ecs-service-task-role-policy" {
  name   = "ecs-${var.service_name}-task-role-policy-${var.env}"
  policy = var.task_role_policy_json
  role   = aws_iam_role.ecs-service-task-role.id
}
