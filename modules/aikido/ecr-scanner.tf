resource "aws_iam_role" "aikido-security-ecr-readonly-role" {
  count = var.ecr_scanner_enabled ? 1 : 0

  name = "aikido-security-ecr-readonly-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = var.aikido-principal-arn-ecr
        },
        Action = "sts:AssumeRole",
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.aikido-role-external-id
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "aikido-security-ecr-policy" {
  count = var.ecr_scanner_enabled ? 1 : 0

  name = "aikido-security-ecr-policy"
  role = aws_iam_role.aikido-security-ecr-readonly-role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:DescribeRepositories",
          "ecr:DescribeRegistry",
          "ecr:GetAuthorizationToken"
        ],
        Resource = "*",
        Effect   = "Allow"
      }
    ]
  })
}
