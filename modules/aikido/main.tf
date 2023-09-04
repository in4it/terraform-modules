resource "aws_iam_role" "aikido-security-readonly-role" {
  name               = "aikido-security-readonly-role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::881830977366:role/service-role/lambda-aws-cloud-findings-role-uox26vzd"
            },
            "Action": "sts:AssumeRole",
            "Condition": {
                "StringEquals": {
                  "sts:ExternalId": "aikido-776"
                }
            }
        }
    ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "aikido-managed-role" {
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
  role       = aws_iam_role.aikido-security-readonly-role.id
}
resource "aws_iam_role_policy" "aikido-security-policy" {
  name   = "aikido-security-policy"
  role   = aws_iam_role.aikido-security-readonly-role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "iam:CreateServiceLinkedRole",
                "inspector2:*",
                "budgets:ViewBudget",
                "backup:ListBackupPlans",
                "backup:GetBackupPlan",
                "backup:ListProtectedResources"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF
}
