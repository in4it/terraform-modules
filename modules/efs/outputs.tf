output "efs_id" {
  value       = aws_efs_file_system.this.id
  description = "EFS ID"
}

output "efs_sg_id" {
  value       = aws_security_group.this.id
  description = "Security group ID of the EFS"
}

output "efs_dns_name" {
  description = "DNS name of the EFS"
  value       = aws_efs_file_system.this.dns_name
}
