resource "aws_iam_role" "aikido-security-ec2-hard" {
  count = var.ec2_scanner_enabled ? 1 : 0

  name = "aikido-security-ec2-hard"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = var.aikido-principal-arn-ec2
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

resource "aws_iam_role_policy" "aikido-security-ec2-policy" {
  count = var.ec2_scanner_enabled ? 1 : 0

  name = "aikido-security-ec2-policy"
  role = aws_iam_role.aikido-security-ec2-hard.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeVolumes",
          "ec2:DescribeVolumeStatus",
          "ec2:DescribeSnapshots",
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot",
          "ec2:CreateTags",
          "ebs:ListSnapshotBlocks",
          "ebs:GetSnapshotBlock",
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ],
        Resource = "*",
        Effect   = "Allow"
      }
    ]
  })
}

