resource "aws_iam_role" "aikido-security-readonly-role" {
  name               = "aikido-security-readonly-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          AWS = var.aikido-principal-arn
        },
        Action    = "sts:AssumeRole",
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.aikido-role-external-id
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "aikido-managed-role" {
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
  role       = aws_iam_role.aikido-security-readonly-role.id
}

resource "aws_iam_role_policy" "aikido-security-policy" {
  name   = "aikido-security-policy"
  role   = aws_iam_role.aikido-security-readonly-role.id
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action = [
          "iam:CreateServiceLinkedRole",
          "inspector2:*",
          "budgets:ViewBudget",
          "backup:ListBackupPlans",
          "backup:GetBackupPlan",
          "backup:ListProtectedResources"
        ],
        Resource = "*",
        Effect   = "Allow"
      }
    ]
  })
}
