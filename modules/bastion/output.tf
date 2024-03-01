output "security-group-id" {
  value = aws_security_group.bastion.id
}

output "instance-id" {
  value = aws_instance.bastion.id
}
