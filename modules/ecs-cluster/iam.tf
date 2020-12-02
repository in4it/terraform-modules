#
# ECS service role
#
resource "aws_iam_role" "cluster-service-role" {
  name = "ecs-service-role-${var.cluster_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "cluster-service-role" {
  name = "${var.cluster_name}-policy"
  role = aws_iam_role.cluster-service-role.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:Describe*",
                "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
                "elasticloadbalancing:DeregisterTargets",
                "elasticloadbalancing:Describe*",
                "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
                "elasticloadbalancing:RegisterTargets"
            ],
            "Resource": "*"
        }
    ]
}
EOF

}

#
# IAM EC2 role
#
resource "aws_iam_role" "cluster-ec2-role" {
name = "ecs-${var.cluster_name}-ec2-role"

assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_instance_profile" "cluster-ec2-role" {
name = "ecs-${var.cluster_name}-ec2-role"
role = aws_iam_role.cluster-ec2-role.name
}

resource "aws_iam_role_policy" "cluster-ec2-role" {
name = "cluster-ec2-role-policy"
role = aws_iam_role.cluster-ec2-role.id

policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "ecs:CreateCluster",
              "ecs:DeregisterContainerInstance",
              "ecs:DiscoverPollEndpoint",
              "ecs:Poll",
              "ecs:RegisterContainerInstance",
              "ecs:StartTelemetrySession",
              "ecs:Submit*",
              "ecs:StartTask",
              "ecr:GetAuthorizationToken",
              "ecr:BatchCheckLayerAvailability",
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage",
              "logs:CreateLogStream",
              "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
        {
          "Effect": "Allow",
          "Action": [
              "logs:*"
          ],
          "Resource": [
              "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:${var.log_group}:*"
          ]
        }
    ]
}
EOF

}

