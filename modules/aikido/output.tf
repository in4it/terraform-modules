output "aikido-role-arn" {
  value = aws_iam_role.aikido-security-readonly-role.arn
}
output "aikido-role-ec2-arn" {
  value = aws_iam_role.aikido-security-ec2-hard[0].arn
}
output "aikido-role-ecr-arn" {
  value = aws_iam_role.aikido-security-ecr-readonly-role[0].arn
}
