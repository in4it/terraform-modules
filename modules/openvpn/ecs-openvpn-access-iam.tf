resource "aws_iam_role" "ecs-openvpn-access-task-role" {
  name               = "ecs-openvpn-access-task-role-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.ecs-openvpn-access-task-role-assume-policy.json
}

data "aws_iam_policy_document" "ecs-openvpn-access-task-role-assume-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "ecs-openvpn-access-task-role-policy" {
  name   = "ecs-openvpn-access-task-role-policy-${var.env}"
  policy = data.aws_iam_policy_document.ecs-openvpn-access-task-role-policy.json
  role   = aws_iam_role.ecs-openvpn-access-task-role.id
}

data "aws_iam_policy_document" "ecs-openvpn-access-task-role-policy" {
  statement {
    actions = ["s3:*"]
    effect  = "Allow"
    resources = [
      "${aws_s3_bucket.configuration-bucket.arn}/*",
    ]
  }
}
