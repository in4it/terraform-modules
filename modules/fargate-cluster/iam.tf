#
# Fargate execution role
#

resource "aws_iam_role" "ecs-task-execution-role" {
  name = "ecs-task-execution-role-${var.cluster_name}"

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
  name = "ecs-task-execution-role-policy-${var.cluster_name}"
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
  count  = var.execution_role_policy == "" ? 0 : 1
  name   = "ecs-task-execution-custom-role-policy-${var.cluster_name}"
  role   = aws_iam_role.ecs-task-execution-role.id
  policy = var.execution_role_policy
}
