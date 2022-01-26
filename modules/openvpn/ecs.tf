resource "aws_ecs_cluster" "cluster" {
  name = "${var.project_name}-vpn-${var.env}"
}

resource "aws_cloudwatch_log_group" "cluster" {
  name              = "${var.project_name}-vpn-${var.env}"
  retention_in_days = var.log_retention_days
}

resource "aws_iam_role" "ecs-task-execution-role" {
  name = "ecs-task-execution-role-${var.project_name}-vpn-${var.env}"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ecs-tasks.amazonaws.com"
            },
            "Action": "sts:AssumeRole",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "ecs-task-execution-role-policy" {
  name = "ecs-task-execution-role-policy-${var.project_name}-vpn-${var.env}"
  role = aws_iam_role.ecs-task-execution-role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ecs-task-execution-custom-role-policy" {
  name   = "ecs-task-execution-custom-role-policy-${var.project_name}-vpn-${var.env}"
  role   = aws_iam_role.ecs-task-execution-role.id
  policy = data.aws_iam_policy_document.ecs_execution_role.json
}

data "aws_iam_policy_document" "ecs_execution_role" {
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey"
    ]
    resources = [
      aws_kms_alias.ssm-parameters.arn,
      aws_kms_key.ssm-parameters.arn,
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters"
    ]
    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.project_name}-${var.env}/vpn/*"
    ]
  }
}