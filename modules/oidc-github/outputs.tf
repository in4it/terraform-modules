output "iam_role_arn" {
  depends_on  = [aws_iam_role.github]
  description = "ARN of the IAM role."
  value       = aws_iam_role.github.arn
}
