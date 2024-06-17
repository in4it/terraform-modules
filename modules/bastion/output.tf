output "security-group-id" {
  value = aws_security_group.bastion.id
}

output "bastion-iam-role" {
  value = aws_iam_role.bastion.id
}

output "instance-id" {
  value = aws_instance.bastion.id
}

output "start-session-command" {
  value = "aws ssm start-session --target ${aws_instance.bastion.id}"
}
