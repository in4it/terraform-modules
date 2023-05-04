output "iam_role_arn" {
  depends_on  = [aws_iam_role.github]
  description = "ARN of the IAM role."
  value       = var.enabled ? aws_iam_role.github[0].arn : ""
}
